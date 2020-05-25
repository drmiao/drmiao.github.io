
import fsplayer.api.IPresenterInfo;

interface fsplayer.api.IPresentersCollection
{
	/*
	Returns presenters count in the collection
	*/
	function getCount():Number;
	
	/*
	Returns a presenter with the specified presenter index
	*/
	function getPresenter(index:Number):IPresenterInfo;
}
