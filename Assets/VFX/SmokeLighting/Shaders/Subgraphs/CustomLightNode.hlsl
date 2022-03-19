// Based on Gist from Simon Broggi (https://gist.github.com/simonbroggi/672b979ca37b01db752e0087b26315ab) 
// Helper for reading URP Main Light + Additonal Lights

#ifndef CUSTOM_LIGHT_NODE
#define CUSTOM_LIGHT_NODE

void GetAdditionalLightData_float(in uint index, in float3 worldPosition, out half3 direction, out half3 color, out half distanceAttenuation, out half shadowAttenuation)
{
#ifdef SHADERGRAPH_PREVIEW
    direction = half3(0.3, 0.8, 0.6);
    color = half3(1, 1, 1);
    distanceAttenuation = 1.0;
    shadowAttenuation = 1.0;
#else
    direction = float3(0, 1, 0);
    color = 0.0;
    distanceAttenuation = 0.0;
    shadowAttenuation = 0.0;

    #if defined(UNIVERSAL_LIGHTING_INCLUDED)

        if (index < GetAdditionalLightsCount()) // Don't try to get the light if it doesn't exist
        {
            // GetPerObjectLightIndex and GetAdditionalPerObjectLight 
            // defined in Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl
            int perObjectLightIndex = GetPerObjectLightIndex(index);
            Light light = GetAdditionalPerObjectLight(perObjectLightIndex, worldPosition);
            direction = light.direction;
            color = light.color; 
            distanceAttenuation = light.distanceAttenuation;
            shadowAttenuation = light.shadowAttenuation;
        }

    #endif
#endif
}


void GetMainLightData_float(out half3 direction, out half3 color, out half distanceAttenuation, out half shadowAttenuation)
{
#ifdef SHADERGRAPH_PREVIEW
    direction = half3(0.3, 0.8, 0.6);
    color = half3(1, 1, 1);
    distanceAttenuation = 1.0;
    shadowAttenuation = 1.0;
#else
    direction = float3(0, 1, 0);
    color = 0.0;
    distanceAttenuation = 0.0;
    shadowAttenuation = 0.0;

    // Universal Render Pipeline
    #if defined(UNIVERSAL_LIGHTING_INCLUDED)
    
        // GetMainLight defined in Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl
        Light mainLight = GetMainLight();
        direction = mainLight.direction;
        color = mainLight.color;
        distanceAttenuation = mainLight.distanceAttenuation;
        shadowAttenuation = mainLight.shadowAttenuation;
    #endif
#endif
}
#endif