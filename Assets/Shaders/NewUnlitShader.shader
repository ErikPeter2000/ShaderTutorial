shader "Unlit/NewUnlitShader" // This is the name of the shader
{
    Properties // This is where you define all the properties you want to be able to change in the material inspector
    {
        // removed scale offset so it doesnt appear in editor
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader // Multiple subshaders can be used to define different shaders for different gpus. We only use one here.
    {
        Pass // A pass represents an execution of a vertex and pixel shading algorithm. Sometime multiple passes are needed when interacting with lighting.
        {
            CGPROGRAM // This is where the fun stuff happens. Here you define the vertex and pixel shaders.
            #pragma vertex vert // vertex shader function
            #pragma fragment frag // pixel shader function

            struct appdata // vertex shader inputs
            {
                // POSITION and TEXCOORD0 are Semantic Signifiers, they tell the GPU what the variables are.
                float4 vertex : POSITION; // vertex position
                float2 uv : TEXCOORD0; // texture coordinate
            };

            struct v2f // vertex shader outputs
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v) // vertex shader
            {
                v2f o;
                // transform position to clip space. Clip space is used by the GPU to determine which vertices whould be rendered and which are not visible.
                // (multiply with model*view*projection matrix)
                o.vertex = UnityObjectToClipPos(v.vertex);
                // just pass the texture coordinate
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex; // texture to sample

            fixed4 frag (v2f i) : SV_Target // pixel shader that returns the color represented as a low-precision fixed4.
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG // end of the shader program
        }
    }
}
