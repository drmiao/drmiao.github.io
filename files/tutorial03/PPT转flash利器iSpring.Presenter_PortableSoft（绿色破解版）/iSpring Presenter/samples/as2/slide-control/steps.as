import slideplayer.api.*;

#include "utils.as"

System.security.allowDomain("*");

var SLIDE_WIDTH:Number = 720;
var SLIDE_HEIGHT:Number = 540;

var rootMC:MovieClip = this;

var slidesMC:MovieClip = rootMC.createEmptyMovieClip("slidesMC", 2);
// initialize clipping mask for slide area
var maskMC:MovieClip = rootMC.createEmptyMovieClip("maskMC", 3);
createMask(maskMC, SLIDE_WIDTH, SLIDE_HEIGHT);
slidesMC.setMask(maskMC);


var slideMC1:MovieClip = slidesMC.createEmptyMovieClip("slide1", 1);


labelStepIndex.text = "Current step: 0";

// start loading slide 1 from data folder

loadSlide("data/slide_steps.swf");

var g_slideController:ISlideController;
var g_playbackController:IPlaybackController;

var g_trackBar:CTrackBar = new CTrackBar(rootMC);
g_trackBar.x = 130;
g_trackBar.y = 577;
g_trackBar.init("track", "slider");

var g_playingBefore:Boolean;
var g_trackBarPressed:Boolean = false;

function loadSlide(fileName:String):Void
{
	var slashPos:Number = Math.max(this._url.lastIndexOf("/"), this._url.lastIndexOf("\\"));
	var fullPath:String = this._url.substr(0, slashPos + 1) + fileName;
	
	var ml:MovieClipLoader = new MovieClipLoader();
	ml.addListener(this);
	ml.loadClip(fullPath, slideMC1);
}

function onLoadInit(target:MovieClip):Void
{
	g_slideController = target.getSlideController();
	g_playbackController = g_slideController.getPlaybackController();
	g_playbackController.addListener(this);
}

function onLoadError(target:MovieClip, errorCode:String, httpStatus:Number):Void
{
}

function onPausePlayback():Void
{
}

function onStartPlayback():Void
{
}

function onSlidePositionChanged(position:Number):Void
{
	if (!g_trackBarPressed)
	{
		g_trackBar.setPos(position);
	}
}

g_trackBar.newPos = function(pos:Number):Void
{
	if (g_trackBarPressed)
	{
		g_playbackController.playFromPosition(pos);
		g_playbackController.pause();
	}
}

g_trackBar.mouseDown = function():Void
{
	g_trackBarPressed = true;
	g_playingBefore = g_playbackController.isPlaying();
}

g_trackBar.mouseUp = function():Void
{
	if (g_playingBefore)
	{
		g_playbackController.play();
	}
	g_trackBarPressed = false;
}

function onAnimationStepChanged(stepIndex:Number):Void
{
	labelStepIndex.text = "Current step: " + stepIndex;
}

function onSlidePlaybackFinished():Void
{
}

// buttons
buttonPreviousStep.onRelease = function():Void
{
	g_playbackController.gotoPreviousStep();
}

buttonNextStep.onRelease = function():Void
{
	g_playbackController.gotoNextStep();
}

buttonPlay.onRelease = function():Void
{
	g_playbackController.play();
}

buttonPause.onRelease = function():Void
{
	g_playbackController.pause();
}
