import fsplayer.ui.skins.ISkin;

interface fsplayer.ui.skins.ISkinListener
{
	/*
	Skin must call this method on ISkinListener interface to notify that skin initialization process has been finished
	*/
	function onSkinInit(skin:ISkin):Void;
}
