import fsplayer.api.IPresenterPhoto;
import fsplayer.api.ICompanyInfo;

interface fsplayer.api.IPresenterInfo
{
	/*
	Returns name of the presenter
	*/
	function getName():String;
	
	/*
	Returns the title of the presenter (e.g. project manager)
	*/
	function getTitle():String;
	
	/*
	Returns brief information about the presenter
	*/
	function getBiographyText():String;
	
	/*
	Returns the contact e-mail address of the presenter
	*/
	function getEmail():String;
	
	/*
	Returns the presenter's web site address
	*/
	function getWebSite():String;
	
	/*
	Returns Boolean value that indicates whether the presenter provided photo
	*/
	function hasPhoto():Boolean;
	
	/*
	Returns IPresenterPhoto interface which allows to load the photo of the presenter
	*/
	function getPhoto():IPresenterPhoto;
	
	/*
	Returns index of the presenter
	*/
	function getIndex():Number;
	
	/*
	Indicates whether the presenter has custom company info
	*/
	function hasCompany():Boolean;
	
	
	/*
	Returns the presenter custom company info
	*/
	function getCompany():ICompanyInfo;
}
