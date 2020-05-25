interface fsplayer.api.IPlaybackListenerEx 
{ 
  // this method is invoked when quiz on a slide has been activated 
  function onQuizActivated():Void; 

  // this method is invoked before quiz on a slide has been deactivated 
  function onQuizDeactivated():Void;
  
}
