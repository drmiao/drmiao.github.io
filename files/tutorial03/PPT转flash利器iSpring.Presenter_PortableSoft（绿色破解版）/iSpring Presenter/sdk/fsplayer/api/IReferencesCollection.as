import fsplayer.api.IReferenceInfo;

interface fsplayer.api.IReferencesCollection
{
	/*
	Returns reference count
	*/
	function getCount():Number;
	
	/*
	Returns reference by its index (0 - (count-1))
	*/
	function getReference(index:Number):IReferenceInfo;
}
