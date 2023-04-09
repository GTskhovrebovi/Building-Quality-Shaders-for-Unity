Shader "Custom/CubemapReflections"
{
    Properties
    {
        _BaseColor("Base Color", color) = (1,1,1,1)
        _CubeMap("Cubemap", Cube) = "white" {}
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

            samplerCUBE _CubeMap;
            CBUFFER_START(UnityPerMaterial)
            float4 _BaseColor;
            float4 _BaseTex_ST;
            CBUFFER_END
            
            struct appdata
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
            };

            struct v2f
            {
                float4 positionCS : SV_POSITION;
                float3 reflectWS : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                 v2f o;
                 o.positionCS = TransformObjectToHClip(v.positionOS.xyz);
                 float3 normalWS = TransformObjectToWorldNormal(v.normalOS);
                 float3 positionWS = mul(unity_ObjectToWorld, v.positionOS).xyz;
                 float3 viewDirWS = GetWorldSpaceNormalizeViewDir(positionWS);
                 viewDirWS = normalize(viewDirWS);
                 o.reflectWS = reflect(-viewDirWS, normalWS);
                 return o;
            }

            float4 frag (v2f i) : SV_TARGET
            {
                float4 cubemapSample = texCUBE(_CubeMap, i.reflectWS);
                return cubemapSample;
            }
            
            ENDHLSL
        }
        
    }
}