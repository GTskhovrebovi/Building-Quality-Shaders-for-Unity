using UnityEngine;

public class DissolveWorld : MonoBehaviour
{
    [SerializeField] private Renderer dissolveRenderer;
    
    private Material _material;

    private void Start()
    {
        _material = dissolveRenderer.material;
    }
    
    void Update()
    {
        _material.SetVector("_PlaneOrigin", transform.position);
        _material.SetVector("_PlaneNormal", transform.up);
    }
}