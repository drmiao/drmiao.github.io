import slideplayer.api.*;

interface slideplayer.api.ISlideController
{
	/*
	Returns slideplayer.api.IPlaybackController interface of the slide.
	*/
	function getPlaybackController():IPlaybackController;

	/*
	Returns slideplayer.api.ISoundController interface of the slide.
	*/
	function getSoundController():ISoundController;

	/*
	Returns slideplayer.api.IHyperlinksManager interface of the slide.
	*/
	function getHyperlinksManager():IHyperlinksManager;

	/*
	Allows to set slideplayer.api.IHyperlinkManager interface which will listen for hyperlink actions.
	*/
	function setHyperlinksManager(hyperlinksManager:IHyperlinksManager):Void;

	/*
	Returns slide width in pixels
	*/
	function getSlideWidth():Number;

	/*
	Returns slide height in pixels
	*/
	function getSlideHeight():Number;

	/*
	Returns number of animation steps on the slide.
	*/
	function getStepsCount():Number;

	/*
	Returns slideplayer.api.IAnimationSteps interface of the slide.
	*/
	function getAnimationSteps():IAnimationSteps;
}
