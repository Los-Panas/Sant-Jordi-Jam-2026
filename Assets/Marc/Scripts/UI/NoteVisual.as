using namespace CometEngine;

class NoteVisual : CometBehaviour
{
	float targetTimeMs = 0.0f;
	float approachRateMs = 1500.0f;

	Vector3 startPos;
	Vector3 targetPos;

	Transform @myTransform;
	Image @myImage; // Inspector assigned property for nested child Image

	int gridX;
	int gridY;
	bool isAlive = false;
	bool isColliderActive = false;

	// New requested features
	bool randomColor = true;
	Color baseColor;
	bool hasBeenHit = false;
	bool hasMissed = false;

	void Awake()
	{
		@myTransform = Transform::Get(entity);
		// Retain manual assignment of @myImage from the Inspector
	}

	void Initialize(int gx, int gy, float timeMs, float approach, Vector3 origin, Vector3 destination)
	{
		gridX = gx;
		gridY = gy;
		targetTimeMs = timeMs;
		approachRateMs = approach;

		targetPos = destination;

		isAlive = true;
		hasBeenHit = false;
		hasMissed = false;
		isColliderActive = false;

		if (randomColor)
		{
			int randVal = Random::RangeInt(0, 6);		   // Range 0-5
			if (randVal == 0)
				baseColor = Color(1.0f, 0.0f, 0.0f, 1.0f); // Red
			else if (randVal == 1)
				baseColor = Color(0.0f, 1.0f, 0.0f, 1.0f); // Green
			else if (randVal == 2)
				baseColor = Color(0.0f, 0.0f, 1.0f, 1.0f); // Blue
			else if (randVal == 3)
				baseColor = Color(1.0f, 1.0f, 0.0f, 1.0f); // Yellow
			else if (randVal == 4)
				baseColor = Color(1.0f, 0.0f, 1.0f, 1.0f); // Magenta
			else
				baseColor = Color(0.0f, 1.0f, 1.0f, 1.0f); // Cyan
		}
		else
		{
			baseColor = Color(1.0f, 1.0f, 1.0f, 1.0f);
		}

		// Spawn offset (Push start pos 10% away from origin towards destination)
		startPos.x = origin.x + (destination.x - origin.x) * 0.1f;
		startPos.y = origin.y + (destination.y - origin.y) * 0.1f;
		startPos.z = origin.z + (destination.z - origin.z) * 0.1f;

		if (myTransform !is null)
		{
			// Hard reset of the transformation matrix to prevent NaN bleeding
			myTransform.position = startPos;
			myTransform.eulerAngles = Vector3(0.0f, 0.0f, 0.0f);
			myTransform.localScale = Vector3(0.1f, 0.1f, 0.1f);
		}

		if (myImage !is null)
		{
			// Initial Alpha set to 0.0f, disable native raycasts
			myImage.color = Color(baseColor.r, baseColor.g, baseColor.b, 0.0f);
			myImage.mouseFilter = UI::MouseFilter::IGNORE; 
		}
	}

	void SetHit()
	{
		hasBeenHit = true;
	}

	void TickVisuals(float currentAudioTimeMs)
	{
		if (!isAlive)
			return;

		if (hasBeenHit)
		{
			// Extremely fast fade out upon successful hit (~5 frames)
			float currentAlpha = 0.0f;
			if (myImage !is null) currentAlpha = myImage.color.a - (Time::GetDeltaTime() * 15.0f);
			
			if (currentAlpha <= 0.0f)
			{
				Deactivate();
			}
			else if (myImage !is null)
			{
				myImage.color = Color(baseColor.r, baseColor.g, baseColor.b, currentAlpha);
				myImage.mouseFilter = UI::MouseFilter::IGNORE; // Keep it dead to interactions
			}
			return; // Stop matrix interpolation while dying
		}

		if (approachRateMs <= 0.0001f)
			approachRateMs = 1500.0f;

		float timeRemaining = targetTimeMs - currentAudioTimeMs;
		float progress = 1.0f - (timeRemaining / approachRateMs);

		if (progress < 0.0f)
			progress = 0.0f;
			
		// Physical Collision / UI Raycast window allowance (between 80% and 160% scale)
		bool shouldCollide = (progress >= 0.8f && progress <= 1.6f);
		if (shouldCollide != isColliderActive)
		{
		    isColliderActive = shouldCollide;
		    if (myImage !is null)
		    {
		        if (isColliderActive)
		            myImage.mouseFilter = UI::MouseFilter::STOP; // Becomes interactable/clickable
		        else
		            myImage.mouseFilter = UI::MouseFilter::IGNORE; // Ghosted through mouse events
		    }
		}

		// Maximum allowed scale: 160%. Triggers immediate miss and destruction.
		if (progress >= 1.6f)
		{
			Deactivate();
			return;
		}

		if (currentAudioTimeMs > targetTimeMs + 150.0f)
		{
			hasMissed = true;
		}

		if (myTransform !is null)
		{
			// FAKE 3D SCALING (0.1 to 1.6 limit)
			float scaleVal = 0.1f + (0.9f * progress);
			myTransform.localScale = Vector3(scaleVal, scaleVal, scaleVal);

			// POSITION MOVEMENT
			Vector3 newPos;
			newPos.x = startPos.x + (targetPos.x - startPos.x) * progress;
			newPos.y = startPos.y + (targetPos.y - startPos.y) * progress;
			newPos.z = startPos.z + (targetPos.z - startPos.z) * progress;
			myTransform.position = newPos;
		}

		if (myImage !is null)
		{
			if (!hasMissed && progress <= 1.0f)
			{
			    // Normal approach phase: alpha climbs up simulating depth
				myImage.color = Color(baseColor.r, baseColor.g, baseColor.b, progress);
			}
			else
			{
				// Smooth but swift miss fade out (between 1.0 and 1.6 scale range)
				// Alpha naturally dies from 1.0 to 0.0 spanning 0.6 scale units
				float missAlpha = 1.0f - ((progress - 1.0f) / 0.6f);
				if (missAlpha < 0.0f)
					missAlpha = 0.0f;
					
				myImage.color = Color(baseColor.r, baseColor.g, baseColor.b, missAlpha);
				myImage.mouseFilter = UI::MouseFilter::IGNORE; 
			}
		}
	}

	void Deactivate()
	{
		isAlive = false;
		isColliderActive = false;

		if (myTransform !is null)
			myTransform.localScale = Vector3(0.1f, 0.1f, 0.1f);
		if (myImage !is null)
		{
			myImage.color = Color(1.0f, 1.0f, 1.0f, 0.0f);
			myImage.mouseFilter = UI::MouseFilter::IGNORE;
		}
	}
}
