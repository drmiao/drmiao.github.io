
interface fsplayer.api.IPlaybackListener
{
	/*
	This method is invoked when presentation playback is paused
	*/
	function onPausePlayback():Void;
	
	/*
	This method is invoked when presentation playback resumes after pause
	*/
	function onStartPlayback():Void;
	
	/*
	This method is invoked when presentation advances to the next animation step
	*/
	function onAnimationStepChanged(stepIndex:Number):Void;
	
	/*
	This method is invoked when the playback position changes
	*/
	function onSlidePositionChanged(position:Number):Void;
	
	/*
	This method is invoked when the transition phase changes (from 0 to 1)
	*/
	function onSlideTransitionPhaseChanged(phase:Number):Void;

	/*
	This method is invoked when the current slide advances to the different one
	*/
	function onCurrentSlideIndexChanged(slideIndex:Number):Void;
	
	/*
	This method is invoked when slide load is completed
	*/
	function onSlideLoadingComplete(slideIndex:Number):Void;
	
	/*
	This method is invoked when presentation playback comes to the end and stops
	*/
	function onPresentationPlaybackComplete():Void;
	
	/*
	This method is invoked when an interactive element of the presentation
	(e.g. a text field of a Quiz) acquires or losts keyboard focus
	*/
	function onKeyboardFocusStateChanged(acquireFocus:Boolean):Void;
	
	/*
	This method is invoked when automatic playback is suspended at animation step end
	*/
	function onPlaybackSuspended():Void;
	
	/*
	This method is invoked when automatic playback is resumed on user's request
	*/
	function onPlaybackResumed():Void;
	
	
	/*
	This method is invoked when the user clicked "End Slide Show" action button or hyperlink
	*/
	function onHandleCloseRequest():Void;
}
