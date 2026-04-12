using namespace CometEngine;

class ScoreManager : CometBehaviour
{
	int currentScore = 0;
	int currentCombo = 0;
	int maxCombo = 0;

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
			scoreText.text = "" + currentScore;
		}
	}
}
