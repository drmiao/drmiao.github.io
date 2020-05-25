interface slideplayer.api.IPlaybackListener
{
	/*
	This method is invoked when slide is paused. 
	*/
	function onPausePlayback():Void;

	/*
	This method is invoked when slide playback is resumed. 
	*/
	function onStartPlayback():Void;

	/*
	This method is invoked when slide playback position is changed. Position is a Number between 0 and 1
	*/
	function onSlidePositionChanged(position:Number):Void;

	/*
	This method is invoked when animation step was changed.
	*/
	function onAnimationStepChanged(stepIndex:Number):Void;

	/*
	This method is called when slide playback was finished.
	*/
	function onSlidePlaybackFinished():Void;
	
	/*
	This method is invoked when automatic playback is suspended at animation step end
	*/
	function onPlaybackSuspended():Void;
	
	/*
	This method is invoked when automatic playback is resumed on user's request
	*/
	function onPlaybackResumed():Void;
}
