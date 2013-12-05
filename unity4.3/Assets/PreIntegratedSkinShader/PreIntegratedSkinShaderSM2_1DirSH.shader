// fully supports only 1 directional light. Other lights can affect it, but it will be per-vertex/SH.

Shader "Skin/PreIntegratedSkinShaderSM2_1DirSH" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Diffuse Map(RGB)", 2D) = "white" {}
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_SpecGlosDepthMap ("Specular (R) Glosiness(G) Depth (B)", 2D) = "white" {}
		_Bumpiness ("Bumpiness", Range(0,1)) = 0.9
		_SpecIntensity ("Specular Intensity", Range(0,100)) = 1.0
		_SpecRoughness ("Specular Roughness", Range(0.3,1)) = 0.7
		_LookupDiffuseSpec ("Lookup Map: Diffuse Falloff(RGB) Specular(A)", 2D) = "gray" {}
		_ScatteringOffset ("Scattering Boost", Range(0,1)) = 0.0
		_ScatteringPower ("Scattering Power", Range(0,2)) = 1.0  
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 250
		
		CGPROGRAM
			#pragma surface surf Skin approxview halfasview noforwardadd nodirlightmap nolightmap   exclude_path:prepass
			#pragma exclude_renderers flash
			#pragma target 2.0
			#pragma glsl
			#include "PreIntegratedSkinShaderCommon.cginc"
		ENDCG
	}
	
	Fallback "VertexLit"
}
