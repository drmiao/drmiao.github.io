import fsplayer.api.*

System.security.allowDomain("*");

var g_playerAPI:IPlayer;
var g_controller:IPresentationPlaybackController;
slideProgressBar._xscale = 0;
logText.html = true;

var presentation:MovieClip = this.createEmptyMovieClip("presentation", 1);
var loader:CPresentationLoader = new CPresentationLoader();
loader.setPlayerListener(this);
loader.addListener(this);

var playerListener:IPlayerListener = this;
var playbackListener:IPlaybackListener = this;

function onPlayerInit(playerAPI:IPlayer):Void
{
	TraceOutput("Player initialized\n", true);
	
	g_playerAPI = playerAPI;
	g_playerAPI.addListener(playerListener);
	
	g_controller = playerAPI.getPlaybackController();
	g_controller.addListener(playbackListener);
}


var url:String = presentationURL.text;
LoadPresentation(url);

function LoadPresentation(url:String)
{
	if (g_playerAPI)
	{
		g_playerAPI.removeListener(playerListener);
		g_playerAPI = undefined;
	}
	
	if (g_controller)
	{
		g_controller.removeListener(playbackListener);
		g_controller = undefined;
	}
	
	TraceOutput("Loading presentation:\n<b>" + url + "</b>\n");
	loader.loadClip(url, presentation);
}

btnLoad.onRelease = function()
{
	LoadPresentation(presentationURL.text);
}

// this function is invoked by MovieClipLoader.loadClip() has begun to download file
function onLoadStart(mc:MovieClip):Void
{
	slideProgressBar._xscale = 0;
	updateLoadProgress(0, 0);
	TraceOutput("Loading was started\n");
}

function onLoadError(target_mc:MovieClip, errorCode:String):Void
{
	TraceOutput("Error loading presentation\nError code:<b>" + errorCode + "</b>");
}

// This function is invoked every time the loading content is written to the hard disk during the loading process 
function onLoadProgress(mc:MovieClip, loadedBytes:Number, totalBytes:Number):Void
{
	updateLoadProgress(loadedBytes, totalBytes);
	TraceOutput("Loaded " + loadedBytes + " of " + totalBytes + "\n");
}

// This function is invoked when a file that was loaded with MovieClipLoader.loadClip() is completely downloaded.
function onLoadComplete(mc:MovieClip):Void
{
	TraceOutput("On load complete\n", true);
}

// This function is invoked after onLoadComplete event
function onLoadInit(mc:MovieClip):Void
{
	TraceOutput("On load init\n", true);
}

function onSlideLoadingComplete(slideIndex:Number):Void
{
	TraceOutput("Slide loaded: " + slideIndex + "\n", true);
}

function TraceOutput(txt, bold):Void
{
	if (bold)
	{
		txt = "<b>" + txt + "</b>";
	}
	logText.htmlText += txt;
	logText.scroll = logText.maxscroll;
}

function updateLoadProgress(loadedBytes:Number, totalBytes:Number)
{
	var loadingPercent:Number = (totalBytes != 0) ? (loadedBytes / totalBytes) * 100 : 0;
	loadProgressBar._xscale = loadingPercent;
	loadingIndicator.text = "Loading progress: " + loadedBytes + " / " + totalBytes + " (" + int(loadingPercent) + "%)";
}
