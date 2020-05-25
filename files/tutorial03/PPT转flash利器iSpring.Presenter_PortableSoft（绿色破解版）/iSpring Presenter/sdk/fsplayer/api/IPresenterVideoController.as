import fsplayer.api.IPresenterVideoListener;
import fsplayer.api.IPresenterVideo;

interface fsplayer.api.IPresenterVideoController
{
	function addListener(listener:IPresenterVideoListener):Void;
	function removeListener(listener:IPresenterVideoListener):Void;
	
	function getCurrentVideo():IPresenterVideo;
}
