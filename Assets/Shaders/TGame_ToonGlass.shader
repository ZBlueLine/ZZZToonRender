Shader "Tgame/ToonGlass"
{
	Properties 
	{
		[GroupStart]_GlassColorGroup("镜片颜色设置",int) = 0
		[Toggle(_USE_MATCAP)]_MatCapOn("MatCap做法", Float) = 1
		_BaseMap ("Base Map", 2D) = "white" {}
		_Matcap("高光 R:高光形状 G:高光遮罩(根据uv走向画)", 2D) = "black" {}
		_Color1 ("玻璃颜色", Color) = (0, 0.66, 0.73, 0.5)
		[HDR]_Color2 ("高光颜色", Color) = (0, 0.66, 0.73, 0.5)
		[GroupEnd]
		[GroupStart]_SeparateModel("用于拆分出来的镜片模型", int) = 0
		[Toggle(_BINDING_MESH)]_BindingMesh("模型经过绑定勾选此项", int) = 0
		_OffsetScale("高光偏移缩放", Range(0,3)) = 1
		[GroupEnd]

		[GroupStart]_DistortGroup("扭曲溶解设置",int) = 0
		[Toggle]_EnableYAxisDissolve("方向性溶解", int) = 0
		[Toggle]_YAxisDissolveReverse("方向性溶解方向逆转", int) = 0
		_DissolveMap("溶解贴图", 2D) = "white" {}
		_DissolveValue("溶解控制", Range(0, 1)) = 0
		_CharacterHeight("角色身高(用于方向性溶解)", Range(0, 4)) = 1.7
		_DissolveRange("溶解区域宽度(用于方向性溶解)", Range(1, 20)) = 10
		_DissolveEdgeRange("溶解边缘宽度", Range(0, 1)) = 0.05
		[HDR]_DissolveEdgeColor("溶解边缘宽度颜色", Color) = (2.2973969,0.639370024,0.639369905,1)
		[Toggle]_UseDither("开启遮挡溶解",int) = 1
		_Dither("遮挡溶解",Range(0,1)) = 0
		_DitherUV("遮挡溶解密度",Range(1,10)) = 1
		[GroupEnd]


		//[GroupStart]_StencilGroup("模版测试",int) = 0
		//	_Stencil("Stencil Ref",range(0,255)) = 5
		//	[Enum(UnityEngine.Rendering.CompareFunction)]_StencilComp("StencilCompare",int) = 0
		//	[Enum(UnityEngine.Rendering.StencilOp)]_StencilOp("StencilPass",int) = 2
		//      [GroupEnd]

		[GroupStart]_OutlineGroup("描边设置",int) = 0
		[KeywordEnum(Vert, VertexColorSmooth) ] _Normal("平滑法线来源" , Float) = 0
		[NoScaleOffset]_OutlineColorMatcap("描边颜色贴图(黑白matcap)", 2D) = "black" {}
		_OutlineLightColor("描边亮部颜色", Color) = (0, 0, 0, 1)
		_OutlineDarkColor("描边暗部颜色", Color) = (0, 0, 0, 1)
		_OutlineWidth("描边宽度", Range(0, 20)) = 0.79
		[GroupEnd]

		[HideInInspector][Enum(UnityEngine.Rendering.BlendMode)]Src("Src",int) = 5
		[HideInInspector][Enum(UnityEngine.Rendering.BlendMode)]Dst("Dst",int) = 10
		[HideInInspector][Enum(UnityEngine.Rendering.BlendMode)]SrcA("SrcA",int) = 1
		[HideInInspector][Enum(UnityEngine.Rendering.BlendMode)]DstA("DstA",int) = 0

		[HideInInspector][Enum(UnityEngine.Rendering.CullMode)]_Cull("CullMode",int) = 2
		[HideInInspector][Enum(UnityEngine.Rendering.CompareFunction)]_ZTest("ZTest",int) = 4
		[HideInInspector][KeywordEnum(Off,On)]_ZWrite("ZWrite",int) = 1
	}
	SubShader 
	{
		Tags 
		{
			"RenderPipeline"="UniversalPipeline"
			"RenderType"="Transparent"
			"Queue"="Transparent"
		}

		HLSLINCLUDE
		#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

		CBUFFER_START(UnityPerMaterial)
			float4 _BaseMap_ST;
			float4 _Matcap_ST;
			float _Ratation;
			float4 _Color1;
			float4 _Color2;
			float4 _OutlineLightColor;
			float4 _OutlineDarkColor;
			float _OutlineWidth;
			float _OffsetScale;
			//float _ViewDirBlend;
			//DISSOLVE
			int _EnableYAxisDissolve;
			int _YAxisDissolveReverse;
			half _CharacterHeight;
			half _DissolveValue;
			half4 _DissolveEdgeColor;
			float4 _DissolveMap_ST;
			half _DissolveRange;
			half _DissolveEdgeRange;




			float _Dither;
			float _DitherUV;
			half _UseDither;
		CBUFFER_END

		float Unity_Dither(float In, float4 ScreenPosition)
		{
			float2 uv = ScreenPosition.xy * _ScreenParams.xy;
			float DITHER_THRESHOLDS[16] =
			{
				1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
				13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
				4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
				16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
			};
			uint index = (uint(uv.x) % 4) * 4 + uint(uv.y) % 4;
			return In - DITHER_THRESHOLDS[index];
		}

		TEXTURE2D(_OutlineColorMatcap);
		SAMPLER(sampler_OutlineColorMatcap);
		//TEXTURE2D(_HighLightMap);
		//SAMPLER(sampler_HighLightMap);
		TEXTURE2D(_DissolveMap);
		SAMPLER(sampler_DissolveMap);
		TEXTURE2D(_BaseMap);
		SAMPLER(sampler_BaseMap);
		TEXTURE2D(_Matcap);
		SAMPLER(sampler_Matcap);
		ENDHLSL

		Pass 
		{
			Name "Unlit"

			Cull [_Cull]

			Blend[Src][Dst],[SrcA][DstA]
			Cull[_Cull]
			ZTest[_ZTest]
			ZWrite[_ZWrite]

			//Stencil
			//{
				//	Ref[_Stencil]
				//	Comp[_StencilComp]
				//	Pass[_StencilOp]
			//}

			HLSLPROGRAM
			#pragma vertex UnlitPassVertex
			#pragma fragment UnlitPassFragment
			#pragma shader_feature_local _ _USE_MATCAP
			#pragma shader_feature_local _ _BINDING_MESH 

			// Structs
			struct Attributes 
			{

				float4 positionOS	: POSITION;
				float3 normalOS		: NORMAL;
				float4 tangentOS	: TANGENT;
				float2 uv			: TEXCOORD0;
			};

			struct Varyings 
			{
				float4 positionCS 	: SV_POSITION;
				float3 tangentWS 	: TEXCOORD0;
				float3 bitangentWS 	: TEXCOORD1;
				float3 normalWS 	: TEXCOORD2;
				float3 positionWS 	: TEXCOORD3;
				float4 uv 			: TEXCOORD4;
				float4 ScreenPos :TEXCOORD10;
			};
			

			float2 rotateUV(float2 uv, float rotation) 
			{
				float sine = sin(rotation);
				float cosine = cos(rotation);
				
				uv.x = uv.x * cosine - uv.y * sine;
				uv.y = uv.x * sine + uv.y * cosine;

				return uv;
			}

			// Vertex Shader
			Varyings UnlitPassVertex(Attributes IN) 
			{
				Varyings OUT;

				VertexPositionInputs positionInputs = GetVertexPositionInputs(IN.positionOS.xyz);
				OUT.positionCS = positionInputs.positionCS;
				OUT.positionWS = positionInputs.positionWS;

				VertexNormalInputs normalInput = GetVertexNormalInputs(IN.normalOS, IN.tangentOS);
				OUT.tangentWS = normalInput.tangentWS;
				OUT.bitangentWS = normalInput.bitangentWS;
				OUT.normalWS = normalInput.normalWS;
				
				OUT.uv.xy = TRANSFORM_TEX(IN.uv.xy, _BaseMap);
				OUT.uv.zw = TRANSFORM_TEX(IN.uv.xy, _Matcap);
				float4 screenPos = ComputeScreenPos(OUT.positionCS);
				OUT.ScreenPos = screenPos;

				#if defined(_USE_MATCAP)
					float3 cameraUpWS = float3(UNITY_MATRIX_I_V[0][1], UNITY_MATRIX_I_V[1][1], UNITY_MATRIX_I_V[2][1]);
					float3 cameraForwardDirWS = positionInputs.positionWS - _WorldSpaceCameraPos;
					float3 cameraRightDirWS = cross(cameraUpWS, cameraForwardDirWS);
					cameraUpWS = cross(cameraForwardDirWS, cameraRightDirWS);

					cameraUpWS = normalize(cameraUpWS);
					cameraForwardDirWS = normalize(cameraForwardDirWS);
					cameraRightDirWS = normalize(cameraRightDirWS);

					float3x3 matrix_perVertex_MV = float3x3(cameraRightDirWS.x, cameraUpWS.x, cameraForwardDirWS.x,
					cameraRightDirWS.y, cameraUpWS.y, cameraForwardDirWS.y,
					cameraRightDirWS.z, cameraUpWS.z, cameraForwardDirWS.z);

					float2 matcapUV;				
					matcapUV = mul(normalInput.normalWS, matrix_perVertex_MV).xy;
					OUT.uv.zw = matcapUV.xy * 0.5 + 0.5;
				#endif

				return OUT;
			}

			// Fragment Shader
			half4 UnlitPassFragment(Varyings IN) : SV_Target 
			{


				
				//溶解效果
				half2 dissolveCoord =  IN.uv.xy*_DissolveMap_ST.xy+_DissolveMap_ST.zw;
				half dissolveNoise = SAMPLE_TEXTURE2D(_DissolveMap, sampler_DissolveMap, dissolveCoord.xy).r;
				float edge = 0;

				float2 uv = IN.uv.xy;
				half2 MatCapUV = IN.uv.zw;
				half4 BaseColor = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv);
				
				#if defined(_USE_MATCAP)
					half heightLight = SAMPLE_TEXTURE2D(_Matcap, sampler_Matcap, MatCapUV).r;
					half mask = SAMPLE_TEXTURE2D(_Matcap, sampler_Matcap, uv).g;
					heightLight *= mask;
				#else
					float4x4 World_Matrix = GetObjectToWorldMatrix();
					float3 ZeroPositionWS = float3(World_Matrix[0].w, World_Matrix[1].w, World_Matrix[2].w);
					float3 cameraDirHor = _WorldSpaceCameraPos - ZeroPositionWS;
					cameraDirHor.y = 0;
					cameraDirHor = normalize(cameraDirHor);
					float3 headForward = 0;
					#if defined(_BINDING_MESH)
						headForward = float3(UNITY_MATRIX_M[0].y, 0, UNITY_MATRIX_M[2].y);
					#else 
						headForward = float3(UNITY_MATRIX_M[0].z, 0, UNITY_MATRIX_M[2].z);
					#endif
					headForward = normalize(headForward);

					//dot的结果与角度不是线性关系，不适合用于uv偏移，所以先转角度
					float uvOffset = acos(dot(headForward.xz, cameraDirHor.xz)) / (3.1415926535/2);
					half side = sign(cross(cameraDirHor, headForward).y);
					uvOffset *= side * _OffsetScale;
					float2 hightLightUV = IN.uv.zw;
					hightLightUV.x += uvOffset;
					half heightLight = SAMPLE_TEXTURE2D(_Matcap, sampler_Matcap, hightLightUV).r;
				#endif

				BaseColor *= _Color1;
				float4 finalColor = lerp(BaseColor, _Color2, heightLight);
				return finalColor;
			}
			ENDHLSL
		}
		
		Pass
		{
			Name "Outline"
			Tags { "LightMode" = "OutLine" }
			ZWrite On
			Lighting Off
			Cull Front

			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#pragma shader_feature_local _NORMAL_VERT _NORMAL_VERTEXCOLORSMOOTH

			struct Attributes
			{
				float3 positionOS : POSITION;
				float2 texcoord : TEXCOORD0;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 smoothNormal : TEXCOORD2;
				float4 color : COLOR;
			};

			struct Varyings
			{	
				float4 positionCS : SV_POSITION;
				float2 uv: TEXCOORD1;
				float3 normalVS : TEXCOORD2;
				float3 positionWS : TEXCOORD3;
				float4 ScreenPos :TEXCOORD10;
			};

			Varyings vert(Attributes input) 
			{
				Varyings output;
				
				VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS);
				VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);
				output.positionWS = vertexInput.positionWS;
				float3 normalWS = vertexNormalInput.normalWS;

				half width = _OutlineWidth * 0.001;
				float2 offset = 0;
				half4 positionCS = vertexInput.positionCS;
				
				#if defined(_NORMAL_VERTEXCOLORSMOOTH)
					float3 smoothNormalTS = input.color.rgb * 2 - 1;
					float3x3 tbn = float3x3(vertexNormalInput.tangentWS, vertexNormalInput.bitangentWS, vertexNormalInput.normalWS);
					float3 smoothNormalWS  = mul(smoothNormalTS, tbn);
					float3 smoothNormalCS = mul((float3x3) UNITY_MATRIX_VP, smoothNormalWS);
					offset = normalize(smoothNormalCS.xy) * width * vertexInput.positionCS.w;
					positionCS = vertexInput.positionCS;
					if(length(input.color.rgb) > 0.2)
					{
						positionCS.xy += offset;
					}
				#else
					float3 normalCS = mul((float3x3) UNITY_MATRIX_VP, vertexNormalInput.normalWS);
					offset = normalize(normalCS.xy) * width * vertexInput.positionCS.w;
					positionCS.xy += offset;
				#endif
				output.positionCS = positionCS;
				output.uv = input.texcoord;
				output.normalVS = TransformWorldToViewDir(vertexNormalInput.normalWS);
				float4 screenPos = ComputeScreenPos(positionCS);
				output.ScreenPos = screenPos;

				return output;
			}

			half4 frag(Varyings IN) : SV_TARGET
			{
				half2 dissolveCoord =  IN.uv.xy*_DissolveMap_ST.xy+_DissolveMap_ST.zw;
				half dissolveNoise = SAMPLE_TEXTURE2D(_DissolveMap, sampler_DissolveMap, dissolveCoord.xy).r;
				float edge = 0;

				float3 normalVS = normalize(IN.normalVS.xyz);
				normalVS.xy = normalVS.xy * 0.5 - 0.5;
				half gradientColor = SAMPLE_TEXTURE2D(_OutlineColorMatcap, sampler_OutlineColorMatcap, normalVS.xy).r;
				half4 finalColor = lerp(_OutlineDarkColor, _OutlineLightColor, gradientColor);
				return finalColor;
			}
			ENDHLSL
		}
	}
	CustomEditor "ShaderLab.Editor.CommonShaderEditor"
}