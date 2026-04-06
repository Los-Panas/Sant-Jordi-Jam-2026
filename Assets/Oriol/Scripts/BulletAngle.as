using namespace CometEngine;

[AssetMenu("BulletAngle", "Bullet Behaviours/Bullet Angle")] class /*@*/ BulletAngle : BulletBehaviour
{
	[Serialize] private Entity bullet;
	[Serialize] private float angleRange = 360.0F;
	[Serialize] private float fireRate = 0.5f;
	[Serialize] private float degreesPerBullet = 18.0f;

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

			int bulletCount = (angleRange / degreesPerBullet);
			if (bulletCount < 1)
			{
				bulletCount = 1;
			}

			float startAngle = Random::RangeFloat(0.0f, 360.0f);

			float step = degreesPerBullet;

			for (int i = 0; i < bulletCount; i++)
			{
				float currentAngle = startAngle + (step * i);

				Quaternion rotation;
				rotation.SetFromEulerAngles(Vector3(0.0f, 0.0f, currentAngle));

				Object::Instantiate(bullet, spawner.transform.position, rotation);
			}
		}

		BulletBehaviour::OnUpdate();
	}
}