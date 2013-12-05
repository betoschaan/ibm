#include "UnityCG.cginc"
			
uniform sampler2D _MainTex;
uniform sampler2D _BumpMap;
uniform sampler2D _SpecGlosDepthMap;

uniform sampler2D _LookupDiffuseSpec;

uniform float _ScatteringOffset;
uniform float _ScatteringPower;
			
#ifdef ENABLE_RIMS
uniform float _BackRimStrength;
uniform float _BackRimWidth;
uniform float _FrontRimStrength;
uniform float _FrontRimWidth;
#endif

uniform float _Bumpiness;

uniform float _BumpinessDR;
uniform float _BumpinessDG;
uniform float _BumpinessDB;

uniform float _SpecIntensity;
uniform float _SpecRoughness;

uniform fixed4 _Color;

#ifdef ENABLE_TRANSLUCENCY
uniform float _TranslucencyOffset;
uniform float _TranslucencyPower;
uniform float _TranslucencyRadius;
#endif

struct MySurfaceOutput {
    half3 Albedo;
    half3 Normal;
    #ifdef ENABLE_SEPARATE_DIFFUSE_NORMALS
    half3 NormalBlue;
    half3 NormalGreen;
    half3 NormalRed;
    #endif
    half3 Emission;
    half Specular;
    half Gloss;
    half Alpha;
    half Scattering;
    #ifdef ENABLE_TRANSLUCENCY
    half3 Translucency;
    #endif
    #ifdef ENABLE_RIMS
    half BackRimWidth;
    half FrontRimWidth;
    #endif
};     

struct Input {
	float2 uv_MainTex;
};

inline fixed4 LightingSkin(MySurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
	float NdotL = dot(s.Normal, lightDir); // light ramp
	#if defined(ENABLE_TRANSLUCENCY) || defined(ENABLE_RIMS)
	float NdotE = dot(s.Normal, viewDir); // faloff/rim
	#endif
	float3 h = lightDir + viewDir; // Unnormalized half-way vector  
	float3 H = normalize(h);
	float NdotH = dot(s.Normal, H);
	float EdotH = dot(viewDir, H);
	
	#ifdef ENABLE_SEPARATE_DIFFUSE_NORMALS
	half3 diffNdotL = 0.5 + 0.5 * half3(
		dot(s.NormalRed, lightDir),
		dot(s.NormalGreen, lightDir),
		dot(s.NormalBlue, lightDir));
	#else
	half diffNdotL = 0.5 + 0.5 * NdotL;
	#endif
		
	#ifdef DIRECTIONAL
		diffNdotL *= atten;
	#endif
	
	#ifdef ENABLE_SEPARATE_DIFFUSE_NORMALS
	half3 diff = 2.0 * half3(
		tex2D(_LookupDiffuseSpec, half2(diffNdotL.r, s.Scattering)).r,
		tex2D(_LookupDiffuseSpec, half2(diffNdotL.g, s.Scattering)).g,
		tex2D(_LookupDiffuseSpec, half2(diffNdotL.b, s.Scattering)).b
	);				
	#else
	half3 diff = 2.0 * tex2D(_LookupDiffuseSpec, half2(diffNdotL, s.Scattering)).rgb;
	#endif
			
	
	#ifndef DIRECTIONAL
		diff *= atten;
	#endif
	
	// specular
	float PH = pow( 2.0*tex2D(_LookupDiffuseSpec,float2(NdotH,s.Specular)).a, 10.0 );  

	float exponential = pow(1.0 - EdotH, 5.0);
	float fresnelReflectance = exponential + 0.028 * (1.0 - exponential);  

	float frSpec = max( PH * fresnelReflectance / dot( h, h ), 0 );  
	float specLevel = saturate(NdotL * s.Gloss * frSpec); // BRDF * dot(N,L) * rho_s
	// NB: specLevel saturated for correct rendering with HDR

	#ifdef ENABLE_TRANSLUCENCY
    half3 translucency = s.Translucency * saturate((1-NdotL)*dot(s.Normal, (viewDir-lightDir) * _TranslucencyRadius ));
    #endif
    
	half4 c = _LightColor0.rgba;

    #ifdef ENABLE_RIMS
	half frim = (pow(saturate((1-NdotE)*(NdotL)) * s.FrontRimWidth, 2)) * _FrontRimStrength;
	half brim = (pow(saturate((1-NdotE)*(1-NdotL) * s.BackRimWidth), 20)) * _BackRimStrength;
	#endif
	
	c.rgb *= 
		s.Albedo * (
			diff
			#ifdef ENABLE_TRANSLUCENCY
			+ translucency * atten
			#endif
		    #ifdef ENABLE_RIMS
			+ (frim * atten).xxx
			#endif
		)
		+ (specLevel * atten).xxx
	    #ifdef ENABLE_RIMS
		+ brim.xxx
		#endif
		;
	
	return c;
}

void surf (Input IN, inout MySurfaceOutput o) {
	float2 uv = IN.uv_MainTex;
	
	#ifdef ENABLE_SEPARATE_DIFFUSE_NORMALS
	float3 normalHigh = UnpackNormal(tex2D(_BumpMap, uv));
	float3 normalLow = UnpackNormal(tex2Dbias(_BumpMap, float4(uv, 0, 3)));
	
	o.Normal = normalize(lerp(normalLow, normalHigh, _Bumpiness));
	o.NormalRed = normalize(lerp(normalLow, normalHigh, _BumpinessDR));
	o.NormalGreen = normalize(lerp(normalLow, normalHigh, _BumpinessDG));
	o.NormalBlue = normalize(lerp(normalLow, normalHigh, _BumpinessDB));
	#else
	#ifndef NOGLSL
	o.Normal = UnpackNormal(tex2Dbias(_BumpMap, float4(uv, 0, (1-_Bumpiness)*3)));
	#else
	// no GLSL support (most likely Intel igp)
	// fallback to smoothing to fully perpendicular normal instead of low res mipmap
	// this could result in differences if normal contains larger features, not just
	// small bumpy ones.
	// TODO could geet rid of normalize op by pecifying packed normal for various platforms (or is there a define i didn't find?)
//	o.Normal = normalize(lerp(half3(0,0,1),UnpackNormal(tex2D(_BumpMap, uv)), _Bumpiness));
	// FIXME should normalize it, but there are no more instructions left!
	o.Normal = (lerp(half3(0,0,1),UnpackNormal(tex2D(_BumpMap, uv)), _Bumpiness));
	#endif
	#endif
	
	half3 specGlosDepth = tex2D(_SpecGlosDepthMap, uv).rgb;
	
	half depth = specGlosDepth.b;
	o.Scattering = saturate((depth + _ScatteringOffset) * _ScatteringPower);
					
	half3 c = tex2D(_MainTex, uv).rgb;

	o.Albedo = c.rgb * _Color.rgb;
	o.Alpha = 1; // no transparency

	o.Specular = specGlosDepth.g * _SpecRoughness;
	o.Gloss = specGlosDepth.r * _SpecIntensity;
	
	#ifdef ENABLE_RIMS
	half rimSpread = 1 - depth*0.8;
    o.BackRimWidth = _BackRimWidth * rimSpread;
    o.FrontRimWidth = _FrontRimWidth * rimSpread;
	#endif

	#ifdef ENABLE_TRANSLUCENCY
    // Calculate the scale of the translucency effect.
	depth = 1-depth;
	depth = saturate((depth + _TranslucencyOffset) * 1);
	
    float scale = 8.25 * depth / _TranslucencyRadius;
    float d = scale * depth;
    half translucencyStrength = (1-depth) * _TranslucencyPower;
    
       
    // Could use a lookup map for this, but it's actually faster to compute on my GTX460
    // half3 translucencyProfile = tex2D(_LookupTranslucency, half2(d, 0)).rgb;
    
    float dd = -d * d;
    half3 translucencyProfile =
    				 float3(0.233, 0.455, 0.649) * exp(dd / 0.0064) +
                     float3(0.1,   0.336, 0.344) * exp(dd / 0.0484) +
                     float3(0.118, 0.198, 0.0)   * exp(dd / 0.187)  +
                     float3(0.113, 0.007, 0.007) * exp(dd / 0.567)  +
                     float3(0.358, 0.004, 0.0)   * exp(dd / 1.99)   +
                     float3(0.078, 0.0,   0.0)   * exp(dd / 7.41);
                     
    o.Translucency = translucencyStrength * translucencyProfile;
	#endif
	o.Emission = 0;
}