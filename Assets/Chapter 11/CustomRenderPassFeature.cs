using UnityEngine;
using UnityEngine.Rendering.Universal;

namespace Chapter_11
{
    public class CustomRenderPassFeature : ScriptableRendererFeature
    {
        [SerializeField] private Material material;
        [SerializeField] private RenderPassEvent renderPassEvent;
        CustomPostProcessPass pass;

        public override void Create()
        {
            pass = new CustomPostProcessPass(material, renderPassEvent);
        }
    
        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            pass.Setup(renderer, "Custom Render Pass Feature");
        }
    }
}