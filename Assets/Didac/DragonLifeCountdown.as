using namespace CometEngine;
using namespace UI;

class /*@*/ DragonLifeCountdown : CometBehaviour
{
	private float _timer = 0.0f;
	float maxTime = 2.0f;

	ImageRect life;

	Entity winMenu;

	void Start(){
		winMenu.enabled = false;
		Time::SetTimeScale(1.0f);
	}


	void Update()
	{
		_timer += Time::GetDeltaTime();

		print(_timer);

		Vector3 size = life.transform.localScale;
		size.x = 1.0f - Math::Lerp(0.0f, maxTime, _timer/maxTime) / maxTime;
		life.transform.localScale = size;

		if(_timer >= maxTime)
		{
			winMenu.enabled = true;
			Time::SetTimeScale(0.0f);
		}

	}
}