// ActionScript file
import mx.core.Application;
import sample.ApplicationController;

private var g_applicationController:ApplicationController;

public function onInit():void
{	
	g_applicationController = new ApplicationController(this);
}