// ActionScript file

package ispring.flex
{
	import flash.events.Event;
	
	import ispring.as2player.IPlayer;
	
	public class PlayerInitEvent extends Event
	{
		public static const PLAYER_INIT:String = "playerInit";
		
		public var player:IPlayer;
		
		public function PlayerInitEvent(type:String, _player:IPlayer)
		{
			super(type);
			
			player = _player;
		}
	}
}