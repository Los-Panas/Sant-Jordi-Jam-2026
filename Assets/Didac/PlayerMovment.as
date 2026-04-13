using namespace CometEngine;

enum ePlayerDir
{
	IdleTop = 0,
	MoveTop = 1,
	IdleLeft = 2,
	MoveLeft = 3,
	IdleDown = 4,
	MoveDown = 5,
	IdleRight = 6,
	MoveRight = 7
}

class /*@*/ PlayerMovment : CometBehaviour
{
	[Serialize] private float speed = 300.0f;
	[Serialize] private Entity harp;

	private Animator mAnim;
	private RigidBody mRigidBody;

	private ePlayerDir mCurrentDir = ePlayerDir::IdleTop;
	private bool isMoving = false;

	private bool hasHarp = true;
	[Serialize] private float spawnHarpMinDist = 4.0f;
	[Serialize] private Entity deathMenu;
	[Serialize] private float immortalTimeAfterHitSeconds = 0.8F;
	private bool isImmortal = false;
	private float immortalStartTime = 0.0f;

	// Called before first frame
	void Start()
	{
		deathMenu.enabled = false;

		mAnim = Animator::Get(entity);
		mRigidBody = RigidBody::Get(entity);
	}

	// Called Every Frame
	void FixedUpdate()
	{
		if (isImmortal)
		{
			float timeSinceHit = Time::GetGameTime() - immortalStartTime;
			if (timeSinceHit >= immortalTimeAfterHitSeconds)
			{
				isImmortal = false;
			}
		}

		Vector2 newPos = Vector2::zero;

		ePlayerDir LastDir = mCurrentDir;

		if (Input::GetKeyPressed(KeyCode::W))
		{
			newPos += Vector2::up;
			mCurrentDir = ePlayerDir::MoveTop;
		}
		else if (Input::GetKeyUp(KeyCode::W))
		{
			mCurrentDir = ePlayerDir::IdleTop;
		}

		if (Input::GetKeyPressed(KeyCode::S))
		{
			newPos += Vector2::down;
			mCurrentDir = ePlayerDir::MoveDown;
		}
		else if (Input::GetKeyUp(KeyCode::S))
		{
			mCurrentDir = ePlayerDir::IdleDown;
		}

		if (Input::GetKeyPressed(KeyCode::A))
		{
			newPos += Vector2::left;
			mCurrentDir = ePlayerDir::MoveLeft;
		}
		else if (Input::GetKeyUp(KeyCode::A))
		{
			mCurrentDir = ePlayerDir::IdleLeft;
		}

		if (Input::GetKeyPressed(KeyCode::D))
		{
			newPos += Vector2::right;
			mCurrentDir = ePlayerDir::MoveRight;
		}
		else if (Input::GetKeyUp(KeyCode::D))
		{
			mCurrentDir = ePlayerDir::IdleRight;
		}

		if (LastDir != mCurrentDir)
		{
			mAnim.SetInt("state", mCurrentDir);
		}

		mRigidBody.velocity = newPos * speed;
	}

	void DropHarp()
	{
		hasHarp = false;
		Camera @cam = Camera::GetAllCameras()[0];

		Vector3 camPos = cam.entity.transform.position;
		Vector2 size = cam.worldSize;

		float halfWidth = size.x / 2.0f;
		float halfHeight = size.y / 2.0f;

		float minX = camPos.x - halfWidth;
		float maxX = camPos.x + halfWidth;
		float minY = camPos.y - halfHeight;
		float maxY = camPos.y + halfHeight;

		Vector3 spawnPos;
		bool positionValid = false;

		for (int i = 0; i < 10; i++)
		{
			spawnPos.x = Random::RangeFloat(minX + (halfWidth * 0.1f), maxX - (halfWidth * 0.1f));
			spawnPos.y = Random::RangeFloat(minY + (halfHeight * 0.1f), maxY - (halfHeight * 0.1f));
			spawnPos.z = 0.0f;

			float dist = (spawnPos - this.entity.transform.position).Length();

			if (dist > spawnHarpMinDist)
			{
				positionValid = true;
				break;
			}
		}

		Entity::Instantiate(harp, spawnPos, Quaternion::identity);
	}

	void Die()
	{
		Time::SetTimeScale(0.0f);
		deathMenu.enabled = true;
	}

	void OnTriggerEnter(Collider collider)
	{
		if (collider.tag == "Bullet")
		{
			Object::Destroy(collider.entity);
			if (!isImmortal)
			{
				if (hasHarp)
				{
					immortalStartTime = Time::GetGameTime();
					isImmortal = true;

					DropHarp();
				}
				else
				{
					Die();
				}
			}
		}
		else if (collider.tag == "Harp")
		{
			hasHarp = true;
			Object::Destroy(collider.entity);
		}
		print("Collided with " + collider.tag);
	}
}