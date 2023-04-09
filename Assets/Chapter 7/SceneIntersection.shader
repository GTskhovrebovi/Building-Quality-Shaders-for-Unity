Shader "Custom/SceneIntersection"
{
    Properties
    {
        _BaseColor("Base Color", color) = (1,1,1,1)
        _IntersectColor("Intersect Color", Color) = (1, 1, 1, 1)
        _IntersectPower("Intersect Power", Range(0.01, 100)) = 1
    }
    
    SubShader
    {
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
            float4 _BaseColor;
            float4 _IntersectColor;
            float _IntersectPower;
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

                float screenPosW = i.positionSS.w;
                
                float intersectAmount = sceneEyeDepth - screenPosW;
                intersectAmount = saturate(1.0f - intersectAmount);
                intersectAmount = pow(intersectAmount, _IntersectPower);
                float4 outputColor = lerp(_BaseColor, _IntersectColor, intersectAmount);
                return outputColor;
            }
            
            ENDHLSL
        }
        
    }
}