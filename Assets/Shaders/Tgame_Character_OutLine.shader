Shader "Tgame/Character/OutLine"
{
    Properties
    {
        [GroupStart]_BaseGroup("基础贴图",int) = 0
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        [NoScaleOffset] _BaseMap("Base Map", 2D) = "white" {}
        [NoScaleOffset]_SecondLayerColorMap("过渡区颜色", 2D) = "white" {}
        [NoScaleOffset]_ThirdLayerColorMap("暗部基颜色", 2D) = "white" {}
        [GroupEnd]

        [GroupStart]_LightGroup("光照设置",int) = 0
        [NoScaleOffset][Linear]_LightMap("Light Map R:光照分色对比度， G:金属度， B:高光亮度， A:光滑度 (面部不需要这张图)", 2D) = "black" {}
        _Smooth("Smooth", Range(0, 1)) = 1

        [HDR]_EmissionColor("Emission Color", Color) = (0, 0, 0, 1)
        [Space(20)]

        [NoScaleOffset][Linear]_BumpShadowMap("Normal Map RG:法线 B:明暗偏移 A:自发光", 2D) = "white" {}
        _BumpScale("Normal Map Strength", Float) = 1
        [Space(20)]

        [Header(Diffuse Setting)]
        _FirstLayerColor("受光区颜色", Color) = (1, 1, 1, 1)
        _SSSColor("SSS颜色", Color) = (0.848, 0.7497263, 0.721648, 1)
        _SecondLayerColor("过渡区颜色", Color) = (0.848, 0.7497263, 0.721648, 1)
        _ThirdLayerColor("暗部颜色", Color) = (0.8, 0.5584577, 0.5215999, 1)
        _ShadowThresholdCenter("一层光照分色位置", Range(0.5, 1)) = 0.7
        _SecondShadowThresholdCenter("二层光照分色位置", Range(0.5, 1)) = 0.4
        _ShadowThresholdSoftness("一层光照对比度(脸部模型只需要调这个)", Range(0, 1)) = 0.083
        _SecondShadowThresholdSoftness("二层光照对比度", Range(0, 1)) = 0.075
        _MainLightColorUsage("主光颜色饱和度", Range(0, 1)) = 1
        [Space(20)]
        [Header(Specular Setting)]
        _SpecularExpon("非金属高光聚集", Range(1, 30)) = 1.3
        _SpecularBrightness("非金属高光整体亮度", Range(0, 40)) = 2.4
        
        _MetalSpecularExpon("金属高光聚集", Range(1, 30)) = 3.5
        _MetalSpecularBrightness("金属高光整体亮度", Range(0, 20)) = 3.63
        [Space(20)]

        [Header(IndirectLight Setting)]
        [NoScaleOffset]_MetalMatCap("金属间接光Matcap", 2D) = "black" {}
        [HideInInspector]_SpecularKsNonMetal("非金属反射系数", Float) = 0.04
        [HideInInspector]_SpecularKsMetal("金属反射系数", Float) = 1
        _SHLightingStrength("非金属间接光强度", Range(0, 5)) = 1
        _MetalMatCapStrength("金属间接光强度", Range(0, 3)) = 0.64
        _IndirectLightMixBaseColor("间接光混合主贴图颜色", Range(0, 1)) = 1
        [GroupEnd]

        [GroupStart]_StockingAreaGroup("丝袜控制",int) = 0
        [Toggle(_AREA_STOCKING)]_StockingArea("丝袜区域", int) = 0
        [NoScaleOffset][Linear]_StockingMap("丝袜贴图", 2D) = "black" {}
        [NoScaleOffset]_StockingMatcap("丝袜Matcap", 2D) = "black" {}
        _StockingTint("丝袜颜色", Color) = (0.8, 0.5584577, 0.5215999, 1)
        _StockingRefractDepth("折射深度", Range(0, 1)) = 0.5
        [GroupEnd]

        [GroupStart]_FaceGroup("面部控制",int) = 0
        [Toggle(_AREA_FACE)]_FaceArea("面部区域", int) = 0
        [Toggle(_BINDING_MESH)]_BindingMesh("模型经过绑定勾选此项", int) = 0
        [NoScaleOffset][Linear]_FaceMap("面部阴影控制图 R:SDF G:高光维持区域 B:亮部光感Mask A:头发阴影区域", 2D) = "white" {}
        [Space(10)]
        [Toggle(_HARI_SHADOW)]_HairShadowOn("开启头发阴影", int) = 0
        _HairShadowDistance("头发阴影偏移(脸部模型上调)", Range(0, 4)) = 1
        [GroupEnd]

        [GroupStart]_RimGroup("边缘光设置",int) = 0
        [NoScaleOffset][Linear]_RimLightWidthMap("边缘光控制贴图 R:亮度 G:宽度", 2D) = "white"{}
        [Toggle]_LightSideRim("单边边缘光", float) = 0
        [Toggle(_SIDERIM_MATCAP)]_RimMatcapOn("边缘光Matcap遮罩", int) = 0
        [NoScaleOffset][Linear]_RimLightMatcap("边缘光Matcap", 2D) = "black"{}
        _RimLightWidth("边缘光宽度", Range(0, 2)) = 0.246
        _RimLightSoft("边缘光软硬", Range(0, 0.5)) = 0.1
        _RimLightMixAlbedo("边缘光混合主贴图颜色", Range(0, 1)) = 1
        
        [Toggle(_DEPTH_RIMLIGHT)]_DepthRim("深度边缘光", float) = 0
        _RimLightThreshold("深度边缘光阈值", Range(0, 1)) = 1

        [HDR]_RimLightTintColor("边缘光颜色", Color) = (0.7, 0.7, 0.7, 1)
        [GroupEnd]

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
            float4 _BaseMap_ST;
            half4 _BaseColor;
            half4 _EmissionColor;
            half _BumpScale;
            half _MetalMatCapStrength;
            half _SHLightingStrength;
            half _IndirectLightMixBaseColor;

            half _HairShadowDistance;

            half4 _StockingTint;
            half _StockingRefractDepth;

            half _IridescenceCenter;
            half _IridescenceSoftness;
            half _IridescenceStrength;
            half4 _FirstLayerColor;
            half4 _SSSColor;
            half4 _SecondLayerColor;
            half4 _ThirdLayerColor;
            half _ShadowThresholdCenter;
            half _SecondShadowThresholdCenter;
            half _ShadowThresholdSoftness;
            half _SecondShadowThresholdSoftness;
            half _MainLightColorUsage;
            half _SpecularExpon;
            half _Smooth;
            half _MetalSpecularExpon;
            half _SpecularBrightness;
            half _MetalSpecularBrightness;
            half _SpecularKsNonMetal;
            half _SpecularKsMetal;

            half _LightSideRim;
            half _RimLightWidth;
            half _RimLightSoft;
            half _RimLightMixAlbedo;
            half3 _RimLightTintColor;
            
            half _RimLightThreshold;

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