package
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import ispring.flex.PlayerInitEvent;
	import ispring.flex.PresentationContainer;
	import ispring.as2player.IPlayer;
	import ispring.as2player.IPresentationInfo;
	import ispring.as2player.IPresentationPlaybackController;
	import ispring.as2player.ISlideInfo;
	import ispring.as2player.ISlidesCollection;
	import ispring.as2player.PlaybackEvent;
	import ispring.as2player.PlaybackPositionEvent;
	import ispring.as2player.SlidePlaybackEvent;
	
	import mx.controls.Button;
	import mx.controls.HSlider;
	import mx.controls.Label;
	import mx.events.FlexEvent;
	import mx.events.SliderEvent;
	
	public class ApplicationController
	{
		private var m_presentationContainer:PresentationContainer;
		private var m_btnOpenPresentation:Button;
		private var m_btnClosePresentation:Button;
		
		private var m_btnPlayPause:Button;
		private var m_btnNextSlide:Button;
		private var m_btnPrevSlide:Button;
		
		private var m_lblSlideTitle:Label;
		private var m_lblSlideIdex:Label;
		
		private var m_timeline:HSlider;
		private var m_timelineIsDragged:Boolean = false;
		
		private var m_seeking:Boolean = false;
		private var m_seekPosition:Number = -1;
		
		private var m_player:IPlayer;
		private var m_playbackController:IPresentationPlaybackController;
		private var m_presentationInfo:IPresentationInfo;
		
		public function ApplicationController(application:sample3)
		{
			m_presentationContainer = application.presentationContainer;
			m_btnOpenPresentation = application.btnOpenPresentation;
			m_btnClosePresentation = application.btnClosePresentation;
			
			m_btnNextSlide = application.btnNextSlide;
			m_btnPrevSlide = application.btnPrevSlide;
			m_btnPlayPause = application.btnPlayPause;
			
			m_lblSlideIdex = application.lblSlideIndex;
			m_lblSlideTitle = application.lblSlideTitle;
			
			m_timeline = application.timeline;
			m_timeline.allowTrackClick = false;
			
			initEventHandlers();
		}
		
		private function initEventHandlers():void
		{
			m_btnOpenPresentation.addEventListener(FlexEvent.BUTTON_DOWN, onBtnOpenPresentationClick);
			m_btnClosePresentation.addEventListener(FlexEvent.BUTTON_DOWN, onBtnClosePresentationClick);
			m_btnPlayPause.addEventListener(FlexEvent.BUTTON_DOWN, onBtnPlayPauseClick);
			
			m_btnNextSlide.addEventListener(FlexEvent.BUTTON_DOWN, onBtnNextSlideClick);
			m_btnPrevSlide.addEventListener(FlexEvent.BUTTON_DOWN, onBtnPrevSlideClick);
			
			m_timeline.addEventListener(SliderEvent.THUMB_DRAG, onTimelineDrag);
			m_timeline.addEventListener(SliderEvent.THUMB_PRESS, onTimelinePress);
			m_timeline.addEventListener(SliderEvent.THUMB_RELEASE, onTimelineRelease);
			
			m_presentationContainer.addEventListener(PlayerInitEvent.PLAYER_INIT, onPlayerInit);	
		}
		
		private function onPlayerInit(e:PlayerInitEvent):void
		{	
			m_player = e.player;
			m_playbackController = m_player.playbackController;
			m_presentationInfo = m_player.presentationInfo;
			
			m_timeline.maximum = m_presentationInfo.duration;
			
			var playbackController:IPresentationPlaybackController = m_player.playbackController;
			
			playbackController.addEventListener(SlidePlaybackEvent.CURRENT_SLIDE_INDEX_CHANGED, onCurrentSlideIndexChange);
			playbackController.addEventListener(PlaybackPositionEvent.SLIDE_POSITION_CHANGED, onSlidePositionChange);
			playbackController.addEventListener(PlaybackEvent.START_PLAYBACK, onStartPlayback);
			playbackController.addEventListener(PlaybackEvent.PAUSE_PLAYBACK, onPausePlayback);
			playbackController.addEventListener(PlaybackEvent.SEEKING_COMPLETE, onSeekingComplete);
		}
		
		/***********************
		*Buttons event handlers
		************************/
		
		private function onBtnOpenPresentationClick(e:FlexEvent):void
		{		
			var file:File = new File();
			file.browseForOpen("Select presentation");
			file.addEventListener(Event.SELECT, onSelectPresentation);
		}
		
		private function onBtnClosePresentationClick(e:FlexEvent):void
		{
			release();
		}
		
		private function release():void
		{
			if (!m_player)
				return;
			
			m_presentationContainer.unload();
			
			m_player = null;
			m_playbackController = null;
			m_presentationInfo = null;
			
			m_timeline.value = 0;
			m_lblSlideIdex.text = "";
			m_lblSlideTitle.text = "";			
		}
		
		private function onSelectPresentation(e:Event):void
		{			
			release();
			
			var file:File = e.currentTarget as File;
			var appStorageFile:File = File.applicationStorageDirectory.resolvePath(file.name);
			file.copyTo(appStorageFile, true);
			m_presentationContainer.load(appStorageFile.url);
		}
		
		private function onBtnPlayPauseClick(e:FlexEvent):void
		{
			m_btnPlayPause.selected = !m_btnPlayPause.selected;
			
			if (!m_player)
				return;
			
			if (m_btnPlayPause.selected)
			{	
				m_playbackController.play();
			}
			else
			{
				m_playbackController.pause();
			}
		}
		
		private function onBtnNextSlideClick(e:FlexEvent):void
		{
			if (m_playbackController)
				m_playbackController.gotoNextSlide(true);
		}
		
		private function onBtnPrevSlideClick(e:FlexEvent):void
		{
			if (m_playbackController)
				m_playbackController.gotoPreviousSlide(true);
		}
		
		private function onTimelineDrag(e:SliderEvent):void
		{
			newSliderPosition(e.value);
		}
		
		private function onTimelinePress(e:SliderEvent):void
		{			
			m_timelineIsDragged = true;
			
			if (m_playbackController)
				m_playbackController.pause();
		}
		
		private function onTimelineRelease(e:SliderEvent):void
		{
			m_timelineIsDragged = false;
			
			newSliderPosition(m_timeline.value);
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
		
		/*************************
		 * Player event handlers
		 ************************/
		private function onCurrentSlideIndexChange(e:SlidePlaybackEvent):void
		{
			if (!m_player)
				return;
			
			var slideIndex:int = e.slideIndex;
			var slides:ISlidesCollection = m_presentationInfo.slides;
			var slidesCount:int = slides.visibleSlidesCount;
			
			m_lblSlideTitle.text = slides.getVisibleSlide(slideIndex).title;
			m_lblSlideIdex.text = "" + (slideIndex + 1) + "/" + slidesCount;
		}
		
		private function onStartPlayback(e:PlaybackEvent):void
		{
			if (m_timelineIsDragged)
				return;
			
			m_btnPlayPause.selected = true;
		}
		
		private function onPausePlayback(e:PlaybackEvent):void
		{
			if (m_timelineIsDragged || m_seeking)
				return;
				
			m_btnPlayPause.selected = false;
		}
		
		private function onSlidePositionChange(e:PlaybackPositionEvent):void
		{
			if (!m_player)
				return;
			
			if (!m_timelineIsDragged && !m_seeking)
				m_timeline.value = getPresentationPosition();
		}

		private function onSeekingComplete(e:PlaybackEvent):void
		{			
			if (m_seekPosition != -1)
			{
				setPresentationPosition(m_seekPosition, true);
				m_seekPosition = -1;
			}
			else
			{
				m_seeking = false;
			}
			
			if (!m_timelineIsDragged)
				m_playbackController.play();
		}

		/**
		 * Note: position is a number in range between 0 and presentationDuration
		 */
		private function setPresentationPosition(position:Number, autoStart:Boolean):void
		{			
			if (!m_player)
				return;
			
			var presentationInfo:IPresentationInfo = m_player.presentationInfo;
			
			var slidesCount:Number = presentationInfo.slides.slidesCount;
			var currentPresentationTime:Number = position;
			
			for (var i:Number = 0; i < slidesCount; ++i)
			{				
				var slideInfo:ISlideInfo = presentationInfo.slides.getVisibleSlide(i);
				var slideStartTime:Number = slideInfo.startTime;
				var slideEndTime:Number = slideInfo.endTime;
				
				if ((currentPresentationTime >= slideStartTime) && (currentPresentationTime <= slideEndTime))
				{
					break;
				}
			}
				
			var slidePosition:Number = (currentPresentationTime - slideStartTime) / (slideEndTime - slideStartTime);
			
			var playbackController:IPresentationPlaybackController = m_player.playbackController;
			playbackController.gotoSlide(i, false);
			playbackController.seek(slidePosition);
			playbackController.endSeek(autoStart);
		}
	
		/**
		 * Note: return range between 0 and presentationDuration
		 */
		private function getPresentationPosition():Number
		{
			var presInfo:IPresentationInfo = m_player.presentationInfo;
			var playbackController:IPresentationPlaybackController = m_player.playbackController;
			
			var currentSlideIndex:int = playbackController.currentSlideIndex;
			var currentSlidePos:Number = playbackController.currentSlidePlaybackPosition; 
			
			var slideStartTime:Number = presInfo.slides.getVisibleSlide(currentSlideIndex).visibleStartTime;
			
			var nextSlideStartTime:Number;
			if (playbackController.currentVisibleSlideIndex < presInfo.slides.visibleSlidesCount - 1)
			{
				nextSlideStartTime = presInfo.slides.getVisibleSlide(currentSlideIndex + 1).visibleStartTime;
			}
			else
			{
				nextSlideStartTime = presInfo.visibleDuration;
			}
			
			var currentTime:Number = slideStartTime + currentSlidePos * (nextSlideStartTime - slideStartTime);
			return currentTime;
		}
	}
}