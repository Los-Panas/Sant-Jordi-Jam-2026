using namespace CometEngine;

class RhythmGameController : CometBehaviour
{
	string mapFilePath = "Assets/Marc/ss_archive_nelward_hi.txt";
	// DEBUG
	AudioSample audioSample;

	Entity parserEntity;
	BeatmapParser @parserHandle;

	Entity gridEntity;
	RhythmGrid @gridHandle;

	Entity hitDetectorEntity;
	HitDetector @hitHandle;

	Entity spawnerEntity;
	NoteSpawner @spawnerHandle;

	Entity scoreManagerEntity;
	ScoreManager @scoreHandle;

	Entity @audioSourceEntity;
	AudioSource @audioSource;

	float notesDelaySeconds = 0.0f;   // Visual delay before visual spawning loop starts tracking (0 means it starts now)
	float audioDelaySeconds = 2.0f;   // Absolute delay before audio blasts

	bool isAudioStarted = false;
	bool isNotesStarted = false;
	float currentAudioTimeMs = 0.0f;

	void Start()
	{
		if (parserEntity is null)
			parserEntity = entity;
		if (gridEntity is null)
			gridEntity = entity;
		if (hitDetectorEntity is null)
			hitDetectorEntity = entity;
		if (spawnerEntity is null)
			spawnerEntity = entity;
		if (scoreManagerEntity is null)
			scoreManagerEntity = entity;
		if (audioSourceEntity is null)
			audioSourceEntity = entity;

		@parserHandle = cast<BeatmapParser>(BeatmapParser::Get(parserEntity));
		@gridHandle = cast<RhythmGrid>(RhythmGrid::Get(gridEntity));
		@hitHandle = cast<HitDetector>(HitDetector::Get(hitDetectorEntity));
		@spawnerHandle = cast<NoteSpawner>(NoteSpawner::Get(spawnerEntity));
		@scoreHandle = cast<ScoreManager>(ScoreManager::Get(scoreManagerEntity));
		@audioSource = cast<AudioSource>(AudioSource::Get(audioSourceEntity));

		if (parserHandle !is null && gridHandle !is null)
		{
			if (FileSystem::Exists(mapFilePath))
			{
				string rawData = FileSystem::Load(mapFilePath);
				MapData loadedMap = parserHandle.ParseTxtMap(rawData);
				gridHandle.SetMap(loadedMap);
				Debug::Log("[RhythmGameController] Game Started. Map loaded successfully.");
			}
			else
			{
				Debug::Log("[RhythmGameController] Error: Map file not found at " + mapFilePath);
			}
		}

		if (audioSource !is null)
		{
			audioSource.audioSample = audioSample;
		}

		currentAudioTimeMs = -notesDelaySeconds * 1000.0f;
		isAudioStarted = false;
		isNotesStarted = false;
	}

	void Update()
	{
		// 1. Audio Countdown Tracker
		if (!isAudioStarted)
		{
			audioDelaySeconds -= Time::GetDeltaTime();
			if (audioDelaySeconds <= 0.0f)
			{
				isAudioStarted = true;
				if (audioSource !is null)
				{
					audioSource.Play();
				}
			}
		}

		// 2. Visual Notes & Math Sync Tracker
		if (!isNotesStarted)
		{
			notesDelaySeconds -= Time::GetDeltaTime();
			currentAudioTimeMs = -notesDelaySeconds * 1000.0f; 
			
			if (notesDelaySeconds <= 0.0f)
			{
				isNotesStarted = true;
			}
		}
		else
		{
			currentAudioTimeMs += Time::GetDeltaTime() * 1000.0f;
		}

		if (gridHandle !is null)
		{
			gridHandle.UpdateGridState(currentAudioTimeMs, scoreHandle);

			// Check for new Spawns
			if (spawnerHandle !is null)
			{
				for (uint i = 0; i < gridHandle.currentMap.notes.length(); i++)
				{
					NoteData note = gridHandle.currentMap.notes[i];
					if (note.isActive && !note.hasVisual && !note.isHit && !note.isMissed)
					{
						// Safety Guard: Only spawn visual if the music is within the approach distance
						if ((note.timeMs - currentAudioTimeMs) <= gridHandle.approachTimeMs)
						{
							spawnerHandle.SpawnNoteFromLogic(note.x, note.y, note.timeMs, gridHandle.approachTimeMs);

							note.hasVisual = true;
							gridHandle.currentMap.notes[i] = note; // Save back modified struct
						}
					}
				}

				spawnerHandle.TickAllVisuals(currentAudioTimeMs);
			}
		}

		// Logic of mouse hover interaction (pure mathematical screen distance approach)
		if (hitHandle !is null && spawnerHandle !is null)
		{
			Vector2 mousePos = Input::GetMousePosition();
			
			// Correccion Ratio Resolucion Pantalla vs ScreenSpace Canvas (Referencia Estandar HD)
			float canvasRefWidth = 1920.0f;
			float canvasRefHeight = 1080.0f;
			
			float screenRatioX = mousePos.x / float(Window::GetWidth());
			float screenRatioY = mousePos.y / float(Window::GetHeight());
			
			float virtualX = screenRatioX * canvasRefWidth;
			float virtualY = screenRatioY * canvasRefHeight;
			
			virtualY = canvasRefHeight - virtualY; // Fix Y-Axis Cartesian Inversion
			
			mousePos.x = virtualX;
			mousePos.y = virtualY;

			hitHandle.ProcessHover(mousePos, currentAudioTimeMs, scoreHandle, spawnerHandle);
		}
	}
}
