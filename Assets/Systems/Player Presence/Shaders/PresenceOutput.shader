Shader "Presence/Output"
{
    Properties
    {
        _PresenceInputTexture ("Presence Input", 2D) = "black" {}
        _PresenceBuildRate ("Build Rate", Range(0, 5)) = 0.1
        _PresenceDecayRate ("Decay Rate", Range(0, 5)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _PresenceInputTexture;
            float4 _PresenceInputTexture_ST;

            uniform sampler2D _LastFrameTexture;
            uniform float4 _LastFrameTexture_ST;

            half _PresenceBuildRate;
            half _PresenceDecayRate;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _PresenceInputTexture);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the previous and new input data
                fixed4 previousFrameData = tex2D(_LastFrameTexture, i.uv);
                fixed4 newInputData = tex2D(_PresenceInputTexture, i.uv);

                // extract out the presence intensity
                fixed previousPresence = previousFrameData.r;
                fixed newPresence = newInputData.r;

                // decay the previous presence
                previousPresence = clamp(previousPresence - _PresenceDecayRate * unity_DeltaTime.x, 0, 1);

                // calculate the new presence value
                newPresence = clamp(previousPresence + (newPresence * _PresenceBuildRate * unity_DeltaTime.x), 0, 1);

                return fixed4(newPresence, newPresence, newPresence, 1);
            }
            ENDCG
        }
    }
}
