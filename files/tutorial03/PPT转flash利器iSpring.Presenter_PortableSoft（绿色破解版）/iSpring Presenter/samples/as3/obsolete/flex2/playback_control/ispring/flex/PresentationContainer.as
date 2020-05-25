package ispring.flex
{
	import ispring.as3bridge.BridgeLoader;
	import ispring.as3bridge.BridgeEvent;
	import ispring.as3bridge.Player;
	import flash.display.Sprite;
	import mx.events.ResizeEvent;
	import mx.core.UIComponent;

	public class PresentationContainer extends UIComponent
	{
		private var m_container:Sprite;
		private var m_bridgeLoader:BridgeLoader;
		private var m_player:Player;
		
		public function PresentationContainer()
		{
			super();
			
			m_container = new Sprite();
			addChild(m_container);
			
			m_bridgeLoader = new BridgeLoader(m_container);
			m_bridgeLoader.addEventListener(BridgeEvent.PRESENTATION_LOADED, onPresentationLoaded);
			
			addEventListener(ResizeEvent.RESIZE, onResize);
		}
		
		public function get bridgeLoader():BridgeLoader
		{
			return m_bridgeLoader;
		}
		
		private function onResize(e:ResizeEvent):void
		{
			if ((m_player != null) && (m_player.initialized))
			{
				scaleContainer(m_player.presentationInfo.slideWidth, m_player.presentationInfo.slideHeight);
			}
		}
		
		private function onPresentationLoaded(e:BridgeEvent):void
		{
			if (e.player.initialized)
			{
				m_player = e.player;
				scaleContainer(e.player.presentationInfo.slideWidth, e.player.presentationInfo.slideHeight);
			}
		}
		
		private function scaleContainer(slideWidth:Number, slideHeight:Number):void
		{
			var presentationAspectRatio:Number = slideWidth / slideHeight;
			var componentAspectRatio:Number = width / height;
			
			if (componentAspectRatio > presentationAspectRatio)
			{
				m_container.scaleY = height / slideHeight;
				m_container.scaleX = m_container.scaleY;
			}
			else
			{
				m_container.scaleX = width / slideWidth;
				m_container.scaleY = m_container.scaleX;
			}
			
			m_container.x = width / 2 - (m_container.scaleX * slideWidth) / 2;
			m_container.y = height / 2 - (m_container.scaleY * slideHeight) / 2;
		}
	}
}