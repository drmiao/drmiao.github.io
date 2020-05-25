import fsplayer.api.IPresentationInfo;
import fsplayer.api.IPresentationPlaybackController;
import fsplayer.api.ISoundController;
import fsplayer.api.IPlayerListener;
import fsplayer.ui.skins.ISkin;
import fsplayer.api.IKeyboardSettings;

interface fsplayer.api.IPlayer
{
	/*
	Allows to add an external object which implements IPlayerListener interface; This object will receive notification from Player
	*/
	function addListener(listener:IPlayerListener):Void;
	
	/*
	Removes previously added Listener to stop receiving notifications from Player. 
	*/
	function removeListener(listener:IPlayerListener):Void;
	
	/*
	Returns Boolean value that shows whether the Player was initialized. The following methods are not available until player gets initialized:
	getPresentationInfo(),
	getPlaybackController(), 
	getSoundController(), 
	getSettings() 
	*/
	function isInitialized():Boolean;
	
	/*
	Returns IPresentationPlaybackController Interface which allows to control presentation playback and navigation
	*/
	function getPlaybackController():IPresentationPlaybackController;
	
	/*
	Returns ISoundController Interface which allows to control (turn up and down) sound volume
	*/
	function getSoundController():ISoundController;
	
	/*
	Returns IPresentationInfo Interface that stores information about presentation
	*/
	function getPresentationInfo():IPresentationInfo;
	
	/*
	Returns an Object that contains settings needed to develop your custom Player. Please note that these settings can be changed
	*/
	function getSettings():Object;
	
	/*
	Returns the ISkin interface of the player
	*/
	function getSkin():ISkin;

	/*
	Returns the IKeyboardSettings interfaces providing keyboard control settings
	*/
	function getKeyboardSettings():IKeyboardSettings;
}
