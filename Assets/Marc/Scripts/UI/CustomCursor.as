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
			// Map global Canvas position directly to screen space mouse coords and invert UI Y-Axis
			float invertedY = Window::GetHeight() - mousePos.y;
			myTransform.position = Vector3(mousePos.x, invertedY, 0.0f);
		}
	}

	void OnDestroy()
	{
		// Restore mouse cursor when scene unloads or entity dies
		Cursor::SetVisible(true);
	}
}
