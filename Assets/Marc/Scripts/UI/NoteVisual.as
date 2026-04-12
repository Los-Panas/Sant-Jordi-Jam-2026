using namespace CometEngine;

class NoteVisual : CometBehaviour
{
	float targetTimeMs = 0.0f;
	float approachRateMs = 1500.0f;

	Vector3 startPos;
	Vector3 targetPos;

	Transform @myTransform;
	Image @myImage;

	int gridX;
	int gridY;
	bool isAlive = false;
	bool isColliderActive = false;

	void Awake()
	{
		@myTransform = Transform::Get(entity);
		@myImage = UI::Image::Get(entity);
	}

	void Initialize(int gx, int gy, float timeMs, float approach, Vector3 origin, Vector3 destination)
	{
		gridX = gx;
		gridY = gy;
		targetTimeMs = timeMs;
		approachRateMs = approach;
		startPos = origin;
		targetPos = destination;

		isAlive = true;
		isColliderActive = false;

		if (myTransform !is null)
		{
			// Hard reset of the transformation matrix to prevent NaN bleeding
			myTransform.position = startPos;
			myTransform.eulerAngles = Vector3(0.0f, 0.0f, 0.0f);
			myTransform.localScale = Vector3(0.1f, 0.1f, 0.1f);
			
			// If it's a UI element, force reset its anchored position too
			RectTransform@ rect = cast<RectTransform>(myTransform);
			if (rect !is null)
			{
			    rect.anchoredPosition = Vector2(startPos.x, startPos.y);
			}
		}

		if (myImage !is null)
		{
			// Initial Alpha set to 0.0f
			myImage.color = Color(1.0f, 1.0f, 1.0f, 0.0f);
		}
	}

	void TickVisuals(float currentAudioTimeMs)
	{
		if (!isAlive)
			return;

		// Failsafe por si el Inspector serializó la variable en 0
		if (approachRateMs <= 0.0001f)
			approachRateMs = 1500.0f;

		float timeRemaining = targetTimeMs - currentAudioTimeMs;
		float progress = 1.0f - (timeRemaining / approachRateMs);

		if (progress < 0.0f)
			progress = 0.0f;
		if (progress > 1.0f)
			progress = 1.0f;

		if (myTransform !is null)
		{
			// FAKE 3D SCALING (0.1 a 1.0)
			float scaleVal = 0.1f + (0.9f * progress);
			myTransform.localScale = Vector3(scaleVal, scaleVal, scaleVal);

			// POSITION MOVEMENT
			Vector3 newPos;
			newPos.x = startPos.x + (targetPos.x - startPos.x) * progress;
			newPos.y = startPos.y + (targetPos.y - startPos.y) * progress;
			newPos.z = 0.0f;

			
			RectTransform@ rect = cast<RectTransform>(myTransform);
			if (rect !is null)
			{
			    rect.anchoredPosition = Vector2(newPos.x, newPos.y);
			}
		}

		if (myImage !is null)
		{
			// FAKE 3D FADING ALPHA (Smooth fade in during approach)
			myImage.color = Color(1.0f, 1.0f, 1.0f, progress);
		}

		// Activates physics/buttons near the end for precision mouse hovering
		if (timeRemaining <= 200.0f && !isColliderActive)
		{
			isColliderActive = true;
			// TODO: If you add physical colliders, enable them here
			Debug::Log("[NoteVisual] Collider threshold reached for: " + gridX + ", " + gridY);
		}

		if (currentAudioTimeMs > targetTimeMs + 150.0f)
		{
			Deactivate();
		}
	}

	void Deactivate()
	{
		isAlive = false;
		isColliderActive = false;

		if (myTransform !is null)
			myTransform.localScale = Vector3(0.1f, 0.1f, 0.1f);
		if (myImage !is null)
			myImage.color = Color(1.0f, 1.0f, 1.0f, 0.0f);
	}
}
