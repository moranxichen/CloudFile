Shader "Shader/DiffuseScene"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _EmissionMask("EmissionMask", 2D) = "Black" {}
		_EmissionColor("EmissionColor",Color) = (1,1,1,1)
		_EmissionIntensity("EmissionIntensity",Range(1,2))=1
		_EmissionSaturation("EmissionSaturation",Range(1,2))=1
		
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
	Pass{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
			#include "UnityCG.cginc"
	
			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
	
			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				#ifndef LIGHTMAP_OFF
				half2 uvLM : TEXCOORD1;
				#endif 
				UNITY_FOG_COORDS(1)
			};
	
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _EmissionMask;
	       	float4 _EmissionMask_ST;
	       	fixed4 _EmissionColor;
	       	fixed _EmissionIntensity;
	       	fixed _EmissionSaturation;
	
			v2f vert(appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				#ifndef LIGHTMAP_OFF
				o.uvLM = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
	
			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord);
				fixed4 maskvar = tex2D(_EmissionMask, i.texcoord);
				UNITY_APPLY_FOG(i.fogCoord, col);
				#ifndef LIGHTMAP_OFF
				fixed3 lm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uvLM.xy));
				col.rgb *= lm;

				fixed3 emissvar = col.rgb*_EmissionColor.rgb ;
				fixed gray = 0.2125 * emissvar.r + 0.7154 * emissvar.g + 0.0721 * emissvar.b;
            	fixed3 grayColor = fixed3(gray, gray, gray);
            	float3 finalColor = lerp(grayColor, emissvar, _EmissionSaturation);

				fixed3 outc = lerp(col.rgb,finalColor.rgb*_EmissionIntensity,maskvar.r);
				return fixed4(outc.rgb,1);
				#endif
				return col;
			}
		ENDCG
		}
	}
}
