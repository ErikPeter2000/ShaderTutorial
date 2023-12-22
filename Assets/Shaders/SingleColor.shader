Shader "Unlit/SingleColor" // the name of the shader, and category
{
    Properties // the inputs for the shader
    {
        _Color ("Main Color", Color) = (1,1,1,1) // color with default white
    } 
    // a subshader is a part of a shader that will run on a specific hardware configuration
    // we don't need to worry about this for now
    SubShader 
    {
        Pass // a pass represents a single rendering pass. Usually only one is needed, but more can be used for specific lighting effects like casting shadows.
        {
            CGPROGRAM // This defines where the main shader code is.
            #pragma vertex vert // define the vertex shader
            #pragma fragment frag // define the fragment shader

            // POSITION and SV_POSITION are semantic descriptors that describe the variable to the GPU
            // the vertex shader only needs to return the position of the vertex in clip space
            float4 vert (float4 vertex: POSITION) : SV_POSITION
			{
				return UnityObjectToClipPos(vertex);
			}

            fixed4 _Color;
            fixed4 frag () : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
