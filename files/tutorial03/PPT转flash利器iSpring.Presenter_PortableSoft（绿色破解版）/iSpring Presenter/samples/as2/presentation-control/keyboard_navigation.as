import fsplayer.api.*

System.security.allowDomain("*");

var g_playerAPI:IPlayer;
var g_controller:IPresentationPlaybackController;

var presentation:MovieClip = this.createEmptyMovieClip("presentation", 1);
var loader:CPresentationLoader = new CPresentationLoader();
loader.setPlayerListener(this);
loader.loadClip("presentation.swf", presentation);

function onPlayerInit(playerAPI:IPlayer):Void
{
	g_playerAPI = playerAPI;
	g_controller = playerAPI.getPlaybackController();
	
	// this movie clip will listen to events of playback controller
	g_controller.addListener(this);
}

// toggle keyboard navigation
this.enabledNavigationCheckbox.onRelease = setKeyboardNavigationState;
this.disabledNavigationCheckbox.onRelease = setKeyboardNavigationState;

function setKeyboardNavigationState():Void
{
	if (g_playerAPI)
	{
		var keyboardNavigation:Object = g_playerAPI.getSettings().navigation.keyboard;
		if ((keyboardNavigation.enabled == true) || (keyboardNavigation.enabled == 1))
		{
			keyboardNavigation.enabled = false;
		}
		else
		{
			keyboardNavigation.enabled = true;
		}
		updateCheckboxesStates(keyboardNavigation.enabled);
	}
}

function updateCheckboxesStates(isSelected:Boolean):Void
{
	enabledNavigationCheckbox._visible = isSelected;
	disabledNavigationCheckbox._visible = !isSelected;
}
