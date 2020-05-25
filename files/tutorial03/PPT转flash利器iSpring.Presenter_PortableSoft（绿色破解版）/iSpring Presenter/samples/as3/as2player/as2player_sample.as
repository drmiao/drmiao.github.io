if (flash.system.Capabilities.playerType == "External")
{
	trace("This example will work in browser plugin, ActiveX or Standalone Flash player only");
	return;
}
else
{	
	var bridgeSample:AS2PlayerSample = new AS2PlayerSample(this);
}
