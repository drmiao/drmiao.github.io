import slideplayer.api.*;

class CMyHyperlinksManager implements IHyperlinksManager
{
	private var m_viewedSlides:Array;
	private var m_currentSlideIndex:Number;
	
	function CMyHyperlinksManager()
	{
		m_viewedSlides = new Array(); 
	}
	
	function gotoSlide(slideIndex:Number):Void
	{
		m_currentSlideIndex = slideIndex;
		m_viewedSlides.push(slideIndex);
		loadSlide(slideIndex);
	}
	
	function loadSlide(slideIndex:Number):Void
	{
		// empty
	}

	function openURL(url:String, target:String):Void
	{
		getURL(url, "_blank");
	}

	function gotoLastViewedSlide():Void
	{
		if (m_viewedSlides.length > 1)
		{		
			var curSlide:Number = Number(m_viewedSlides.pop());
			var lastViewedSlide:Number;
	
			do
			{
				lastViewedSlide = Number(m_viewedSlides.pop());
			} while ((lastViewedSlide == curSlide) && (m_viewedSlides.length != 0));
		
			if (lastViewedSlide != curSlide)
			{
				gotoSlide(lastViewedSlide);
			}
			else
			{
				m_viewedSlides.push(curSlide);
			}
		}
	}

	function endShow():Void
	{
		fscommand("quit", "true");
	}
	
	function gotoFirstSlide():Void
	{
	}
	
	function gotoLastSlide():Void
	{
	}
	
	function gotoNextSlide():Void
	{
	}
	
	function gotoPreviousSlide():Void
	{
	}
}
