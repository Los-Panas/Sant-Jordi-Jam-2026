using namespace CometEngine;

[AssetMenu("RandomBulletBehaviour", "Bullet Behaviours/Random Bullet")] class /*@*/ RandomBulletBehaviour : BulletBehaviour
{
	[Serialize] private Entity bullet;
	[Serialize] private float fireRate = 0.5f;
	[Serialize] private float amountOfBulletsPerShot = 2.0f;

	private float timeSinceLastShot = 0.0f;

	void OnEnabled()
	{
		BulletBehaviour::OnEnabled();

		timeSinceLastShot = fireRate;
	}

	void OnUpdate()
	{
		timeSinceLastShot += Time::GetDeltaTime();
		if (timeSinceLastShot >= fireRate)
		{
			timeSinceLastShot = 0.0f;

			for (int i = 0; i < amountOfBulletsPerShot; i++)
			{
				float randomZ = Random::RangeFloat(0.0f, 360.0f);
				Quaternion randomRotation;
				randomRotation.SetFromEulerAngles(Vector3(0.0f, 0.0f, randomZ));

				Entity::Instantiate(bullet, spawner.transform.position, randomRotation);
			}
		}

		BulletBehaviour::OnUpdate();
	}
}