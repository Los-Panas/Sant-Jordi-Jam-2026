using namespace CometEngine;


//Superalo Christian
class /*@*/ ChristianTest : CometBehaviour
{
	AudioSample[] sample;

	private AudioSource source;

	float bpm = 180.f;
	private float timer = 0.f;
	private int noteIndex = 0;

	private int[] melody = {
		//1,4,5,7,9,10,12
		1,1,5,4,-1,0,0,1,1,5,4,0
	};

	// Called before first frame
	void Start()
	{
		source = AudioSource::Get(entity);
	}

	// Called Every Frame
	void Update()
	{
		if (Input::GetKeyDown(KeyCode::SPACE))
		{
			noteIndex = 0;
			timer = 0.f;
		}

		if (sample.length() == 0 || noteIndex >= melody.length())
			return;

		timer += Time::GetDeltaTime();

		if (timer >= 60.f / bpm)
		{
			if(melody[noteIndex] == -1)
			{
				noteIndex = (noteIndex + 1);
				timer = 0.f;
				return;
			}
			source.audioSample = sample[melody[noteIndex]];
			source.Play();
			noteIndex = (noteIndex + 1);
			timer = 0.f;
		}
	}
}