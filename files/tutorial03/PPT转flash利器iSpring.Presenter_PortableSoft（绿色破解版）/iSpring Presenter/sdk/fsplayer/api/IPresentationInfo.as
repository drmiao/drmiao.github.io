import fsplayer.api.IPresenterInfo;
import fsplayer.api.IPresentersCollection;
import fsplayer.api.ISlidesCollection;
import fsplayer.api.IThumbnailsCollection
import fsplayer.api.ICompanyInfo;
import fsplayer.api.IReferencesCollection;

interface fsplayer.api.IPresentationInfo
{
	/*
	Returns String with title of the presentation
	*/
	function getTitle():String;
	
	/*
	Returns ISlides interface that allows to get information about slides
	*/
	function getSlides():ISlidesCollection;
	
	/*
	Returns width of slides in presentation in pixels
	*/
	function getSlideWidth():Number;
	
	/*
	Returns height of slides in presentation in pixels
	*/
	function getSlideHeight():Number;
	
	/*
	Returns a Boolean value that indicates whether your presentation has got thumbnails
	*/
	function hasThumbnails():Boolean;
	
	/*
	Returns IThumbnails interface that allows to get information about presentation thumbnails
	*/
	function getThumbnails():IThumbnailsCollection;
	
	/*
	Returns a Boolean value that indicates whether your presentation has got information about presenter
	*/
	function hasPresenter():Boolean;
	
	/*
	Returns IPresenterInfo interface that stores information about presenter
	*/
	function getPresenterInfo():IPresenterInfo;
	
	/*
	Returns the frame rate of loaded presentation
	*/
	function getFrameRate():Number;
	
	/*
	Returns the duration of the presentation in seconds
	*/
	function getDuration(withTransitions:Boolean /* = false*/):Number;
	
	/*
	Returns a Boolean value that indicates whether the presentation has company information
	*/
	function hasCompanyInfo():Boolean;
	
	/*
	Returns an ICompanyInfo interface that stores information about company
	*/
	function getCompanyInfo():ICompanyInfo;
	
	/*
	Returns a Boolean value that indicates whether the presentation has References
	*/
	function hasReferences():Boolean;
	
	/*
	Returns presentation references
	*/
	function getReferences():IReferencesCollection;
	
	/*
	Returns total duration of visible slides in seconds
	*/
	function getVisibleDuration(withTransitions:Boolean /* = false*/):Number;
	
	/*
	Returns presentation presenters collection
	*/
	function getPresenters():IPresentersCollection;
	
	/*
	Returns the presentation unique Id
	*/
	function getUniqueId():String;
}
