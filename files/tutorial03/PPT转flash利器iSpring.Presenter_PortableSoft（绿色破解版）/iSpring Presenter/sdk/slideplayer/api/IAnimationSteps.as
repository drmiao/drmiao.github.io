import slideplayer.api.IAnimationStep;

interface slideplayer.api.IAnimationSteps
{
	/*
	Returns number of animation steps on the slide
	*/
	function getStepsCount():Number;
	
	/*
	Returns the duration of animation steps in seconds
	*/
	function getDuration():Number;
	
	/*
	Returns IAnimationStep Interface which allows to get timing settings of this animation step
	*/
	function getStep(index:Number):IAnimationStep;
}
