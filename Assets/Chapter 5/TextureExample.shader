Shader "Custom/TextureExample"
{
    Properties
    {
        _BaseColor("Base Color", color) = (1, 1, 1, 1)
        _BaseTex("Base Texture", 2D) = "white" {}
    }
    
    SubShader
    {
        Tags 
        {
            "RenderPipeline" = "UniversalPipeline" // URP
            "RenderType" = "Opaque"
            "Queue" = "Geometry" 
        }
        
        Pass
        {
            Tags { "LightMode" = "UniversalForward" } // URP
            
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl" // URP

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

            sampler2D _BaseTex;
            CBUFFER_START(UnityPerMaterial)
            float4 _BaseColor;
            float4 _BaseTex_ST;
            CBUFFER_END

            v2f vert (appdata v)
            {
                v2f o;
                o.positionCS = TransformObjectToHClip(v.positionOS.xyz);
                o.uv = TRANSFORM_TEX(v.uv, _BaseTex);
                return o;
            }

            float4 frag (v2f i) : SV_TARGET
            {
                // Mipmaps
                float4 sampleUVs = float4(i.uv, 0.0f, 3.0f);
                float4 textureSample = tex2Dlod(_BaseTex, sampleUVs);
                //
                //float4 textureSample = tex2D(_BaseTex, i.uv);
                return textureSample * _BaseColor;
            }
            
            ENDHLSL
        }
    }
    
    FallBack Off
}
