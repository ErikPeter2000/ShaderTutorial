// This is High Level Shader Language (HLSL) code. It is used to define how the GPU should render the mesh.

Shader "Unlit/NewUnlitShader" // This is the name of the shader
{
    Properties // This is where you define all the properties you want to be able to change in the material inspector
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader // Multiple subshaders can be used to define different shaders for different gpus. We only use one here.
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass // A pass represents an execution of a vertex and pixel shading algorithm. Sometime multiple passes are needed when interacting with lighting.
        {
            CGPROGRAM // This is where the fun stuff happens. This is where you define the vertex and pixel shaders.
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
