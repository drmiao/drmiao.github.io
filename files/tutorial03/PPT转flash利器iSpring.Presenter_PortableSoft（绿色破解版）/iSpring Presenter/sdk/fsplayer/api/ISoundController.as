import fsplayer.api.ISoundListener;

interface fsplayer.api.ISoundController
{
	/*
	Allows to add external object which implements ISoundListener interface; it will receive notifications about sound volume changes
	*/
	function addListener(listener:ISoundListener):Void;
	
	/*
	Removes previously added Listener to stop receiving notifications about sound volume changes
	*/
	function removeListener(listener:ISoundListener):Void;
	
	/*
	Returns sound volume.
	Note: sound volume is a number between 0 and 1
	*/
	function getVolume():Number;
	
	/*
	Sets sound volume.
	Note: sound volume is a number between 0 and 1
	*/
	function setVolume(volume:Number):Void;
	
	/*
	Tweaks the implementation-specific parameter to the specified value
	The following parameters are currently supported
	blinkSounds:Boolean - shut all sounds down for a moment when switching from the slide with embedded Flash movies
	*/
	function tweak(parameterName:String, parameterValue:Object):Void;
	
	/*
	Returns the tweakable parameter value
	*/
	function getTweakableParameter(parameterName:String):Object;
}
