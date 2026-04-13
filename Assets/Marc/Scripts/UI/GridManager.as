using namespace CometEngine;

class GridManager : CometBehaviour
{
    // These entities should be assigned from the inspector.
    // They represent the 9 cells of the 3x3 grid.
    // Indexing usually goes from top-left (0,0) to bottom-right (2,2)
    // Here we can store them in a single flat array of 9 elements.
    array<Entity@> gridAnchors(9);
    
    // Fallback/Center origin point where notes spawn
    Entity@ centerOrigin;

    void Start()
    {
        Debug::Log("[GridManager] Initialized. Remember to assign the 9 anchors in the Inspector!");
    }

    Vector3 GetAnchorPosition(int x, int y)
    {
        if (x < 0 || x > 2 || y < 0 || y > 2)
        {
            Debug::LogWarning("[GridManager] Warning: Requested out of bounds anchor " + x + ", " + y);
            return Vector3(0, 0, 0); 
        }
        
        int index = (y * 3) + x;
        Entity@ anchorEntity = gridAnchors[index];
        
        if (anchorEntity !is null)
        {
            RectTransform@ rect = RectTransform::Get(anchorEntity);
            if (rect !is null)
            {
                // Devolvemos la posición global del canvas para alinear distintos padres
                return rect.position; 
            }
        }
        
        return Vector3(0, 0, 0);
    }
    
    Vector3 GetOriginPosition()
    {
        if (centerOrigin !is null)
        {
            RectTransform@ rect = RectTransform::Get(centerOrigin);
            if (rect !is null) return rect.position;
        }
        
        // Fallback: Dynamically average the 9 anchors to find the exact center!
        Vector3 avg(0.0f, 0.0f, 0.0f);
        int validCount = 0;
        for (int i = 0; i < 9; i++) {
            Entity@ a = gridAnchors[i];
            if (a !is null) {
                RectTransform@ r = RectTransform::Get(a);
                if (r !is null) {
                    avg = avg + r.position;
                    validCount++;
                }
            }
        }
        
        if (validCount > 0) {
            avg.x /= float(validCount);
            avg.y /= float(validCount);
            avg.z /= float(validCount);
            return avg;
        }
        
        return Vector3(0, 0, 0);
    }
}
