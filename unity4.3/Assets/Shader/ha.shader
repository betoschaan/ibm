// Simplified Multiply Particle shader. Differences from regular Multiply Particle one:
// - no Smooth particle support
// - no AlphaTest
// - no ColorMask

Shader "Netdoktor/Woman Hair2" {
Properties {
	_MainTex ("Particle Texture", 2D) = "white" {}
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecularTex ("Specular (R) Gloss (G) Anisotropic Mask (B)", 2D) = "gray" {}
}

Category {
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	Blend Zero SrcColor
	Cull Off //2 sided
	//Lighting Off 
	ZWrite Off 
	//Fog { Color (1,1,1,1) } 
	
	BindChannels {
		//Bind "Color", color
		//Bind "Vertex", vertex
		Bind "TexCoord", texcoord
	}
	
	// ---- Dual texture cards
//	SubShader {
//		Pass {
//			SetTexture [_MainTex] {
//				combine texture * primary
//			}
//			SetTexture [_MainTex] {
//				constantColor (1,1,1,1)
//				combine previous lerp (previous) constant
//			}
//		}
//	}
	
	// ---- Single texture cards (does not do particle colors)
	SubShader {
		Pass {
			SetTexture [_MainTex] {
			
		//		constantColor (1,1,1,1)
				//combine texture lerp(texture) constant
				
				
		
			}
							

		}
	}
	
	 SubShader {
        // Draw ourselves after all opaque geometry
        Tags { "Queue" = "Transparent" }

        // Grab the screen behind the object into _GrabTexture
        GrabPass { }

        // Render the object with the texture generated above, and invert it's colors
        Pass {
            SetTexture [_GrabTexture] { combine one-texture }
        }
    }

}
}
