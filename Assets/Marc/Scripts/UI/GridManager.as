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
                // Extraemos pos local, las de world dan NaN en UIs que no han calculado su layout!
                return Vector3(rect.anchoredPosition.x, rect.anchoredPosition.y, 0.0f); 
            }
        }
        
        return Vector3(0, 0, 0);
    }
    
    Vector3 GetOriginPosition()
    {
        if (centerOrigin !is null)
        {
            RectTransform@ rect = RectTransform::Get(centerOrigin);
            if (rect !is null) return Vector3(rect.anchoredPosition.x, rect.anchoredPosition.y, 0.0f);
        }
        return Vector3(0, 0, 0);
    }
}
