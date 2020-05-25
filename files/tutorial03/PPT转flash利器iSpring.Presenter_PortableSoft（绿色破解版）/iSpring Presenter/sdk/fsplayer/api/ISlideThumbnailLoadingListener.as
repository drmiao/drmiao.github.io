import fsplayer.api.ISlideThumbnail;

interface fsplayer.api.ISlideThumbnailLoadingListener
{
	/*
	This method is invoked before the beginning of loading slide thumbnail
	*/
	function onSlideThumbnailLoadInit(thumbnail:ISlideThumbnail):Void;
}
