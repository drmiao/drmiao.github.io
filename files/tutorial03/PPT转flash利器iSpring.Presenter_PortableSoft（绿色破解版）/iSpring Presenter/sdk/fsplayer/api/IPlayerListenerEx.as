import fsplayer.api.IPlayerEx;
import fsplayer.api.IPlayerListener;

interface fsplayer.api.IPlayerListenerEx extends IPlayerListener
{
	function onPlayerPreInit(player:IPlayerEx):Void;
}
