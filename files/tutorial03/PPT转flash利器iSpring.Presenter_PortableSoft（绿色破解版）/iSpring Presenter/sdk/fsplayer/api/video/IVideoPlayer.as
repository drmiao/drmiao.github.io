import fsplayer.api.video.IVideoPlayerListener;

interface fsplayer.api.video.IVideoPlayer
{
	function addListener(listener:IVideoPlayerListener):Void;
	
	function removeListener(listener:IVideoPlayerListener):Void;
	
	// Opens video and starts loading (with playback)
	function open(source:String):Void;
	
	// Closes video if it was opened. Does nothing if video hasn't been opened
	function close():Void;
	
	// Indicates whether video is opened or not
	function hasVideo():Boolean;
	
	function pause():Void;
	
	function play():Void;
	
	function isPlaying():Boolean;
	
	function seek(time:Number):Void;
	
	function getPlaybackTime():Number;
}
