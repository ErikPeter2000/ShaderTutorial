// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/SingleColor"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1) // color with default white
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float4 vert (float4 vertex: POSITION) : SV_POSITION // spell inputs exactly, and return only the clip position
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
