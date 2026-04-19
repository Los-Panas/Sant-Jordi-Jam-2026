using namespace CometEngine;
using namespace CometEngine::ParticleSystemModule;

class /*@*/ Stone : CometBehaviour
{
	private Collider _collider;
	private ParticleSystem _particleSystem;

	float duration = 3.f;
	[Tooltip("How much bigger the stone should be at the initial state")] float percentSize = 1.5f;

	int maxLife = 3;
	private int _currentLife = 0;

	private float _timer = 0.f;

	private bool _falling = true;

	private float _initialSize;

	void Awake()
	{
		_collider = Collider::Get(this.entity);
		_particleSystem = ParticleSystem::Get(this.entity);

		_currentLife = maxLife;
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

	void OnTriggerEnter(Collider collision)
	{
		if (collision.entity.CompareTag("Bullet"))
		{
			if (--_currentLife <= 0)
			{
				Object::Destroy(this.entity);
				// TODO: Destruction effect
			}

			// TODO: Hit effect
			Object::Destroy(collision.entity);
		}
	}
}