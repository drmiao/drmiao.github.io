package sample.components
{
	import mx.core.UIComponent;
	import flash.display.DisplayObject;
	import mx.managers.PopUpManager;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class RubberBandComp extends UIComponent
	{		
		private static const SIZING_COMPLETE:String = "sizingComplete";
		
		private var m_parent:DisplayObject;
		
		public function RubberBandComp(parent:DisplayObject)
		{
			super();
			
			m_parent = parent;
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
				
			// Draw rubber band with a 1 pixel border, and a grey fill. 				
			graphics.clear();								
			graphics.lineStyle(1);
			graphics.beginFill(0xCCCCCC, 0.5);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
		}
		
		public function show():void
		{
			PopUpManager.addPopUp(this, m_parent, false);
		}
		
		public function hide():void
		{
			PopUpManager.removePopUp(this);
		}
	}
}