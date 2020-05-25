package sample.components
{
	import mx.containers.Panel;
	import mx.core.UIComponent;
	import mx.core.SpriteAsset;
	import mx.events.FlexEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import mx.managers.PopUpManager;
	import flash.geom.Point;
	import mx.core.DragSource;
	import mx.managers.DragManager;
	import flash.display.Sprite;

	public class DragPanel extends Panel
	{
		private static const MIN_WIDTH:int = 130;
		private static const MIN_HEIGHT:int = 130;
		
        // Variables used to hold the mouse pointer's location in the title bar.
        // Since the mouse pointer can be anywhere in the title bar, you have to 
        // compensate for it when you drop the panel. 
        public var m_titleXOff:Number;
        public var m_titleYOff:Number;
				
		private var m_rbComp:RubberBandComp;
		private var m_cover:Cover;
		
		// Global coordinates of lower left corner of panel.
		protected var m_startDragPoint:Point;

		// Add the creationCOmplete event handler.
		public function DragPanel()
		{
			super();
			
			m_rbComp = new RubberBandComp(this);
			m_cover = new Cover(this);
			
			if (width < MIN_WIDTH)
				width = MIN_WIDTH;
				
			if (height < MIN_HEIGHT)
				height = MIN_HEIGHT;
			
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
					
		private function creationCompleteHandler(event:Event):void
		{
			// Add the resizing event handler.	
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			titleBar.addEventListener(MouseEvent.MOUSE_DOWN, onTitleBarMouseDown);
		}
			
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// Draw resize graphics if not minimzed.				
			graphics.clear()
			
			graphics.lineStyle(2);
			graphics.moveTo(unscaledWidth - 6, unscaledHeight - 1)
			graphics.curveTo(unscaledWidth - 3, unscaledHeight - 3, unscaledWidth - 1, unscaledHeight - 6);						
			graphics.moveTo(unscaledWidth - 6, unscaledHeight - 4)
			graphics.curveTo(unscaledWidth - 5, unscaledHeight - 5, unscaledWidth - 4, unscaledHeight - 6);						
		}

		/**********
		 * draging
		 **********/
        private function onTitleBarMouseDown(e:MouseEvent):void
        {
			m_startDragPoint = new Point(e.localX, e.localY);
			
			systemManager.addEventListener(MouseEvent.MOUSE_MOVE, onDragMouseMove, true);
			systemManager.addEventListener(MouseEvent.MOUSE_UP, onDragMouseUp, true);
			
			var globaPos:Point = getGlobalPosition();
			
			m_rbComp.width = width;
			m_rbComp.height = height;
			
			m_cover.show();
        }

		private function onDragMouseMove(e:MouseEvent):void
		{
			var parentGlobalPos:Point = parent.localToGlobal(new Point(0, 0));
			
			x = (e.stageX - parentGlobalPos.x) - m_startDragPoint.x;
			y = (e.stageY - parentGlobalPos.y) - m_startDragPoint.y;
			
			m_cover.updatePosition();
			
			e.updateAfterEvent();
		}
		
		private function onDragMouseUp(e:MouseEvent):void
		{
			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, onDragMouseMove, true);
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, onDragMouseUp, true);
			
			m_cover.hide();
		}

		/**********
		 * resizing
		 **********/
		// Resize panel event handler.
		public  function onMouseDown(event:MouseEvent):void
		{
			// Determine if the mouse pointer is in the lower right 14x14 pixel
			// area of the panel. Initiate the resize if so.
			
			// Lower left corner of panel
			var lowerLeftX:Number = x + width; 
			var lowerLeftY:Number = y + height;
				
			// Upper left corner of 14x14 hit area
			var upperLeftX:Number = lowerLeftX - 14;
			var upperLeftY:Number = lowerLeftY - 14;
				
			// Mouse positionin Canvas
			var panelRelX:Number = event.localX + x;
			var panelRelY:Number = event.localY + y;

			// See if the mousedown is in the lower right 7x7 pixel area
			// of the panel.
			if (upperLeftX <= panelRelX && panelRelX <= lowerLeftX)
			{
				if (upperLeftY <= panelRelY && panelRelY <= lowerLeftY)
				{		
					event.stopPropagation();	
					startResizing(event);
				}
			}				
		}
		
		private function startResizing(e:MouseEvent):void
		{			
			// Place the rubber band over the panel. 
			var globalPos:Point = getGlobalPosition();
			m_rbComp.x = globalPos.x;
			m_rbComp.y = globalPos.y;
			m_rbComp.height = height;
			m_rbComp.width = width;
			
			// Make sure rubber band is on top of all other components.
			if (parent)
			{
				parent.setChildIndex(this, parent.numChildren - 1);
			}

			m_rbComp.show();
			m_cover.show();
			
			// Add event handlers so that the SystemManager handles 
			// the mouseMove and mouseUp events. 
			// Set useCapure flag to true to handle these events 
			// during the capture phase so no other component tries to handle them.
			systemManager.addEventListener(MouseEvent.MOUSE_MOVE, onResizeMouseMove, true);
			systemManager.addEventListener(MouseEvent.MOUSE_UP, onResizeMouseUp, true);
		}
		
		private function onResizeMouseMove(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
				
			var globalPos:Point = getGlobalPosition();
			var newRbcHeight:int = e.stageY - globalPos.y;
			var newRbcWidth:int = e.stageX - globalPos.x;
			
			m_rbComp.height = Math.max(newRbcHeight, MIN_HEIGHT);
			m_rbComp.width = Math.max(newRbcWidth, MIN_WIDTH);
			
			m_cover.updatePosition();
			
			e.updateAfterEvent();
		}
		
		private function onResizeMouseUp(e:MouseEvent):void
		{			
			e.stopImmediatePropagation();
	
			// Use a minimum panel size of 150 x 50.
			height = m_rbComp.height < MIN_HEIGHT ? MIN_HEIGHT : m_rbComp.height;				
			width = m_rbComp.width < MIN_WIDTH ? MIN_WIDTH : m_rbComp.width;
		
			if (parent)
			{
				// Put the resized panel on top of all other components.
				parent.setChildIndex(this, parent.numChildren-1);
			}
	
			// Hide the cover until next time.
			PopUpManager.removePopUp(m_rbComp);
			
			m_cover.hide();
			
			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, onResizeMouseMove, true);
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, onResizeMouseUp, true);
		}
		
		private function getGlobalPosition():Point
		{
			return localToGlobal(new Point(0, 0));
		}
	}
}