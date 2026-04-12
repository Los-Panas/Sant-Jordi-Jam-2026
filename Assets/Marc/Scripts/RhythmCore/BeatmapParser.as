using namespace CometEngine;
// #include "../Structs/NoteData.as"
// #include "../Structs/MapData.as"

class BeatmapParser : CometBehaviour
{
    MapData ParseTxtMap(const string& in rawData)
    {
        MapData map;
        
        array<string>@ stringTokens = rawData.split(",");
        
        if (stringTokens is null || stringTokens.length() == 0)
        {
            Debug::Log("[BeatmapParser] Error: Txt map is empty or invalid. Aborting map load.");
            return map;
        }

        for (uint i = 1; i < stringTokens.length(); i++)
        {
            string token = stringTokens[i];
            
            if (token == "" || token == " ") continue;
            
            array<string>@ noteTokens = token.split("|");
            
            if (noteTokens !is null && noteTokens.length() == 3)
            {
                int rawX = int(parseInt(noteTokens[0]));
                int rawY = int(parseInt(noteTokens[1]));
                float timeMs = float(parseFloat(noteTokens[2]));
                
                int finalX = 2 - rawX;
                int finalY = 2 - rawY;
                
                NoteData newNote(finalX, finalY, timeMs);
                map.notes.insertLast(newNote);
            }
            else
            {
                Debug::Log("[BeatmapParser] Corrupt data at index " + i + ": " + token);
            }
        }
        
        Debug::Log("[BeatmapParser] TXT Map parsing complete. Total notes: " + map.notes.length());
        return map;
    }

    MapData ParseJsonMap(const string& in jsonString)
    {
        MapData map;
        Debug::Log("[BeatmapParser] ParseJsonMap requires native JSON bindings.");
        return map;
    }
}
