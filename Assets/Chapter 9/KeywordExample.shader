Shader "Custom/KeywordExample"
{
    Properties
    {
        _BaseColor("Base Color", color) = (1,1,1,1)
        _BaseTex("Base Texture", 2D) = "white" {}
        [Toggle(OVERRIDE_RED_ON)] _OverrideRed("Force Red", Float) = 0
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
            #pragma multi_compile_local OVERRIDE_RED_ON __
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            sampler2D _BaseTex;
            CBUFFER_START(UnityPerMaterial)
            float4 _BaseColor;
            float4 _BaseTex_ST;
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

            v2f vert (appdata v)
            {
                v2f o;
                o.positionCS = TransformObjectToHClip(v.positionOS.xyz);
                o.uv = TRANSFORM_TEX(v.uv, _BaseTex);
                return o;
            }

            float4 frag (v2f i) : SV_TARGET
            {
                float4 textureSample = tex2D(_BaseTex, i.uv);

                #if OVERRIDE_RED_ON
                    return float4(1.0f, 0.0f, 0.0f, 1.0f);
                #else
                    return textureSample * _BaseColor;
                #endif
            }
            
            ENDHLSL
        }
    }
}