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

            struct v2f
            {
                float3 worldPos : TEXCOORD0;
                
                half3 tspace0 : TEXCOORD1; 
                half3 tspace1 : TEXCOORD2; 
                half3 tspace2 : TEXCOORD3; 

                float2 uv : TEXCOORD4;
                float4 pos : SV_POSITION;
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
                diff.rgb += ShadeSH9(half4(worldNormal,1)); // add illumination from othe light probes

                fixed4 occ = tex2D(_OccMap, i.uv);

                fixed4 col = tex2D(_MainTex, i.uv);
                col *= diff;
                col *= occ;
                return col;
            }
            ENDCG
        }

        Pass // This new pass will calculate shadows
        {
            Tags {"LightMode"="ShadowCaster"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
            #include "UnityCG.cginc"

            struct v2f { 
                V2F_SHADOW_CASTER;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
}