using namespace CometEngine;

class NoteData
{
    int x; 
    int y; 
    float timeMs; 
    
    bool isActive; 
    bool hasVisual; // Indicates if the visual object was already created for it
    bool isHit;    
    bool isMissed; 

    NoteData()
    {
        x = 0;
        y = 0;
        timeMs = 0.0f;
        isActive = false;
        hasVisual = false;
        isHit = false;
        isMissed = false;
    }

    NoteData(int inX, int inY, float inTimeMs)
    {
        x = inX;
        y = inY;
        timeMs = inTimeMs;
        isActive = false;
        hasVisual = false;
        isHit = false;
        isMissed = false;
    }
}
