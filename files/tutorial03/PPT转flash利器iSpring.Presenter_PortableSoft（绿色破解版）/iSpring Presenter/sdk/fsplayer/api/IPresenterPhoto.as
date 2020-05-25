import fsplayer.api.IPresenterPhotoLoadingListener;

interface fsplayer.api.IPresenterPhoto
{
	/*
	This method loads presenter photo into specified MovieClip
	*/
	function load(target:MovieClip, listener:IPresenterPhotoLoadingListener):Void;
}
