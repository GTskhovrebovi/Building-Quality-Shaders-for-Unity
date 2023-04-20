using System;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace Chapter_14.World_Scan.Chapter_14___World_Scan
{
    [Serializable]
    public class WorldScanRenderPass : ScriptableRenderPass
    {
        private Material _material;
        private WorldScanVolumeComponent _worldScanVolumeComponent;
        RenderTargetIdentifier _source;
        RenderTargetIdentifier _tempTex;
        private string _profilerTag;
        
        private int _id = Shader.PropertyToID("_TempTex");
        
        public WorldScanRenderPass(Material material, RenderPassEvent passEvent)
        {
            _material = material;
            renderPassEvent = passEvent;
        }
        
        public void Setup(ScriptableRenderer renderer, string profilerTag)
        {
            _profilerTag = profilerTag;
            _source = renderer.cameraColorTarget;
            var stack = VolumeManager.instance.stack;
            _worldScanVolumeComponent = stack.GetComponent<WorldScanVolumeComponent>();
            if (_material != null && _worldScanVolumeComponent != null && _worldScanVolumeComponent.IsActive())
            {
                renderer.EnqueuePass(this);
            }
        }
        
        public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
        {
            if (_worldScanVolumeComponent == null) return;
            
            var descriptor = renderingData.cameraData.cameraTargetDescriptor;    
            descriptor.depthBufferBits = 0;
            
            var renderer = renderingData.cameraData.renderer;
            _source = renderer.cameraColorTarget;
            
            _tempTex = new RenderTargetIdentifier(_id);
            cmd.GetTemporaryRT(_id, descriptor, FilterMode.Bilinear);
            base.Configure(cmd, descriptor);
        }
        
        // public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
        // {
        //     if (_worldScanVolumeComponent == null) return;
        //     
        //     _tempTex = new RenderTargetIdentifier(_id);
        //     cmd.GetTemporaryRT(_id, cameraTextureDescriptor);
        //     base.Configure(cmd, cameraTextureDescriptor);
        // }

        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            if (!_worldScanVolumeComponent.IsActive()) return;
            
            var cmd = CommandBufferPool.Get(_profilerTag);
            
            cmd.Blit(_source, _tempTex);
            
            _material.SetVector("_ScanOrigin", _worldScanVolumeComponent.scanOrigin.value);
            _material.SetFloat("_ScanDist", _worldScanVolumeComponent.scanDist.value);
            _material.SetFloat("_ScanWidth", _worldScanVolumeComponent.scanWidth.value);
            _material.SetTexture("_OverlayRampTex", _worldScanVolumeComponent.overlayRampTex.value);
            _material.SetColor("_OverlayColor", _worldScanVolumeComponent.overlayColor.value);
            
            cmd.Blit(_tempTex, _source, _material);
            
            context.ExecuteCommandBuffer(cmd);
            
            cmd.Clear();
            CommandBufferPool.Release(cmd);
        }
        
        public override void FrameCleanup(CommandBuffer cmd)
        {
            cmd.ReleaseTemporaryRT(_id);
        }
    }
}