import fsplayer.api.IPlayer;
import fsplayer.api.IPlayerListener;
import fsplayer.api.IPlayerEx;
import fsplayer.api.IPlayerListenerEx;

class fsplayer.api.CPresentationLoader extends MovieClipLoader implements IPlayerListenerEx
{
	private var m_player:IPlayer;
	private var m_target:MovieClip;
	private var m_bytesLoaded:Number;
	private var m_bytesTotal:Number;
	private var m_listener:IPlayerListener;
	
	function CPresentationLoader()
	{
		addListener(this);
	}
	
	/*
	This method allows to set listener which will be notified when the player gets initialized
	*/
	function setPlayerListener(listener:IPlayerListener):Void
	{
		m_listener = listener;
	}
	
	/*
	The load method loads FlashSpring generated presentation into the specified movie clip
	*/
	function loadClip(url:String, target:MovieClip):Void
	{
		m_target = target;
		m_player = undefined;
		m_bytesLoaded = undefined;
		m_bytesTotal = undefined;
		
		super.loadClip(url, target);
	}
	
	/*
	Returns last loaded player
	*/
	function get player():IPlayer
	{
		return m_player;
	}
	
	/*
	This method is invoked by player when it gets initialized
	*/
	function onPlayerInit(player:IPlayer):Void
	{
		m_player.removeListener(this);
		stopTimer();
		m_listener.onPlayerInit(player);
	}
	
	function onPlayerPreInit(player:IPlayerEx):Void
	{
		var listenerEx:IPlayerListenerEx = IPlayerListenerEx(m_listener);
		if (listenerEx)
		{
			listenerEx.onPlayerPreInit(player);
		}
	}
	
	/*
	Returns a number of loaded bytes of the Flash presentation
	*/
	function get bytesLoaded():Number
	{
		return m_bytesLoaded;
	}
	
	/*
	Returns total number of bytes of the Flash presentation
	*/
	function get bytesTotal():Number
	{
		return m_bytesTotal;
	}
	
	/*
	Deletes classes and namespaces of the loaded Flash presentation
	 */
	function cleanup():Void
	{
		m_target.cleanup();
		unloadMovie(m_target);
		removeMovieClip(m_target);
	}

	//////////////////////////////////////////////////////////////////////////
	// The following functions are private and should not be called directly
	//////////////////////////////////////////////////////////////////////////
	
	/*
	This function is called by MovieClipLoader when the portion of movie clip data is loaded
	*/
	private function onLoadProgress(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void
	{
		m_bytesLoaded = bytesLoaded;
		m_bytesTotal = bytesTotal;
		tryToInitPlayer();
	}
	
	/*
	This function is called by MovieClipLoader when loading error has been returned
	*/
	private function onLoadError(target:MovieClip, errorCode:String, httpStatus:Number)
	{		
		m_player = undefined;
	}
	
	/*
	This function is called by MovieClipLoader when the MovieClip has been loaded and actions on its first frame have been executed
	*/
	private function onLoadInit(target:MovieClip):Void
	{
		startTimer();
		tryToInitPlayer();
	}
	
	/*
	This function is called by MovieClipLoader when all MovieClip data have been loaded
	*/
	private function onLoadComplete(target:MovieClip):Void
	{
		tryToInitPlayer();
	}
	
	/*
	We call this function trying to initialize player
	*/
	private function tryToInitPlayer():Void
	{
		if (!m_player)
		{
			m_player = m_target.getPlayer();
			if (m_player)
			{
				m_player.addListener(this);
				if (m_player.isInitialized())
				{
					// the player has already been initialized. we need to call onPlayerInit manually
					onPlayerInit(m_player);
				}
			}
		}
	}
	
	/*
	We call this function for initialize player by timer
	*/
	private function startTimer():Void
	{
		var thisPtr:CPresentationLoader = this;
		m_target.onEnterFrame = function()
		{
			thisPtr.tryToInitPlayer();
		}
	}
	
	/*
	We call this function for stop timer
	*/
	private function stopTimer():Void
	{
		m_target.onEnterFrame = undefined;
	}
}
