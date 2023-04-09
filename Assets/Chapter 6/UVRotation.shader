Shader "Custom/UVRotation"
{
    Properties
    {
        _BaseColor("Base Color", color) = (1,1,1,1)
        _BaseTex("Base Texture", 2D) = "white" {}
        _Rotation("Rotation Amount", float) = 0.0
        _Center("Rotation Center", Vector) = (0,0,0,0)
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
            float _Rotation;
            float2 _Center;
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
                float c = cos(_Rotation);
                float s = sin(_Rotation);
                float2x2 rotMatrix = float2x2(c, -s, s, c);
                
                v2f o;
                o.positionCS = TransformObjectToHClip(v.positionOS.xyz);
                o.uv = TRANSFORM_TEX(v.uv, _BaseTex);
                o.uv -= _Center;
                o.uv = mul(rotMatrix, o.uv);
                o.uv += _Center;
                return o;
            }

            float4 frag (v2f i) : SV_TARGET
            {
                float4 textureSample = tex2D(_BaseTex, i.uv);
                return textureSample * _BaseColor;
            }
            
            ENDHLSL
        }
        
    }
}