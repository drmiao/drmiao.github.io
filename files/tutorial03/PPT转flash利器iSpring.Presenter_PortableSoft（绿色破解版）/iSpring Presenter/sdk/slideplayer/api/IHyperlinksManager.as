interface slideplayer.api.IHyperlinksManager
{
	/*
	This method is invoked when user clicks a hyperlink to another slide
	An implementation must load and display slide with given index
	Note: slideIndex is zero-based
	*/
	function gotoSlide(slideIndex:Number):Void;

	/*
	This method is invoked when user clicks a hyperlink to some external URL 
	Note: the simplest way to implement this method is to call following ActionScript function: getURL(url, target)
	*/
	function openURL(url:String, target:String):Void;

	/*
	This method is invoked when user clicks a hyperlink to last viewed slide.
	An implementation of this method must open slide that was previously shown.
	*/
	function gotoLastViewedSlide():Void;

	function gotoFirstSlide():Void;
	
	function gotoLastSlide():Void;
	
	function gotoNextSlide():Void;
	
	function gotoPreviousSlide():Void;

	/*
	This method is invoked when user clicks a hyperlink that finishes slide show
	*/
	function endShow():Void;
}
