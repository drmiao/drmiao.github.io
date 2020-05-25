import fsplayer.api.ICompanyLogoLoadingListener;

interface fsplayer.api.ICompanyLogo
{
	/*
	Loads company logo into the specified MovieClip.
	The listener is an optional parameter which will receive notification when company logo is loaded
	*/
	function load(target:MovieClip, listener:ICompanyLogoLoadingListener):Void;
	
	/*
	Returns a web page URL, for example, the company web site address, which should be opened when user clicks the company logo
	Note: An empty string indicates that no hyperlink is attached to the company logo
	*/
	function getHyperlinkURL():String;
	
	/*
	Returns the target window name ("_self", "_blank", "_parent", "_top", or custom window name) where company logo hyperlink should be opened
	*/
	function getHyperlinkTarget():String;
}
