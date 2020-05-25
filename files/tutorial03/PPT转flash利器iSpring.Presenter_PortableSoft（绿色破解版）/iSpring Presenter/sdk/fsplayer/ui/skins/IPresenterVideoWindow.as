import fsplayer.api.IPresenterVideoController;

interface fsplayer.ui.skins.IPresenterVideoWindow
{
	function initialize(presenterVideoController:IPresenterVideoController, settings:Object):Void;
	function getPresenterVideoTarget():MovieClip;
}
