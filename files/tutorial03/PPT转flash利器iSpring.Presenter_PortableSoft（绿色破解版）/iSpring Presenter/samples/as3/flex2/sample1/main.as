// ActionScript file
import sample.ApplicationController;

private static var PRESENTATION_URL:String = "presentations/presentation.swf";

private var g_applicationController:ApplicationController;

private function onInit():void
{
	g_applicationController = new ApplicationController(this);
	g_applicationController.loadPresentation(PRESENTATION_URL);
}
