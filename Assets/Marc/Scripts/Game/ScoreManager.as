using namespace CometEngine;

class ScoreManager : CometBehaviour
{
	int currentScore = 0;
	int currentCombo = 0;
	int maxCombo = 0;

	int MULTIPLIER = 10;

	// We would need references to UI::Text to update visual text, e.g.:
	// UI::Text@ comboTextHandle;

	void Start()
	{
		ResetScore();
	}

	void OnHitPerfect()
	{
		currentCombo++;
		if (currentCombo > maxCombo)
			maxCombo = currentCombo;

		// Reward more points based on combo
		int gainedPoints = 100 + (currentCombo * MULTIPLIER);
		currentScore += gainedPoints;

		UpdateUI();
		Debug::Log("[ScoreManager] PERFECT Hit! Combo: " + currentCombo + " | Score: " + currentScore);
	}

	void OnHitGood()
	{
		currentCombo++;
		if (currentCombo > maxCombo)
			maxCombo = currentCombo;

		int gainedPoints = 50 + (currentCombo * MULTIPLIER / 2);
		currentScore += gainedPoints;

		UpdateUI();
		Debug::Log("[ScoreManager] GOOD Hit! Combo: " + currentCombo + " | Score: " + currentScore);
	}

	void OnMiss()
	{
		currentCombo = 0; // Break combo

		UpdateUI();
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
		// TODO: Map to actual Comet UI text components.
		// Example logic:
		// if (comboTextHandle !is null) comboTextHandle.text = "Combo: " + currentCombo;
	}
}
