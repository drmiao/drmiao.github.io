import ispring.as2player.*;
import flash.events.*;

var g_player:IPlayer;

// load presentation
var loader:PresentationLoader = new PresentationLoader();
addChild(loader);
loader.addEventListener(PlayerEvent.PLAYER_INIT, playerInit);
loader.load(new URLRequest("presentation1.swf"));

// send after presentation loaded and initialized
function playerInit(e:PlayerEvent):void
{
	g_player = loader.player;
	g_player.playbackController.addEventListener(SlidePlaybackEvent.CURRENT_SLIDE_INDEX_CHANGED, onSlideChange);

	playButton.buttonMode = true;
	playButton.addEventListener(MouseEvent.CLICK, onPlayClick);
	pauseButton.buttonMode = true;
	pauseButton.addEventListener(MouseEvent.CLICK, onPauseClick);
}

function onSlideChange(e:SlidePlaybackEvent):void
{
	trace("current slide: " + e.slideIndex);
}

function onPlayClick(e:MouseEvent):void
{
	g_player.playbackController.play();
}

function onPauseClick(e:MouseEvent):void
{
	g_player.playbackController.pause();
}
