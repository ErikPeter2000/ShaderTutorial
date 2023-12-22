// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Here, I use the object's normals and position to reflect the view direction onto the sky, and then sample the skybox's color.

Shader "Unlit/SkyReflection"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                half3 worldRefl : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            v2f vert (float4 vertex : POSITION, float3 normal : NORMAL)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                float3 worldPos = mul(unity_ObjectToWorld, vertex).xyz; // comput world pos of vertex
                float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos)); // compute world view direction
                float3 worldNormal = UnityObjectToWorldNormal(normal); // compute world normal
                o.worldRefl = reflect(-worldViewDir, worldNormal); // compute world reflection vector
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, i.worldRefl); // sample skybox
                half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR); // decode HDR color
                fixed4 c = 0;
                c.rgb = skyColor;
                return c;
            }
            ENDCG
        }
    }
}
