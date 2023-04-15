Shader "Custom/DepthOnly" //Unclear
{
    Properties
    {
    }
    
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
            "RenderPipeline" = "UniversalPipeline"
        }
        UsePass "Universal Render Pipeline/Unlit/DepthOnly"
//        Pass
//        {
//            Name "DepthOnly"
//            Tags{"LightMode" = "DepthOnly"}
//            ZWrite On
//            ColorMask 0
//            
//             HLSLPROGRAM
//             #pragma vertex DepthOnlyVertex
//             #pragma fragment DepthOnlyFragment
//             #include "Packages/com.unity.render-pipelines.universal/Shaders/UnlitInput.hlsl"
//             #include "Packages/com.unity.render-pipelines.universal/Shaders/DepthOnlyPass.hlsl"
//             #pragma multi_compile_instancing
//             #pragma multi_compile _ DOTS_INSTANCING_ON
//             ENDHLSL
//        }
        
        Pass
        {
            Name "DepthNormalsOnly"
            Tags{"LightMode" = "DepthNormalsOnly"}
            ZWrite On

            HLSLPROGRAM

            #pragma vertex DepthNormalsVertex
            #pragma fragment DepthNormalsFragment

            #include "Packages/com.unity.render-pipelines.universal/Shaders/UnlitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/UnlitDepthNormalsPass.hlsl"
            ENDHLSL
        }
    }
}