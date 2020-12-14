// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/BlitCopy" {
	Properties { 
	_MainTex ("", any) = "" {} 
	 //1
	_MainTex_Alpha ("Trans (A)", 2D) = "white" {}
	_UseSecondAlpha("Is Use Second Alpha", int) = 0}
	SubShader { 
		Pass {
 			ZTest Always Cull Off ZWrite Off Fog { Mode Off }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			
			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
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
				o.texcoord = v.texcoord.xy;
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				return tex2D(_MainTex, i.texcoord);
			}
			ENDCG 

		}
	}
	Fallback Off 
}
