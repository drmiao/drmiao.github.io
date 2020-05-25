import fsplayer.api.*

System.security.allowDomain("*");

var g_playerAPI:IPlayer;
var g_controller:IPresentationPlaybackController;
slideProgressBar._xscale = 0;

var presentation:MovieClip = this.createEmptyMovieClip("presentation", 1);
var loader:CPresentationLoader = new CPresentationLoader();
loader.setPlayerListener(this);
loader.loadClip("presentation.swf", presentation);

function onPlayerInit(playerAPI:IPlayer):Void
{
	g_playerAPI = playerAPI;
	g_controller = playerAPI.getPlaybackController();
	
	// this movie clip will listen to events of playback controller
	g_controller.addListener(this);

	updatePlayPauseButtons(true);
}

this.playButton.onRelease = function()
{
	if (g_controller)
	{
		if (!g_controller.isPlaying())
		{
			g_controller.play();
		}
	}
}

this.pauseButton.onRelease = function()
{
	if (g_controller)
	{
		if (g_controller.isPlaying())
		{
			g_controller.pause();
		}
	}
}

this.nextStepButton.onRelease = function()
{
	if (g_controller)
	{
		g_controller.gotoNextStep();
		updatePlayPauseButtons(true);
	}	
}

this.previousStepButton.onRelease = function()
{
	if (g_controller)
	{
		g_controller.gotoPreviousStep();
		updatePlayPauseButtons(false);
	}	
}

function onCurrentSlideIndexChanged(slideIndex:Number):Void
{
	slideProgressBar._xscale = 0;
	currentSlideIndex.text = "Current slide index: " + (slideIndex + 1);
}

function onAnimationStepChanged(stepIndex:Number):Void
{
	currentStepIndex.text = "Current step index: " + stepIndex;
}

function onSlidePositionChanged(position:Number):Void
{
	slideProgressBar._xscale = position * 100;
}

function updatePlayPauseButtons(isPlaying:Boolean):Void
{
	playButton._visible = !isPlaying;
	pauseButton._visible = isPlaying;
}

function onStartPlayback():Void
{
	updatePlayPauseButtons(true);
}

function onPausePlayback():Void
{
	updatePlayPauseButtons(false);
}
