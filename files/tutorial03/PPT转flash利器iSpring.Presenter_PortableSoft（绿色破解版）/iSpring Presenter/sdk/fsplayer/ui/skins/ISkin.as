import fsplayer.ui.skins.*;
import fsplayer.api.IPlayer;

interface fsplayer.ui.skins.ISkin
{
	/*
	This method is invoked by player core when it needs to initialize skin. You can use information from passed IPlayer interface to initialize skin elements
	*/
	function initialize(player:IPlayer):Void;
	
	/*
	This method is invoked by player core. This method returns ISlideShowWindow interface which is used by player core to load and display Flash presentation slides
	*/
	function getSlideShowWindow():ISlideShowWindow;
	
	/*
	Player core passes ISkinListener interface that allows core to receive notifications about skin initializaiton process
	*/
	function setListener(listener:ISkinListener):Void;
}
