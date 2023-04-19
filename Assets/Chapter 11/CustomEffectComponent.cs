using System;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace Chapter_11
{
    [Serializable, VolumeComponentMenuForRenderPipeline("Custom/CustomEffectComponent", typeof(UniversalRenderPipeline))]
    public class CustomEffectComponent : VolumeComponent, IPostProcessComponent
    {
        public ClampedFloatParameter intensity = new ClampedFloatParameter(value: 0, min: 0, max: 1, overrideState: true);

        public bool IsActive() => intensity.value > 0;
        public bool IsTileCompatible() => true;
    }
}