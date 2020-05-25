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

// toggle forward navigation on mouse click
this.enabledNavigationCheckbox.onRelease = setMouseNavigationState;
this.disabledNavigationCheckbox.onRelease = setMouseNavigationState;

function setMouseNavigationState():Void
{
	if (g_playerAPI)
	{
		var mouseNavigation:Object = g_playerAPI.getSettings().navigation.mouse;
		if ((mouseNavigation.enabled == true) || (mouseNavigation.enabled == 1))
		{
			mouseNavigation.enabled = false;
		}
		else
		{
			mouseNavigation.enabled = true;
		}
		updateCheckboxesStates(mouseNavigation.enabled);
	}
}

function updateCheckboxesStates(isSelected:Boolean):Void
{
	enabledNavigationCheckbox._visible = isSelected;
	disabledNavigationCheckbox._visible = !isSelected;
}
