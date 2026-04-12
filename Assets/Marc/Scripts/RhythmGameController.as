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

	float currentAudioTimeMs = 2.0f;

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
			audioSource.Play();
		}
	}

	void Update()
	{
		currentAudioTimeMs += Time::GetDeltaTime() * 1000.0f;

		if (gridHandle !is null)
		{
			gridHandle.UpdateGridState(currentAudioTimeMs);

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
			mousePos.y = Window::GetHeight() - mousePos.y; // Fix Y-Axis Cartesian Inversion

			hitHandle.ProcessHover(mousePos, currentAudioTimeMs, scoreHandle, spawnerHandle);
		}
	}
}
