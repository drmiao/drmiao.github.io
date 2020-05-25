import fsplayer.ui.skins.ISkinUIControllerListener;

interface fsplayer.ui.skins.ISkinUIController
{
	function addUIListener(listener:ISkinUIControllerListener):Void;
	function removeUIListener(listener:ISkinUIControllerListener):Void;
	
	// enables / disables default close event handling
	function enableDefaultCloseEventHandler(enableDefaultCloseHandler:Boolean):Void;
	function defaultCloseEventHandlerIsEnabled():Boolean;
}
