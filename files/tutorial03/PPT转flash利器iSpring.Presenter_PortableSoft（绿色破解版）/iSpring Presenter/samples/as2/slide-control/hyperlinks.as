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

var g_slideController:ISlideController;
var g_hyperlinksManager:CMyHyperlinksManager = new CMyHyperlinksManager();

g_hyperlinksManager.loadSlide = function(slideIndex:Number):Void
{
	loadSlide(slideIndex);
}

g_hyperlinksManager.gotoSlide(0);

function loadSlide(slideIndex:Number):Void
{
	g_slideController.setHyperlinksManager(undefined);
	
	var fileName:String = "data_hl/slide" + (slideIndex + 1) + ".swf";

	var slashPos:Number = Math.max(this._url.lastIndexOf("/"), this._url.lastIndexOf("\\"));
	var fullPath:String = this._url.substr(0, slashPos + 1) + fileName;
	
	var ml:MovieClipLoader = new MovieClipLoader();
	ml.addListener(this);
	ml.loadClip(fullPath, slideMC1);
}

function onLoadInit(target:MovieClip):Void
{
	var slideController:ISlideController = target.getSlideController();
	
	slideController.setHyperlinksManager(g_hyperlinksManager);
}