Shader "Tgame/Character/OutLine"
{
    Properties
    {
        [GroupStart]_OutlineGroup("描边设置",int) = 0
        [KeywordEnum(Vert, VertexColorSmooth) ] _Normal("平滑法线来源" , Float) = 0
        [Toggle]_Binding("UV3Smooth模式且模型有绑定请勾选此项" , Float) = 0
        [NoScaleOffset]_OutlineColorMatcap("描边颜色贴图(黑白matcap)", 2D) = "black" {}
        _OutlineLightColor("描边亮部颜色", Color) = (0, 0, 0, 1)
        _OutlineDarkColor("描边暗部颜色", Color) = (0, 0, 0, 1)
        _OutlineWidth("描边宽度", Range(0, 20)) = 0.79
        _Offsetx("描边偏移X",Float) = 0
        _Offsety("描边偏移Y",Float) = 0
        [GroupEnd]

        [GroupStart]_StencilGroup("模版测试",int) = 0
        _Stencil("Stencil Ref",range(0,255)) = 5
        [Enum(UnityEngine.Rendering.CompareFunction)]_StencilComp("StencilCompare",int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)]_StencilOp("StencilPass",int) = 2
        [GroupEnd]

        [HideInInspector][Enum(UnityEngine.Rendering.BlendMode)]Src("Src",int) = 1
        [HideInInspector][Enum(UnityEngine.Rendering.BlendMode)]Dst("Dst",int) = 0
        [HideInInspector][Enum(UnityEngine.Rendering.BlendMode)]SrcA("SrcA",int) = 1
        [HideInInspector][Enum(UnityEngine.Rendering.BlendMode)]DstA("DstA",int) = 0

        [HideInInspector][Enum(UnityEngine.Rendering.CullMode)]_Cull("CullMode",int) = 2
        [HideInInspector][Enum(UnityEngine.Rendering.CompareFunction)]_ZTest("ZTest",int) = 4
        [HideInInspector][KeywordEnum(Off,On)]_ZWrite("ZWrite",int) = 1
    }

    HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        CBUFFER_START(UnityPerMaterial)
            //Outline
            float _Binding;
            float4 _OutlineLightColor;
            float4 _OutlineDarkColor;
            float _OutlineWidth;
        CBUFFER_END

        uniform float3 _LirDir;
        uniform float4 _CustomLightColor;
        uniform float _CustomLightColorIntensity;
        uniform float _ShadowIntensity;
        uniform float4 _CustomShadowColor;

        TEXTURE2D(_FaceMap);
        TEXTURE2D(_StockingMap);
        TEXTURE2D(_StockingMatcap);
        TEXTURE2D(_MetalMatCap);
        TEXTURE2D(_BumpShadowMap);
        TEXTURE2D(_BaseMap);
        TEXTURE2D(_LightMap);
        TEXTURE2D(_SecondLayerColorMap);
        TEXTURE2D(_ThirdLayerColorMap);
        TEXTURE2D(_ShadowColorMap);
        TEXTURE2D(_RimLightWidthMap);
        TEXTURE2D(_RimLightMatcap);
        TEXTURE2D(_DissolveMap);
        TEXTURE2D(_OutlineColorMatcap);
        TEXTURE2D(_HairShadowRT);

        SAMPLER(sampler_LinearClamp);
        SAMPLER(sampler_LinearRepeat);
        SAMPLER(sampler_PointRepeat);


        float Remap01ToOtherRange(float In, float2 OutMinMax)
        {
            return OutMinMax.x + In * (OutMinMax.y - OutMinMax.x);
        }
    ENDHLSL

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque" "IgnoreProjector" = "True" "RenderPipeline" = "UniversalPipeline" "ShaderModel"="2.0"
        }
        LOD 300

		Pass
		{
			Name "Outline"
			// Tags { "LightMode" = "OutLine" }
			ZWrite On
			
			Cull Front
			Offset [_Offsetx], [_Offsety]
			
			Stencil
			{
				Ref[_Stencil]
				Comp[_StencilComp]
				Pass[_StencilOp]
			}



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

				//	
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
				#if defined(_NORMAL_UV3SMOOTH)
					float3 linearRawData = input.smoothNormal;
					linearRawData = _Binding > 0.1 ? float3(-linearRawData.y, linearRawData.z, -linearRawData.x) : linearRawData;
					float3 smoothNormalWS  = TransformObjectToWorldNormal(linearRawData);
					float3 smoothNormalCS = mul((float3x3) UNITY_MATRIX_VP, smoothNormalWS);
					offset = normalize(smoothNormalCS.xy) * width * vertexInput.positionCS.w;
					positionCS = vertexInput.positionCS;
					offset *= input.color.r;
					positionCS.xy += offset;
					
				#elif defined(_NORMAL_VERTEXCOLORSMOOTH)
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
				float4 screenPos = ComputeScreenPos(output.positionCS);
				output.ScreenPos = screenPos;
				return output;
			}

			half4 frag(Varyings input) : SV_TARGET
			{
				float3 normalVS = normalize(input.normalVS.xyz);
				normalVS.xy = normalVS.xy * 0.5 - 0.5;
				half gradientColor = SAMPLE_TEXTURE2D(_OutlineColorMatcap, sampler_LinearRepeat, normalVS.xy).r;
				half4 finalColor = lerp(_OutlineDarkColor, _OutlineLightColor, gradientColor);
				return finalColor;
			}
			ENDHLSL
		}
        
        Pass
        {
            Name "DepthOnly"
            Tags{"LightMode" = "DepthOnly"}

            ZWrite On
            ColorMask 0
			Cull Front
			Offset [_Offsetx], [_Offsety]

            HLSLPROGRAM

            #pragma vertex DepthOnlyVertex
            #pragma fragment DepthOnlyFragment
			
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

				//	
			};

			Varyings DepthOnlyVertex(Attributes input)
			{
				Varyings output;
				
				VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS);
				VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);
				output.positionWS = vertexInput.positionWS;
				float3 normalWS = vertexNormalInput.normalWS;

				half width = _OutlineWidth * 0.001;
				float2 offset = 0;
				half4 positionCS = vertexInput.positionCS;
				#if defined(_NORMAL_UV3SMOOTH)
					float3 linearRawData = input.smoothNormal;
					linearRawData = _Binding > 0.1 ? float3(-linearRawData.y, linearRawData.z, -linearRawData.x) : linearRawData;
					float3 smoothNormalWS  = TransformObjectToWorldNormal(linearRawData);
					float3 smoothNormalCS = mul((float3x3) UNITY_MATRIX_VP, smoothNormalWS);
					offset = normalize(smoothNormalCS.xy) * width * vertexInput.positionCS.w;
					positionCS = vertexInput.positionCS;
					offset *= input.color.r;
					positionCS.xy += offset;
					
				#elif defined(_NORMAL_VERTEXCOLORSMOOTH)
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
				float4 screenPos = ComputeScreenPos(output.positionCS);
				output.ScreenPos = screenPos;
				return output;
			}

			half4 DepthOnlyFragment(Varyings input) : SV_TARGET
			{
				return 0;
			}
            ENDHLSL

        }
        
	}

	FallBack "Hidden/Universal Render Pipeline/FallbackError"
	CustomEditor "ShaderLab.Editor.CommonShaderEditor"
}