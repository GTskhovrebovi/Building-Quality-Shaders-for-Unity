Shader "Custom/PolarCoordinates"
{
    Properties
    {
        _BaseColor("Base Color", color) = (1,1,1,1)
        _BaseTex("Base Texture", 2D) = "white" {}
        _Center("Center",Vector) = (0.5, 0.5, 0, 0)
        _RadialScale("Radial Scale", float) = 1
        _LengthScale("Length Scale", float) = 1
    }
    
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
            "RenderPipeline" = "UniversalPipeline"
        }
        
        Pass
        {
            Tags { "LightMode" = "UniversalForward" }
            
            HLSLPROGRAM

            #pragma vertex vert;
            #pragma fragment frag;
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            sampler2D _BaseTex;
            CBUFFER_START(UnityPerMaterial)
            float4 _BaseColor;
            float4 _BaseTex_ST;
            float2 _Center;
            float _RadialScale;
            float _LengthScale;
            CBUFFER_END
            
            struct appdata
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            float2 CartesianToPolar(float2 cartUV)
            {
                float2 offset = cartUV - _Center;
                float radius = length(offset) * 2;
                float angle = atan2(offset.x, offset.y) / (2.0f * PI);
                return float2(radius, angle);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.positionCS = TransformObjectToHClip(v.positionOS.xyz);
                o.uv = TRANSFORM_TEX(v.uv, _BaseTex);
                return o;
            }

            float4 frag (v2f i) : SV_TARGET
            {
                float2 radialUV = CartesianToPolar(i.uv) * float2(_RadialScale, _LengthScale);
                float4 textureSample = tex2D(_BaseTex, radialUV);
                return textureSample * _BaseColor;
            }
            
            ENDHLSL
        }
        
    }
}