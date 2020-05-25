import fsplayer.api.IPlaybackAction;

interface fsplayer.api.IKeyboardSettings
{
	function getPlaybackAction(keyCode:Number, controlPressed:Boolean, shiftPressed:Boolean):IPlaybackAction;
	
	function keyboardEnabled():Boolean;
}
