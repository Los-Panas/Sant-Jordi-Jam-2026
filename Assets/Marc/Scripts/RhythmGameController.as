using namespace CometEngine;

class RhythmGameController : CometBehaviour
{
	string mapFilePath = "Assets/Marc/ss_archive_toby_fox_-_megalovania__sim_gretina_remix_.txt";

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

		@parserHandle = cast<BeatmapParser>(BeatmapParser::Get(parserEntity));
		@gridHandle = cast<RhythmGrid>(RhythmGrid::Get(gridEntity));
		@hitHandle = cast<HitDetector>(HitDetector::Get(hitDetectorEntity));
		@spawnerHandle = cast<NoteSpawner>(NoteSpawner::Get(spawnerEntity));
		@scoreHandle = cast<ScoreManager>(ScoreManager::Get(scoreManagerEntity));

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
						spawnerHandle.SpawnNoteFromLogic(note.x, note.y, note.timeMs, gridHandle.approachTimeMs);

						note.hasVisual = true;
						gridHandle.currentMap.notes[i] = note; // Save back modified struct
					}
				}

				spawnerHandle.TickAllVisuals(currentAudioTimeMs);
			}
		}

		// Logic of mouse hover interaction within the general manager
		if (Input::GetMouseButtonDown(MouseCode::LEFT))
		{
			// Placeholder interaction simulating collision
			// since we don't have screen space 2D projections built into our code yet.
			// When real mouse positional hover logic is injected here,
			// you will map Input::GetMousePosition() against the GridManager's UI transforms.
			if (hitHandle !is null)
			{
				// This triggers 'Hover' mathematically for standard testing
				hitHandle.ProcessHover(1, 1, currentAudioTimeMs, scoreHandle);
			}
		}
	}
}
