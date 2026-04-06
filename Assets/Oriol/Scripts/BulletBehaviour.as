using namespace CometEngine;

class /*@*/ BulletBehaviour : CometObject
{
	[HideInInspector] BulletSpawner spawner;

	[Serialize] private float timeToChangeToNewState = 3.0f;

	private float startingTimeToChangeState = 0.0f;

	void Stop()
	{
		spawner.ChangeBulletBehaviour();
	}

	void OnEnabled()
	{
		startingTimeToChangeState = 0.0f;
	}

	void OnDisabled()
	{}

	void OnUpdate()
	{
		startingTimeToChangeState += Time::GetDeltaTime();
		if (startingTimeToChangeState >= timeToChangeToNewState)
		{
			Stop();
		}
	}
}