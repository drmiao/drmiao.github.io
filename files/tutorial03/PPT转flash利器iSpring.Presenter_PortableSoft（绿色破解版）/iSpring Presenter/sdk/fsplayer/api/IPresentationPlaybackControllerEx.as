import quizmaker.api.IQuizApi;

interface fsplayer.api.IPresentationPlaybackControllerEx extends fsplayer.api.IPresentationPlaybackController
{
	function getActiveQuiz():IQuizApi;
}
