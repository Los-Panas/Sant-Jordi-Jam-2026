using namespace CometEngine;

class /*@*/ DeadMenuManager : CometBehaviour
{
	void LoadMainMenu()
	{
		Time::SetTimeScale(1.0f);
		SceneManager::LoadScene(0);
	}
}