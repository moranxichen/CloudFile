Shader "Shader/DiffuseProbes"{
	Properties{
		_MainColor("MainColor",Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}

		_EmissionMask("EmissionMask", 2D) = "Black" {}
		_EmissionColor("EmissionColor",Color) = (1,1,1,1)
		_EmissionIntensity("EmissionIntensity",Range(1,2))=1
		_LightX ("LightX", Range(-1, 1)) = 0.5
        _LightY ("LightY", Range(-1, 1)) = 0.5
        _LightZ ("LightZ", Range(-1, 1)) = 0.5
        _LBTIntensity("LBTIntensity",Range(1,5))=1
        _LBTBackColor("LBTBackColor",Color) = (0.2,0.2,0.2,1)

        _OutlineWidth("OutlineWidth",Range(0,1))=0
	}

		SubShader{
			Tags { "Queue" = "Geometry""LightMode" = "ForwardBase""RenderType" = "Opaque"   }
			LOD 100

			Pass
        {
            name "outline"
            Cull Front
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
            fixed _OutlineWidth;

            v2f vert (appdata v){
                v2f o;
                // o.vertex = UnityObjectToClipPos(v.vertex+v.normal*float4(_OutlineWidth,_OutlineWidth,_OutlineWidth,0));
                o.uv = v.uv;
                v.vertex.xyz += v.normal * _OutlineWidth;
				o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 _OutlineColor;
            fixed4 frag (v2f i) : SV_Target
            {
                // fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 col = _OutlineColor;
                return col;
            }
            ENDCG
        }

			Pass {
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fog

				#include "UnityCG.cginc"

				struct v2f {
					float4 vertex : SV_POSITION;
					half2 texcoord : TEXCOORD0;
					fixed3  SHLighting : COLOR;
					fixed3 worldNormal :TEXCOORD1;
					UNITY_FOG_COORDS(1)
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float4 _MainColor;
				fixed _LightX;
       			fixed _LightY;
       			fixed _LightZ;
       			sampler2D _EmissionMask;
       			float4 _EmissionMask_ST;
       			fixed4 _EmissionColor;
       			fixed _LBTIntensity;
       			fixed4 _LBTBackColor;
       			fixed _EmissionIntensity;

				v2f vert(appdata_base v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.worldNormal = UnityObjectToWorldNormal(v.normal);
					o.SHLighting = ShadeSH9(float4(o.worldNormal,1));
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					i.worldNormal = normalize(i.worldNormal);
					fixed4 col = tex2D(_MainTex, i.texcoord);
					fixed4 maskvar = tex2D(_EmissionMask, i.texcoord);

					float lbt = dot(float3(_LightX,_LightY,_LightZ),i.worldNormal);

					float lbt_var = (lbt*0.5)+0.5;

					float4 lbtback = (pow(lbt_var*-1,2))*_LBTBackColor;

					float3 lbtc = lerp((lbt_var*_MainColor).rgb,lbtback.rgb,lbt) ;

					col.rgb *= i.SHLighting;


					UNITY_APPLY_FOG(i.fogCoord, col);
					// UNITY_OPAQUE_ALPHA(col.a);

					fixed4 maincolor = fixed4(col.rgb*(lbtback*_LBTIntensity) , 1);

					fixed3 outc = lerp(maincolor.rgb,_EmissionColor.rgb*_EmissionIntensity,maskvar.r);

					return fixed4 (outc.rgb,1) ;
				}
			ENDCG
		}
	}

}
