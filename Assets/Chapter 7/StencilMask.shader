Shader "Custom/StencilMask"
{
    Properties
    {
        [IntRange] _StencilRef("Stencil Ref", Range(0, 255)) = 1
    }
    
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry-1"
            "RenderPipeline" = "UniversalPipeline"
        }
        
        Pass
        {
            Stencil
            {
                Ref[_StencilRef]
                
                //LEqual, Less, GEqual, Greater, Equal, NotEqual, Always, Never
                Comp Always
                
                // Keep Zero Replace IncrSat DecrSat Invert IncrWrap DecrWrap
                Pass Replace 
            }
            
            Zwrite Off
        }
    }
}