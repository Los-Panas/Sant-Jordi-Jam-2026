using namespace CometEngine;
using namespace CometEngine::ParticleSystemModule;

class /*@*/ Stone : CometBehaviour
{
	private Collider _collider;
	private ParticleSystem _particleSystem;

	float duration = 3.f;
	[Tooltip("How much bigger the stone should be at the initial state")]
	float percentSize = 1.5f;

	private float _timer = 0.f;

	private bool _falling = true;

	private float _initialSize;

	void Awake()
	{
		_collider = Collider::Get(this.entity);
		_particleSystem = ParticleSystem::Get(this.entity);
	}

	void Start()
	{
		_collider.enabled = false;
		_particleSystem.enabled = false;
		_initialSize = this.entity.transform.scale.x;
	}

	void Update()
	{
		if (!_falling)
			return;

		_timer += Time::GetDeltaTime();

		float lerpSize = Math::Lerp(_initialSize * percentSize, _initialSize, _timer / duration);
		transform.localScale = Vector3::one * lerpSize;

		if (_timer >= duration)
		{
			_falling = false;
			_collider.enabled = true;
			_particleSystem.enabled = true;
			_particleSystem.Play();
		}
	}

	void OnTriggerEnter(Collision collision)
	{
		print("AAAAAAAAAAAAAAAAAAAAAAAAAAA");
		print(collision);
		print(collision.colliderA);
		print(collision.colliderB);
		print(collision.rigidBodyA);
		print(collision.rigidBodyB);
		
		if(collision.entity.CompareTag("Bullet"))
		{
			Object::Destroy(this.entity);
			Object::Destroy(collision.entity);
		}
	}

	void OnCollisionEnter(Collision collision)
	{
		print("BBBBBBBBBBBBBBBBBBBBB" + collision.entity.name);

		if(collision.entity.CompareTag("Bullet"))
		{
			Object::Destroy(this.entity);
			Object::Destroy(collision.entity);
		}
	}
}