
interface fsplayer.ui.skins.ISkinSizeController
{
	/*
	Returns true if self-scaling is been enabled for the skin, false otherwise
	*/
	function getAutoSize():Boolean;
	
	/*
	This method allows to set self-scaling property. If self-scaling is enabled, the skin will occupy entire Flash player window
	*/
	function setAutoSize(autoSize:Boolean):Void;
	
	/*
	Returns width of the skin in pixels
	*/
	function getWidth():Number;
	
	/*
	Returns height of the skin in pixels
	*/
	function getHeight():Number;
	
	/*
	This method allows to set width and height in pixels of the window where skin is displayed. Applies to the skin if self-scaling is disabled
	*/
	function setSize(width:Number, height:Number):Void;
	
	/*
	Returns X-direction scaling value of the window where skin is displayed. Applies to the skin if self-scaling is disabled
	Note:The default value is 100%
	*/
	function getScaleX():Number;
	
	/*
	Returns Y-direction scaling value of the window where skin is displayed. Applies to the skin if self-scaling is disabled
	Note:The default value is 100%
	*/
	function getScaleY():Number;
	
	/*
	This method allows to set X and Y scaling of the window where skin is displayed
	*/
	function setScale(scaleX:Number, scaleY:Number):Void;
}
