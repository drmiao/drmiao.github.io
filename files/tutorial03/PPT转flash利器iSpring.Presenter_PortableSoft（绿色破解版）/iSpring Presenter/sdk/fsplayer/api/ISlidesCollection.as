import fsplayer.api.ISlideInfo;

interface fsplayer.api.ISlidesCollection
{
	/*
	Returns number of slides in your presentation
	*/
	function getSlidesCount():Number;
	
	/*
	Returns ISlideInfo interface for given slide index. Note: Slide index is zero-based
	*/
	function getSlideInfo(slideIndex:Number):ISlideInfo;
	
	/*
	Returns number of visibleSlides in your presentation. 
	*/
	function getVisibleSlidesCount():Number;
	
	/*
	Returns ISlideInfo interface for given visible slide index. Note: Slide index is zero-based.
	*/
	function getVisibleSlide(visibleSlideIndex:Number):ISlideInfo;
}