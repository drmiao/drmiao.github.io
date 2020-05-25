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

loadSlide(1);

var g_slideController:ISlideController;
var g_soundController:ISoundController;

var g_trackBar:CTrackBar = new CTrackBar(rootMC);
g_trackBar.x = 140;
g_trackBar.y = 571;
g_trackBar.init("track", "slider");

function loadSlide(slideIndex:Number):Void
{
	var ml:MovieClipLoader = new MovieClipLoader();
	ml.addListener(this);
	var fileName:String = "data_snd/slide" + slideIndex + ".swf";

	var slashPos:Number = Math.max(this._url.lastIndexOf("/"), this._url.lastIndexOf("\\"));
	var fullPath:String = this._url.substr(0, slashPos + 1) + fileName;
	ml.loadClip(fullPath, slideMC1);
	loadingLabel.text = this._url;
}

function onLoadProgress(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void
{
	var percent:Number = 100 * bytesLoaded / bytesTotal;;
	loadingProgress._xscale = percent;
	loadingLabel.text = "Loading: " + int(percent) + "%";
}

function onLoadInit(target:MovieClip):Void
{
	g_slideController = target.getSlideController();
	g_soundController = g_slideController.getSoundController();
	g_trackBar.setPos(g_soundController.getVolume());
}

g_trackBar.newPos = function(pos:Number):Void
{
	g_soundController.setVolume(pos);
	volumeLabel.text = "Volume " + Math.floor(pos * 100) + " %";
}