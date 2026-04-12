using namespace CometEngine;

class NoteSpawner : CometBehaviour
{
	Entity templateNotePrefab;
	Entity parentCanvas;

	array<Entity @> notePool;
	int POOL_SIZE = 40;

	Entity rhythmGridEntity;
	RhythmGrid @gridHandle;

	Entity gridManagerEntity;
	GridManager @gridManagerHandle;

	void Start()
	{
		if (templateNotePrefab is null)
		{
			Debug::Log("[NoteSpawner] Error: Template Note Prefab is not assigned.");
			return;
		}

		for (int i = 0; i < POOL_SIZE; i++)
		{
			Entity @noteInstance = Object::Instantiate(templateNotePrefab, parentCanvas);
			if (noteInstance !is null)
			{
				NoteVisual @nv = cast<NoteVisual>(NoteVisual::Get(noteInstance));
				if (nv !is null)
				{
					nv.Deactivate(); // Explicitly hide newly pooled object visually
				}
				notePool.insertLast(noteInstance);
			}
		}

		Debug::Log("[NoteSpawner] Pool loaded and set to transparent hidden state.");

		if (rhythmGridEntity !is null)
			@gridHandle = RhythmGrid::Get(rhythmGridEntity);
		else
			Debug::LogWarning("[NoteSpawner] rhythmGridEntity is null.");

		if (gridManagerEntity !is null)
		{
			@gridManagerHandle = GridManager::Get(gridManagerEntity);
			if (gridManagerHandle is null)
			{
				Debug::LogWarning("[NoteSpawner] CRITICAL: Assigned Entity exists, but does NOT have GridManager.as attached! Check inspector.");
			}
		}
		else
		{
			Debug::LogWarning("[NoteSpawner] gridManagerEntity is null in the Inspector. Assign the entity first.");
		}
	}

	void SpawnNoteFromLogic(int x, int y, float timeMs, float approachMs)
	{
		Entity @visualEntity = GetAvailableNoteFromPool();
		if (visualEntity is null)
			return;

		NoteVisual @visualComponent = NoteVisual::Get(visualEntity);
		if (visualComponent !is null)
		{
			if (gridManagerHandle is null)
				Debug::LogWarning("[NoteSpawner] gridManagerHandle is null.");

			Vector3 originPos = gridManagerHandle.GetOriginPosition();
			Vector3 targetPos = gridManagerHandle.GetAnchorPosition(x, y);

			visualComponent.Initialize(x, y, timeMs, approachMs, originPos, targetPos);
		}
	}

	void TickAllVisuals(float currentAudioTimeMs)
	{
		for (uint i = 0; i < notePool.length(); i++)
		{
			Entity @e = notePool[i];
			if (e !is null)
			{
				NoteVisual @nv = NoteVisual::Get(e);
				if (nv !is null && nv.isAlive)
				{
					nv.TickVisuals(currentAudioTimeMs);
				}
			}
		}
	}

	Entity @GetAvailableNoteFromPool()
	{
		for (uint i = 0; i < notePool.length(); i++)
		{
			Entity @e = notePool[i];
			NoteVisual @nv = NoteVisual::Get(e);
			if (nv !is null && !nv.isAlive)
			{
				return e;
			}
		}
		return null;
	}

	void NotifyHit(int x, int y, float timeMs)
	{
		for (uint i = 0; i < notePool.length(); i++)
		{
			Entity @e = notePool[i];
			if (e !is null)
			{
				NoteVisual @nv = NoteVisual::Get(e);
				// Uniquely track and pop the visual Note by its signature
				if (nv !is null && nv.isAlive && nv.gridX == x && nv.gridY == y && nv.targetTimeMs == timeMs)
				{
					nv.SetHit();
					return;
				}
			}
		}
	}
}
