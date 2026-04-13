using namespace CometEngine;
using namespace CometEngine::SceneManagement;

class /*@*/ MainMenuManager : CometBehaviour
{
	[Serialize] private Entity exitButton;

	void Start()
	{
#ifdef COMET_WEB
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

	void LoadCreditsScene()
	{
		SceneManager::LoadScene(2);
	}

	void QuitGame()
	{
		App::Quit();
	}
}