using namespace CometEngine;

class HitDetector : CometBehaviour
{
    float hitWindowPerfectMs = 45.0f; 
    float hitWindowGoodMs = 120.0f;  
    
    Entity gridEntity;
    RhythmGrid@ gridHandle;
    
    void Start()
    {
        if (gridEntity !is null)
        {
            @gridHandle = cast<RhythmGrid>(RhythmGrid::Get(gridEntity));
            if (gridHandle !is null)
            {
                Debug::Log("[HitDetector] Successfully bound to RhythmGrid component.");
            }
        }
    }

    // Notice we injected ScoreManager reference in the signature
    void ProcessHover(int hoverGridX, int hoverGridY, float audioTimeMs, ScoreManager@ scoreManager)
    {
        if (gridHandle is null) return;

        for (uint i = 0; i < gridHandle.currentMap.notes.length(); i++)
        {
            NoteData note = gridHandle.currentMap.notes[i];
            
            if (note.isActive && !note.isHit && !note.isMissed)
            {
                if (note.x == hoverGridX && note.y == hoverGridY)
                {
                    float timeDiff = note.timeMs - audioTimeMs;
                    if (timeDiff < 0) timeDiff = -timeDiff;
                    
                    if (timeDiff <= hitWindowPerfectMs)
                    {
                        note.isHit = true;
                        note.isActive = false;
                        gridHandle.currentMap.notes[i] = note;
                        
                        if (scoreManager !is null) scoreManager.OnHitPerfect();
                    }
                    else if (timeDiff <= hitWindowGoodMs)
                    {
                        note.isHit = true;
                        note.isActive = false;
                        gridHandle.currentMap.notes[i] = note;
                        
                        if (scoreManager !is null) scoreManager.OnHitGood();
                    }
                }
            }
        }
    }
}
