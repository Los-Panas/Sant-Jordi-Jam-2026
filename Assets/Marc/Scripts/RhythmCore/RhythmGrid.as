using namespace CometEngine;
// #include "../Structs/MapData.as"

class RhythmGrid : CometBehaviour
{
    MapData currentMap;
    float approachTimeMs = 1500.0f; 

    void SetMap(MapData map)
    {
        currentMap = map;
        Debug::Log("[RhythmGrid] Map assigned. Total notes: " + currentMap.GetTotalNotes());
    }

    void UpdateGridState(float audioTimeMs)
    {
        for (uint i = 0; i < currentMap.notes.length(); i++)
        {
            NoteData note = currentMap.notes[i];
            
            if (audioTimeMs > note.timeMs + 150.0f && !note.isHit && !note.isMissed)
            {
                note.isMissed = true;
                note.isActive = false;
                
                currentMap.notes[i] = note; 
                continue;
            }
            
            if (audioTimeMs >= (note.timeMs - approachTimeMs) && audioTimeMs <= note.timeMs && !note.isActive && !note.isHit && !note.isMissed)
            {
                note.isActive = true;
                
                currentMap.notes[i] = note;
            }
        }
    }
}
