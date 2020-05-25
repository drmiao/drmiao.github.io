interface cpslabs.utils.IMessageBroadcaster
{
	function addListener(eventName:String, listener:Object, handler:Function):Void;
	
	function removeListener(eventName:String, listener:Object, handler:Function):Boolean;
	
	public function broadcastMessage(eventName:String):Void;
}
