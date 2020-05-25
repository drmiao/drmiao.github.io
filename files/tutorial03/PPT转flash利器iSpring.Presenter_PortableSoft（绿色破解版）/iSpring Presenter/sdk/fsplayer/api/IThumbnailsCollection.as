import fsplayer.api.ISlideThumbnail;

interface fsplayer.api.IThumbnailsCollection
{
	/*
	Returns ISlideThumbnail interface for specified slide
	*/
	function getThumbnail(slideIndex:Number):ISlideThumbnail;
	
	/*
	Returns width of thumbnail in pixels
	*/
	function getThumbnailWidth():Number;
	
	/*
	Returns height of thumbnail in pixels
	*/
	function getThumbnailHeight():Number;
	
	/*
	Returns number of thumbnails for the slides in presentation
	*/
	function getThumbnailsCount():Number;
}