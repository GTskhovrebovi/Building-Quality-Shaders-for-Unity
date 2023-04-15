using UnityEngine;

public class ColorControl : MonoBehaviour
{
    private Material _material;
    private static readonly int BaseColor = Shader.PropertyToID("_BaseColor");

    void Start()
    {
        _material = GetComponent<Renderer>().material;
    }
    
    void Update()
    {
        var color = _material.GetColor(BaseColor);

        Color.RGBToHSV(color, out var hue, out var sat, out var val);
        hue = (Time.time * 0.25f) % 1.0f;
        color = Color.HSVToRGB(hue, sat, val);
        _material.SetColor(BaseColor, color);
    }
}