Shader "Custom/Xray"
{
    Properties
    {
        _XrayColor("X-ray Color", color) = (1,1,1,1)
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
            Ztest Greater
            Zwrite Off
            
            Tags { "LightMode" = "UniversalForward" }
            
            HLSLPROGRAM

            #pragma vertex vert;
            #pragma fragment frag;
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            CBUFFER_START(UnityPerMaterial)
            float4 _XrayColor;
            CBUFFER_END
            
            struct appdata
            {
                float4 positionOS : POSITION;
            };

            struct v2f
            {
                float4 positionCS : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.positionCS = TransformObjectToHClip(v.positionOS.xyz);
                return o;
            }

            float4 frag (v2f i) : SV_TARGET
            {
                return _XrayColor;
            }
            
            ENDHLSL
        }
    }
}