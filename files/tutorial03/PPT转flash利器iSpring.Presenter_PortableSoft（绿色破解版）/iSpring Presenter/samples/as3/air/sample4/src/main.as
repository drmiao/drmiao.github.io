// ActionScript file
import ispring.as2player.IPlayer;

import mx.core.Application;

private var g_player:IPlayer;

private var g_applicationController:ApplicationController;

private function onInit():void
{
	g_applicationController = new ApplicationController(Application.application as sample4);
}