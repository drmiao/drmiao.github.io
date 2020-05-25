import fsplayer.api.ISoundController;

interface fsplayer.api.ISoundListener
{
	/*
	This method is invoked on change of sound volume
	*/
	function onSoundVolumeChanged(soundController:ISoundController):Void;
}
