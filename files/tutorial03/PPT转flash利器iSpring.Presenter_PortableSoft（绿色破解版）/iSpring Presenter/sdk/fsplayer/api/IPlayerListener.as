import fsplayer.api.IPlayer;

interface fsplayer.api.IPlayerListener
{
	/*
	This method is invoked before the beginning of playbacking of presentation. When the Player is initialized you are ready to get objects that ActionScript API provides
	*/
	function onPlayerInit(player:IPlayer):Void;
}
