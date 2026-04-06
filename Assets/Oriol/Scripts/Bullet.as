using namespace CometEngine;

class /*@*/ Bullet : CometBehaviour
{
	[Serialize] private float speed = 5.0f;
	[Serialize] private float lifetime = 5.0f;

	private float timeAlive = 0.0f;

	void Update()
	{
		transform.position += transform.right * speed * Time::GetDeltaTime();

		timeAlive += Time::GetDeltaTime();
		if (timeAlive >= lifetime)
		{
			Object::Destroy(entity);
		}
	}

	void OnBecameInvisible()
	{
		Object::Destroy(entity);
	}
}