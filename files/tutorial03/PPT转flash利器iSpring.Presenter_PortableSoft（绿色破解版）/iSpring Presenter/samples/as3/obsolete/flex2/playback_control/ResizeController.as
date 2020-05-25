package
{
	import mx.core.Application;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.HSlider;
	import mx.events.ResizeEvent;
	import ispring.flex.PresentationContainer;
	
	public class ResizeController
	{
		private static const INDENT:Number = 20;
		
		private var m_application:Application;
		private var m_presentationContainer:PresentationContainer;
		private var m_lPresentationTitle:Label;
		private var m_buttonPlayPause:Button;
		private var m_buttonPrevious:Button;
		private var m_buttonPres1:Button;
		private var m_buttonPres2:Button;
		private var m_buttonNext:Button;
		private var m_posSlider:HSlider;
		private var m_lSlideNumber:Label;
		
		public function ResizeController(application:Application,
										 presentationContainer:PresentationContainer,
										 lPresentationTitle:Label,
										 buttonPlayPause:Button,
										 buttonPrevious:Button,
										 buttonNext:Button,
										 buttonPres1:Button,
										 buttonPres2:Button,
										 posSlider:HSlider,
										 lSlideNumber:Label)
		{
			m_application = application;
			m_presentationContainer = presentationContainer;
			m_lPresentationTitle = lPresentationTitle;
			m_buttonPlayPause = buttonPlayPause;
			m_buttonPrevious = buttonPrevious;
			m_buttonPres1 = buttonPres1;
			m_buttonPres2 = buttonPres2;
			m_buttonNext = buttonNext;
			m_posSlider = posSlider;
			m_lSlideNumber = lSlideNumber;
			
			m_application.addEventListener(ResizeEvent.RESIZE, onApplicationResize);
			
			resize();
		}
		
		private function calcPresentationTitlePosition():void
		{
			m_lPresentationTitle.move(INDENT, INDENT);
		}
		
		private function calcButtonsPosition():void
		{
			var x:Number;
			var y:Number;
			
			x = INDENT;
			y = m_application.height - (m_buttonPlayPause.height + INDENT);
			m_buttonPlayPause.move(x, y);
			
			x = m_buttonPlayPause.x + m_buttonPlayPause.width + INDENT;
			y = m_application.height - (m_buttonPrevious.height + INDENT);
			m_buttonPrevious.move(x, y);
			
			x = m_buttonPrevious.x + m_buttonPrevious.width + INDENT;
			y = m_application.height - (m_buttonNext.height + INDENT);
			m_buttonNext.move(x, y);
			
			x = m_buttonPlayPause.x;
			y = m_buttonPlayPause.y - m_buttonPres1.height - INDENT;
			m_buttonPres1.move(x, y);
			
			x = m_buttonPres1.x + m_buttonPres1.width + INDENT;
			m_buttonPres2.move(x, y);
		}
		
		private function calcPosSliderPosition():void
		{
			var x:Number = m_buttonNext.x + m_buttonNext.width + INDENT;
			var y:Number = m_application.height - (m_posSlider.height + INDENT);
			m_posSlider.move(x, y);
			m_posSlider.width = m_application.width - (m_posSlider.x + m_lSlideNumber.width + INDENT * 2);
		}
		
		private function calcSlideNumberPosition():void
		{
		  var x:Number = m_application.width - (m_lSlideNumber.width + INDENT);
		  var y:Number = m_application.height - (m_lSlideNumber.height + INDENT);
		  m_lSlideNumber.move(x, y);
		}
		
		private function calcPresentationContainerPosition():void
		{
			var x:Number = INDENT;
			var y:Number = m_lPresentationTitle.x + m_lPresentationTitle.height + INDENT;
			m_presentationContainer.move(x, y);
			m_presentationContainer.width = m_application.width - INDENT * 2;
			var marginBottom:int = (m_buttonPlayPause.y + m_buttonPlayPause.height + INDENT * 2) - m_buttonPres1.y;
								  	  
			m_presentationContainer.height = m_application.height - (m_presentationContainer.y + marginBottom)
		}
		
		private function resize():void
		{
			calcPresentationTitlePosition();
			calcButtonsPosition();
			calcSlideNumberPosition();
			calcPosSliderPosition();
			calcPresentationContainerPosition();
		}
		
		private function onApplicationResize(e:ResizeEvent):void
		{
			resize();
		}
		
		private function max(...arguments):Number
		{
			var m:Number = -1;
			
			for (var i:Number = 0; i < arguments.length; i++)
			{
				if (arguments[i] > m)
				{
					m = arguments[i];
				}
			}
			
			return m;
		}
	}
}