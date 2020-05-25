// ActionScript file
package sample
{
	import mx.controls.Button;
	import mx.controls.HSlider;

	import flash.events.MouseEvent;

	import ispring.flex.PresentationContainer;
	import ispring.flex.PlayerInitEvent;
	import ispring.as2player.IPresentationPlaybackController;
	import ispring.as2player.IPlayer;
	import ispring.as2player.IPresentationInfo;
	import ispring.as2player.SlidePlaybackEvent;
	import ispring.as2player.PlaybackPositionEvent;
	import ispring.as2player.PlaybackEvent;
	import ispring.as2player.ISlidesCollection;
	import ispring.as2player.ISlideInfo;

	import mx.events.FlexEvent;
	import mx.events.SliderEvent;
	
	public class ApplicationController
	{
		private static var PRESENTATION1_URL:String = "presentations/presentation1.swf";
		private static var PRESENTATION2_URL:String = "presentations/presentation2.swf";
		
		private var m_btnPresentation1:Button;
		private var m_btnPresentation2:Button;
		
		private var m_btnPlayPause:Button;
		private var m_btnPrev:Button;
		private var m_btnNext:Button;
		
		private var m_timeline:HSlider;
		private var m_timelineIsDragged:Boolean = false;
		
		private var m_seeking:Boolean = false;
		private var m_seekPosition:Number = -1;
		
		private var m_presentationContainer:PresentationContainer;
		
		private var m_player:IPlayer;
		private var m_playbackController:IPresentationPlaybackController;
		private var m_presentationInfo:IPresentationInfo;
		
		public function ApplicationController(v:sample2)
		{
			m_presentationContainer = v.presentationContainer;
						
			//presentations buttons
			m_btnPresentation1 = v.btnPresentation1;
			m_btnPresentation2 = v.btnPresentation2;
			
			//navigation buttons
			m_btnPlayPause = v.btnPlayPause;			
			m_btnPrev = v.btnPrev;
			m_btnNext = v.btnNext;
			
			//timeline
			m_timeline = v.timeline;
			m_timeline.allowTrackClick = false;
			m_timeline.liveDragging = true;
			
			initEventHandlers();
		}
		
		private function initEventHandlers():void
		{
			m_btnPresentation1.addEventListener(FlexEvent.BUTTON_DOWN, onBtnPres1Click);
			m_btnPresentation2.addEventListener(FlexEvent.BUTTON_DOWN, onBtnPres2Click);
			
			m_btnPlayPause.addEventListener(FlexEvent.BUTTON_DOWN, onBtnPlayPauseClick);	
			m_btnNext.addEventListener(FlexEvent.BUTTON_DOWN, onBtnNextClick);
			m_btnPrev.addEventListener(FlexEvent.BUTTON_DOWN, onBtnPrevClick);
			
			m_timeline.addEventListener(SliderEvent.THUMB_DRAG, onTimelineDrag);
			m_timeline.addEventListener(SliderEvent.THUMB_PRESS, onTimelinePress);
			m_timeline.addEventListener(SliderEvent.THUMB_RELEASE, onTimelineRelease);
			
			m_presentationContainer.addEventListener(PlayerInitEvent.PLAYER_INIT, onPlayerInit);	
		}
		
		private function loadPresentation(url:String):void
		{
			m_presentationContainer.load(url);
		}
		
		private function onPlayerInit(e:PlayerInitEvent):void
		{
			m_player = e.player;
			m_playbackController = m_player.playbackController;
			m_presentationInfo = m_player.presentationInfo;
			
			m_timeline.maximum = m_presentationInfo.duration;
			
			m_playbackController.addEventListener(SlidePlaybackEvent.CURRENT_SLIDE_INDEX_CHANGED, onCurrentSlideIndexChange);
			m_playbackController.addEventListener(PlaybackPositionEvent.SLIDE_POSITION_CHANGED, onSlidePositionChange);
			m_playbackController.addEventListener(PlaybackEvent.START_PLAYBACK, onStartPlayback);
			m_playbackController.addEventListener(PlaybackEvent.PAUSE_PLAYBACK, onPausePlayback);
			m_playbackController.addEventListener(PlaybackEvent.SEEKING_COMPLETE, onSeekingComplete);	
		}
		
		/***********************
		*Buttons event handlers
		************************/

		private function release():void
		{
			if (!m_player)
				return;
			
			m_presentationContainer.unload();
			
			m_player = null;
			m_playbackController = null;
			m_presentationInfo = null;
			
			m_timeline.value = 0;
		}
		
		private function onTimelineDrag(e:SliderEvent):void
		{
			newSliderPosition(e.target.value);
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
		
		private function onBtnPres1Click(e:FlexEvent):void
		{
			release();
			loadPresentation(PRESENTATION1_URL);
		}
		
		private function onBtnPres2Click(e:FlexEvent):void
		{
			release();
			loadPresentation(PRESENTATION2_URL);
		}
		
		private function onBtnPrevClick(e:FlexEvent):void
		{
			if (m_playbackController)
			{
				m_playbackController.gotoPreviousSlide(true);
			}
		}
		
		private function onBtnNextClick(e:FlexEvent):void
		{
			if (m_playbackController)
			{
				m_playbackController.gotoNextSlide(true);
			}
		}
		
		private function onBtnPlayPauseClick(e:FlexEvent):void
		{
			m_btnPlayPause.selected = !m_btnPlayPause.selected;
			
			if (!m_playbackController)
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