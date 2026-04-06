using namespace CometEngine;

class /*@*/ BulletSpawner : CometBehaviour
{
	[Serialize] private array<BulletBehaviour> bulletBehaviours;

	private BulletBehaviour currentBehaviour;

	void Start()
	{
		array<BulletBehaviour> validBehaviours;
		for (uint i = 0; i < bulletBehaviours.length(); i++)
		{
			if (bulletBehaviours[i] != null)
			{
				bulletBehaviours[i].spawner = this;
				validBehaviours.insertLast(bulletBehaviours[i]);
			}
		}
		bulletBehaviours = validBehaviours;

		ChangeBulletBehaviour();
	}

	void Update()
	{
		if (currentBehaviour != null)
		{
			currentBehaviour.OnUpdate();
		}
	}

	void ChangeBulletBehaviour()
	{
		BulletBehaviour previousBehaviour = currentBehaviour;
		if (currentBehaviour != null)
		{
			currentBehaviour.OnDisabled();
		}

		if (previousBehaviour != null && bulletBehaviours.length() > 1)
		{
			while (currentBehaviour == previousBehaviour)
			{
				currentBehaviour = bulletBehaviours[Random::RangeInt(0, bulletBehaviours.length() - 1)];
			}
		}
		else
		{
			currentBehaviour = bulletBehaviours[Random::RangeInt(0, bulletBehaviours.length() - 1)];
		}

		if (currentBehaviour != null)
		{
			currentBehaviour.OnEnabled();
		}
	}
}