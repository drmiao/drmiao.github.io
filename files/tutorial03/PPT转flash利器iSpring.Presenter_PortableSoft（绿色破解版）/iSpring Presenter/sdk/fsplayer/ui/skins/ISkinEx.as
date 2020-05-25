import fsplayer.ui.skins.ISkin;
import fsplayer.ui.skins.IPresenterVideoWindow;

interface fsplayer.ui.skins.ISkinEx extends ISkin
{
	function hasPresenterVideoWindow():Boolean;
	
	function getPresenterVideoWindow():IPresenterVideoWindow;
}
