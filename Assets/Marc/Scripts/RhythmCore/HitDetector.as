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
    // State trackers for debug testing
    int lastHoveredX = -1;
    int lastHoveredY = -1;

    void ProcessHover(Vector2 mousePos, float audioTimeMs, ScoreManager@ scoreManager, NoteSpawner@ spawnerHandle)
    {
        if (gridHandle is null || spawnerHandle is null || spawnerHandle.gridManagerHandle is null) return;

        int hoveredX = -1;
        int hoveredY = -1;
        
        // --- MOTOR DIAGNOSTIC TEST ---
        if (Input::GetKeyDown(KeyCode::T))
        {
            Vector3 anchor00 = spawnerHandle.gridManagerHandle.GetAnchorPosition(0, 0);
            
            Debug::Log("==== DIAGNOSTICO DEL MOTOR (Pulso T) ====");
            Debug::Log("1. Input::GetMousePos() (Hardware Bruto): X:" + Input::GetMousePosition().x + " Y:" + Input::GetMousePosition().y);
            Debug::Log("2. Mouse Mapeado (El que usa el juego): X:" + mousePos.x + " Y:" + mousePos.y);
            Debug::Log("3. Posición UI Motor (Ancla Celda 0,0): X:" + anchor00.x + " Y:" + anchor00.y);
            Debug::Log("4. Window::GetWidth() / GetHeight(): " + Window::GetWidth() + "x" + Window::GetHeight());
            
            // Intentar desenterrar el tamaño real del Canvas si lo tenemos vinculado
            if (spawnerHandle.parentCanvas !is null) {
                RectTransform@ cRect = RectTransform::Get(spawnerHandle.parentCanvas);
                if (cRect !is null) {
                    Debug::Log("5. Canvas Real Size: " + cRect.size.x + "x" + cRect.size.y);
                }
            }
            Debug::Log("=========================================");
        }
        // -----------------------------
        
        // --- CALCULO DEL RADIO DINAMICO DEL HITBOX ---
        Vector3 a1 = spawnerHandle.gridManagerHandle.GetAnchorPosition(0, 0);
        Vector3 a2 = spawnerHandle.gridManagerHandle.GetAnchorPosition(1, 0);
        float diffX = a2.x - a1.x;
        float diffY = a2.y - a1.y;
        float cellDistSqr = (diffX * diffX) + (diffY * diffY);
        float maxDistSqr = cellDistSqr * 0.2025f; // Radio equivalente al 45% del espacio real entre celdas
        
        // Find which anchor the mouse is actively hovering over
        for (int x = 0; x < 3; x++)
        {
            for (int y = 0; y < 3; y++)
            {
                Vector3 anchorPos3D = spawnerHandle.gridManagerHandle.GetAnchorPosition(x, y);
                float dx = mousePos.x - anchorPos3D.x;
                float dy = mousePos.y - anchorPos3D.y;
                float distSqr = (dx * dx) + (dy * dy);
                
                if (distSqr <= maxDistSqr) 
                {
                    hoveredX = x;
                    hoveredY = y;
                }
            }
        }

        // --- SIMPLE DEBUG TEST REQUESTED ---
        // Logs exactly which cell the engine thinks your mouse is touching 
        if (hoveredX != lastHoveredX || hoveredY != lastHoveredY)
        {
            lastHoveredX = hoveredX;
            lastHoveredY = hoveredY;
            if (hoveredX == -1)
                Debug::Log("[HitDetector-TEST] MOUSE IN DEAD ZONE (Outside anchor radius)");
            else
                Debug::Log("[HitDetector-TEST] Mouse touching cell: [" + hoveredX + ", " + hoveredY + "]");
        }
        // ----------------------------------

        if (hoveredX != -1 && hoveredY != -1)
        {
            for (uint i = 0; i < gridHandle.currentMap.notes.length(); i++)
            {
                NoteData note = gridHandle.currentMap.notes[i];
                
                if (note.isActive && !note.isHit && !note.isMissed)
                {
                    if (note.x == hoveredX && note.y == hoveredY)
                    {
                        float timeDiff = note.timeMs - audioTimeMs;
                        
                        // Translated to Math: Progress of 0.8 equals 300ms remainder at 1500 rate
                        // Progress of 1.6 equals passing -900ms at 1500 rate
                        // Visual match for Perfect/Good detection bounds:
                        if (timeDiff <= 300.0f && timeDiff >= -900.0f)
                        {
                            note.isHit = true;
                            note.isActive = false;
                            gridHandle.currentMap.notes[i] = note;
                            
                            // Perfect visual center
                            if (timeDiff > -50.0f && timeDiff < 50.0f) {
                                if (scoreManager !is null) scoreManager.OnHitPerfect();
                            } else {
                                if (scoreManager !is null) scoreManager.OnHitGood();
                            }
                            
                            spawnerHandle.NotifyHit(note.x, note.y, note.timeMs);
                        }
                    }
                }
            }
        }
    }
}
