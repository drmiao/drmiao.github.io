interface slideplayer.api.ISoundController
{
	/*
	Returns sound volume in range [0..1] 
	*/
	function getVolume():Number;

	/*
	Sets sound volume. volume must be in range [0..1] 
	*/
	function setVolume(volume:Number):Void;
}
