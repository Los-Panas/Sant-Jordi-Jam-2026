using namespace CometEngine;
// #include "NoteData.as"

class MapData
{
    float bpm;
    float offsetMs;
    array<NoteData> notes;

    MapData()
    {
        bpm = 0.0f;
        offsetMs = 0.0f;
    }

    int GetTotalNotes()
    {
        return notes.length();
    }
}
