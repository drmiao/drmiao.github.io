package ispring.as3bridge
{	
	public class SlidesCollection
	{
		private var m_bridgeConnector:BridgeConnector;
		
		private var m_slides:Array;
		private var m_slidesCount:Number;
		private var m_visibleSlidesCount:Number;
		private var m_visibleIndexToIndex:Array;
		private var m_log:LogConsole;
		
		public function SlidesCollection(internalClass:InternalClass, bridgeConnector:BridgeConnector, sc:Object)
		{
			m_log = LogConsole.getInstance();
			
			m_bridgeConnector = bridgeConnector;
			m_slidesCount = sc.slidesCount;
			m_visibleSlidesCount = sc.visibleSlidesCount;
			
			m_slides = new Array();
			m_visibleIndexToIndex = new Array(m_visibleSlidesCount ? m_visibleSlidesCount : 0);
			
			initSlides(sc.slides);
			initEventFunctions();
		}
		
		public function get slidesCount():Number
		{
			return m_slidesCount;
		}
		
		public function getSlideInfo(slideIndex:Number):SlideInfo
		{
			return m_slides[slideIndex];
		}
		
		public function release():void
		{
			removeEventFunctions();
		}
		
		private function onSlideMetadataLoad(slideIndex:Number, slideInfo:Object):void
		{
			m_slides[slideIndex].setMetadata(new InternalClass(), slideInfo);
		}
		
		private function onSlideLoadingComplete(slideIndex:Number):void
		{
			m_slides[slideIndex].loadingComplete(new InternalClass());
		}
		
		private function initEventFunctions():void
		{
			m_bridgeConnector.setOnSlideMetadataLoadCallback(this.onSlideMetadataLoad);
			m_bridgeConnector.setOnSlideLoadingCompleteSlidesCollection(this.onSlideLoadingComplete);
		}
		
		private function removeEventFunctions():void
		{
			m_bridgeConnector.removeOnSlideMetadataLoadCallback();
			m_bridgeConnector.removeOnSlideLoadingCompleteSlidesCollection();
		}
		
		private function initSlides(slidesInfo:Object):void
		{
			for (var i:Number = 0; i < m_slidesCount; i++)
			{
				var slide:SlideInfo = new SlideInfo(new InternalClass(), m_bridgeConnector, i, slidesInfo["slide" + i]);
				
				if (!slide.isHidden())
					m_visibleIndexToIndex[slide.visibleIndex] = i;
				
				m_slides[i] = slide;
			}
		}
		
		private function get visibleSlidesCount():Number
		{
			return m_visibleSlidesCount;
		}
		
		private function getVisibleSlide(visibleSlideIndex:Number):SlideInfo
		{
			if (visibleSlideIndex < 0 && visibleSlideIndex >= m_visibleSlidesCount)
				return undefined;
			
			return m_slides[m_visibleIndexToIndex[visibleSlideIndex]];
		}
	}
}