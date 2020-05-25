
import cpslabs.utils.IMessageBroadcaster;

class cpslabs.utils.CMessageBroadcaster implements IMessageBroadcaster
{
	private var m_events:Object;
	private var m_id:String;
	
	public function CMessageBroadcaster()
	{
		m_events = new Object();
	}
	
	function get id():String
	{
		return m_id;
	}
	
	function set id(objectId:String):Void
	{
		m_id = objectId;
	}
	
	function addListener(eventName:String, listener:Object, handler:Function):Void
	{
		var eventHandlers:Array = m_events[eventName];
		if (!eventHandlers)
		{
			eventHandlers = new Array();
			m_events[eventName] = eventHandlers;
		}
		
		var eventHandler:Object = new Object();
		eventHandler.handler = handler;
		eventHandler.listener = listener;
		eventHandlers.push(eventHandler);
	}
	
	function removeListener(eventName:String, listener:Object, handler:Function):Boolean
	{
		var eventHandlers:Array = m_events[eventName];
		if (!eventHandlers)
		{
			return false;
		}
		
		if (listener == undefined)
		{
			delete m_events[eventName];
			return true;
		}
		else // (listener != undefined)
		{
			if (handler == undefined)
			{
				for (var i:Number = eventHandlers.length - 1; i >= 0; --i)
				{
					var eventHandler:Object = eventHandlers[i];
					if (eventHandler.listener == listener)
					{
						eventHandlers.splice(i, 1);
						return true;
					}
				}
			}
			else	// (handler != undefined)
			{
				for (var i:Number = eventHandlers.length - 1; i >= 0; --i)
				{
					var eventHandler:Object = eventHandlers[i];
					if ((eventHandler.listener == listener) && (eventHandler.handler == handler))
					{
						eventHandlers.splice(i, 1);
						return true;
					}
				}
			}
		}
		return false;
	}
	
	public function broadcastMessage(eventName:String):Void
	{
		var eventHandlers:Array = m_events[eventName];
		if (eventHandlers && (eventHandlers.length > 0))
		{
			var n:Number = eventHandlers.length;
			
			arguments.shift();
			for (var i:Number = 0; i < n; ++i)
			{
				var eventHandler:Object = eventHandlers[i];
				eventHandler.handler.apply(eventHandler.listener, arguments);
			}
		}
	}
}
