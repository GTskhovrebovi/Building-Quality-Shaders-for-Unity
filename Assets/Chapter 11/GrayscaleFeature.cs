using UnityEngine.Rendering.Universal;

namespace Chapter_11
{
    [System.Serializable]
    public class GrayscaleFeature : ScriptableRendererFeature
    {
        private GrayscaleRenderPass _pass = new();

        public override void Create()
        {
            name = "Grayscale";
            _pass = new GrayscaleRenderPass();
        }

        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            _pass.Setup(renderer, "Grayscale Post Process");
        }
    }
}