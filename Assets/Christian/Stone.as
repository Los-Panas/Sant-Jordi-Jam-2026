using namespace CometEngine;
using namespace CometEngine::ParticleSystemModule;

class /*@*/ Stone : CometBehaviour
{
	private Collider _collider;
	private ParticleSystem _particleSystem;

	Sprite hitSprite;
	private Sprite _initialSprite;
	private SpriteRenderer _spriteRenderer;

	float duration = 3.f;
	[Tooltip("How much bigger the stone should be at the initial state")] float percentSize = 1.5f;

	int maxLife = 3;
	private int _currentLife = 0;

	private float _timer = 0.f;

	private bool _falling = true;
	bool startOnGround = false;

	private float _initialSize;

	void Awake()
	{
		_collider = Collider::Get(this.entity);
		_particleSystem = ParticleSystem::Get(this.entity);
		_spriteRenderer = SpriteRenderer::Get(this.entity);
		_initialSprite = _spriteRenderer.sprite;

		_currentLife = maxLife;
	}

	void Start()
	{
		if(startOnGround){
			_collider.enabled = false;
			_particleSystem.enabled = false;
			_initialSize = this.entity.transform.scale.x;
			_falling = false;
		}
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
			else
			{
				// Hit effect
				_spriteRenderer.sprite = hitSprite;
				Invoke("ResetSprite", 0.1f);
			}

			Object::Destroy(collision.entity);
		}
	}

	void ResetSprite()
	{
		_spriteRenderer.sprite = _initialSprite;
	}
}