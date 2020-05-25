import fsplayer.api.IPlayer;
import fsplayer.api.IPlayerCore;

interface fsplayer.api.IPlayerEx extends IPlayer
{
	function getPlayerCore():IPlayerCore;
}
