using namespace CometEngine;
using namespace CometEngine::UI;

class /*@*/ TimelineButton : CometBehaviour
{
	Image imageUp;
	Image imageDown;

	void OnImageUpPressed()
	{
		imageUp.enabled = !imageUp.enabled;
		imageDown.enabled = false;
	}

	void OnImageDownPressed()
	{
		imageDown.enabled = !imageDown.enabled;
		imageUp.enabled = false;
	}
}