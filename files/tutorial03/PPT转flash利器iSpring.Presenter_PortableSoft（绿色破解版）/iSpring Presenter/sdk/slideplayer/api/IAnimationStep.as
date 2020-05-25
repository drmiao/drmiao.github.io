
interface slideplayer.api.IAnimationStep
{
	/*
	Returns the duration of the animation step
	*/
	function getPlayTime():Number;
	
	/*
	Returns the duration of pause after the animation step
	*/
	function getPauseTime():Number;
	
	/*
	Returns the time when animation step starts playback
	*/
	function getStartTime():Number;
	
	/*
	Returns start time of pause after the animation step
	*/
	function getPauseStartTime():Number;
	
	/*
	Returns end time of pause after the animation step
	*/
	function getPauseEndTime():Number;
}
