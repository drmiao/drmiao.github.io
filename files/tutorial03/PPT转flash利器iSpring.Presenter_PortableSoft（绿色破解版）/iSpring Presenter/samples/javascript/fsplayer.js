// JS API

fsplayer = {};
fsplayer.api = {};

fsplayer.api.PlaybackControllerEvents = {};
fsplayer.api.PlaybackControllerEvents.PausePlaybackHandlers = {};
fsplayer.api.PlaybackControllerEvents.StartPlaybackHandlers = {};
fsplayer.api.PlaybackControllerEvents.PlaybackSuspendedHandlers = {};
fsplayer.api.PlaybackControllerEvents.PlaybackResumedHandlers = {};
fsplayer.api.PlaybackControllerEvents.AnimationStepChangedHandlers = {};
fsplayer.api.PlaybackControllerEvents.SlidePositionChangedHandlers = {};
fsplayer.api.PlaybackControllerEvents.CurrentSlideIndexChangedHandlers = {};
fsplayer.api.PlaybackControllerEvents.SlideLoadingCompleteHandlers = {};
fsplayer.api.PlaybackControllerEvents.PresentationPlaybackCompleteHandlers = {};
fsplayer.api.PlaybackControllerEvents.CloseRequestHandlers = {};

fsplayer.api.SoundControllerEvents = {};
fsplayer.api.SoundControllerEvents.ChangeVolumeHandlers = {};	
	
// Player
fsplayer.api.Player = function(movie, id)
{
	this.m_movie = movie;
	this.m_id = id;
	this.m_playbackController = new fsplayer.api.PlaybackController(movie, id);
	this.m_soundController = new fsplayer.api.SoundController(movie, id);
	this.m_presentationInfo = new fsplayer.api.PresentationInfo(movie);	
	this.m_skinUIController = new fsplayer.api.SkinUIController(movie, id);
};
fsplayer.api.Player.prototype.__name__ = "fsplayer.api.Player";
fsplayer.api.Player.prototype.m_movie = null;
fsplayer.api.Player.prototype.m_id = null;
fsplayer.api.Player.prototype.m_playbackController = null;
fsplayer.api.Player.prototype.m_soundController = null;
fsplayer.api.Player.prototype.m_presentationInfo = null;
fsplayer.api.Player.prototype.m_skinUIController = null;
fsplayer.api.Player.prototype = fsplayer.api.Player;
fsplayer.api.Player.prototype.getPlaybackController = function()
{
	return this.m_playbackController;
};
fsplayer.api.Player.prototype.getSoundController = function()
{
	return this.m_soundController;
};
fsplayer.api.Player.prototype.getPresentationInfo = function()
{
	return this.m_presentationInfo;
};
fsplayer.api.Player.prototype.getSkinUIController = function()
{
	return this.m_skinUIController;
};

// PresentationLoader
fsplayer.api.PresentationLoader = function()
{
	this.m_movie = null;
	this.m_id = "movie_id";
};

fsplayer.api.PresentationLoader.PLAYER_CONTENT_DIV_ID = 'playercontent';

fsplayer.api.PresentationLoader.prototype.__name__ = "fsplayer.api.PresentationLoader";
fsplayer.api.PresentationLoader.prototype.m_movie = null;
fsplayer.api.PresentationLoader.prototype.m_id = null;
fsplayer.api.PresentationLoader.prototype.m_width = null;
fsplayer.api.PresentationLoader.prototype.m_height = null;
fsplayer.api.PresentationLoader.prototype.m_contentParent = null;
fsplayer.api.PresentationLoader.prototype = fsplayer.api.PresentationLoader;

fsplayer.api.PresentationLoader.prototype.load = function(movieName, contentParent, movieId, width, height)
{
	if (this.m_contentParent)
		this.unload();
	
	if (typeof(contentParent) == "string")
	{
		this.m_contentParent = document.getElementById(contentParent);
	}
	else if (typeof(contentParent) == "object" && contentParent.appendChild)
	{
		this.m_contentParent = contentParent;
	}
	else //unknown parent type
	{
		return;
	}
	
	this.m_id = movieId;
	this.m_width = width;
	this.m_height = height;
	
	var contentDiv = document.createElement('div'); 
	contentDiv.setAttribute('id', "playercontent");
	this.m_contentParent.appendChild(contentDiv);

	var swfVars = {id: movieId};
	var swfParams = {
		allowscriptaccess: "sameDomain",
		allowfullscreen: true,
		salign: "lt"
	};
	var swfAttributes = {
		id: movieId,
		name: movieId
	};

	var thisPtr = this;
	var swfEmbedHandler = function(e)
	{
		thisPtr.onSwfEmbed(e.ref);
	};

	swfobject.embedSWF(movieName, contentDiv.getAttribute("id"), 
			width, height, "9", false, 
			swfVars, swfParams, swfAttributes, swfEmbedHandler);
};

fsplayer.api.PresentationLoader.prototype.onSwfEmbed = function(movie)
{
	this.m_movie = movie;
	if (movie)
	{
		var thisPtr = this;
		fsplayer.api.PresentationLoader.prototype.onPlayerInit[this.m_id] = function()
		{
			thisPtr.onPlayerInit(new fsplayer.api.Player(thisPtr.m_movie, thisPtr.m_id));
		};
	}
};

fsplayer.api.PresentationLoader.prototype.onPlayerInit = function(player)
{
	// override
};
fsplayer.api.PresentationLoader.prototype.getMovie = function()
{
	return this.m_movie;
};
fsplayer.api.PresentationLoader.prototype.getMovieId = function()
{
	return this.m_id;
};

fsplayer.api.PresentationLoader.prototype.unload = function()
{
	this.m_width = null;
	this.m_height = null;
	
	this.m_id = null;
	this.m_movie = null;
	
	this.m_contentParent.innerHTML = "";
	this.m_contentParent = null;
};

// Playback Controller
fsplayer.api.PlaybackController = function(movie, id)
{
	this.m_movie = movie;
	this.m_id = id;
};

// events' constants
fsplayer.api.PlaybackController.PAUSE_PLAYBACK = "playbackListener_onPausePlayback";
fsplayer.api.PlaybackController.START_PLAYBACK = "playbackListener_onStartPlayback";
fsplayer.api.PlaybackController.PLAYBACK_SUSPENDED = "playbackListener_onPlaybackSuspended";
fsplayer.api.PlaybackController.PLAYBACK_RESUMED = "playbackListener_onPlaybackResumed";
fsplayer.api.PlaybackController.ANIMATION_STEP_CHANGED = "playbackListener_onAnimationStepChanged";
fsplayer.api.PlaybackController.SLIDE_POSITION_CHANGED = "playbackListener_onSlidePositionChanged";
fsplayer.api.PlaybackController.CURRENT_SLIDE_INDEX_CHANGED = "playbackListener_onCurrentSlideIndexChanged";
fsplayer.api.PlaybackController.SLIDE_LOADING_COMPLETE = "playbackListener_onSlideLoadingComplete";
fsplayer.api.PlaybackController.PRESENTATION_PLAYBACK_COMPLETE = "playbackListener_onPresentationPlaybackComplete";
fsplayer.api.PlaybackController.CLOSE_REQUEST = "playbackListener_onCallCloseRequest";
fsplayer.api.PlaybackController.prototype.m_movie = null;
fsplayer.api.PlaybackController.prototype.m_id = null;
fsplayer.api.PlaybackController.prototype.__name__ = "fsplayer.api.PlaybackController";
fsplayer.api.PlaybackController.prototype = fsplayer.api.PlaybackController;

fsplayer.api.PlaybackController.prototype.play = function()
{
	this.m_movie.playbackController_play();
};

fsplayer.api.PlaybackController.prototype.pause = function()
{
	this.m_movie.playbackController_pause();
};

fsplayer.api.PlaybackController.prototype.gotoSlide = function(slideIndex, autoStart)
{
	this.m_movie.playbackController_gotoSlide(slideIndex, autoStart);
};

fsplayer.api.PlaybackController.prototype.isPlaying = function()
{
	return this.m_movie.playbackController_isPlaying();
};

fsplayer.api.PlaybackController.prototype.gotoNextSlide = function(autoStart)
{
	this.m_movie.playbackController_gotoNextSlide(autoStart);
};

fsplayer.api.PlaybackController.prototype.gotoPreviousSlide = function(autoStart)
{
	this.m_movie.playbackController_gotoPreviousSlide(autoStart);
};

fsplayer.api.PlaybackController.prototype.getCurrentSlideIndex = function()
{
	//alert("movie " + this.m_movie + ", index - " + this.m_movie.playbackController_getCurrentSlideIndex());
	return this.m_movie.playbackController_getCurrentSlideIndex();
};

fsplayer.api.PlaybackController.prototype.getCurrentSlidePlaybackPosition = function()
{
	return this.m_movie.playbackController_getCurrentSlidePlaybackPosition();
};

fsplayer.api.PlaybackController.prototype.gotoNextStep = function()
{
	this.m_movie.playbackController_gotoNextStep();
};

fsplayer.api.PlaybackController.prototype.gotoPreviousStep = function()
{
	this.m_movie.playbackController_gotoPreviousStep();
};

fsplayer.api.PlaybackController.prototype.getCurrentStepIndex = function()
{
	return this.m_movie.playbackController_getCurrentStepIndex();
};

fsplayer.api.PlaybackController.prototype.setPausePlaybackHandler = function()
{
	var thisPtr = this;
	this.m_movie.playbackController_setEventListener("playbackListener_onPausePlayback", "fsplayer.api.PlaybackControllerEvents.PausePlaybackHandlers." + this.m_id);
	fsplayer.api.PlaybackControllerEvents.PausePlaybackHandlers[this.m_id] = function()
	{
		thisPtr.onPausePlayback();
	};
};

fsplayer.api.PlaybackController.prototype.onPausePlayback = function()
{
	// override
};

fsplayer.api.PlaybackController.prototype.setStartPlaybackHandler = function()
{
	var thisPtr = this;
	this.m_movie.playbackController_setEventListener("playbackListener_onStartPlayback", "fsplayer.api.PlaybackControllerEvents.StartPlaybackHandlers." + this.m_id);
	fsplayer.api.PlaybackControllerEvents.StartPlaybackHandlers[this.m_id] = function()
	{
		thisPtr.onStartPlayback();
	};
};

fsplayer.api.PlaybackController.prototype.onStartPlayback = function()
{
	// override
};

fsplayer.api.PlaybackController.prototype.setPlaybackSuspendedHandler = function()
{
	var thisPtr = this;
	this.m_movie.playbackController_setEventListener("playbackListener_onPlaybackSuspended", "fsplayer.api.PlaybackControllerEvents.PlaybackSuspendedHandlers." + this.m_id);
	fsplayer.api.PlaybackControllerEvents.PlaybackSuspendedHandlers[this.m_id] = function()
	{
		thisPtr.onPlaybackSuspended();
	};
};

fsplayer.api.PlaybackController.prototype.onPlaybackSuspended = function()
{
	// override
};

fsplayer.api.PlaybackController.prototype.setPlaybackResumedHandler = function()
{
	var thisPtr = this;
	this.m_movie.playbackController_setEventListener("playbackListener_onPlaybackResumed", "fsplayer.api.PlaybackControllerEvents.PlaybackResumedHandlers." + this.m_id);
	fsplayer.api.PlaybackControllerEvents.PlaybackResumedHandlers[this.m_id] = function()
	{
		thisPtr.onPlaybackResumed();
	};
};

fsplayer.api.PlaybackController.prototype.onPlaybackResumed = function()
{
	// override
};

fsplayer.api.PlaybackController.prototype.setAnimationStepChangedHandler = function()
{
	var thisPtr = this;
	this.m_movie.playbackController_setEventListener("playbackListener_onAnimationStepChanged", "fsplayer.api.PlaybackControllerEvents.AnimationStepChangedHandlers." + this.m_id);
	fsplayer.api.PlaybackControllerEvents.AnimationStepChangedHandlers[this.m_id] = function(stepIndex)
	{
		thisPtr.onAnimationStepChanged(stepIndex);
	};
};

fsplayer.api.PlaybackController.prototype.onAnimationStepChanged = function(stepIndex)
{
	// override
};

fsplayer.api.PlaybackController.prototype.setSlidePositionChangedHandler = function()
{
	var thisPtr = this;
	this.m_movie.playbackController_setEventListener("playbackListener_onSlidePositionChanged", "fsplayer.api.PlaybackControllerEvents.SlidePositionChangedHandlers." + this.m_id);
	fsplayer.api.PlaybackControllerEvents.SlidePositionChangedHandlers[this.m_id] = function(position)
	{
		thisPtr.onSlidePositionChanged(position);
	};
};

fsplayer.api.PlaybackController.prototype.onSlidePositionChanged = function(position)
{
	// override
};

fsplayer.api.PlaybackController.prototype.setCurrentSlideIndexChangedHandler = function()
{
	//alert(this.m_id);
	var thisPtr = this;
	this.m_movie.playbackController_setEventListener("playbackListener_onCurrentSlideIndexChanged", "fsplayer.api.PlaybackControllerEvents.CurrentSlideIndexChangedHandlers." + this.m_id);
	fsplayer.api.PlaybackControllerEvents.CurrentSlideIndexChangedHandlers[this.m_id] = function(slideIndex)
	{
		thisPtr.onCurrentSlideIndexChanged(slideIndex);
	};
};
fsplayer.api.PlaybackController.prototype.onCurrentSlideIndexChanged = function(index)
{
	// override
};

fsplayer.api.PlaybackController.prototype.setSlideLoadingCompleteHandler = function()
{
	var thisPtr = this;
	this.m_movie.playbackController_setEventListener("playbackListener_onSlideLoadingComplete", "fsplayer.api.PlaybackControllerEvents.SlideLoadingCompleteHandlers." + this.m_id);
	fsplayer.api.PlaybackControllerEvents.SlideLoadingCompleteHandlers[this.m_id] = function(slideIndex)
	{
		thisPtr.onSlideLoadingComplete(slideIndex);
	};
};
fsplayer.api.PlaybackController.prototype.onSlideLoadingComplete = function(index)
{
	// override
};

fsplayer.api.PlaybackController.prototype.setPresentationPlaybackCompleteHandler = function()
{
	var thisPtr = this;
	this.m_movie.playbackController_setEventListener("playbackListener_onPresentationPlaybackComplete", "fsplayer.api.PlaybackControllerEvents.PresentationPlaybackCompleteHandlers." + this.m_id);
	fsplayer.api.PlaybackControllerEvents.PresentationPlaybackCompleteHandlers[this.m_id] = function()
	{
		thisPtr.onPresentationPlaybackComplete();
	};
};
fsplayer.api.PlaybackController.prototype.onPresentationPlaybackComplete = function()
{
	// override
};

fsplayer.api.PlaybackController.prototype.setCloseRequestHandler = function()
{
	this.m_movie.playbackController_setEventListener("playbackListener_onCallCloseRequest", "fsplayer.api.PlaybackControllerEvents.CloseRequestHandlers." + this.m_id);
	
	var thisPtr = this;
	fsplayer.api.PlaybackControllerEvents.CloseRequestHandlers[this.m_id] = function()
	{
		thisPtr.onCallCloseRequest();
	};
};
fsplayer.api.PlaybackController.prototype.onCallCloseRequest = function()
{
	// override
};

fsplayer.api.PlaybackController.prototype.enableAllEventHandlers = function()
{
	this.setPausePlaybackHandler();
	this.setStartPlaybackHandler();
	this.setPlaybackSuspendedHandler();
	this.setPlaybackResumedHandler();
	this.setAnimationStepChangedHandler();
	this.setSlidePositionChangedHandler();
	this.setCurrentSlideIndexChangedHandler();
	this.setSlideLoadingCompleteHandler();
	this.setPresentationPlaybackCompleteHandler();
	this.setCloseRequestHandler();
};

fsplayer.api.PlaybackController.prototype.removeAllEventHandlers = function()
{
	this.removePlaybackHandler(this.PAUSE_PLAYBACK);
	this.removePlaybackHandler(this.START_PLAYBACK);
	this.removePlaybackHandler(this.PLAYBACK_SUSPENDED);
	this.removePlaybackHandler(this.PLAYBACK_RESUMED);
	this.removePlaybackHandler(this.ANIMATION_STEP_CHANGED);
	this.removePlaybackHandler(this.SLIDE_POSITION_CHANGED);
	this.removePlaybackHandler(this.CURRENT_SLIDE_INDEX_CHANGED);
	this.removePlaybackHandler(this.SLIDE_LOADING_COMPLETE);
	this.removePlaybackHandler(this.PRESENTATION_PLAYBACK_COMPLETE);
	this.removePlaybackHandler(this.CLOSE_REQUEST);
};


fsplayer.api.PlaybackController.prototype.setPlaybackHandler = function(event)
{
	if (this.m_movie != undefined)
	{
		switch (event)
		{
			case this.PAUSE_PLAYBACK:
				this.setPausePlaybackHandler();
				break;
			case this.START_PLAYBACK:
				this.setStartPlaybackHandler();
				break;
			case this.PLAYBACK_SUSPENDED:
				this.setPlaybackSuspendedHandler();
				break;
			case this.PLAYBACK_RESUMED:
				this.setPlaybackResumedHandler();
				break;
			case this.ANIMATION_STEP_CHANGED:
				this.setAnimationStepChangedHandler();
				break;
			case this.SLIDE_POSITION_CHANGED:
				this.setSlidePositionChangedHandler();
				break;
			case this.CURRENT_SLIDE_INDEX_CHANGED:
				this.setCurrentSlideIndexChangedHandler();
				break;
			case this.SLIDE_LOADING_COMPLETE:
				this.setSlideLoadingCompleteHandler();
				break;
			case this.PRESENTATION_PLAYBACK_COMPLETE:
				this.setPresentationPlaybackCompleteHandler();
				break;
			case this.CLOSE_REQUEST:
				this.setCloseRequestHandler();
				break;
		}
	}
};

fsplayer.api.PlaybackController.prototype.removePlaybackHandler = function(event)
{
	if (this.m_movie != undefined)
	{
		this.m_movie.playbackController_removeEventListener(event);
	}
};

// Sound Controller
fsplayer.api.SoundController = function(movie, id)
{
	this.m_movie = movie;
	this.m_id = id;
};

// events' constants
fsplayer.api.SoundController.VOLUME_CHANGED = "soundListener_onSoundVolumeChanged";

fsplayer.api.SoundController.prototype.setVolume = function(volume)
{
	this.m_movie.soundController_setVolume(volume);
};

fsplayer.api.SoundController.prototype.getVolume = function()
{
	return this.m_movie.soundController_getVolume();
};

fsplayer.api.SoundController.prototype.setSoundHandler = function(event)
{
	if (this.m_movie != undefined)
	{
		switch (event)
		{
			case this.VOLUME_CHANGED:
				this.setChangeVolumeHandler();
				break;			
		}
	}
};

fsplayer.api.SoundController.prototype.removeSoundHandler = function(event)
{
	if (this.m_movie != undefined)
	{
		this.m_movie.soundController_removeEventListener(event);
	}
};

fsplayer.api.SoundController.prototype.removeAllEventHandlers = function()
{
	this.removePlaybackHandler(this.VOLUME_CHANGED);
};

fsplayer.api.SoundController.prototype.setChangeVolumeHandler = function()
{
	var thisPtr = this;
	this.m_movie.soundController_setEventListener("soundListener_onSoundVolumeChanged", "fsplayer.api.SoundControllerEvents.ChangeVolumeHandlers." + this.m_id);
	fsplayer.api.SoundControllerEvents.ChangeVolumeHandlers[this.m_id] = function(newVolume)
	{
		thisPtr.onSoundVolumeChanged(newVolume);
	};
};

fsplayer.api.SoundController.prototype.onSoundVolumeChanged = function(newVolume)
{
	// override
};


// Presentation Info
fsplayer.api.PresentationInfo = function(movie)
{
	this.m_movie = movie;
	this.m_slidesCollection = new fsplayer.api.SlidesCollection(movie);
	this.m_presentersCollection = new fsplayer.api.PresentersCollection(movie);
};
fsplayer.api.PresentationInfo.prototype.m_movie = null;
fsplayer.api.PresentationInfo.prototype.m_slidesCollection = null;
fsplayer.api.PresentationInfo.prototype.m_presentersCollection = null;
fsplayer.api.PresentationInfo.prototype.__name__ = "fsplayer.api.PresentationInfo";
fsplayer.api.PresentationInfo.prototype = fsplayer.api.PresentationInfo;
fsplayer.api.PresentationInfo.prototype.getTitle = function()
{
	return this.m_movie.presentation_getTitle();
};
fsplayer.api.PresentationInfo.prototype.getDuration = function()
{
	return this.m_movie.presentation_getDuration();
};
fsplayer.api.PresentationInfo.prototype.getSlides = function()
{
	return this.m_slidesCollection;
};
fsplayer.api.PresentationInfo.prototype.getPresenters = function()
{
	return this.m_presentersCollection;
};

// PresentersCollection
fsplayer.api.PresentersCollection = function(movie)
{
	this.m_movie = movie;
};
fsplayer.api.PresentersCollection.prototype.m_movie = null;
fsplayer.api.PresentersCollection.prototype.__name__ = "fsplayer.api.PresentersCollection";
fsplayer.api.PresentersCollection.prototype = fsplayer.api.PresentersCollection;
fsplayer.api.PresentersCollection.prototype.getCount = function()
{
	return this.m_movie.presenters_getCount();
};

// SlidesCollection
fsplayer.api.SlidesCollection = function(movie)
{
	this.m_movie = movie;
	this.m_slideInfoArray = new Array();
};
fsplayer.api.SlidesCollection.prototype.m_movie = null;
fsplayer.api.SlidesCollection.prototype.m_slideInfoArray = null;
fsplayer.api.SlidesCollection.prototype.__name__ = "fsplayer.api.SlidesCollection";
fsplayer.api.SlidesCollection.prototype = fsplayer.api.SlidesCollection;
fsplayer.api.SlidesCollection.prototype.getSlidesCount = function()
{
	return this.m_movie.presentation_getSlidesCount();
};
fsplayer.api.SlidesCollection.prototype.getSlideInfo = function(index)
{
	if (!this.m_slideInfoArray[index])
	{
		this.m_slideInfoArray[index] = new fsplayer.api.SlideInfo(this.m_movie, index);
	}
	return this.m_slideInfoArray[index];
};

// Slide Info
fsplayer.api.SlideInfo = function(movie, index)
{
	this.m_movie = movie;
	this.m_index = index;
};
fsplayer.api.SlideInfo.prototype.m_movie = null;
fsplayer.api.SlideInfo.prototype.__name__ = "fsplayer.api.SlideInfo";
fsplayer.api.SlideInfo.prototype = fsplayer.api.SlideInfo;
fsplayer.api.SlideInfo.prototype.getTitle = function()
{
	return this.m_movie.slide_getTitle(this.m_index);
};

fsplayer.api.SlideInfo.prototype.isLoaded = function()
{
	return this.m_movie.slide_isLoaded(this.m_index);
};

fsplayer.api.SlideInfo.prototype.getDuration = function()
{
	return this.m_movie.slide_getDuration(this.m_index);
};

fsplayer.api.SlideInfo.prototype.getStepsCount = function()
{
	return this.m_movie.slide_getStepsCount(this.m_index);
};

fsplayer.api.SkinUIController = function(movie, id)
{
	this.m_movie = movie;
	this.m_id    = id;
	
	this.setCloseRequestHandler = function()
	{
		this.m_movie.skinUI_setEventListener("skinUI_onCallCloseRequest", "fsplayer.api.SkinUIController.SkinUIEvents.CloseRequestHandlers." + this.m_id);
		
		var thisPtr = this;
		fsplayer.api.SkinUIController.SkinUIEvents.CloseRequestHandlers[this.m_id] = function()
		{
			thisPtr.onCallCloseRequest();
		};
	};	
	
	this.onCallCloseRequest = function()
	{
		//override
	};
};

fsplayer.api.SkinUIController.SkinUIEvents = {};
fsplayer.api.SkinUIController.SkinUIEvents.CloseRequestHandlers = {};