using namespace CometEngine;

class /*@*/ AnimatorStateDebugger : CometBehaviour
{
	// Called before first frame
	void Start()
	{
	}

	// Called Every Frame
	void Update()
	{

		if (Input::GetKeyDown(KeyCode(F1)))
		{
			ActivateAttackTrigger();
		}
		if (Input::GetKeyDown(KeyCode(F2)))
		{
			ActivateHitTrigger();
		}
		if (Input::GetKeyDown(KeyCode(F3)))
		{
			ActivateDeathTrigger();
		}
	}

	void ActivateAttackTrigger()
	{
		AnimatorManagerSingleton::get.SetPlayerState("ActivateAttack");
		Debug::Log("F1 Log Key Down");
	}
	void ActivateHitTrigger()
	{
		AnimatorManagerSingleton::get.SetPlayerState("ActivateHit");
		Debug::Log("F2 Log Key Down");
	}
	void ActivateDeathTrigger()
	{
		AnimatorManagerSingleton::get.SetPlayerState("ActivateDeath");
		Debug::Log("F3 Log Key Down");
	}
}