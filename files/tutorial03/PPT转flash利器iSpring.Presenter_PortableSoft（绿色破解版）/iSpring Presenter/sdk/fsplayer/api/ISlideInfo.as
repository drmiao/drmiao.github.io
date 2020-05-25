import fsplayer.api.ISlideThumbnail;
import fsplayer.api.IAnimationSteps;
import fsplayer.api.ISlideResources;

interface fsplayer.api.ISlideInfo
{
	/*
	Returns Boolean value that indicates whether slide is completely loaded
	*/
	function isLoaded():Boolean;
	
	/*
	Returns title of the slide
	*/
	function getTitle():String;
	
	/*
	Returns IAnimationSteps interface that allows to get information about animation steps on this slide
	*/
	function getAnimationSteps():IAnimationSteps;
	
	/*
	Returns slide duration in seconds
	*/
	function getDuration(withTransition:Boolean /* = false*/):Number;	
	
	/*
	Returns transition duration in seconds
	*/
	function getTransitionDuration():Number;	

	/*
	Returns notes text of the slide
	*/
	function getNotesText():String;
	
	/*
	Returns slide start time within presentation
	*/
	function getStartTime(withTransition:Boolean /* = false*/):Number;
	
	/*
	Returns slide end time within presentation
	*/
	function getEndTime(withTransition:Boolean /* = false*/):Number;
	
	/*
	Returns slide start step index within presentation
	*/
	function getStartStepIndex():Number;
	
	/*
	Returns slide end step index within presentation
	*/
	function getEndStepIndex():Number;
	
	/*
	Returns slide text
	*/
	function getSlideText():String;
	
	/*
	Returns notes text optimized for searching
	*/
	function getNotesTextNormalized():String;
	
	/*
	Returns slide title optimized of searching
	*/
	function getTitleNormalized():String;
	
	/*
	Returns slide level (0 - upper level)
	*/
	function getLevel():Number;
	
	/*
	Returns Boolean value that indicates whether slide is hidden
	*/
	function isHidden():Boolean;
	
	/*
	Returns slide index within presentation
	*/
	function getIndex():Number;
	
	/*
	 Returns slide index within slide show (hidden slides are excluded from slide show). This method returns an undefined value if the slide is hidden
	*/
	function getVisibleIndex():Number;
	
	/*
	Returns visible slide start time within presentation, undefined for hidden slide.
	*/
	function getVisibleStartTime(withTransition:Boolean /* = false*/):Number;
	
	/*
	Returns visible slide end time within presentation, undefined for hidden slide.
	*/
	function getVisibleEndTime(withTransition:Boolean /* = false*/):Number;
	
	/*
	Returns visible slide start step index within presentation, undefined for hidden slide.
	*/
	function getVisibleStartStepIndex():Number;
	
	/*
	Returns visible slide end step index within presentation, undefined for hidden slide.
	*/
	function getVisibleEndStepIndex():Number;
	
	/*
	Returns slide presenter index or an undefined value if no presenter is associated with the slide
	*/
	function getPresenterIndex():Number;
	
	/*
	Returns slide resources
	*/
	function getResources():ISlideResources;
	
	/*
	Returns HTML representation of the slide notes
	*/
	function getNotesHtml():String;	

	/*
	Indicates whether slide is advanced automatically
	*/
        function getAutoChange():Boolean;	
}
