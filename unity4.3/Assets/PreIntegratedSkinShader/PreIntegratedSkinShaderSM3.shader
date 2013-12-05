Shader "Skin/PreIntegratedSkinShaderSM3" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_BackRimStrength ("Back Rim Strength", Range(0,1)) = 0.0
		_BackRimWidth ("Back Rim Width", Range(0,2)) = 0.0
		_FrontRimStrength ("Front Rim Strength", Range(0,100)) = 0.0
		_FrontRimWidth ("Front Rim Width", Range(0,1)) = 0.0
		_MainTex ("Diffuse Map(RGB)", 2D) = "white" {}
		_BumpinessDR ("Diffuse Bumpiness R", Range(0,1)) = 0.1
		_BumpinessDG ("Diffuse Bumpiness G", Range(0,1)) = 0.6
		_BumpinessDB ("Diffuse Bumpiness B", Range(0,1)) = 0.7
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_SpecGlosDepthMap ("Specular (R) Glosiness(G) Depth (B)", 2D) = "white" {}
		_Bumpiness ("Specular Bumpiness", Range(0,1)) = 0.9
		_SpecIntensity ("Specular Intensity", Range(0,100)) = 1.0
		_SpecRoughness ("Specular Roughness", Range(0.3,1)) = 0.7
		_LookupDiffuseSpec ("Lookup Map: Diffuse Falloff(RGB) Specular(A)", 2D) = "gray" {}
		_ScatteringOffset ("Scattering Boost", Range(0,1)) = 0.0
		_ScatteringPower ("Scattering Power", Range(0,2)) = 1.0  
		_TranslucencyOffset ("Translucency Offset", Range(0,1)) = 0.0
		_TranslucencyPower ("Translucency Power", Range(0,10)) = 1
		_TranslucencyRadius ("Translucency Radius", Range(0,1)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 500
		
		CGPROGRAM
			#pragma surface surf Skin addshadow fullforwardshadows nolightmap nodirlightmap exclude_path:prepass
			#pragma target 3.0
			#pragma exclude_renderers flash
			#pragma glsl
			#define ENABLE_TRANSLUCENCY 1
			#define ENABLE_RIMS 1
			#define ENABLE_SEPARATE_DIFFUSE_NORMALS 1
			#include "PreIntegratedSkinShaderCommon.cginc"
		ENDCG
	}
	Fallback "Skin/PreIntegratedSkinShaderSM2"
}
