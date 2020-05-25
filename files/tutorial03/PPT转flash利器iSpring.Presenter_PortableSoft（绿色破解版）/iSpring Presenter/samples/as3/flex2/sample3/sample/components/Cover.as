package sample.components
{
	import mx.core.UIComponent;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import mx.managers.PopUpManager;
	import flash.geom.Point;
	import flash.events.MouseEvent;

	public class Cover extends UIComponent
	{
		private var m_bg:Sprite;
		private var m_parent:DisplayObject;
		
		public function Cover(parent:DisplayObject)
		{
			m_parent = parent;
			
			m_bg = new Sprite;
			m_bg.graphics.beginFill(0x000000);
			m_bg.graphics.drawRect(0, 0, 10, 10);
			m_bg.alpha = 0.0;
			addChild(m_bg);
		}
		
		public function show():void
		{
			m_bg.width = m_parent.width;
			m_bg.height = m_parent.height;
			PopUpManager.addPopUp(this, m_parent, false);
		}
		
		public function hide():void
		{
			PopUpManager.removePopUp(this);
		}
		
		public function updatePosition():void
		{
			var globalParenPos:Point = m_parent.localToGlobal(new Point(0, 0));
		
			x = globalParenPos.x;
			y = globalParenPos.y;
		}
	}
}