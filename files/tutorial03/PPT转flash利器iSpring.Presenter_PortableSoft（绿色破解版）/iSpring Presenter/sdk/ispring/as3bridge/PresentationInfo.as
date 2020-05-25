package ispring.as3bridge
{
	public class PresentationInfo
	{
		private var m_bridgeConnector:BridgeConnector;
		
		private var m_title:String;
		private var m_duration:Number;
		private var m_slideWidth:Number;
		private var m_slideHeight:Number;
		private var m_hasReferences:Boolean;
		private var m_hasPresenter:Boolean;
		private var m_frameRate:Number;
		
		private var m_presentersCollection:PresentersCollection;
		private var m_referencesCollection:ReferencesCollection;
		private var m_slidesCollection:SlidesCollection;
		private var m_log:LogConsole;
		
		public function PresentationInfo(internalClass:InternalClass, bridgeConnector:BridgeConnector)
		{
			m_log = LogConsole.getInstance();
			
			m_bridgeConnector = bridgeConnector;
			initEventFunctions();
		}
		
		public function get hasPresenter():Boolean
		{
			return m_presentersCollection.presentersCount > 0;
		}
		
		public function getPresenterInfo(index:int = 0):PresenterInfo
		{
			return m_presentersCollection.getPresenter(index);
		}
		
		public function get slides():SlidesCollection
		{
			return m_slidesCollection;
		}
		
		public function get references():ReferencesCollection
		{
			return m_referencesCollection;
		}
		
		public function get title():String
		{
			return m_title;
		}
		
		public function get duration():Number
		{
			return m_duration;
		}
		
		public function get slideWidth():Number
		{
			return m_slideWidth;
		}
		
		public function get slideHeight():Number
		{
			return m_slideHeight;
		}
		
		public function get hasReferences():Boolean
		{
			return m_hasReferences;
		}
		
		public function get frameRate():Number
		{
			return m_frameRate;
		}
		
		private function initEventFunctions():void
		{
			m_bridgeConnector.setOnPresentationLoadedCallbackPresentationInfo(this.onPresentationLoaded);
		}
		
		private function onPresentationLoaded(presentationInfo:Object):void
		{
			if (m_slidesCollection)
				m_slidesCollection.release();

			m_title			= presentationInfo.title;
			m_duration		= presentationInfo.duration;
			m_slideWidth	= presentationInfo.slideWidth;
			m_slideHeight	= presentationInfo.slideHeight;
			m_hasReferences	= presentationInfo.hasReferences;
			m_hasPresenter	= presentationInfo.hasPresenter;
			m_frameRate		= presentationInfo.frameRate;
			
			if (m_hasPresenter)
			{
				m_presentersCollection = new PresentersCollection(new InternalClass(), presentationInfo.presentersCollection);
			}
		
			if (m_hasReferences)
			{
				m_referencesCollection = new ReferencesCollection(new InternalClass(), presentationInfo.referencesCollection);
			}
			
			m_slidesCollection = new SlidesCollection(new InternalClass(), m_bridgeConnector, presentationInfo.slidesCollection);
			
		}
	}
}