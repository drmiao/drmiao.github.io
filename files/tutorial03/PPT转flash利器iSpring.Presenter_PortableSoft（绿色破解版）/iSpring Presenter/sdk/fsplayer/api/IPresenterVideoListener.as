import fsplayer.api.IPresenterVideo;

interface fsplayer.api.IPresenterVideoListener
{
	function onChangePresenterVideo(video:IPresenterVideo):Void;
	function onPresenterVideoBufferEmpty():Void;
	function onPresenterVideoBufferFull():Void;
}
