﻿void AmbientLight_float(float3 WorldNormal, bool IsVertex, out float3 Ambient)
{
    #ifdef SHADERGRAPH_PREVIEW
    Ambient = 0.2f;
    #else
    if(IsVertex)
    {
        Ambient = SampleSHVertex(WorldNormal);
    }
    else
    {
        Ambient = SampleSH(WorldNormal);
    }
    #endif
}

void AmbientLight_half(half3 WorldNormal, bool IsVertex, out half3 Ambient)
{
    #ifdef SHADERGRAPH_PREVIEW
    Ambient = 0.2f;
    #else
    if(IsVertex)
    {
        Ambient = SampleSHVertex(WorldNormal);
    }
    else
    {
        Ambient = SampleSH(WorldNormal);
    }
    #endif
}