import fsplayer.api.IPresenterVideo;

interface fsplayer.api.ISlideResources
{
	/*
	Indicates if there is presenter video
	*/
	function hasPresenterVideo():Boolean;
	
	/*
	Returns the IPresenterVideo interface describing presenter video
	If there is no presenter video, an undefined value is returned
	*/
	function getPresenterVideo():IPresenterVideo;
}
