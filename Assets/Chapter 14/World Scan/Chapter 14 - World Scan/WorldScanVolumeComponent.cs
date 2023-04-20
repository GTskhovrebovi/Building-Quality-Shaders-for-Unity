using System;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace Chapter_14.World_Scan.Chapter_14___World_Scan
{
    [Serializable, VolumeComponentMenuForRenderPipeline("Custom/WorldScan", typeof(UniversalRenderPipeline))]
    public class WorldScanVolumeComponent : VolumeComponent, IPostProcessComponent
    {
        [Tooltip("Is the effect active?")]
        public BoolParameter enabled = new(false);
        [Tooltip("The world space origin point of the scan.")]
        public Vector3Parameter scanOrigin = new(Vector3.zero);
        [Tooltip("How quickly, in units per second, the scan propagates.")]
        public FloatParameter scanSpeed = new(1.0f);
        [Tooltip("How far, in meters, the scan has travelled from the origin.")]
        public FloatParameter scanDist = new(0.0f);
        [Tooltip("The distance, in meters, the scan texture gets applied over.")]
        public FloatParameter scanWidth = new(1.0f);
        [Tooltip("An x-by-1 ramp texture representing the scan color.")]
        public Texture2DParameter overlayRampTex = new(null);
        [Tooltip("An additional HDR color tint applied to the scan.")]
        public ColorParameter overlayColor = new(Color.white, true, true, true);
        
        public bool IsActive() =>  overlayRampTex.value != null && enabled.value && active;
        public bool IsTileCompatible() => true;

        // public void StartScan(Vector3 origin)
        // {
        //     enabled.Override(true);
        //     scanOrigin.Override(origin);
        //     scanDist.Override(0.0f);
        // }
        //
        // public void UpdateScan()
        // {
        //     scanDist.value += scanSpeed.value * Time.deltaTime;
        // }
        //
        // public void StopScan()
        // {
        //     enabled.Override(false);
        // }
    }
}