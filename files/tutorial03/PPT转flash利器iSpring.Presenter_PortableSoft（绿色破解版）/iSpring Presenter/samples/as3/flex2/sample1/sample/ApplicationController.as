// ActionScript file
package sample
{
	import mx.controls.Button;
	import ispring.flex.PresentationContainer;
	import ispring.as2player.IPresentationPlaybackController;
	import ispring.flex.PlayerInitEvent;
	import mx.events.FlexEvent;
	import ispring.as2player.PlaybackEvent;
	
	public class ApplicationController
	{
		private var m_btnPlayPause:Button;
		private var m_presentationContainer:PresentationContainer;
		
		private var m_playbackController:IPresentationPlaybackController;
		
		public function ApplicationController(v:sample1)
		{
			m_presentationContainer = v.presentationContainer;
			m_presentationContainer.addEventListener(PlayerInitEvent.PLAYER_INIT, onPlayerInit);
			
			m_btnPlayPause = v.btnPlayPause;
			m_btnPlayPause.addEventListener(FlexEvent.BUTTON_DOWN, onBtnPlayPauseClick);
		}
		
		public function loadPresentation(url:String):void
		{
			m_presentationContainer.load(url);
		}
		
		private function onPlayerInit(e:PlayerInitEvent):void
		{
			m_playbackController = e.player.playbackController;
			
			m_playbackController.addEventListener(PlaybackEvent.START_PLAYBACK, onStartPlayback);
			m_playbackController.addEventListener(PlaybackEvent.PAUSE_PLAYBACK, onPausePlayback);
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
		
		private function onStartPlayback(e:PlaybackEvent):void
		{
			m_btnPlayPause.selected = true;
		}
		
		private function onPausePlayback(e:PlaybackEvent):void
		{		
			m_btnPlayPause.selected = false;
		}
		
	}
}