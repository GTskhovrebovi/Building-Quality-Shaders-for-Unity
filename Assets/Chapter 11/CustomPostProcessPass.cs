using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace Chapter_11
{
    [System.Serializable]
    public class CustomPostProcessPass : ScriptableRenderPass
    {
        RenderTargetIdentifier source;
        RenderTargetIdentifier tempTex;
        private Material _material;
        private string profilerTag;

        private int _tempTexID = Shader.PropertyToID("_TempTex");
    
        public CustomPostProcessPass(Material material, RenderPassEvent passEvent)
        {
            _material = material;
            renderPassEvent = passEvent;
        }
    
        public void Setup(ScriptableRenderer renderer, string profilerTag)
        {
            this.profilerTag = profilerTag;
            source = renderer.cameraColorTarget;
            VolumeStack stack = VolumeManager.instance.stack;
            CustomEffectComponent customEffectComponent = stack.GetComponent<CustomEffectComponent>();
            //renderPassEvent = RenderPassEvent.BeforeRenderingPostProcessing;
            if (customEffectComponent != null && customEffectComponent.IsActive())
            {
                renderer.EnqueuePass(this);
            }
        }

        public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
        {
            // Grab the camera target descriptor. We will use this when creating a temporary render texture.
            RenderTextureDescriptor descriptor = renderingData.cameraData.cameraTargetDescriptor;
            descriptor.depthBufferBits = 0;

            var renderer = renderingData.cameraData.renderer;
            source = renderer.cameraColorTarget;

            // Create a temporary render texture using the descriptor from above.
            tempTex = new RenderTargetIdentifier(_tempTexID);
            cmd.GetTemporaryRT(_tempTexID , descriptor, FilterMode.Bilinear);
        }
    
        // The actual execution of the pass. This is where custom rendering occurs.
        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            CommandBuffer cmd = CommandBufferPool.Get(profilerTag);
            cmd.Clear();

            var stack = VolumeManager.instance.stack;
            var customEffect = stack.GetComponent<CustomEffectComponent>();
            if (customEffect.IsActive())
            {
                Blit(cmd, source, tempTex, _material, 0);
            }

            Blit(cmd, tempTex, source);
        
            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }

        //Cleans the temporary RTs when we don't need them anymore
        public override void OnCameraCleanup(CommandBuffer cmd)
        {
            cmd.ReleaseTemporaryRT(_tempTexID);
        }
    }
}