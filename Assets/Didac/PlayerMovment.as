using namespace CometEngine;

enum ePlayerDir
{
	IdleTop,   // 0
	MoveTop,   // 1
	IdleLeft,  // 2
	MoveLeft,  // 3
	IdleDown,  // 4
	MoveDown,  // 5
	IdleRight, // 6
	MoveRight  // 7
}

class /*@*/ PlayerMovment : CometBehaviour
{
	[Serialize] private float speed = 300.0f;

	private Animator mAnim;
	private RigidBody mRigidBody;

	private ePlayerDir mCurrentDir = ePlayerDir::IdleTop;
	private bool isMoving = false;

	// Called before first frame
	void Start()
	{
		mAnim = Animator::Get(entity);
		mRigidBody = RigidBody::Get(entity);
	}

	// Called Every Frame
	void PreUpdate()
	{
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
}