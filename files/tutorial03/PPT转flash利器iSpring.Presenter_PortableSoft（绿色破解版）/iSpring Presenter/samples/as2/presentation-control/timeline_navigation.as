import fsplayer.api.*

System.security.allowDomain("*");

var g_playerAPI:IPlayer;
var g_controller:IPresentationPlaybackController;
var g_presentationInfo:IPresentationInfo;

var slider:MovieClip = this.presentationSlider;
var line:MovieClip = this.presentationLine;
var sliderPressed:Boolean = false;
var position:Number = undefined;

var presentation:MovieClip = this.createEmptyMovieClip("presentation", 1);
var loader:CPresentationLoader = new CPresentationLoader();
loader.setPlayerListener(this);
loader.loadClip("presentation.swf", presentation);

function onPlayerInit(playerAPI:IPlayer):Void
{
	g_playerAPI = playerAPI;
	g_controller = playerAPI.getPlaybackController();
	g_presentationInfo = playerAPI.getPresentationInfo();
	
	// this movie clip will listen to events of playback controller
	g_controller.addListener(this);
	
	updatePlayPauseButtons(true);
}

this.playButton.onRelease = function()
{
	if (g_controller)
	{
		if (!g_controller.isPlaying())
		{
			g_controller.play();
		}
	}
}

this.pauseButton.onRelease = function()
{
	if (g_controller)
	{
		if (g_controller.isPlaying())
		{
			g_controller.pause();
		}
	}
}

function onCurrentSlideIndexChanged(slideIndex:Number):Void
{
	currentSlideIndex.text = "Current slide index: " + (slideIndex + 1);
	refreshSlider();
}

function onSlidePositionChanged(position:Number):Void
{
	refreshSlider();
}

slider.onPress = function():Void
{
	sliderPressed = true;
}


this.onMouseUp = function():Void
{
	if (sliderPressed)
	{
		navigatePresentation();
		g_controller.endSeek(true);
		sliderPressed = false;
	}
}

this.onMouseMove = function()
{
	if (sliderPressed)
	{
		var x1:Number = line._x;
		var x2:Number = x1 + line._width;
		var dx:Number = _root._xmouse;
		if (x1 <= dx && dx <= x2)
		{
			slider._x = dx;
			setSliderPosition((dx - x1)/(x2 - x1));
		}
		else if (dx < x1)
		{
			slider._x = x1;
			setSliderPosition(0);
		}
		else if (dx > x2)
		{
			slider._x = x2;
			setSliderPosition(1);
		}
		navigatePresentation();
	}
}

function navigatePresentation():Void
{
	var sliderPosition:Number = getSliderPosition();
	var presentationDuration:Number = g_presentationInfo.getDuration();
	var time:Number = presentationDuration * sliderPosition;
	var slides:ISlidesCollection = g_presentationInfo.getSlides();
	var slideInfo:ISlideInfo;
	var slideStart:Number;
	var slideEnd:Number;
	var slideIndex:Number;
	for (var i:Number = 0; i < slides.getSlidesCount(); ++i)
	{
		slideInfo = slides.getSlideInfo(i);
		slideIndex = i;
		slideStart = slideInfo.getStartTime();
		slideEnd = slideInfo.getEndTime();
		if (slideStart <= time && time < slideEnd)
		{
			break;
		}
	}
	var slidePosition:Number = (time - slideStart) / (slideEnd - slideStart);
	g_controller.gotoSlide(slideIndex);
	g_controller.seek(slidePosition);
}

function refreshSlider():Void
{
	if (!sliderPressed)
	{
		var presentationDuration:Number = g_presentationInfo.getDuration();
		var slideIndex:Number = g_controller.getCurrentSlideIndex();
		var slideInfo:ISlideInfo = g_presentationInfo.getSlides().getSlideInfo(slideIndex);
		var slideStartTime:Number = slideInfo.getStartTime();
		var slideDuration:Number = slideInfo.getDuration();
		var slidePosition:Number = g_controller.getCurrentSlidePlaybackPosition();
		var position:Number = (slideStartTime + slideDuration * slidePosition) / presentationDuration;
		
		setSliderPosition(position);
	}
}

function setSliderPosition(position:Number):Void // 0..1
{
	slider._x = line._x + line._width * position;
}

function getSliderPosition():Number
{
	return (slider._x - line._x) / line._width;
}

function updatePlayPauseButtons(isPlaying:Boolean):Void
{
	playButton._visible = !isPlaying;
	pauseButton._visible = isPlaying;
}

function onStartPlayback():Void
{
	updatePlayPauseButtons(true);
}

function onPausePlayback():Void
{
	updatePlayPauseButtons(false);
}
