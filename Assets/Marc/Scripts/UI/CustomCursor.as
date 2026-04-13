using namespace CometEngine;

class CustomCursor : CometBehaviour
{
	RectTransform @myTransform;

	void Start()
	{
		// Hide the native OS hardware cursor
		Cursor::SetVisible(false);
		@myTransform = cast<RectTransform>(RectTransform::Get(entity));
	}

	void Update()
	{
		if (myTransform !is null)
		{
			Vector2 mousePos = Input::GetMousePosition();
			
			// Screen space to Canvas Reference scale mapping
			float canvasRefWidth = 1920.0f;
			float canvasRefHeight = 1080.0f;
			
			float screenRatioX = mousePos.x / float(Window::GetWidth());
			float screenRatioY = mousePos.y / float(Window::GetHeight());
			
			float virtualX = screenRatioX * canvasRefWidth;
			float virtualY = screenRatioY * canvasRefHeight;

			float invertedY = canvasRefHeight - virtualY;
			myTransform.position = Vector3(virtualX, invertedY, 0.0f);
		}
	}

	void OnDestroy()
	{
		// Restore mouse cursor when scene unloads or entity dies
		Cursor::SetVisible(true);
	}
}
