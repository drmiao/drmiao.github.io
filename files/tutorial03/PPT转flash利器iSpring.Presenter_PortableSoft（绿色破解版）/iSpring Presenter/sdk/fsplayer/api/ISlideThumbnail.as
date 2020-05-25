import fsplayer.api.ISlideThumbnailLoadingListener;

interface fsplayer.api.ISlideThumbnail
{
	/*
	Returns index of the slide which the thumbnail refers to
	*/
	function getSlideIndex():Number;
	
	/*
	This method specifies MovieClip inside of which the slide thumbnail will be loaded
	You can pass an object that implements ISlideThumbnailLoadingListener interface which will be notified when thumbnail was loaded
	*/
	function load(target:MovieClip, listener:ISlideThumbnailLoadingListener):Void;
}
