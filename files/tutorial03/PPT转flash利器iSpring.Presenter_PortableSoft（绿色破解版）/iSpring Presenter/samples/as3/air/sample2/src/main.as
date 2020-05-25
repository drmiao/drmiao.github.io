// ActionScript file
import flash.events.Event;
import flash.filesystem.File;

import ispring.as2player.IPlayer;
import ispring.flex.PlayerInitEvent;

private var g_player:IPlayer;

private function onInit():void
{
	presentationContainer.addEventListener(PlayerInitEvent.PLAYER_INIT, onPlayerInit);
}

private function onPlayerInit(e:PlayerInitEvent):void
{	
	g_player = e.player;
}

private function onBtnOpenPresentationClick():void
{
	var file:File = new File();
	file.browseForOpen("Select presentation");
	file.addEventListener(Event.SELECT, onSelectPresentation);
}

private function onBtnClosePresentationClick():void
{
	presentationContainer.unload();
}

private function onSelectPresentation(e:Event):void
{
	presentationContainer.unload();
	
	var file:File = e.currentTarget as File;
	var appStorageFile:File = File.applicationStorageDirectory.resolvePath(file.name);
	file.copyTo(appStorageFile, true);
	presentationContainer.load(appStorageFile.url);
} 