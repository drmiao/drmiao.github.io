package
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.controls.Button;
	import mx.events.FlexEvent;
	
	public class ApplicationController
	{
		private var m_btnOpenPresentation:Button;
		
		public function ApplicationController(application:sample4)
		{
			m_btnOpenPresentation = application.btnOpenPresentation;
			
			m_btnOpenPresentation.addEventListener(FlexEvent.BUTTON_DOWN, onBtnOpenPresentationClick)
		}
		
		/***********************
		*Buttons event handlers
		************************/
		
		private function onBtnOpenPresentationClick(e:FlexEvent):void
		{
			var file:File = new File();
			file.browseForOpen("Select presentation");
			file.addEventListener(Event.SELECT, onSelectPresentation);
		}
		
		private function onSelectPresentation(e:Event):void
		{
			var file:File = e.currentTarget as File;
			var appStorageFile:File = File.applicationStorageDirectory.resolvePath(file.name);
			file.copyTo(appStorageFile, true);
			var url:String = appStorageFile.url;
			
			var window:PresentationWindow = new PresentationWindow();
			window.title = url;
			window.open(true);
			
			var controller:PresentationWindowController = new PresentationWindowController(window, url);
		}
	}
}