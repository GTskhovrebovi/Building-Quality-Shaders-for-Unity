﻿using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace Chapter_11
{
    [System.Serializable, VolumeComponentMenu("Custom/Grayscale")]
    public sealed class GrayscaleSettings : VolumeComponent, IPostProcessComponent
    {
        [Tooltip("How strongly the effect is applied. " + "0 = original image, 1 = fully grayscale.")]
        public ClampedFloatParameter strength = new(0.0f, 0.0f, 1.0f);
        public bool IsActive() => strength.value > 0.0f && active;

        public bool IsTileCompatible() => false;
    }
}