using UnityEngine;

public class KeywordControl : MonoBehaviour
{
    private Material _material;

    public void Start()
    {
        _material = GetComponent<Renderer>().material;
    }

    private void Update()
    {
        var toggle = Time.time % 2.0f > 1.0f;
        if(toggle)
        {
            _material.EnableKeyword("OVERRIDE_RED_ON");
        }
        else
        {
            _material.DisableKeyword("OVERRIDE_RED_ON");
        }
    }
}