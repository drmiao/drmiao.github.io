import fsplayer.api.IPlaybackListener;

interface fsplayer.api.IPresentationPlaybackController
{
	/*
	Allows to add an external object which implements IPlaybackListener interface; it will be notified about events during playback
	*/
	function addListener(listener:IPlaybackListener):Void;
	
	/*
	Removes previously added Listener to stop receiving notifications about events during playback
	*/
	function removeListener(listener:IPlaybackListener):Void;
	
	/*
	Returns Boolean value that indicates whether your presentation is playing or not
	*/
	function isPlaying():Boolean;
	
	/*
	Returns duration of currently playing slide in seconds
	*/
	function getCurrentSlideDuration():Number;
	
	/*
	Starts playback of your presentation
	*/
	function play():Void;
	
	/*
	Pauses playback of your presentation
	*/
	function pause():Void;
	
	/*
	Performs advance to the next slide
	*/
	function gotoNextSlide(autoStart:Boolean /* = true*/):Void;
	
	/*
	Performs advance to the previous slide. 
	*/
	function gotoPreviousSlide(autoStart:Boolean /* = true */):Void;
	
	/*
	Performs advance to the previously viewed slide 
	*/
	function gotoLastViewedSlide(autoStart:Boolean /* = true*/):Void;
	
	/*
	Returns index of currently playing slide
	Note: Slide index is zero-based
	*/
	function getCurrentSlideIndex():Number;
	
	/*
	Performs advance to the given presentation slide
	Note: Slide index is zero-based
	*/
	function gotoSlide(slideIndex:Number, autoStart:Boolean /* = true*/):Void;
	
	/*
	Returns current playback position within the slide
	Note: playback position is a number in range between 0 and 1
	*/
	function getCurrentSlidePlaybackPosition():Number;
	
	/*
	Pauses current slide playback at the given position set by an index
	Note: position is a number in range between 0 and 1
	*/
	function pauseCurrentSlideAt(position:Number):Void;
	
	/*
	Starts current slide playback from the given position
	Note: position is a number in range between 0 and 1
	*/
	function playCurrentSlideFrom(position:Number):Void;
	
	/*
	Switches presentation playback in slide seeking mode and changes current slide playback position to the specified one
	In seeking mode slide playback is suspended
	To exit from seeking mode and restore previous playback mode you must call endSeek() method
	Note: position is a number in range between 0 and 1
	*/
	function seek(position:Number):Void;
	
	/*
	Exits from seeking mode and restores previously set playback mode
	*/
	function endSeek(resumePlayback:Boolean /* = undefined */):Void;
	
	/*
	Returns index of animation step currently playing
	*/
	function getCurrentStepIndex():Number;
	
	/*
	Moves slide playback one animation step forward. This method plays slide from the beginning of the next animation step
	Being called at the and of the slide this method causes playback switching to the beginning of the next slide
	*/
	function gotoNextStep():Void;
	
	/*
	Moves slide playback one step back. This method pauses slide playback at the end of the previous animation step
	Being called on the start slide step this method causes playback switching to the end of the previous slide
	*/
	function gotoPreviousStep():Void;
	
	/*
	This method allows to set pause between animation steps. If an undefined value is passed as pause value, animation steps will not be played automatically
	*/
	function setAnimationStepPause(pause:Number):Void;
	
	/*
	Plays current slide from the beginning of specified animation step
	*/
	function playFromStep(stepIndex:Number):Void;
	
	/*
	Pauses current slide at the beginning of specified animation step
	*/
	function pauseAtStepStart(stepIndex:Number):Void;
	
	/*
	Pauses current slide at the end of specified animations step
	*/
	function pauseAtStepEnd(stepIndex:Number):Void;
	
	/*
	Enables/disables automatic switching to the next slide at slide end
	*/
	function enableAutomaticSlideSwitching(autoSwitch:Boolean):Void;
	
	/*
	Returns true if automatic slide switching is enabled, false otherwise
	*/
	function getAutomaticSlideSwitching():Boolean;
	
	/*
	Returns index of currently playing visible slide.
	Returns an undefined value if current slide is hidden.
	Note: Slide index is zero-based. 
	*/
	function getCurrentVisibleSlideIndex():Number;
	
	/*
	Performs advance to the given presentation visible slide.
	Note: Slide index is zero-based. 
	*/
	function gotoVisibleSlide(visibleSlideIndex:Number, autoStart:Boolean /* = true*/):Void;
	
	/*
	Performs advance to first presentation slide
	*/
	function gotoFirstSlide(autoStart:Boolean /* = true*/, considerHiddenSlides:Boolean /*= undefined*/):Void;
	
	/*
	Performs advance to last presentation slide
	*/
	function gotoLastSlide(autoStart:Boolean /* = true*/, considerHiddenSlides:Boolean /*= undefined*/):Void;
	
	/*
	Returns next slide index or an undefined value in case current slide is the latest one
	*/
	function getNextSlideIndex():Number;
	
	/*
	Returns previous slide index or an undefined value in case current slide is the first one
	*/
	function getPreviousSlideIndex():Number;

	/*
	Returns Boolean value that indicates whether some named slide show is playing or not
	*/
	function namedSlideShowIsPlaying():Boolean;	
	
	// enables or disables default handler for the "End slide show event" which tries to close the presentation
	function enableDefaultEndSlideShowHandler(value:Boolean):Void;
	
	// indicates whether the default slide show handler is enabled
	function defaultEndSlideShowHandlerIsEnabled():Boolean;

	/*
	Returns Boolean value that indicates whether slide transition is playing or slide
	*/
	function transitionIsPlaying():Boolean;	

	/*
	Returns current slide transition phase
	Note: transition phase is a number in range between 0 and 1
	*/
	function getCurrentSlideTransitionPhase():Number;
}
