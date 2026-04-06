using namespace CometEngine;

class /*@*/ BulletSpawner : CometBehaviour
{
	[Serialize] private Entity smallBullet;

	void Update()
	{
		if (Input::GetKeyDown(KeyCode::SPACE))
		{
			float randomZ = Random::RangeFloat(0.0f, 360.0f);
			Quaternion randomRotation;
			randomRotation.SetFromEulerAngles(Vector3(0.0f, 0.0f, randomZ));

			Object::Instantiate(smallBullet, transform.position, randomRotation);
		}
	}
}