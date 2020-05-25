function createMask(maskMC:MovieClip, width:Number, height:Number):Void
{
	maskMC.beginFill(0x000000);
	maskMC.moveTo(0, 0);
	maskMC.lineTo(width, 0);
	maskMC.lineTo(width, height);
	maskMC.lineTo(0, height);
	maskMC.endFill();
}