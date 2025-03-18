Shader "Hidden/CustomPostProcess/ToonToneMapping" {
	Properties
	{
		_MainTex("Texture", any) = "" {}
		_Color("Multiplicative color", Color) = (1.0, 1.0, 1.0, 1.0)
		_FilmSlopes("Film Slopes", float) = 1
		_FilmToest("Film Slopes", float) = 1
		_FilmShoulderg("Film Slopes", float) = 0.32
		_FilmShouldergt("Film Slopes", float) = 0.32
		_FilmBlackClipe("Film Slopes", float) = 1.33
		_FilmBlackClipet("Film Slopes", float) = 0
	}
	SubShader{
		Pass {
			ZTest Always Cull Off ZWrite Off

			HLSLPROGRAM
			#pragma vertex FullscreenVert
			#pragma fragment FragToneMapping
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			float _FilmSlopes;
			float _FilmToest;
			float _FilmShoulderg;
			float _FilmShouldergt;
			float _FilmBlackClipe;
			float _FilmBlackClipet;

			TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);

			uniform float4 _MainTex_ST;
			uniform float4 _Color;

			float Wvalue(float x, float e0, float e1)
			{

				float a = saturate((x - e0) / (e1 - e0));
				return a * a * (3 - 2 * a);
			}
			float Hvalue(float x, float e0, float e1)
			{
				return saturate((x - e0) / (e1 - e0));
			}

			float NewTonamap(float x, float a, float b, float c, float d, float e, float f)
			{
				float l0 = (a - c) * d / b;
				float L_x = c + b * (x - c);
				float T_x = c * pow(x / c, e) + f;
				float S0 = c + l0;
				float S1 = c + b * l0;
				float C2 = b * b / (b - S1);
				float S_x = b - (b - S1) * pow(e, -(C2 * (x - S0) / b));
				float w0_x = 1 - Wvalue(x, 0, c);
				float w2_x = Hvalue(x, c + l0, c + l0);
				float w1_x = 1 - w0_x - w2_x;
				float f_x = T_x * w0_x + L_x * w1_x + S_x * w2_x;
				return f_x;
			}

			float3 ToonTonemapping(float3 x, float FilmSlopes, float FilmToest, float FilmShoulderg, float FilmShouldergt, float FilmBlackClipe, float FilmBlackClipet)
			{
				 //float a = 1;
				 //float b = 1;
				 //float c = 0.32;
				 //float d = 0.32;
				 //float e = 1.33;
				 //float f = 0;

				 float a = FilmSlopes;
				 float b = FilmToest;
				 float c = FilmShoulderg;
				 float d = FilmShouldergt;
				 float e = FilmBlackClipe;
				 float f = FilmBlackClipet;

				 x.r = NewTonamap(x.r, a, b, c, d, e, f);
				 x.g = NewTonamap(x.g, a, b, c, d, e, f);
				 x.b = NewTonamap(x.b, a, b, c, d, e, f);

				 return x;
			 }

			 half4 EncodeHDR(half3 color)
			 {
		 #if _USE_RGBM
				 half4 outColor = EncodeRGBM(color);
		 #else
				 half4 outColor = half4(color, 1.0);
		 #endif

		 #if UNITY_COLORSPACE_GAMMA
				 return half4(sqrt(outColor.xyz), outColor.w); // linear to γ
		 #else
				 return outColor;
		 #endif
			 }

			 half3 DecodeHDR(half4 color)
			 {
		 #if UNITY_COLORSPACE_GAMMA
				 color.xyz *= color.xyz; // γ to linear
		 #endif

		 #if _USE_RGBM
				 return DecodeRGBM(color);
		 #else
				 return color.xyz;
		 #endif
			 }



			 struct Attributes
			 {
			#if _USE_DRAW_PROCEDURAL
				uint vertexID     : SV_VertexID;
			#else
				float4 positionOS : POSITION;
				float2 uv         : TEXCOORD0;
			#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
			 };

			 struct Varyings
			 {
				 float4 positionCS : SV_POSITION;
				 float2 uv         : TEXCOORD0;
				 UNITY_VERTEX_OUTPUT_STEREO
			 };
			Varyings FullscreenVert(Attributes input)
			{
				Varyings output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

			#if _USE_DRAW_PROCEDURAL
				output.positionCS = GetQuadVertexPosition(input.vertexID);
				output.positionCS.xy = output.positionCS.xy * float2(2.0f, -2.0f) + float2(-1.0f, 1.0f); //convert to -1..1
				output.uv = GetQuadTexCoord(input.vertexID) * _ScaleBias.xy + _ScaleBias.zw;
			#else
				output.positionCS = TransformObjectToHClip(input.positionOS.xyz);
				output.uv = input.uv;
			#endif

				return output;
			}

			half4 FragToneMapping(Varyings i) : SV_Target
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				half3 color = DecodeHDR(SAMPLE_TEXTURE2D_X(_MainTex, sampler_MainTex, i.uv));
				color = ToonTonemapping(color, _FilmSlopes, _FilmToest, _FilmShoulderg, _FilmShouldergt, _FilmBlackClipe, _FilmBlackClipet);
				return EncodeHDR(color);
			}
			ENDHLSL
		}
	}
	Fallback Off
}