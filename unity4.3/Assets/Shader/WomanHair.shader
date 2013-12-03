// Unlit alpha-cutout shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Netdoktor/Woman Hair" {
	Properties {
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		_Color ("Main Color", Color) = (1,1,1,1)
	}

	SubShader {
		Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
		LOD 100
		
		Pass {
			Lighting Off
			Alphatest Greater [_Cutoff]
			SetTexture [_MainTex] { combine texture } 
		}
	}
}