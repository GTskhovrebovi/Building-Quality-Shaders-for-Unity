Shader "Custom/Silhouette"
{
    Properties
    {
        _ForegroundColor ("FG Color", Color) = (1, 1, 1, 1)
        _BackgroundColor ("BG Color", Color) = (1, 1, 1, 1)
    }
    
    SubShader
    {
        zwrite Off
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "RenderPipeline" = "UniversalPipeline"
        }
        
        Pass
        {
            Tags { "LightMode" = "UniversalForward" }
            
            HLSLPROGRAM

            #pragma vertex vert;
            #pragma fragment frag;
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            
            CBUFFER_START(UnityPerMaterial)
            float4 _ForegroundColor;
            float4 _BackgroundColor;
            CBUFFER_END
            
            struct appdata
            {
                float4 positionOS : POSITION;
            };

            struct v2f
            {
                float4 positionCS : SV_POSITION;
                float4 positionSS : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.positionCS = TransformObjectToHClip(v.positionOS.xyz);
                o.positionSS = ComputeScreenPos(o.positionCS);
                return o;
            }

            float4 frag (v2f i) : SV_TARGET
            {
                float2 screenUVs = i.positionSS.xy / i.positionSS.w;
                float rawDepth = SampleSceneDepth(screenUVs);
                float scene01Depth = Linear01Depth(rawDepth, _ZBufferParams);
                float sceneEyeDepth = LinearEyeDepth(rawDepth, _ZBufferParams);

                float4 outputColor = lerp(_ForegroundColor, _BackgroundColor, scene01Depth);
                return outputColor;
            }
            
            ENDHLSL
        }
        
    }
}