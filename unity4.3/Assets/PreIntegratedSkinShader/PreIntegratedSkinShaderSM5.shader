Shader "Skin/PreIntegratedSkinShaderSM5" {
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
		_DispTex ("Tessellation Displacement Texture", 2D) = "black" {}
		_EdgeLength ("Tessellation Edge length", Range(2,50)) = 5
		_Phong ("Tessellation Phong Strengh", Range(0,1)) = 0.5
		_DisplacementScale ("Tessellation Displacement Scale", Float) = 0.0
		_DisplacementOffset ("Tessellation Displacement Offset", Float) = 0.0
		_LookupDiffuseSpec ("Lookup Map: Diffuse Falloff(RGB) Specular(A)", 2D) = "gray" {}
		_ScatteringOffset ("Scattering Boost", Range(0,1)) = 0.0
		_ScatteringPower ("Scattering Power", Range(0,2)) = 1.0  
		_TranslucencyOffset ("Translucency Offset", Range(0,1)) = 0.0
		_TranslucencyPower ("Translucency Power", Range(0,10)) = 1
		_TranslucencyRadius ("Translucency Radius", Range(0,1)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 600
		
		CGPROGRAM
			#pragma surface surf Skin addshadow fullforwardshadows nolightmap nodirlightmap exclude_path:prepass vertex:disp tessellate:tessEdge tessphong:_Phong  
			#pragma target 5.0
			
			// currently unity supports SM5 only on dx11, no tessellation goodness on opengl
			// I'm exluding other renderers (in particular d3d11_9x), there the shader should fallback on SM3.
			#pragma only_renderers d3d11
			
			#define ENABLE_TRANSLUCENCY 1
			#define ENABLE_RIMS 1
			#define ENABLE_SEPARATE_DIFFUSE_NORMALS 1
			#include "PreIntegratedSkinShaderCommon.cginc"
			
            uniform sampler2D _DispTex;
			uniform float _DisplacementOffset;
            uniform float _DisplacementScale;
	        uniform float _EdgeLength;
	        uniform float _Phong;

			// Here I tried to avoid errors on Unity3 and fallback to or render as with SM3, but to no avail.
//			#if defined(SHADER_API_D3D11) && defined(UNITY_CAN_COMPILE_TESSELLATION)

	        #include "Tessellation.cginc"
	        
	        float4 tessEdge (appdata_tan v0, appdata_tan v1, appdata_tan v2) {
	            return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
	        }
	        
			void disp(inout appdata_tan v) {
                float displacement = (tex2Dlod(_DispTex, float4(v.texcoord.xy,0,0)).r - _DisplacementOffset) * _DisplacementScale;
                v.vertex.xyz += v.normal * displacement;
            }
//	        #else
//	        void disp(inout appdata_full v) {
//                 // do nothing
//            }
//	        float4 tessEdge (appdata_tan v0, appdata_tan v1, appdata_tan v2) {
//	            return 0;
//	        }
//	        #endif
						
		ENDCG
	}
	Fallback "Skin/PreIntegratedSkinShaderSM3"
}
