import slideplayer.api.*;

interface slideplayer.api.IPlaybackController
{
	/*
	Allows to add an external object which implements IPlaybackListener interface; it will be notified about events during playback.
	*/
	function addListener(listener:IPlaybackListener):Void;

	/*
	Removes previously added Listener to stop receiving notifications about events during playback. 
	*/
	function removeListener(listener:IPlaybackListener):Void;

	/*
	Returns a Boolean value showing whether slide is playing or not.
	*/
	function isPlaying():Boolean;

	/*
	Plays slide if it was paused.
	*/
	function play():Void;

	/*
	Pauses slide playback if it was playing. 
	*/
	function pause():Void;

	/*
	Returns slide position that is currently playing 
	*/
	function getPosition():Number;

	/*
	Plays slide from specified positition. Position is a Number from 0 to 1
	*/
	function playFromPosition(position:Number):Void;

	/*
	Pauses slide at specified position. Position is a Number from 0 to 1
	*/
	function pauseAtPosition(position:Number):Void;

	/*
	Returns index of animation step currently playing. 
	*/
	function getCurrentStepIndex():Number;

	/*
	Moves slide playback one animation step forward. This method plays slide from the beginning of the next animation step.
	*/
	function gotoNextStep():Void;

	/*
	Moves slide playback one step back. This method pauses slide playback at the end of the previous animation step. 
	*/
	function gotoPreviousStep():Void;

	/*
	Plays slide from the beginning of specified animation step. 
	*/
	function playFromStep(stepIndex:Number):Void;

	/*
	Pauses current slide at the beginning of specified animation step. 
	*/
	function pauseAtStepStart(stepIndex:Number):Void;

	/*
	Pauses current slide at the end of specified animations step 
	*/
	function pauseAtStepEnd(stepIndex:Number):Void;
}
