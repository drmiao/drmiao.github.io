
interface fsplayer.api.IReferenceInfo
{
	/*
	Returns reference title
	*/
	function getTitle():String;
	
	/*
	Returns reference URL
	*/
	function getURL():String;
	
	/*
	Returns target window where this reference will be opened
	*/
	function getTarget():String;
}
