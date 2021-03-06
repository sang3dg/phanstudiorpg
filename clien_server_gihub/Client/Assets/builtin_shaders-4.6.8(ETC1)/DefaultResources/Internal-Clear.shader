// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Only used on D3D11 for non-fullscreen clears
Shader "Hidden/InternalClear" {

	CGINCLUDE
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityShaderVariables.cginc"

	struct appdata_t {
		float4 vertex : POSITION;
		fixed4 color : COLOR;
	};

	struct v2f {
		float4 vertex : SV_POSITION;
		fixed4 color : COLOR;
	};
	//2				
uniform sampler2D _MainTex_Alpha;
uniform float _UseSecondAlpha;
//3
fixed4 tex2D_ETC1(sampler2D sa,sampler2D sb,fixed2 v)        
{                                                           
 fixed4 col = tex2D(sa,v);                                  
 fixed alp = tex2D(sb,v).r;                                 
 col.a = min(col.a,alp) ;                                   
 return col;                                                
}   
	v2f vert (appdata_t v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.color = v.color;
		return o;
	}

	fixed4 frag (v2f i) : SV_Target
	{
		return i.color;
	}
	ENDCG 

	SubShader { 
		ZTest Always Cull Off Fog { Mode Off }
		Pass {
			ColorMask 0 ZWrite Off
			CGPROGRAM
			ENDCG
		}
		Pass {
			ZWrite Off
			CGPROGRAM
			ENDCG
		}
		Pass {
			ColorMask 0
			CGPROGRAM
			ENDCG
		}
		Pass {
			CGPROGRAM
			ENDCG
		}
		Pass {
			ColorMask 0 ZWrite Off
			Stencil { Comp Always Pass Zero }
			CGPROGRAM
			ENDCG
		}
		Pass {
			ZWrite Off
			Stencil { Comp Always Pass Zero }
			CGPROGRAM
			ENDCG
		}
		Pass {
			ColorMask 0
			Stencil { Comp Always Pass Zero }
			CGPROGRAM
			ENDCG
		}
		Pass {
			Stencil { Comp Always Pass Zero }
			CGPROGRAM
			ENDCG
		}
	}
	Fallback Off 
}
