Shader "Lit/CustomDiffuse"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OccMap ("Occlusion", 2D) = "white" {}
        _BumpMap ("Normal", 2D) = "bump" {}
    }
    SubShader
    {
        Pass
        {
            Tags {"LightMode"="ForwardBase"} // this shader is a forward base pass. It will get the ambient and main lighting data.

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight // compile shader into multiple variant. Tutorial didnt give much detail
            #include "AutoLight.cginc"

            struct v2f
            {
                float3 worldPos : TEXCOORD0;
                
                half3 tspace0 : TEXCOORD1; 
                half3 tspace1 : TEXCOORD2; 
                half3 tspace2 : TEXCOORD3; 

                float2 uv : TEXCOORD4;
                float4 pos : SV_POSITION;

                SHADOW_COORDS(5) // put shadows data into TEXCOORD5
            };

            sampler2D _MainTex;
            sampler2D _BumpMap;
            sampler2D _OccMap;
            float4 _MainTex_ST;

            v2f vert (appdata_base v, float4 tangent : TANGENT)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                half3 wNormal = UnityObjectToWorldNormal(v.normal);
                half3 wTangent = UnityObjectToWorldDir(tangent.xyz);
                
                half tangentSign = tangent.w * unity_WorldTransformParams.w;
                half3 wBitangent = cross(wNormal, wTangent) * tangentSign;
                
                o.tspace0 = half3(wTangent.x, wBitangent.x, wNormal.x);
                o.tspace1 = half3(wTangent.y, wBitangent.y, wNormal.y);
                o.tspace2 = half3(wTangent.z, wBitangent.z, wNormal.z);

                o.uv = v.texcoord;

                TRANSFER_SHADOW(o)

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half3 tnormal = UnpackNormal(tex2D(_BumpMap, i.uv));

                half3 worldNormal;
                worldNormal.x = dot(i.tspace0, tnormal);
                worldNormal.y = dot(i.tspace1, tnormal);
                worldNormal.z = dot(i.tspace2, tnormal);

                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz)); // calculate the dot product between the normal and the light direction

                fixed4 diff = nl * _LightColor0; // apply the light color to the diffuse color
                fixed3 ambient = ShadeSH9(half4(worldNormal,1)); // illumintaion from probes

                fixed shadow = SHADOW_ATTENUATION(i);

                fixed3 lighting = diff*shadow + ambient;


                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 occ = tex2D(_OccMap, i.uv);
                col.rgb *= lighting;
                col *= occ;
                return col;
            }
            ENDCG
        }

        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
