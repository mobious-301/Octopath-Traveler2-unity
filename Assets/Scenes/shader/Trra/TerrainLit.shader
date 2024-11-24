Shader "Custom/Terrain/Lit1"
{
    Properties
    {
        //Plus
        _DiffuseRemapScale0("Diffuse Remap Scale 0", color) = (1, 1, 1, 1)
        _DiffuseRemapScale1("Diffuse Remap Scale 1", color) = (1, 1, 1, 1)
        _DiffuseRemapScale2("Diffuse Remap Scale 2", color) = (1, 1, 1, 1)
        _DiffuseRemapScale3("Diffuse Remap Scale 3", color) = (1, 1, 1, 1)
       


         [ToggleUI] _EnableHeightBlend("EnableHeightBlend", Float) = 0.0
        _HeightTransition("Height Transition", Range(0, 1.0)) = 0.0
        // Layer count is passed down to guide height-blend enable/disable, due
        // to the fact that heigh-based blend will be broken with multipass.
         [PerRendererData] _NumLayersCount ("Total Layer Count", Float) = 1.0

        // set by terrain engine
         _Control("Control (RGBA)", 2D) = "red" {}
        //  _Splat3("Layer 3 (A)", 2D) = "white" {}
        //  _Splat2("Layer 2 (B)", 2D) = "grey" {}
        //  _Splat1("Layer 1 (G)", 2D) = "grey" {}
        //  _Splat0("Layer 0 (R)", 2D) = "grey" {}


         //改
         _Splat3("Layer 3 (A)", 2D) = "white" {}
         _Splat2("Layer 2 (B)", 2D) = "white" {}
         _Splat1("Layer 1 (G)", 2D) = "white" {}
         _Splat0("Layer 0 (R)", 2D) = "white" {}



         _Normal3("Normal 3 (A)", 2D) = "bump" {}
         _Normal2("Normal 2 (B)", 2D) = "bump" {}
         _Normal1("Normal 1 (G)", 2D) = "bump" {}
         _Normal0("Normal 0 (R)", 2D) = "bump" {}
         _Mask3("Mask 3 (A)", 2D) = "grey" {}
         _Mask2("Mask 2 (B)", 2D) = "grey" {}
         _Mask1("Mask 1 (G)", 2D) = "grey" {}
         _Mask0("Mask 0 (R)", 2D) = "black" {}
        [Gamma] _Metallic0("Metallic 0", Range(0.0, 1.0)) = 0.0
        [Gamma] _Metallic1("Metallic 1", Range(0.0, 1.0)) = 0.0
        [Gamma] _Metallic2("Metallic 2", Range(0.0, 1.0)) = 0.0
        [Gamma] _Metallic3("Metallic 3", Range(0.0, 1.0)) = 0.0
         _Smoothness0("Smoothness 0", Range(0.0, 1.0)) = 0.5
         _Smoothness1("Smoothness 1", Range(0.0, 1.0)) = 0.5
         _Smoothness2("Smoothness 2", Range(0.0, 1.0)) = 0.5
         _Smoothness3("Smoothness 3", Range(0.0, 1.0)) = 0.5

        // used in fallback on old cards & base map
         _MainTex("BaseMap (RGB)", 2D) = "grey" {}
         _BaseColor("Main Color", Color) = (1,1,1,1)

         _TerrainHolesTexture("Holes Map (RGB)", 2D) = "white" {}

        [ToggleUI] _EnableInstancedPerPixelNormal("Enable Instanced per-pixel normal", Float) = 1.0
    }

    HLSLINCLUDE

    #pragma multi_compile_fragment __ _ALPHATEST_ON

    #define TERRAIN_GBUFFER  //启用贴图混合方法  SplatmapMix 获取  mixedDiffuse  NormalMapMix()  改为 正常输出 之上
    
    // #define TERRAIN_SPLAT_BASEPASS

    #define TERRAIN_SPLAT_ADDPASS

    // #define TERRAIN_SPLAT_BASEPASS

    #define TERRAIN_SPLAT_ALBEDO_MAP

    ENDHLSL

    SubShader
    {
        Tags { "Queue" = "Geometry-100" "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "UniversalMaterialType" = "Lit" "IgnoreProjector" = "False" "TerrainCompatible" = "True"}

        Pass
        {
            Name "ForwardLit"
            Tags { "LightMode" = "UniversalForward" }
            HLSLPROGRAM
            #pragma target 3.0

            #pragma vertex SplatmapVert
            #pragma fragment SplatmapFragment

            #define _METALLICSPECGLOSSMAP 1
            #define _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A 1

            // -------------------------------------
            // Universal Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
            #pragma multi_compile _ SHADOWS_SHADOWMASK
            #pragma multi_compile _ _LIGHT_LAYERS
            #pragma multi_compile _ _FORWARD_PLUS
            #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
	    #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
            #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
            #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
            #pragma multi_compile_fragment _ _LIGHT_COOKIES
	    #pragma multi_compile_fragment _ _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma multi_compile_fragment _ DEBUG_DISPLAY
            #pragma multi_compile_instancing
            #pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap

            #pragma shader_feature_local_fragment _TERRAIN_BLEND_HEIGHT
            #pragma shader_feature_local _NORMALMAP
            #pragma shader_feature_local_fragment _MASKMAP
            // Sample normal in pixel shader when doing instancing
            #pragma shader_feature_local _TERRAIN_INSTANCED_PERPIXEL_NORMAL

            #include "Packages/com.unity.render-pipelines.universal/Shaders/Terrain/TerrainLitInput.hlsl"
            // #include "Packages/com.unity.render-pipelines.universal/Shaders/Terrain/TerrainLitPasses.hlsl"
            #include "./TerrainLitPasses.hlsl"
            ENDHLSL
        }


        // UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
    }
    // Dependency "AddPassShader" = "Hidden/Universal Render Pipeline/Terrain/Lit (Add Pass)"
    // Dependency "BaseMapShader" = "Hidden/Universal Render Pipeline/Terrain/Lit (Base Pass)"
    // Dependency "BaseMapGenShader" = "Hidden/Universal Render Pipeline/Terrain/Lit (Basemap Gen)"

    // CustomEditor "UnityEditor.Rendering.Universal.TerrainLitShaderGUI"

    // Fallback "Hidden/Universal Render Pipeline/FallbackError"
}
