// ActionScript file

import mx.events.ResizeEvent;

private var as3bridgeSample:AS3BridgeSample;
private var resizeController:ResizeController;

private function creationComplete():void
{
	as3bridgeSample = new AS3BridgeSample(presentationContainer,
										  lPresentationTitle,
										  buttonPlayPause,
										  buttonPrevious,
										  buttonNext,
										  buttonPres1,
										  buttonPres2,
										  posSlider,
										  lSlideNumber);
	resizeController = new ResizeController(this,
											presentationContainer,
											lPresentationTitle,
											buttonPlayPause,
											buttonPrevious,
											buttonNext,
		                    				buttonPres1,
											buttonPres2,
											posSlider,
											lSlideNumber);											  
}