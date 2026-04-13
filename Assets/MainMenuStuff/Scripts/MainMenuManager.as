using namespace CometEngine;
using namespace CometEngine::SceneManagement;

class /*@*/ MainMenuManager : CometBehaviour
{
	[Serialize] private Entity exitButton;

	void Start()
	{
#ifndef COMET_WEB
		if (exitButton !is null)
		{
			exitButton.enabled = false;
		}
#endif
	}

	void LoadGameScene()
	{
		SceneManager::LoadScene(1);
	}

	void QuitGame()
	{
		App::Quit();
	}
}