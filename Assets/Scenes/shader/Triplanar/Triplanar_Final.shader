Shader "Custom/TriplanarURP" {
    Properties {
        _TopTex("TopTexture", 2D) = "white" {}
        _SideTex("SideTexture", 2D) = "white" {}
        _BlendOffset("BlendOffset",Range(0,0.5)) = 0.25
        _BlendExponent ("Blend Exponent", Range(1, 8)) = 2
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        Pass {
            Name "ForwardLit"
            Tags { "LightMode"="UniversalForward" }
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct Attributes {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
            };

            struct Varyings {
                float4 positionHCS : SV_POSITION;
                float3 normalWS : TEXCOORD1;
                float4 worldPos : TEXCOORD2;
            };

            TEXTURE2D(_TopTex);
            SAMPLER(sampler_TopTex);
            TEXTURE2D(_SideTex);
            SAMPLER(sampler_SideTex);
            float4 _TopTex_ST, _SideTex_ST;
            float _BlendOffset;
            half _BlendExponent;

            struct TriUV {
                float2 xUV, yUV, zUV;
            };

            TriUV GetTriUV(float4 worldpos) {
                TriUV triUV;
                triUV.xUV = worldpos.zy;
                triUV.yUV = worldpos.zx;
                triUV.zUV = worldpos.xy;
                return triUV;
            }

            float3 GetTriWeights(float3 normal) {
                float3 weights = abs(normal);
                weights = saturate(weights - _BlendOffset);
                weights = pow(weights, _BlendExponent);
                return weights / (weights.x + weights.y + weights.z);
            }

            Varyings vert(Attributes input) {
                Varyings output;
                output.positionHCS = TransformObjectToHClip(input.positionOS);
                output.normalWS = TransformObjectToWorldNormal(input.normalOS);
                output.worldPos = mul(UNITY_MATRIX_M, input.positionOS);
                return output;
            }

            half4 frag(Varyings input) : SV_Target {
                TriUV triuv = GetTriUV(input.worldPos);
                half4 colx = SAMPLE_TEXTURE2D(_SideTex, sampler_SideTex, triuv.xUV * _SideTex_ST.xy + _SideTex_ST.zw);
                half4 coly = SAMPLE_TEXTURE2D(_TopTex, sampler_TopTex, triuv.yUV * _TopTex_ST.xy + _TopTex_ST.zw);
                half4 colz = SAMPLE_TEXTURE2D(_SideTex, sampler_SideTex, triuv.zUV * _SideTex_ST.xy + _SideTex_ST.zw);
                float3 weights = GetTriWeights(input.normalWS);
                half4 tricol = colx * weights.x + coly * weights.y + colz * weights.z;

				// tricol.xyz = input.normalWS;
				tricol=tricol*5;
				// tricol=pow(tricol,2);
                return input.worldPos;
            }
            ENDHLSL
        }
    }
}