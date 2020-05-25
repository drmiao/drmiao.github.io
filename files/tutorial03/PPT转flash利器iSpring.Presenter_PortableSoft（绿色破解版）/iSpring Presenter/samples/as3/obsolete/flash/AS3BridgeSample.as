package
{
	import ispring.as3bridge.BridgeLoader;
	import ispring.as3bridge.Player;
	import ispring.as3bridge.PlaybackController;
	import ispring.as3bridge.BridgeEvent;
	import ispring.as3bridge.SoundController;
	import ispring.as3bridge.PresentationInfo;
	import ispring.as3bridge.SlideInfo;
	import ispring.as3bridge.LogConsole;
	
	import flash.display.Sprite;
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.Slider;
	import fl.controls.TextArea;
	import fl.events.SliderEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	import flash.display.DisplayObjectContainer;
	
	public class AS3BridgeSample
	{
		private const BRIDGE_URL:String = "../as3bridge/as3bridge.swf";
		private const PRESENTATION1_URL:String = "presentation1.swf";
		private const PRESENTATION2_URL:String = "presentation2.swf";
		
		private var m_presentation:Sprite;
		
		private var m_bridgeLoader:BridgeLoader;
		
		private var m_playbackController:PlaybackController;
		private var m_soundController:SoundController;
		private var m_presentationInfo:PresentationInfo;
		
		private var m_buttonPrevious:Button;
		private var m_buttonNext:Button;
		private var m_buttonPlay:Button;
		private var m_buttonPause:Button;
		private var m_buttonPres1:Button;
		private var m_buttonPres2:Button;
		private var m_lSlideIndex:Label;
		private var m_lPos:Label;
		private var m_lVolume:Label;
		private var m_posSlider:Slider;
		private var m_volumeSlider:Slider;
		private var m_log:LogConsole;
		
		private var m_volumeSliderPressed:Boolean = false;
		private var m_posSliderPressed:Boolean = false;
		
		private var m_seeking:Boolean = false;
		private var m_seekPosition:Number = -1;
		
		private var m_volumeChanging:Boolean = false;
		private var m_volumePosition:Number = -1;

		public function AS3BridgeSample(target:DisplayObjectContainer)
		{			
			m_presentation = createSprite(target, 37, 10);
			initLog(target);
			initBridgeLoader();
			initControls(target);
		}
		
		private function loadPresentation(presentationURL:String):void
		{
			m_bridgeLoader.loadPresentation(presentationURL)
		}
		
		private function onSlidePositionChanged(e:BridgeEvent):void
		{
			if ((!m_posSliderPressed) && (!m_seeking))
			{
				m_posSlider.value = getPresentationPos(e.position);
			}
		}
		
		private function getPresentationPos(slidePosition:Number):Number // 0..1
		{
			var currentSlideInfo:SlideInfo = m_presentationInfo.slides.getSlideInfo(m_playbackController.currentSlideIndex);
			if (!currentSlideInfo)
				return 0;
				
			var presentationDuration:Number = m_presentationInfo.duration;
			var currentSlideCurrentTime:Number = slidePosition * currentSlideInfo.duration;
			var currentSlideStartTime:Number = currentSlideInfo.startTime;
			return (currentSlideStartTime + currentSlideCurrentTime) / presentationDuration;
		}
		
		private function setPresentationPosition(sliderValue:Number, autoStart:Boolean):void
		{
			var slidesCount:Number = m_presentationInfo.slides.slidesCount;
			var currentPresentationTime:Number = m_presentationInfo.duration * sliderValue;
			var i:Number;
			
			for (i = 0; i < slidesCount; i++)
			{
				var slideInfo:SlideInfo;
				var slideStartTime:Number;
				var slideEndTime:Number;
				
				slideInfo = m_presentationInfo.slides.getSlideInfo(i);
				slideStartTime = slideInfo.startTime;
				slideEndTime = slideInfo.endTime;
				if ((currentPresentationTime >= slideStartTime) && (currentPresentationTime <= slideEndTime))
				{
					break;
				}
			}
		
			var slidePosition:Number;
		
			slidePosition = (currentPresentationTime - slideStartTime) / (slideEndTime - slideStartTime);
			m_playbackController.gotoSlide(i, false);
			m_playbackController.seek(slidePosition);
			m_playbackController.endSeek(autoStart);
		}
		
		private function onPosSliderChange(e:SliderEvent):void
		{
			if (m_playbackController == null)
			{
				return;
			}
			if (!m_seeking)
			{	
				m_seeking = true;
				setPresentationPosition(e.value, false);
			}
			else
			{
				m_seekPosition = e.value;
			}
		}
		
		private function onPosSliderThumbPress(e:SliderEvent):void
		{
			m_posSliderPressed = true;
			if (m_playbackController != null)
			{
				m_playbackController.pause();
			}
		}
		
		private function onPosSliderThumbRelease(e:SliderEvent):void
		{
			m_posSliderPressed = false;
		}
		
		private function onVolumeChange(e:BridgeEvent):void
		{
			if (!m_volumeSliderPressed)
			{
				m_volumeSlider.value = e.volume;
			}
		}
		
		private function onVolumeSliderThumbPress(e:SliderEvent):void
		{
			m_volumeSliderPressed = true;
		}
		
		private function onVolumeSliderThumbRelease(e:SliderEvent):void
		{
			m_volumeSliderPressed = false;
		}
		
		private function onVolumeSliderChange(e:SliderEvent):void
		{
			if (m_soundController == null)
			{
				return;
			}
			if (!m_volumeChanging)
			{
				m_volumeChanging = true;
				m_soundController.volume = e.value;
			}
			else
			{
				m_volumePosition = e.value;
			}
		}
		
		private function initBridgeLoader():void
		{
			m_bridgeLoader = new BridgeLoader(m_presentation);
			m_bridgeLoader.addEventListener(BridgeEvent.BRIDGE_LOADED, onBridgeLoaded);
			m_bridgeLoader.addEventListener(BridgeEvent.PRESENTATION_LOADED, onPresentationLoaded);
			m_bridgeLoader.connectToBridge(BRIDGE_URL);
		}
		
		private function onBridgeLoaded(e:BridgeEvent):void
		{
			m_log.writeLine("Bridge is loaded");
			m_bridgeLoader.loadPresentation(PRESENTATION1_URL);
		}
		
		private function onPresentationLoaded(e:BridgeEvent):void
		{
			if (e.player.initialized)
			{
				m_playbackController = e.player.playbackController;
				m_soundController = e.player.soundController;
				m_presentationInfo = e.player.presentationInfo;
		
				initEventHandlers();
			}
		}
		
		private function initEventHandlers():void
		{
			m_playbackController.addEventListener(BridgeEvent.SLIDE_CHANGE, onSlideChanged);
			m_playbackController.addEventListener(BridgeEvent.PLAY, onPlay);
			m_playbackController.addEventListener(BridgeEvent.PAUSE, onPause);
			m_playbackController.addEventListener(BridgeEvent.POSITION_CHANGE, onSlidePositionChanged);
			m_playbackController.addEventListener(BridgeEvent.SEEKING_COMPLETE, onSeekingComplete);
		
			m_soundController.addEventListener(BridgeEvent.VOLUME_CHANGE, onVolumeChange);
			m_soundController.addEventListener(BridgeEvent.VOLUME_CHANGING_COMPLETE, onVolumeChangingComplete);
		}
		
		private function onVolumeChangingComplete(e:BridgeEvent):void
		{
			if (m_soundController == null)
			{
				return;
			}
			if (m_volumePosition == -1)
			{
				m_volumeChanging = false;
			}
			else
			{
				m_soundController.volume = m_volumePosition;
				m_volumePosition = -1;
			}
		}
		
		private function onSeekingComplete(e:BridgeEvent):void
		{
			if (m_playbackController == null)
			{
				return;
			}
			if (m_seekPosition == -1)
			{
				m_seeking = false;
			}
			else
			{
				setPresentationPosition(m_seekPosition, false);
				m_seekPosition = -1;
			}
			if (!m_posSliderPressed)
			{
				m_playbackController.play();
			}
		}
		
		private function onSlideChanged(e:BridgeEvent):void
		{
			m_lSlideIndex.text = "Current slide index: " + e.slideIndex;	
		}
		
		private function onPlay(e:BridgeEvent):void
		{
			m_buttonPlay.visible = false;
			m_buttonPause.visible = true;
		}
		
		private function onPause(e:BridgeEvent):void
		{
			m_buttonPlay.visible = true;
			m_buttonPause.visible = false;
		}
		
		private function onBtnNextClick(e:MouseEvent):void
		{
			if (m_playbackController != null)
				m_playbackController.gotoNextSlide(true);
		}
		
		private function onBtnPrevClick(e:MouseEvent):void
		{
			if (m_playbackController != null)
				m_playbackController.gotoPreviousSlide(true);
		}
		
		private function onBtnPlayClick(e:MouseEvent):void
		{
			if (m_playbackController != null)
				m_playbackController.play();
		}
		
		private function onBtnPauseClick(e:MouseEvent):void
		{
			if (m_playbackController != null)
				m_playbackController.pause();
		}
		
		private function onBtnPres1Click(e:MouseEvent):void
		{
			loadPresentation(PRESENTATION1_URL);
		}
		
		private function onBtnPres2Click(e:MouseEvent):void
		{
			loadPresentation(PRESENTATION2_URL);
		}
		
		private function initControls(container:DisplayObjectContainer):void
		{
			m_buttonPrevious	= createButton(container, "Previous Slide", 50, 565, onBtnPrevClick);
			m_buttonNext		= createButton(container, "Next Slide", 170, 565, onBtnNextClick);
			m_buttonPlay		= createButton(container, "Play", 290, 565, onBtnPlayClick);
			m_buttonPause		= createButton(container, "Pause", 290, 565, onBtnPauseClick);
			m_buttonPres1		= createButton(container, "presentation1", 400, 630, onBtnPres1Click);
			m_buttonPres2		= createButton(container, "presentation2", 520, 630, onBtnPres2Click);
			m_lSlideIndex		= createLabel(container, "Current slide index: ", 530, 567);
			m_lPos				= createLabel(container, "Position:", 37, 603);
			m_lVolume			= createLabel(container, "Volume:", 37, 633);
			m_posSlider			= createSlider(container, 140, 610, 570, 30, true);
			m_volumeSlider		= createSlider(container, 140, 640, 150, 30, true);
			
			m_buttonPause.visible = false;
			
			m_volumeSlider.value = m_volumeSlider.maximum;
			
			m_volumeSlider.addEventListener(SliderEvent.THUMB_PRESS,	onVolumeSliderThumbPress);
			m_volumeSlider.addEventListener(SliderEvent.THUMB_RELEASE,	onVolumeSliderThumbRelease);
			m_volumeSlider.addEventListener(SliderEvent.CHANGE,			onVolumeSliderChange);
			
			m_posSlider.addEventListener(SliderEvent.THUMB_PRESS,	onPosSliderThumbPress);
			m_posSlider.addEventListener(SliderEvent.THUMB_RELEASE,	onPosSliderThumbRelease);
			m_posSlider.addEventListener(SliderEvent.CHANGE,		onPosSliderChange);

		}
		
		private function initLog(container:DisplayObjectContainer):void
		{
			m_log = LogConsole.getInstance();
			m_log.init(container, m_presentation.x + 10, m_presentation.y + 10, 600, 120);
			m_log.hide();
		}
		
		////////////////////////////////////////////////////////////
		// Components creation methods
		////////////////////////////////////////////////////////////
		
		private static function createSprite(container:DisplayObjectContainer, x0:Number, y0:Number):Sprite
		{
			var s:Sprite = new Sprite();
			s.x = x0;
			s.y = y0;
			container.addChild(s);
			return s;
		}
		
		private static function createButton(container:DisplayObjectContainer, labelText:String, x0:Number, y0:Number, clickHandler:Function):Button
		{
			var btn:Button = new Button();
			btn.label = labelText;
			btn.move(x0, y0);
			btn.addEventListener(MouseEvent.CLICK, clickHandler);
			container.addChild(btn);
			return btn;
		}

		private static function createLabel(container:DisplayObjectContainer, labelText:String, x0:Number, y0:Number):Label
		{
			var lbl:Label = new Label();
			lbl.autoSize = TextFieldAutoSize.CENTER;
			lbl.move(x0, y0);
			lbl.text = labelText;
			container.addChild(lbl);
			return lbl;
		}

		private static function createSlider(container:DisplayObjectContainer, x0:Number, y0:Number, width:Number, height:Number, liveDragging:Boolean):Slider
		{
			var s:Slider = new Slider();
			s.move(x0, y0);
			s.setSize(width, height);
			s.maximum = 1;
			s.snapInterval = 0.001;
			s.liveDragging = liveDragging;
			container.addChild(s);
			return s;
		}
	}
}