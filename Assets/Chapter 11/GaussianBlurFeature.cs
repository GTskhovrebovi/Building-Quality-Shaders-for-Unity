using UnityEngine.Rendering.Universal;

namespace Chapter_11
{
    public class GaussianBlurFeature : ScriptableRendererFeature
    {
        GaussianBlurRenderPass pass;
        public override void Create()
        {
            name = "Gaussian Blur";
            pass = new GaussianBlurRenderPass();
        }
        
        public override void AddRenderPasses(ScriptableRenderer renderer, ref
            RenderingData renderingData)
        {
            pass.Setup(renderer, "Gaussian Blur Post Process");
        }
    }
}