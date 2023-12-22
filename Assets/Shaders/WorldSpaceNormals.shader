Shader "Unlit/WorldSpaceNormals"
{
    // no props
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc" // this library contains the UnityObjectToWorldNormal helper function

            struct v2f
            {
                half3 worldNormal : TEXCOORD0;
                float4 pos : SV_POSITION; // SV_POSITION defines a position in clip space, whilst POSITION is a user-defined postion in any space
            };

            v2f vert (float4 vertex : POSITION, float3 normal : NORMAL)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.worldNormal = UnityObjectToWorldNormal(normal); // UnityCG.cginc file contains function to transform normal from object to world space
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 c = 0;
                c.rgb = i.worldNormal*0.5+0.5; // transform normal from [-1,1] to [0,1]
                return c;
            }
            ENDCG
        }
    }
}
