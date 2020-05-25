import fsplayer.api.IPlayerListener;
import fsplayer.api.IPlayer;
import fsplayer.api.IPresentationPlaybackController;
import fsplayer.api.CPresentationLoader;
import fsplayer.api.IPlaybackListener;
import fsplayer.api.IPresentersCollection;
import fsplayer.api.ISoundController;
import fsplayer.api.ISoundListener;
import fsplayer.api.IPresentationInfo;
import fsplayer.api.ISlidesCollection;
import fsplayer.api.ISlideInfo;
import fsplayer.api.IAnimationStep;
import fsplayer.api.IReferenceInfo;
import fsplayer.api.IPresenterInfo;
import fsplayer.api.IAnimationSteps;

class CAS3Bridge extends LocalConnection implements IPlayerListener, IPlaybackListener, ISoundListener
{
	private var m_presentationLoaded:Boolean = false;
	private var m_mcPresentation:MovieClip;
	private var m_target:MovieClip;
	private var m_playbackController:IPresentationPlaybackController;
	private var m_presentationLoader:CPresentationLoader;
	private var m_commandConnectionName:String;
	private var m_eventConnectionName:String;
	private var m_soundController:ISoundController;
	private var m_presentationInfo:IPresentationInfo;
	private var m_sendPresentationInfo:Object;
	private var m_sendSlidesInfo:Array;
	private var m_presentationURL:String = undefined;
	
	public function CAS3Bridge(target:MovieClip, commandConnectionName:String, eventConnectionName:String)
	{
		m_commandConnectionName = commandConnectionName;
		m_eventConnectionName = eventConnectionName;
			
		m_target = target;
		
		this.allowDomain = function():Boolean
		{
			return true;
		}
		
		this.connect(m_commandConnectionName);
		m_presentationLoader = new CPresentationLoader();
		m_presentationLoader.setPlayerListener(this);
		m_presentationLoader.addListener(this);

		this.send(m_eventConnectionName, "onBridgeLoaded");
		printString("connected");
	}
	
	private function createPresentationTarget():MovieClip
	{
		return m_target.createEmptyMovieClip("m_mcPresentation", target.getNextHighestDepth());
	}
	
	public function loadPresentation(presentationURL:String):Void
	{		
		if (presentationURL == undefined)
			presentationURL = "#";
		
		if (m_mcPresentation != undefined)
		{
			m_presentationLoader.unloadClip(m_mcPresentation);
			m_mcPresentation.unloadMovie();
			m_mcPresentation.removeMovieClip();
		}
		m_mcPresentation = createPresentationTarget();
		
		m_presentationURL = presentationURL;
		printString("load: " + presentationURL);
		
		m_presentationLoaded = false;
		m_presentationLoader.loadClip(presentationURL, m_mcPresentation);
	}
	
	public function onPlayerInit(player:IPlayer):Void // IPlayerListener
	{
		printString("onPlayerInit");
	
		if (m_playbackController)
		{
			m_playbackController.removeListener(this);
		}
		if (m_soundController)
		{
			m_soundController.removeListener(this);
		}
	
		m_presentationInfo = player.getPresentationInfo();
		m_playbackController = player.getPlaybackController();
		m_soundController = player.getSoundController();
		m_playbackController.addListener(this);
		m_soundController.addListener(this);
		
		m_sendPresentationInfo = new Object();
		m_sendSlidesInfo = new Array();
		initSendPresentationInfo();
		this.send(m_eventConnectionName, "onPresentationLoaded", true, m_sendPresentationInfo);
		m_presentationLoaded = true;
	}
	
	private function onLoadError(target_mc:MovieClip, errorCode:String):Void
	{
		printString("Load presentation error: " + errorCode);
		this.send(m_eventConnectionName, "onPresentationLoaded", false, undefined);
	}
	
	private function initSendPresentationInfo():Void
	{
		var spi:Object = new Object();
		var pi:IPresentationInfo = m_presentationInfo;
		
		spi.title		= pi.getTitle();
		spi.duration	= pi.getDuration();
		spi.slideWidth	= pi.getSlideWidth();
		spi.slideHeight	= pi.getSlideHeight();
		spi.frameRate	= pi.getFrameRate();
		
		addReferencesInfo(spi);
		addSlidesInfo(spi);
		addPresentersInfo(spi);
		
		m_sendPresentationInfo = spi;
	}
		
	private function addSlidesInfo(spi:Object):Void
	{
		var pi:IPresentationInfo = m_presentationInfo;
		var sc:ISlidesCollection = pi.getSlides();
		
		spi.slidesCollection = new Object();
		var ssc:Object = spi.slidesCollection;
		ssc.slidesCount = sc.getSlidesCount();
		ssc.visibleSlidesCount = sc.getSlidesCount();
		ssc.slides = new Object();
		var sscs:Object = ssc.slides;
		for (var i:Number = 0; i < ssc.slidesCount; i++)
		{
			var si:ISlideInfo = sc.getSlideInfo(i);
			sscs["slide" + i] = new Object();
			
			var ss:Object = sscs["slide" + i];
			ss.startTime 		= si.getStartTime();
			ss.visibleIndex 	= si.getVisibleIndex();
			ss.visibleStartTime = si.getVisibleStartTime();
		}
	}
	
	private function addReferencesInfo(spi:Object):Void
	{
		var pi:IPresentationInfo = m_presentationInfo;
		
		spi.hasReferences = pi.hasReferences();
		if (spi.hasReferences)
		{
			spi.referencesCollection = new Object();
			var src:Object = spi.referencesCollection;
			src.referencesCount = pi.getReferences().getCount();
			src.references = new Object();
			var srcr:Object = src.references;
			for (var i:Number = 0; i < src.referencesCount; i++)
			{
				var ri:IReferenceInfo = pi.getReferences().getReference(i);
				srcr["reference" + i] = new Object();
				var sr:Object = srcr["reference" + i];
				sr.title = ri.getTitle();
				sr.url = ri.getURL();
				sr.target = ri.getTarget();
			}
		}
	}
	
	private function addPresentersInfo(spi:Object):Void
	{
		var pi:IPresentationInfo = m_presentationInfo;
		
		spi.hasPresenter = pi.hasPresenter();
		if (spi.hasPresenter)
		{
			var presenters:IPresentersCollection = pi.getPresenters();
			var presentersCount:Number = presenters.getCount();
			
			var sPresentersCollection:Object = new Object();
			sPresentersCollection.presentersCount = presentersCount;

			var sPresenters:Object = new Object();
			sPresentersCollection.presenters = sPresenters;

			spi.presentersCollection = sPresentersCollection;
			
			for (var i:Number = 0; i < presentersCount; ++i)
			{
				var presenter:IPresenterInfo = presenters.getPresenter(i);
				var sPresenter:Object = new Object();
				sPresenters["presenter" + i] = sPresenter;
				
				sPresenter.name = presenter.getName();
				sPresenter.title = presenter.getTitle();
				sPresenter.biographyText = presenter.getBiographyText();
				sPresenter.email = presenter.getEmail();
				sPresenter.webSite = presenter.getWebSite();
			}
		}
	}
	
	private function initSendSlideInfo(slideIndex:Number):Boolean
	{
		if (m_sendSlidesInfo[slideIndex] != undefined)
		{
			return false;
		}
		
		m_sendSlidesInfo[slideIndex] = new Object();
		var ssi:Object = m_sendSlidesInfo[slideIndex];
		var si:ISlideInfo = m_presentationInfo.getSlides().getSlideInfo(slideIndex);
		
		ssi.title				= si.getTitle();
		ssi.duration			= si.getDuration();
		ssi.notesText			= si.getNotesText();
		ssi.endTime				= si.getEndTime();
		ssi.startStepIndex		= si.getStartStepIndex();
		ssi.endStepIndex		= si.getEndStepIndex();
		ssi.slideText			= si.getSlideText();
		ssi.notesTextNormalized	= si.getNotesTextNormalized();
		ssi.titleNormalized		= si.getTitleNormalized();
		ssi.level				= si.getLevel();
		
		ssi.hidden				= si.isHidden();
		ssi.visibleEndTime		= si.getVisibleEndTime();
		ssi.visibleStartStepIndex	= si.getVisibleStartStepIndex();
		ssi.visibleEndStepIndex	= si.getVisibleEndStepIndex();
		ssi.presenterIndex		= si.getPresenterIndex();
		
		addStepsInfo(slideIndex, ssi);
		
		return true;
	}
	
	private function addStepsInfo(slideIndex:Number, ssi:Object):Void
	{
		var si:ISlideInfo = m_presentationInfo.getSlides().getSlideInfo(slideIndex);
		
		ssi.animationSteps = new Object();
		var ssiSteps:Object = ssi.animationSteps;
		var steps:IAnimationSteps = si.getAnimationSteps();
		
		ssiSteps.stepsCount	= steps.getStepsCount();
		ssiSteps.duration	= steps.getDuration();
		ssiSteps.steps = new Object();
		
		for (var i:Number = 0; i < ssiSteps.stepsCount; i++)
		{
			ssiSteps.steps["step" + i] = new Object();
			var ss:Object = ssiSteps.steps["step" + i];
			var s:IAnimationStep = steps.getStep(i);
			
			ss.playTime			= s.getPlayTime();
			ss.pauseTime		= s.getPauseTime();
			ss.startTime		= s.getStartTime();
			ss.pauseStartTime	= s.getPauseStartTime();
			ss.pauseEndTime		= s.getPauseEndTime();
		}
	}
	
	// local connection functions (playback controller) >
	private function gotoNextSlide(autoStart:Boolean):Void
	{
		m_playbackController.gotoNextSlide(autoStart);
	}

	private function gotoPreviousSlide(autoStart:Boolean):Void
	{	
		m_playbackController.gotoPreviousSlide(autoStart);
	}

	private function play():Void
	{
		m_playbackController.play();
	}

	private function pause():Void
	{
		m_playbackController.pause();
	}

	private function gotoLastViewedSlide(autoStart:Boolean):Void
	{
		m_playbackController.gotoLastViewedSlide(autoStart);
	}

	private function gotoSlide(slideIndex:Number, autoStart:Boolean):Void
	{
		m_playbackController.gotoSlide(slideIndex, autoStart);
	}

	private function pauseCurrentSlideAt(position:Number):Void
	{
		m_playbackController.pauseCurrentSlideAt(position);
	}

	private function playCurrentSlideFrom(position:Number):Void
	{
		m_playbackController.playCurrentSlideFrom(position);
	}

	private function seek(position:Number):Void
	{
		m_playbackController.seek(position);
		this.send(m_eventConnectionName, "onSeekingComplete");
	}

	private function endSeek(resumePlayback:Boolean):Void
	{
		m_playbackController.endSeek(resumePlayback);
	}

	private function gotoNextStep():Void
	{
		m_playbackController.gotoNextStep();
	}

	private function gotoPreviousStep():Void
	{
		m_playbackController.gotoPreviousStep();
	}

	private function playFromStep(stepIndex:Number):Void
	{
		m_playbackController.playFromStep(stepIndex);
	}

	private function pauseAtStepStart(stepIndex:Number):Void
	{
		m_playbackController.pauseAtStepStart(stepIndex);
	}

	private function pauseAtStepEnd(stepIndex:Number):Void
	{
		m_playbackController.pauseAtStepEnd(stepIndex);
	}
	// local connection functions (playback controller) <
	
	// local connection functions (sound controller) >
	private function setVolume(volume:Number):Void
	{
		m_soundController.setVolume(volume);
		this.send(m_eventConnectionName, "onVolumeChangingComplete");
	}
	// local connection functions (sound controller) <
	
	// local connection functions (slide info) >
	private function loadSlideMetadata(slideIndex:Number):Void
	{
		sendSlideMetadata(slideIndex);
	}
	// local connection functions (slide info) <
	
	// playback listener functions >
	public function onPausePlayback():Void
	{
		this.send(m_eventConnectionName, "onPausePlayback");
	}

	public function onStartPlayback():Void
	{
		this.send(m_eventConnectionName, "onStartPlayback");
	}

	public function onAnimationStepChanged(stepIndex:Number):Void
	{
		this.send(m_eventConnectionName, "onAnimationStepChanged", stepIndex);
	}

	public function onSlidePositionChanged(position:Number):Void
	{
		this.send(m_eventConnectionName, "onSlidePositionChanged", position);
	}

	public function onCurrentSlideIndexChanged(slideIndex:Number):Void
	{
		this.send(m_eventConnectionName, "onCurrentSlideIndexChanged", slideIndex, m_playbackController.getCurrentSlideDuration());
	}

	public function onSlideLoadingComplete(slideIndex:Number):Void
	{
		sendSlideMetadata(slideIndex);
		this.send(m_eventConnectionName, "onSlideLoadingComplete", slideIndex);
	}

	public function onPresentationPlaybackComplete():Void
	{
		this.send(m_eventConnectionName, "onPresentationPlaybackComplete");
	}
	
	// playback listener functions <
	
	// sound listener functions >
	public function onSoundVolumeChanged(soundController:ISoundController):Void
	{
		this.send(m_eventConnectionName, "onSoundVolumeChanged", soundController.getVolume());
	}
	// sound listener functions <
	
	private function sendSlideMetadata(slideIndex:Number):Void
	{
		if (initSendSlideInfo(slideIndex))
		{
			this.send(m_eventConnectionName, "onSlideMetadataLoad", slideIndex, m_sendSlidesInfo[slideIndex]);
		}
	}

	public function printString(msg:String):Void
	{
		this.send(m_eventConnectionName, "onPrintString", msg);
	}
	
	public function printObject(obj:Object):Void
	{
		this.send(m_eventConnectionName, "onPrintObject", obj);
	}
	
	public function onKeyboardFocusStateChanged(acquireFocus:Boolean):Void
	{
		this.send(m_eventConnectionName, "onKeyboardFocusStateChanged", acquireFocus);
	}
	
	function onPlaybackSuspended():Void
	{
		this.send(m_eventConnectionName, "onPlaybackSuspended");
	}
	
	function onPlaybackResumed():Void
	{
		this.send(m_eventConnectionName, "onPlaybackResumed");
	}
	
	function onHandleCloseRequest():Void
	{
	}

	public function onSlideTransitionPhaseChanged(phase:Number):Void
	{
	}
}