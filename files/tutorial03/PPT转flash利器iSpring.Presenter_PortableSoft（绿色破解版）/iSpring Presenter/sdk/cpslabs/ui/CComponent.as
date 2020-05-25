import cpslabs.ITooltip;
import cpslabs.utils.CMessageBroadcaster;


class cpslabs.ui.CComponent
{
	private var m_parent:MovieClip;
	private var m_mc:MovieClip;
	private var m_enabled:Boolean = true;
	private var m_componentBroadcaster:CMessageBroadcaster;
	private var m_id:String = "";
	
	private var m_tooltip:ITooltip;
	private var m_tooltipParams:Object;
	
	/**
	 * This flag is true when the component needs to be updated
	 */
	private var m_needUpdate:Boolean = false;
	
	/**
	 * If the component automatically updates itself on invalidate() method call
	 */
	private var m_autoUpdate:Boolean = true;
	
	/*
		Constructor
	*/
	function CComponent(parent:MovieClip, name:String, depth:Number)
	{
		if (parent)
		{
			m_parent = parent;
			
			if (depth == undefined)
			{
				depth = parent.getNextHighestDepth();
			}
			
			m_mc = parent.createEmptyMovieClip((name != undefined) ? name : ("m" + depth), depth);
			m_mc.tabEnabled  = false;
		}
		
		m_componentBroadcaster = new CMessageBroadcaster();
	}
	
	function setMovieClip(mc:MovieClip):Void
	{
		m_mc = mc;
		m_parent = mc._parent;
	}
	
	function get parent():MovieClip
	{
		return m_parent;
	}
	
	/*
		Object Identifier
	*/
	function set id(componentId:String):Void
	{
		m_id = componentId;
	}
	
	function get id():String
	{
		return m_id;
	}

	function addListener(eventName:String, l:Object, fn:Function):Void
	{
		m_componentBroadcaster.addListener(eventName, l, fn);
	}
	
	function removeListener(eventName:String, l:Object, fn:Function):Boolean
	{
		return m_componentBroadcaster.removeListener(eventName, l, fn);
	}
	
	/*
		target movie clip
	*/
	function get movieClip():MovieClip
	{
		return m_mc;
	}
	
	/*
		visibility
	*/
	function set visible(v:Boolean):Void
	{
		if (movieClip._visible != v)
		{
			movieClip._visible = v;
			if (v)
				onShow();
			else
				onHide();
		}
	}
	
	function get visible():Boolean
	{
		return movieClip._visible;
	}
	
	/*
		enable / disable
	*/
	function set enabled(e:Boolean):Void
	{
		if (m_enabled != e)
		{
			m_enabled = e;
			if (e)
			{
				onEnable();
			}
			else
			{
				onDisable();
			}
		}
	}
	
	function get enabled():Boolean
	{
		return m_enabled;
	}
	
	/*
	 width / height
	*/
	
	/**
	 * @return width of the component
	 */
	function get width():Number
	{
		return getWidth();
	}
	
	/**
	 * @return height of the component
	 */
	function get height():Number
	{
		return getHeight();
	}
	
	/**
	 * Changes width of the component
	 */
	function set width(w:Number):Void
	{
		var newSize:Object = new Object();
		
		newSize.width = w;
		newSize.height = height;
		
		onResizing(newSize);
		broadcastMessage("resizing", this, newSize);
		
		w = newSize.width;
		var h:Number = newSize.height;
		
		if (w != width || h != height)
		{
			resize(w, h);
			onResize(w, h);
			broadcastMessage("resize", this, w, h);
		}
	}
	
	/**
	 * Changes height of the component
	 */
	function set height(h:Number):Void
	{
		var newSize:Object = new Object();

		var oldWidth:Number = width;
		var oldHeight:Number = height;
		
		newSize.width = oldWidth;
		newSize.height = h;
		
		onResizing(newSize);
		broadcastMessage("resizing", this, newSize);
		
		var w:Number = newSize.width;
		h = newSize.height;
		
		if ((w != oldWidth) || (h != oldHeight))
		{
			resize(w, h);
			onResize(w, h);
			broadcastMessage("resize", this, w, h);
		}
	}
	
	/*
		x / y
	*/
	function get x():Number
	{
		return movieClip._x;
	}
	
	function get y():Number
	{
		return movieClip._y;
	}
	
	function set x(x0:Number):Void
	{
		movieClip._x = x0;
		onMove(x0, y);
	}
	
	function set y(y0:Number):Void
	{
		movieClip._y = y0;
		onMove(x, y0);
	}
	
	function get alpha():Number
	{
		return movieClip._alpha;
	}
	
	function set alpha(a:Number):Void
	{
		movieClip._alpha = a;
	}
	
	function get autoUpdate():Boolean
	{
		return m_autoUpdate;
	}
	
	function set autoUpdate(enableAutoUpdate:Boolean):Void
	{
		m_autoUpdate = enableAutoUpdate;
		if (enableAutoUpdate && m_needUpdate)
		{
			update();
			m_needUpdate = false;
		}
	}
	
	function remove():Void
	{
		if (m_tooltip)
			m_tooltip.hide();
		
		m_mc.removeMovieClip();
		delete m_mc;
	}
	
	private function getWidth():Number
	{
		return movieClip._width;
	}
	
	private function getHeight():Number
	{
		return movieClip._height;
	}
	
	/*
		overridable event handlers
	*/
	private function onEnable():Void
	{
	}
	
	private function onDisable():Void
	{
	}
	
	private function onShow():Void
	{
	}
	
	private function onHide():Void
	{
	}
	
	private function onMove(newX:Number, newY:Number):Void
	{
		// do nothing
	}
	
	private function broadcastMessage(eventName:String):Void
	{
		m_componentBroadcaster.broadcastMessage.apply(m_componentBroadcaster, arguments);
	}
	
	private function invalidate():Void
	{
		m_needUpdate = true;
		if (m_autoUpdate)
		{
			update();
			m_needUpdate = false;
		}
	}
	
	private function update():Void
	{
	}
	
	/**
	 * This method is called before the component is resized
	 * width and height properties of this object can be changed to affect the final width and height
	 */
	private function onResizing(newSize:Object):Void
	{
		// the default implementation does nothing
	}

	/**
	 * Resizes component
	 */
	private function resize(w:Number, h:Number):Void
	{
		var mc:MovieClip = movieClip;
		mc._width = w;
		mc._height = h;
	}
	
	private function onResize(w:Number, h:Number):Void
	{
		// the default implementation does nothing
	}
	
	/*
		event initializer
	*/
	private function initMouseEvents(mc:MovieClip, listener:Object, handleMouseMove:Boolean):Void
	{
		if (!mc)
		{
			mc = movieClip;
		}
		
		if (listener == undefined)
		{
			listener = this;
		}
		
		var thisPtr:CComponent = this;
		
		mc.onRollOver = function()
		{
			listener.onRollOver(thisPtr);
		}
		
		mc.onRollOut = function()
		{
			listener.onRollOut(thisPtr);
		}
		
		mc.onPress = function()
		{
			listener.onPress(thisPtr);
		}
		
		mc.onRelease = function()
		{
			listener.onRelease(thisPtr);
		}
		
		mc.onReleaseOutside = function()
		{
			listener.onReleaseOutside(thisPtr);
		}
		
		mc.onDragOver = function()
		{
			listener.onDragOver(thisPtr);
		}
		
		mc.onDragOut = function()
		{
			listener.onDragOut(thisPtr);
		}
		
		if (handleMouseMove)
		{
			mc.onMouseMove = function()
			{
				listener.onMouseMove(thisPtr);
			}
		}
		
	}
	
	public function removeMouseEvents(mc:MovieClip):Void
	{
		if (!mc)
		{
			mc = movieClip;
		}		
		
		delete mc.onRelease;
		delete mc.onReleaseOutside;
		delete mc.onPress;
		delete mc.onRollOver;
		delete mc.onRollOut;
		delete mc.onDragOver;
		delete mc.onDragOut;
		delete mc.onMouseMove;
	}
	
	public function init():Void
	{
	}
	
	
	/**
	 * Adds tooltip to component.
	 * @param tooltip tooltip for component
	 * @param tooltipParams object with params to set for tooltip when it shown 
	 */
	public function addTooltip(tooltip:ITooltip, tooltipParams:Object):Void
	{
		tooltipParams = (tooltipParams ? tooltipParams : new Object());
		m_tooltip = tooltip;
		m_tooltipParams = tooltipParams;
		
		var rollOverHandler:Function = movieClip.onRollOver;
		var rollOutHandler:Function  = movieClip.onRollOut;
		var pressHandler:Function    = movieClip.onPress;
		
		var thisPtr:CComponent = this;
		
		movieClip.onRollOver = function()
		{
			tooltip["useCustomContent"] = false;
			
			for (var i:String in tooltipParams)
			{
				tooltip[i] = tooltipParams[i];
			}
			
			thisPtr.prepareTooltip();
			tooltip.show();
			
			if (rollOverHandler)
				rollOverHandler();
		}
		
		movieClip.onRollOut = function()
		{
			tooltip.hide();
			thisPtr.clearTooltip();
			
			if (rollOutHandler)
				rollOutHandler();
		}
		
		movieClip.onPress = function()
		{
			tooltip.hide();
			thisPtr.clearTooltip();
			
			if (pressHandler)
				pressHandler();
		}
	}
	
	private function prepareTooltip():Void
	{
	}
	
	private function clearTooltip():Void
	{
	}

	public function get tooltip():ITooltip
	{
		return m_tooltip;
	}
	
	public function get tooltipParams():Object
	{
		return m_tooltipParams;
	}
}