import ispring.as3bridge.*;
import flash.display.*;
import flash.events.*;

var player:Player;

// create target sprite
var target:Sprite = new Sprite();
addChild(target);

//create log target
var logTarget:Sprite = new Sprite();
addChild(logTarget);

//init log
var log:LogConsole = LogConsole.getInstance();
log.init(logTarget, 10, 10, 600, 120);

if (flash.system.Capabilities.playerType == "External")
{
	writeLog("This example will work in browser plugin, ActiveX or Standalone Flash player only");
	return;
}

// load bridge
var loader:BridgeLoader = new BridgeLoader(target);
loader.addEventListener(BridgeEvent.BRIDGE_LOADED, onBridgeLoaded);
loader.addEventListener(BridgeEvent.PRESENTATION_LOADED, onPresentationLoaded);
loader.connectToBridge("../as3bridge/as3bridge.swf");

function onPlayClick(e:MouseEvent):void
{
	player.playbackController.play();
}

function onPauseClick(e:MouseEvent):void
{
	player.playbackController.pause();
}

function onBridgeLoaded(e:BridgeEvent):void
{
	loader.loadPresentation("presentation1.swf");
}

function onPresentationLoaded(e:BridgeEvent):void
{
	if (e.player.initialized)
	{
		player = e.player;
		writeLog("Presentation loaded");
		player.playbackController.addEventListener(BridgeEvent.SLIDE_CHANGE, onSlideChange);
	
		playButton.buttonMode = true;
		playButton.addEventListener(MouseEvent.CLICK, onPlayClick);
		pauseButton.buttonMode = true;
		pauseButton.addEventListener(MouseEvent.CLICK, onPauseClick);
	}
}

function onSlideChange(e:BridgeEvent):void
{
	writeLog("current slide: " + e.slideIndex);
}

function writeLog(txt:String):void
{
	log.writeLine(txt);
}
