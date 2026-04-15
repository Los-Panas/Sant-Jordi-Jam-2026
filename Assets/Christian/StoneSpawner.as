using namespace CometEngine;

class /*@*/ StoneSpawner : CometBehaviour
{
	Entity stonePrefab;

	private float timer = 0.f;
	private float spawnTime = 1.5f;

	Vector2 spawnTimeRange = Vector2(5.f, 5.f);
	// Min/Max radius from center to spawn
	Vector2 spawnPositionRange = Vector2(2.5f, 5.5f);

	void Start()
	{
		RandomizeSpawnTime();
	}

	void Update()
	{
		timer += Time::GetDeltaTime();

		if (timer >= spawnTime)
		{
			timer = 0.f;
			RandomizeSpawnTime();
			SpawnStone();
		}
	}

	void SpawnStone()
	{
		Entity newStone = Entity::Instantiate(stonePrefab, GetRandomPosition(), Quaternion::identity, this.entity, Space::World);
	}

	Vector2 GetRandomPosition()
	{
		float angle = Random::RangeFloat(0.f, 360.f);
		float radius = Random::RangeFloat(spawnPositionRange.x, spawnPositionRange.y);

		float x = radius * Math::Cos(angle);
		float z = radius * Math::Sin(angle);

		return Vector2(x, z);
	}

	void RandomizeSpawnTime()
	{
		spawnTime = Random::RangeFloat(spawnTimeRange.x, spawnTimeRange.y);
	}
}