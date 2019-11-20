// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:33037,y:32784,varname:node_3138,prsc:2|emission-4221-OUT;n:type:ShaderForge.SFN_TexCoord,id:6828,x:30852,y:32515,varname:node_6828,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Floor,id:5301,x:32390,y:32721,varname:node_5301,prsc:2|IN-1197-OUT;n:type:ShaderForge.SFN_Multiply,id:3570,x:31236,y:32691,varname:node_3570,prsc:2|A-6828-U,B-1340-OUT;n:type:ShaderForge.SFN_Slider,id:1340,x:30852,y:32710,ptovrint:False,ptlb:U,ptin:_U,varname:node_1340,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:10,max:10;n:type:ShaderForge.SFN_Noise,id:8216,x:32573,y:32721,varname:node_8216,prsc:2|XY-5301-OUT;n:type:ShaderForge.SFN_Multiply,id:6826,x:31236,y:32885,varname:node_6826,prsc:2|A-6828-V,B-973-OUT;n:type:ShaderForge.SFN_Slider,id:973,x:30852,y:32956,ptovrint:False,ptlb:V,ptin:_V,varname:_node_1340_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:10,max:10;n:type:ShaderForge.SFN_Append,id:1197,x:32213,y:32721,varname:node_1197,prsc:2|A-136-OUT,B-1737-OUT;n:type:ShaderForge.SFN_Floor,id:4221,x:32752,y:33129,varname:node_4221,prsc:2|IN-6290-OUT;n:type:ShaderForge.SFN_ComponentMask,id:3082,x:32642,y:32922,varname:node_3082,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-8216-OUT;n:type:ShaderForge.SFN_Add,id:6290,x:32592,y:33129,varname:node_6290,prsc:2|A-3082-OUT,B-8839-OUT;n:type:ShaderForge.SFN_Vector1,id:8839,x:32418,y:33163,varname:node_8839,prsc:2,v1:0.1;n:type:ShaderForge.SFN_Add,id:136,x:31757,y:32587,varname:node_136,prsc:2|A-4908-OUT,B-3570-OUT;n:type:ShaderForge.SFN_Slider,id:9283,x:31313,y:32752,ptovrint:False,ptlb:Random,ptin:_Random,varname:node_9283,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Add,id:1737,x:31763,y:32987,varname:node_1737,prsc:2|A-4908-OUT,B-6826-OUT;n:type:ShaderForge.SFN_Multiply,id:4908,x:31763,y:32791,varname:node_4908,prsc:2|A-3610-OUT,B-1892-OUT;n:type:ShaderForge.SFN_Vector1,id:1892,x:31589,y:32893,varname:node_1892,prsc:2,v1:5;n:type:ShaderForge.SFN_Floor,id:3610,x:31615,y:32731,varname:node_3610,prsc:2|IN-9283-OUT;proporder:1340-973-9283;pass:END;sub:END;*/

Shader "Shader Forge/2" {
    Properties {
        _U ("U", Range(0, 10)) = 10
        _V ("V", Range(0, 10)) = 10
        _Random ("Random", Range(0, 10)) = 0
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float _U;
            uniform float _V;
            uniform float _Random;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                float node_4908 = (floor(_Random)*5.0);
                float2 node_5301 = floor(float2((node_4908+(i.uv0.r*_U)),(node_4908+(i.uv0.g*_V))));
                float2 node_8216_skew = node_5301 + 0.2127+node_5301.x*0.3713*node_5301.y;
                float2 node_8216_rnd = 4.789*sin(489.123*(node_8216_skew));
                float node_8216 = frac(node_8216_rnd.x*node_8216_rnd.y*(1+node_8216_skew.x));
                float node_4221 = floor((node_8216.r+0.1));
                float3 emissive = float3(node_4221,node_4221,node_4221);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
