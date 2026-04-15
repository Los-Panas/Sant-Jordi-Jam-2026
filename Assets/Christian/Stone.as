using namespace CometEngine;

class /*@*/ Stone : CometBehaviour
{
	private Collider _collider;
	// private ParticleSystemModule::ParticleSystem _particleSystem;

	float duration = 3.f;
	float percentSize = 1.5f; // How much bigger the stone should be at the initial state

	private float _timer = 0.f;

	private bool _falling = true;

	private float _initialSize;

	void Awake()
	{
		_collider = Collider::Get(this.entity);
		//_particleSystem = ParticleSystemModule::ParticleSystem::Get(this.entity);
	}

	void Start()
	{
		_collider.enabled = false;
		// _particleSystem.enabled = false;
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
			// _particleSystem.enabled = true;
			// _particleSystem.Play();
		}
	}
}