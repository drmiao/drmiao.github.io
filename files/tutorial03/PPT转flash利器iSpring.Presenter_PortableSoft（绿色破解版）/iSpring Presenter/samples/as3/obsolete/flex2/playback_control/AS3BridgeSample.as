package
{
	import ispring.as3bridge.BridgeLoader;
	import ispring.as3bridge.BridgeEvent;
	import ispring.as3bridge.PlaybackController;
	import ispring.as3bridge.SoundController;
	import ispring.as3bridge.PresentationInfo;
	import ispring.as3bridge.SlideInfo;
	import ispring.as3bridge.Player;
	import ispring.flex.PresentationContainer;
	import mx.controls.Label;
	import mx.controls.Button;
	import flash.events.MouseEvent;
	import mx.controls.HSlider;
	import mx.events.SliderEvent;
	import ispring.as3bridge.LogConsole;
	import flash.display.DisplayObjectContainer;
	
	public class AS3BridgeSample
	{
		private const BRIDGE_URL:String			= "as3bridge.swf";
		private const PRESENTATION1_URL:String = "presentation1.swf";//"presentation1.swf";
		private const PRESENTATION2_URL:String = "presentation2.swf";
		
		private var m_bridgeLoader:BridgeLoader;

		private var m_player:Player;
		private var m_playbackController:PlaybackController;
		private var m_soundController:SoundController;
		private var m_presentationInfo:PresentationInfo;

		// controls
		private var m_presentationContainer:PresentationContainer;
		private var m_lPresentationTitle:Label;
		private var m_buttonPlayPause:Button;
		private var m_buttonPrevious:Button;
		private var m_buttonNext:Button;
		private var m_buttonPres1:Button;
		private var m_buttonPres2:Button;
		private var m_posSlider:HSlider;
		private var m_lSlideNumber:Label;
		
		private var m_posSliderPressed:Boolean = false;
		
		private var m_seeking:Boolean = false;
		private var m_seekPosition:Number = -1;
		
		private var m_blockPlayPauseButton:Boolean = false;
		
		private var m_log:LogConsole;
		
		public function AS3BridgeSample(presentationContainer:PresentationContainer,
									   	 lPresentationTitle:Label,
										 buttonPlayPause:Button,
										 buttonPrevious:Button,
										 buttonNext:Button,
										 buttonPres1:Button,
										 buttonPres2:Button,
										 posSlider:HSlider,
										 lSlideNumber:Label)
		{
			m_presentationContainer = presentationContainer;
			m_lPresentationTitle = lPresentationTitle;
			m_buttonPlayPause = buttonPlayPause;
			m_buttonPrevious = buttonPrevious;
			m_buttonNext = buttonNext;
			m_buttonPres1 = buttonPres1;
			m_buttonPres2 = buttonPres2;
			m_posSlider = posSlider;
			m_lSlideNumber = lSlideNumber;
			
			initControlsEventHandlers();
			
			initLog(m_presentationContainer);
			initBridgeLoader();
		}
		
		private function initLog(container:DisplayObjectContainer):void
		{
			m_log = LogConsole.getInstance();
		//	m_log.init(container, 10, 10, 600, 120);
			m_log.hide();
		}
		
		private function initControlsEventHandlers():void
		{
			m_buttonPrevious.addEventListener(MouseEvent.CLICK,		onBtnPrevClick);
			m_buttonNext.addEventListener(MouseEvent.CLICK,			onBtnNextClick);
			m_buttonPlayPause.addEventListener(MouseEvent.CLICK,	onBtnPlayPauseClick);
			m_buttonPres1.addEventListener(MouseEvent.CLICK, 		onBtnPres1Click);
			m_buttonPres2.addEventListener(MouseEvent.CLICK, 		onBtnPres2Click);
			
			m_posSlider.addEventListener(SliderEvent.THUMB_PRESS,	onPosSliderThumbPress);
			m_posSlider.addEventListener(SliderEvent.THUMB_RELEASE,	onPosSliderThumbRelease);
			m_posSlider.addEventListener(SliderEvent.CHANGE,		onPosSliderChange);
		}
		
		private function initBridgeLoader():void
		{
			m_bridgeLoader = m_presentationContainer.bridgeLoader;
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
				m_player = e.player;
				m_playbackController = e.player.playbackController;
				m_soundController = e.player.soundController;
				m_presentationInfo = e.player.presentationInfo;
				
				initControls();
				
				initEventHandlers();
			}
		}
		
		private function loadPresentation(presentationURL:String):void
		{
			m_bridgeLoader.loadPresentation(presentationURL)
		}
		
		private function initEventHandlers():void
		{
			m_playbackController.addEventListener(BridgeEvent.POSITION_CHANGE, onSlidePositionChanged);
			m_playbackController.addEventListener(BridgeEvent.SEEKING_COMPLETE, onSeekingComplete);
			m_playbackController.addEventListener(BridgeEvent.PLAY, onPlay);
			m_playbackController.addEventListener(BridgeEvent.PAUSE, onPause);
			m_playbackController.addEventListener(BridgeEvent.SLIDE_CHANGE, onSlideIndexChange);
		}
		
		private function initControls():void
		{
			m_lPresentationTitle.text = m_presentationInfo.title;
			m_posSlider.maximum = m_presentationInfo.duration;			
		}
		
		private function setPresentationPosition(sliderValue:Number, autoStart:Boolean):void
		{
			var slidesCount:Number = m_presentationInfo.slides.slidesCount;
			var currentPresentationTime:Number = m_presentationInfo.duration * (sliderValue / m_presentationInfo.duration);
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
		
		private function getPresentationPosition(slidePosition:Number):Number // 0..1
		{
			var currentSlideInfo:SlideInfo = m_presentationInfo.slides.getSlideInfo(m_playbackController.currentSlideIndex);
			if (currentSlideInfo == null)
				return 0;
			
			var presentationDuration:Number = m_presentationInfo.duration;
			var currentSlideCurrentTime:Number = slidePosition * currentSlideInfo.duration;
			var currentSlideStartTime:Number = currentSlideInfo.startTime;
		
			return (currentSlideStartTime + currentSlideCurrentTime) / presentationDuration;
		}
		
		private function newSliderPosition(newPosition:Number):void
		{
			if ((m_player == null) || !m_player.initialized)
				return;
			
			if (!m_seeking)
			{	
				m_seeking = true;
				setPresentationPosition(newPosition, false);
			}
			else
			{
				m_seekPosition = newPosition;
			}
		}
		
		// buttons event handlers >
		private function onBtnPlayPauseClick(e:MouseEvent):void
		{
			if ((m_player == null) || !m_player.initialized)
				return;
			
			if (!m_buttonPlayPause.selected)
				m_playbackController.play();
			else
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
		
		private function onBtnPrevClick(e:MouseEvent):void
		{
			if ((m_player == null) || !m_player.initialized)
				return;
				
			m_playbackController.gotoPreviousSlide(true);
		}
		
		private function onBtnNextClick(e:MouseEvent):void
		{
			if ((m_player == null) || !m_player.initialized)
				return;
				
			m_playbackController.gotoNextSlide(true);
		}
		// buttons event handlers <
		
		// posSlider event handlers >
		private function onPosSliderChange(e:SliderEvent):void
		{
			newSliderPosition(e.value);
		}
		
		private function onPosSliderThumbPress(e:SliderEvent):void
		{
			if ((m_player == null) || !m_player.initialized)
				return;
			
			m_blockPlayPauseButton = true;
			m_posSliderPressed = true;
			m_playbackController.pause();
		}
		
		private function onPosSliderThumbRelease(e:SliderEvent):void
		{
			m_posSliderPressed = false;
			newSliderPosition(m_posSlider.value);
		}
		// posSlider event handlers <
		
		// playbackController event handlers >
		private function onSlideIndexChange(e:BridgeEvent):void
		{
			m_lSlideNumber.text = "Slide " + (e.slideIndex + 1);
		}
		
		private function onPlay(e:BridgeEvent):void
		{
			if (m_blockPlayPauseButton)
				m_blockPlayPauseButton = false;
			m_buttonPlayPause.selected = false;
		}
		
		private function onPause(e:BridgeEvent):void
		{
			if (!m_blockPlayPauseButton)
				m_buttonPlayPause.selected = true;
		}
		
		private function onSlidePositionChanged(e:BridgeEvent):void
		{
			if (!m_posSliderPressed && !m_seeking)
				m_posSlider.value = getPresentationPosition(e.position) * m_presentationInfo.duration;
		}
		
		private function onSeekingComplete(e:BridgeEvent):void
		{
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
				m_playbackController.play();
		}
		// playbackController event handlers <
	}
}