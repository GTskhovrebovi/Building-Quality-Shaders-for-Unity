using UnityEngine;
using UnityEngine.Rendering.Universal;

namespace Chapter_14.World_Scan.Chapter_14___World_Scan
{
    public class WorldScanFeature : ScriptableRendererFeature
    {
        [SerializeField] private Material material;
        [SerializeField] private RenderPassEvent renderPassEvent;
        WorldScanRenderPass pass;
        
        public override void Create()
        {
            name = "World Scanner";
            pass = new WorldScanRenderPass(material, renderPassEvent);
        }
        
        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            pass.Setup(renderer, "World Scan Post Process");
        }
    }
}