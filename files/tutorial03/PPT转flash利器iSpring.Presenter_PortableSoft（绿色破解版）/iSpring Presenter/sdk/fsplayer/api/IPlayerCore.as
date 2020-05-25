import fsplayer.api.video.IVideoPlayer;
import fsplayer.api.core.IHyperlinkManager;

interface fsplayer.api.IPlayerCore
{
	function setExternalPresenterVideoPlayer(player:IVideoPlayer):Void;
	
	function getHyperlinkManager():IHyperlinkManager;

	function setHyperlinkManager(hyperlinkManager:IHyperlinkManager):Void;
}
