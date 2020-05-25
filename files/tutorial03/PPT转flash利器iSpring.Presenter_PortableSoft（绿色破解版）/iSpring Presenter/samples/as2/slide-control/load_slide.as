import slideplayer.api.*;

#include "utils.as"

System.security.allowDomain("*");

var rootMC:MovieClip = this;
var slidesMC:MovieClip = rootMC.createEmptyMovieClip("slidesMC", 2);
var slideMC1:MovieClip = slidesMC.createEmptyMovieClip("slide1", 1);

// initialize clipping mask for slide area
var maskMC:MovieClip = rootMC.createEmptyMovieClip("maskMC", 1);
var SLIDE_WIDTH = 720;
var SLIDE_HEIGHT = 540;
createMask(maskMC, SLIDE_WIDTH, SLIDE_HEIGHT);
slidesMC.setMask(maskMC);

// start loading slide 1 from data folder
loadSlide(1);

var g_slideController:ISlideController;
var g_playbackController:IPlaybackController;


function loadSlide(slideIndex:Number):Void
{
	var fileName:String = "data/slide" + slideIndex + ".swf";

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
}

playPauseSlideButton.onRelease = function()
{
	if (g_playbackController)
	{
		if (g_playbackController.isPlaying())
		{
			g_playbackController.pause();
		}
		else
		{
			g_playbackController.play();
		}
	}
}

slideButton1.onRelease = function()
{
	loadSlide(1);
}

slideButton2.onRelease = function()
{
	loadSlide(2);
}

slideButton3.onRelease = function()
{
	loadSlide(3);
}

slideButton4.onRelease = function()
{
	loadSlide(4);
}

slideButton5.onRelease = function()
{
	loadSlide(5);
}

slideButton6.onRelease = function()
{
	loadSlide(6);
}

slideButton7.onRelease = function()
{
	loadSlide(7);
}

slideButton8.onRelease = function()
{
	loadSlide(8);
}

slideButton9.onRelease = function()
{
	loadSlide(9);
}