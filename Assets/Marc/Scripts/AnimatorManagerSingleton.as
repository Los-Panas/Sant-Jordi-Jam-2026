using namespace CometEngine;

class /*@*/ AnimatorManagerSingleton : CometBehaviour
{

	Entity player;
	Animator playerAnimator;

	// Called before first frame
	void Awake()
	{
		AnimatorManagerSingleton::get = this;
	}

	void Start()
	{
		if (player !is null)
		{
			playerAnimator = Animator::Get(player);
			Debug::Log("[SetPlayerState] Player Animator Initialized Correctly ");
		}
	}

	void SetPlayerState(const string&in stateName)
	{
		if (playerAnimator !is null)
		{
			playerAnimator.SetTrigger(stateName);
			Debug::Log("[SetPlayerState] SetTrigger: " + stateName);
		}
	}

}

namespace AnimatorManagerSingleton
{
	AnimatorManagerSingleton get;
}