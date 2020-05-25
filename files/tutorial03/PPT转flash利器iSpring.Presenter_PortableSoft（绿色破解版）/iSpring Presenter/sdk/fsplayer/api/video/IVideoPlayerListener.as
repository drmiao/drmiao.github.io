import fsplayer.api.video.IVideoPlayer;

interface fsplayer.api.video.IVideoPlayerListener
{
	function onVideoOpened(videoPlayer:IVideoPlayer):Void;
	function onVideoOpeningFailed(videoPlayer:IVideoPlayer):Void;

	function onBufferEmpty(videoPlayer:IVideoPlayer):Void;
	function onBufferFull(videoPlayer:IVideoPlayer):Void;
	function onBufferFlush(videoPlayer:IVideoPlayer):Void;

	function onPlaybackStarted(videoPlayer:IVideoPlayer):Void;
	function onPlabackStopped(videoPlayer:IVideoPlayer):Void;

	function onSeekComplete(videoPlayer:IVideoPlayer):Void;
	function onSeekTimeInvalid(videoPlayer:IVideoPlayer):Void;
}
