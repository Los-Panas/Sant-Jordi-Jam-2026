using namespace CometEngine;

class ScoreManager : CometBehaviour
{
	[Serialize] float timePerPerfect = 1.0f;
	[Serialize] float timePerGood = 0.5f;

	int currentScore = 0;
	int currentCombo = 0;
	int maxCombo = 0;

	int lastTimeLeft100 = -1;

	int MULTIPLIER = 10;

	Text @scoreText; // Inspector assigned reference for UI text

	void Start()
	{
		ResetScore();
	}

	void OnHitPerfect()
	{
		currentCombo++;
		if (currentCombo > 0 && currentCombo % 5 == 0) {
			AnimatorManagerSingleton::get.SetPlayerState("ActivateAttack");
		}
		
		if (currentCombo > maxCombo)
			maxCombo = currentCombo;

		// Reward more points based on combo
		int gainedPoints = 100 + (currentCombo * MULTIPLIER);
		currentScore += gainedPoints;

		PlayerMovmentSingleton::get.AddMoveTime(timePerPerfect);

		UpdateUI();
	}

	void OnHitGood()
	{
		currentCombo++;
		if (currentCombo > 0 && currentCombo % 5 == 0) {
			AnimatorManagerSingleton::get.SetPlayerState("ActivateAttack");
		}
		
		if (currentCombo > maxCombo)
			maxCombo = currentCombo;

		int gainedPoints = 50 + (currentCombo * MULTIPLIER / 2);
		currentScore += gainedPoints;

		PlayerMovmentSingleton::get.AddMoveTime(timePerGood);

		UpdateUI();
	}

	void OnMiss()
	{
		currentCombo = 0; // Break combo

		UpdateUI();
		AnimatorManagerSingleton::get.SetPlayerState("ActivateHit");
		Debug::Log("[ScoreManager] MISSED Note... Combo Broken!");
	}

	void ResetScore()
	{
		currentScore = 0;
		currentCombo = 0;
		maxCombo = 0;
		UpdateUI();
	}

	void UpdateUI()
	{
		if (scoreText !is null)
		{
			float timeLeft = PlayerMovmentSingleton::get.GetMoveTime();
			int timeLeft100 = int(timeLeft * 100.0f);

			if (timeLeft100 != lastTimeLeft100) {
				lastTimeLeft100 = timeLeft100;
				
				int whole = timeLeft100 / 100;
				int decimal = timeLeft100 % 100;
				
				string decStr = "" + decimal;
				if (decimal < 10) decStr = "0" + decimal;
				
				scoreText.text = whole + "." + decStr + "s";
			}
		}
	}

	void Update()
	{
		UpdateUI();
	}
}
