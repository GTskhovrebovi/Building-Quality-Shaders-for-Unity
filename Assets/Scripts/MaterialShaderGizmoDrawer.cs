using UnityEngine;

public class MaterialShaderGizmoDrawer : MonoBehaviour
{
    private void OnDrawGizmosSelected()
    {
        var meshRenderer = GetComponent<MeshRenderer>();
        if (meshRenderer == null) return;
        
        var materials = meshRenderer.sharedMaterials;
        foreach (var material in materials)
        {
            if (material == null) continue;
            
            var tagTex = new Texture2D(1, 1);
            tagTex.SetPixel(0, 0, new Color(0.4f, 0.4f, 0.4f, 0.8f)); // Set alpha to 0.8
            tagTex.Apply();
            
            var shaderName = material.shader.name;
            var style = new GUIStyle
            {
                normal =
                {
                    background = tagTex,
                    textColor = new Color(0f, 0f, 0f, 1f) // Set alpha to 0.8
                },
                alignment = TextAnchor.MiddleCenter,
                padding = new RectOffset(8, 8, 2, 2),
                fontSize = 12,
                fontStyle = FontStyle.Bold
            };

            var labelPos = transform.position + Vector3.up * (transform.localScale.y / 2 + 0.4f);
            UnityEditor.Handles.Label(labelPos, shaderName, style);
        }
    }
}