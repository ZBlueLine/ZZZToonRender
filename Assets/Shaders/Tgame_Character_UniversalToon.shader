Shader "Tgame/Character/Universal Toon Character"
{
    Properties
    {
        _DebugValue("Debug", float) = 0
        [GroupStart]_BaseGroup("基础贴图",int) = 0
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        [NoScaleOffset] _BaseMap("Base Map", 2D) = "white" {}
        [NoScaleOffset]_SecondLayerColorMap("过渡区颜色", 2D) = "white" {}
        [NoScaleOffset]_ThirdLayerColorMap("暗部基颜色", 2D) = "white" {}
        [GroupEnd]

        [GroupStart]_LightGroup("光照设置",int) = 0
        [NoScaleOffset][Linear]_LightMap("Light Map R:材质索引 G:金属度， B:高光亮度 (面部不需要这张图)", 2D) = "white" {}
        [NoScaleOffset][Linear]_LightMap2("G:光滑度 B:Matcap强度 (面部不需要这张图)", 2D) = "white" {}
        _Smooth("Smooth", Range(0, 1)) = 1

        [HDR]_EmissionColor("Emission Color", Color) = (0, 0, 0, 1)
        [Space(20)]

        [NoScaleOffset][Linear]_BumpShadowMap("Normal Map RG:法线 B:明暗偏移 A:自发光", 2D) = "white" {}
        _BumpScale("Normal Map Strength", Float) = 1
        [Space(20)]

        [Header(Diffuse Setting)]
        _FirstLayerColor("受光区颜色", Color) = (1, 1, 1, 1)
        _SecondLayerColor("过渡区颜色", Color) = (0.848, 0.7497263, 0.721648, 1)
        _ThirdLayerColor("暗部颜色", Color) = (0.8, 0.5584577, 0.5215999, 1)
        _ShadowThresholdCenter("一层光照分色位置", Range(0.5, 1)) = 0.7
        _SecondShadowThresholdCenter("二层光照分色位置", Range(0.5, 1)) = 0.4
        _ShadowThresholdSoftness("一层光照对比度(脸部模型只需要调这个)", Range(0, 0.2)) = 0.083
        _SecondShadowThresholdSoftness("二层光照对比度", Range(0, 1)) = 0.075
        _MainLightColorUsage("主光颜色饱和度", Range(0, 1)) = 1
        [Space(20)]
        [Header(Specular Setting)]
        _SpecularExpon("高光聚集", Range(1, 30)) = 3.5
        _SpecularBrightness("高光整体亮度", Range(0, 20)) = 3.63
        [Space(20)]

        [Header(IndirectLight Setting)]
        [HideInInspector]_SpecularKsNonMetal("非金属反射系数", Float) = 0.04
        [HideInInspector]_SpecularKsMetal("金属反射系数", Float) = 0.96
        _IndirectLightMixBaseColor("间接光混合主贴图颜色", Range(0, 1)) = 1
        [GroupEnd]

        [GroupStart]_MatCapSetting("Matcap Setting",int) = 0
        _MatCap1Strength("强度", Range(0, 3)) = 1
        [NoScaleOffset]_MatCap1("Matcap1", 2D) = "black" {}
        [Space(10)]
        _MatCap2Strength("强度", Range(0, 3)) = 1
        [NoScaleOffset]_MatCap2("Matcap2", 2D) = "black" {}
        [Space(10)]
        _MatCap3Strength("强度", Range(0, 3)) = 1
        [NoScaleOffset]_MatCap3("Matcap3", 2D) = "black" {}
        [Space(10)]
        _MatCap4Strength("强度", Range(0, 3)) = 1
        [NoScaleOffset]_MatCap4("Matcap4", 2D) = "black" {}
        [Space(10)]
        _MatCap5Strength("强度", Range(0, 3)) = 1
        [NoScaleOffset]_MatCap5("Matcap5", 2D) = "black" {}
        [GroupEnd]

        [GroupStart]_StockingAreaGroup("丝袜控制",int) = 0
        [Toggle(_AREA_STOCKING)]_StockingArea("丝袜区域", int) = 0
        [NoScaleOffset]_StockingMatcap("丝袜Matcap", 2D) = "black" {}
        _StockingTint("丝袜颜色", Color) = (0.8, 0.5584577, 0.5215999, 1)
        _StockingRefractDepth("折射深度", Range(0, 1)) = 0.5
        [GroupEnd]

        [GroupStart]_FaceGroup("面部控制",int) = 0
        [Toggle(_AREA_FACE)]_FaceArea("面部区域", int) = 0
        [Toggle(_BINDING_MESH)]_BindingMesh("模型经过绑定勾选此项", int) = 0
        [NoScaleOffset][Linear]_FaceMap("面部阴影控制图 R:SDF G:高光维持区域 B:亮部光感Mask A:头发阴影区域", 2D) = "white" {}
        _SSSColor("SSS颜色", Color) = (0.848, 0.7497263, 0.721648, 1)
        [Space(10)]
        [Toggle(_HARI_SHADOW)]_HairShadowOn("开启头发阴影", int) = 0
        _HairShadowDistance("头发阴影偏移(脸部模型上调)", Range(0, 4)) = 1
        [GroupEnd]

        [GroupStart]_RimGroup("边缘光设置",int) = 0
        [NoScaleOffset][Linear]_RimLightWidthMap("边缘光控制贴图 R:亮度 G:宽度", 2D) = "white"{}
        [Toggle]_LightSideRim("单边边缘光", float) = 0
        [NoScaleOffset][Linear]_RimLightMatcap("边缘光Matcap", 2D) = "black"{}
        _RimLightWidth("边缘光宽度", Range(0, 2)) = 0.246
        _RimLightSoft("边缘光软硬", Range(0, 0.5)) = 0.1
        _RimLightMixAlbedo("边缘光混合主贴图颜色", Range(0, 1)) = 1
        
        [Toggle(_DEPTH_RIMLIGHT)]_DepthRim("深度边缘光", float) = 0
        _RimLightThreshold("深度边缘光阈值", Range(0, 1)) = 1

        [HDR]_RimLightTintColor("边缘光颜色", Color) = (0.7, 0.7, 0.7, 1)
        [GroupEnd]

        [GroupStart]_OutlineGroup("描边设置",int) = 0
        [KeywordEnum(Vert, UV3Smooth, VertexColorSmooth) ] _Normal("平滑法线来源" , Float) = 0
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
            float _DebugValue;
            float4 _BaseMap_ST;
            half4 _BaseColor;
            half4 _EmissionColor;
            half _BumpScale;
            half _IndirectLightMixBaseColor;


            half _HairShadowDistance;

            half4 _StockingTint;
            half _StockingRefractDepth;

            half4 _FirstLayerColor;
            half4 _SSSColor;
            half4 _SecondLayerColor;
            half4 _ThirdLayerColor;
            half _ShadowThresholdCenter;
            half _SecondShadowThresholdCenter;
            half _ShadowThresholdSoftness;
            half _SecondShadowThresholdSoftness;
            half _MainLightColorUsage;
            half _Smooth;

            half _MatCap1Strength;
            half _MatCap2Strength;
            half _MatCap3Strength;
            half _MatCap4Strength;
            half _MatCap5Strength;

            half _SpecularExpon;
            half _SpecularBrightness;
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

        TEXTURE2D(_FaceMap);
        // TEXTURE2D(_StockingMap);
        TEXTURE2D(_StockingMatcap);
        TEXTURE2D(_MatCap1);
        TEXTURE2D(_MatCap2);
        TEXTURE2D(_MatCap3);
        TEXTURE2D(_MatCap4);
        TEXTURE2D(_MatCap5);
        TEXTURE2D(_BumpShadowMap);
        TEXTURE2D(_BaseMap);
        TEXTURE2D(_LightMap);
        TEXTURE2D(_LightMap2);
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

        #define DEFINE_SELECT(TYPE)\
        TYPE select(int id, TYPE e0, TYPE e1, TYPE e2, TYPE e3, TYPE e4){return TYPE(id > 0 ?(id > 1?(id > 2 ? (id > 3 ? e4 : e3) : e2) : e1) :e0);}\
        TYPE##2 select(int id, TYPE##2 e0, TYPE##2 e1, TYPE##2 e2, TYPE##2 e3, TYPE##2 e4){return TYPE##2(id > 0 ?(id > 1?(id > 2 ? (id > 3 ? e4 : e3) : e2) : e1) :e0);}\
        TYPE##3 select(int id, TYPE##3 e0, TYPE##3 e1, TYPE##3 e2, TYPE##3 e3, TYPE##3 e4){return TYPE##3(id > 0 ?(id > 1?(id > 2 ? (id > 3 ? e4 : e3) : e2) : e1) :e0);}\
        TYPE##4 select(int id, TYPE##4 e0, TYPE##4 e1, TYPE##4 e2, TYPE##4 e3, TYPE##4 e4){return TYPE##4(id > 0 ?(id > 1?(id > 2 ? (id > 3 ? e4 : e3) : e2) : e1) :e0);}

        DEFINE_SELECT(bool)
        DEFINE_SELECT(float)
        DEFINE_SELECT(half)

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
            Name "Unlit"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
            Blend[Src][Dst],[SrcA][DstA]
            Cull[_Cull]
            ZTest[_ZTest]
            ZWrite[_ZWrite]
            Stencil
            {
                Ref[_Stencil]
                Comp[_StencilComp]
                Pass[_StencilOp]
            }
            //Offset [_Offsetx], [_Offsety]


            HLSLPROGRAM
            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile_instancing

            #pragma shader_feature_local _ _AREA_FACE _AREA_STOCKING
            #pragma shader_feature_local_fragment _ _BINDING_MESH
            #pragma shader_feature_local_fragment _ _HARI_SHADOW
            #pragma shader_feature_local_fragment _DEPTH_RIMLIGHT
            #pragma multi_compile _ _ADDITIONAL_LIGHTS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE
            //#pragma multi_compile_fragment _ _SHADOWS_SOFT


            #pragma vertex CharacterToonPassVertex
            #pragma fragment CharacterToonPassFragment

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
	        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl" 

            #define OUTPUT_SH(normalWS, OUT) OUT.xyz = SampleSHVertex(normalWS)

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 color : COLOR;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float4 uv : TEXCOORD0;
                float3 normalWS : TEXCOORD2;
                float3 viewDirWS : TEXCOORD3;
                float4 tangentWS: TEXCOORD4;
                float3 positionWS : TEXCOORD5;
                float2 dissolveCoord : TEXCOORD7;
                float4 color : TEXCOORD8;
                #if defined(_AREA_FACE)
					float4 positionSS : TEXCOORD9;
                #endif
                float4 ScreenPos :TEXCOORD10;
                DECLARE_LIGHTMAP_OR_SH(staticLightmapUV, vertexSH, 11);
            };

            //自定义的法线格式，所以自己解码
            real3 TGame_UnpackNormalRG(real4 packedNormal, real scale = 1.0)
            {
                real3 normal;
                normal.xy = packedNormal.rg * 2.0 - 1.0;
                normal.z = max(1.0e-16, sqrt(1.0 - saturate(dot(normal.xy, normal.xy))));
                normal.xy *= scale;
                return normalize(normal);
            }

            float3 desaturation(float3 color)
            {
                float3 grayXfer = float3(0.3, 0.59, 0.11);
                float grayf = dot(color, grayXfer);
                return float3(grayf, grayf, grayf);
            }


            float GetCameraFOV()
            {
                //https://answers.unity.com/questions/770838/how-can-i-extract-the-fov-information-from-the-pro.html
                float t = unity_CameraProjection._m11;
                float Rad2Deg = 180 / 3.1415;
                float fov = atan(1.0f / t) * 2.0 * Rad2Deg;
                return fov;
            }

            half3 RimLight(float3 lightDirWS, float3 normalWS, float3 viewDirWS, half3 lightColor, float2 uv,
                        float2 matcapCoords)
            {
                half2 rimlightMask = SAMPLE_TEXTURE2D(_RimLightWidthMap, sampler_LinearClamp, uv).rg;
                half width = _RimLightWidth * rimlightMask.g;
                float rimLight = 1 - saturate(dot(normalWS, viewDirWS));
                half threshold = 1 - (width);
                rimLight = smoothstep(threshold - _RimLightSoft, threshold + _RimLightSoft, rimLight);
                half matcap = 0;
                float3 cameraRightWS = float3(UNITY_MATRIX_I_V[0].x, UNITY_MATRIX_I_V[1].x, UNITY_MATRIX_I_V[2].x);
                float3 rimLightColor = rimLight * lightColor * (_LightSideRim > 0
                                                                            ? step(0, dot(normalWS, cameraRightWS))
                                                                            : 1);
                rimLightColor *= _RimLightTintColor;
                rimLightColor *= rimlightMask.r;
                return rimLightColor;
            }
            half3 DepthRimLight(float3 normalWS, float4 positionCS, half3 lightColor)
            {	
                //深度边缘光
				float linearEyeDepth = LinearEyeDepth(positionCS.z, _ZBufferParams);
				float3 normalVS = mul((float3x3)UNITY_MATRIX_V, normalWS);
				float2 uvOffset = float2(sign(normalVS.x), sign(normalVS.y)) * _RimLightWidth / (1 + linearEyeDepth) / 100;
				float2 loadDepthTexPos = positionCS.xy + uvOffset * _ScaledScreenParams.xy; 
				loadDepthTexPos = max(0, min(loadDepthTexPos, _ScaledScreenParams.xy - 1));
				float sceneLinearEyeDepth = LoadSceneDepth(loadDepthTexPos);
				sceneLinearEyeDepth = LinearEyeDepth(sceneLinearEyeDepth, _ZBufferParams);
				float rimLight = saturate(sceneLinearEyeDepth - (linearEyeDepth + _RimLightThreshold * 10)) / _RimLightSoft;
				half3 rimLightColor = rimLight * lightColor;
				rimLightColor *= _RimLightTintColor;
                return rimLightColor;
            }

            half3 StockingRender(half matcapStrength, TEXTURE2D(stockingMatcap), SAMPLER(texSampler), half2 uv,
                                        half2 matcapCoords, half4 stockingTint)
            {
                matcapCoords = matcapCoords * _StockingRefractDepth;
                half4 matcapColor = SAMPLE_TEXTURE2D(stockingMatcap, texSampler, matcapCoords);
                half4 stockingColor = stockingTint * matcapColor * matcapStrength;
                return stockingColor.rgb;
            }

            half SpecularBRDF_PBR(float3 viewDirWS, float3 lightDirWS, float3 normalWS, half specularStrength, half smoothness)
            {
                float3 halfDir = SafeNormalize(lightDirWS + viewDirWS);
                float NoH = saturate(dot(normalWS, halfDir));
                half LoH = half(saturate(dot(lightDirWS, halfDir)));

                half perceptualRoughness = PerceptualSmoothnessToPerceptualRoughness(smoothness);
                half roughness = max(PerceptualRoughnessToRoughness(perceptualRoughness), HALF_MIN_SQRT);
                half roughness2 = max(roughness * roughness, HALF_MIN);
                half roughness2MinusOne = roughness2 - half(1.0);
                half normalizationTerm = roughness * half(4.0) + half(2.0);

                float d = NoH * NoH * roughness2MinusOne + 1.00001f;

                half LoH2 = LoH * LoH;
                half specularTerm = roughness2 / ((d * d) * max(0.1h, LoH2) * normalizationTerm);
                return specularTerm * specularStrength * _SpecularBrightness;
            }

            half SpecularBRDF(float3 viewDirWS, float3 lightDirWS, float3 normalWS,
                half specularStrength, half smooth)
            {
                float3 halfVector = normalize(viewDirWS + lightDirWS);
                float NoH = max(dot(normalWS, halfVector), 0.0);
                float blinnPhong = pow(saturate(NoH), _SpecularExpon);
                half roughness = 1.01 - smooth;
                blinnPhong = smoothstep(0.5 - roughness, 0.5 + roughness, blinnPhong);
                half specularTerm = blinnPhong * specularStrength;
                specularTerm *= _SpecularBrightness;
                return specularTerm;
            }

            Varyings CharacterToonPassVertex(Attributes input)      
            {
                Varyings output = (Varyings)0;
                output.color = input.color;
                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                output.positionCS = vertexInput.positionCS;
                output.positionWS = vertexInput.positionWS;
                VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);
                output.normalWS = normalInput.normalWS;
                output.tangentWS = float4(normalInput.tangentWS, input.tangentOS.w);
                output.viewDirWS = GetWorldSpaceViewDir(vertexInput.positionWS);

                #if defined(_AREA_FACE)
					output.positionSS = ComputeScreenPos(vertexInput.positionCS);
                #endif

                output.uv.xy = TRANSFORM_TEX(input.uv, _BaseMap);
                OUTPUT_SH(output.normalWS.xyz, output.vertexSH);
                float4 screenPos = ComputeScreenPos(output.positionCS);
                output.ScreenPos = screenPos;
                OUTPUT_LIGHTMAP_UV(input.staticLightmapUV, unity_LightmapST, output.staticLightmapUV);
                return output;
            }

            half4 CharacterToonPassFragment(Varyings input) : SV_Target
            {
                half2 uv = input.uv.xy;
                half4 baseMapColor = SAMPLE_TEXTURE2D(_BaseMap, sampler_LinearClamp, uv);
                float specularStrength = 0;
                half smoothness = 0;
                half emission = 0;
                half lightOffset = 1;
                half3 normalTS = 0;

                #if !defined(_AREA_FACE)
                    half4 rawNormalTS = SAMPLE_TEXTURE2D(_BumpShadowMap, sampler_LinearClamp, uv);
                    half4 lightMap = SAMPLE_TEXTURE2D(_LightMap, sampler_LinearClamp, uv);
                    half4 lightMap2 = SAMPLE_TEXTURE2D(_LightMap2, sampler_LinearClamp, uv);
                    half4 secondLayerColorMap = SAMPLE_TEXTURE2D(_SecondLayerColorMap, sampler_LinearClamp, uv);
                    half4 thirdLayerColorMap = SAMPLE_TEXTURE2D(_ThirdLayerColorMap, sampler_LinearClamp, uv);
                    emission = rawNormalTS.a;
                    normalTS = rawNormalTS.xyz;
                    //光滑度控制金属区域的高光表现
                    float materialIDRawData = lightMap.r;
                    //五种材质，id分别为4 3 2 1 0
                    //绝区零的分类为：0 皮肤 1皮革 2另一种皮革 3 光滑金属件 4粗糙金属件
                    //根据实际需求修改即可
                    int materialID = floor(materialIDRawData * 5);
                    int cloth = materialID > 2 ? 1 : 0;
                    int ismetal = materialID > 0 ? (materialID > 2 ? 0 : 1) : 0;

                    float metallic = lightMap.g;
                    float matcapStrength = lightMap2.g;
                    //控制所有区域出现高光的阈值
                    specularStrength = lightMap.b;
                    smoothness = lightMap2.g * _Smooth;
                    lightOffset = rawNormalTS.b * 2 - 1;
                #endif

                half3 baseColor = baseMapColor.rgb;

                //自定义的法线格式
                normalTS = TGame_UnpackNormalRG(half4(normalTS, 1), _BumpScale);
                float sgn = input.tangentWS.w; // should be either +1 or -1
                float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
                half3 normalWS = TransformTangentToWorld(normalTS, tangentToWorld);

                float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
                float4 shadowMask = SAMPLE_SHADOWMASK(input.staticLightmapUV);
                Light mainLight = GetMainLight(shadowCoord, input.positionWS, shadowMask);

                mainLight.color = mainLight.color;
                mainLight.color *= mainLight.distanceAttenuation;
                float3 lightColor = lerp(desaturation(mainLight.color), mainLight.color, _MainLightColorUsage);
                float3 lightDirWS = normalize(mainLight.direction);

                float2 matcapCoords;
                matcapCoords.x = dot(normalize(UNITY_MATRIX_V[0].xyz), normalWS);
                matcapCoords.y = dot(normalize(UNITY_MATRIX_V[1].xyz), normalWS);
                matcapCoords.xy = matcapCoords.xy * 0.5 + 0.5;

                float3 specularColor = 0;
                float3 viewDirWS = normalize(input.viewDirWS);
                float3 indirectLightColor = 0;
                float2 Ramp;
                half3 diffuseColor = 0;
                half3 mainLightColor = 0;
                half3 albedo = baseColor * _BaseColor.rgb;

                //间接光
                half3 SH = SampleSHPixel(input.vertexSH, normalWS);
                indirectLightColor = SH;
                indirectLightColor *= lerp(1, baseColor, _IndirectLightMixBaseColor);

                #if defined(_AREA_FACE)
					half2 positionSS = input.positionSS.xy;
					float3 headForward;
					float3 headRight;

					#if defined(_BINDING_MESH)
						headForward = float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y);
						headRight = -float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z);
						//headForward = -float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x);
						//headRight = -float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y);
					#else 
						// headForward = float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z);
						// headRight = float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x);
						headForward = float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z);
						headRight = float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x);
					#endif

					headForward = normalize(headForward);
					headRight = normalize(headRight);
					float3 headUp = cross(headForward, headRight);
					float3 fixedLightDirectionWS = normalize(lightDirWS - dot(lightDirWS, headUp) * headUp);
					float sX = dot(fixedLightDirectionWS, headRight);
					float sZ = dot(fixedLightDirectionWS, -headForward);
                    //计算光照和角色朝向的夹角
                    float angleThreshold = atan2(sX, sZ)/3.14159265359;
					float2 sdfUV = float2(-sign(angleThreshold), 1) * uv;
                    angleThreshold =  angleThreshold > 0? (1 -  angleThreshold) : (1 +  angleThreshold);
					//判断光照在脸的哪一侧，并翻转uv（光照一侧对应sdf更亮的一侧）
					float4 faceInfo = SAMPLE_TEXTURE2D(_FaceMap, sampler_LinearRepeat, sdfUV);
					float sdfValue = faceInfo.r;

					float facelightSmooth = saturate(2.5 * (faceInfo.g - 0.5));
                    float s = lerp(_ShadowThresholdSoftness, 0.025, facelightSmooth);
                    s = max(1e-5, s);
					float attenuation = saturate(0.6 + (sdfValue * 1.2 - 0.6) / (s * 4 + 1) - angleThreshold);
                    float aRamp[3] = {
                        attenuation / s, 
                        attenuation / s - 1,
                        attenuation / 0.125 -16*s
                    };
                    //四层混合，经验公式没有特别的意义，只要保证四个相加后为1即可
                    half albedoshadow = saturate(1 - aRamp[0]);
                    half albedoShallow = min(saturate(1 - aRamp[1]), saturate(aRamp[0]));
                    half albedoSSS = min(saturate(1 - aRamp[2]), saturate(aRamp[1]));
                    half albedoFront = saturate(aRamp[2]);

					#if defined(_HARI_SHADOW)
						//计算头发阴影
						float4 scaledScreenParams = GetScaledScreenParams();
						float3 viewLightDir = normalize(TransformWorldToViewDir(mainLight.direction));
						float hairShadowDistance = _HairShadowDistance / GetCameraFOV();
						positionSS += hairShadowDistance * viewLightDir.xy * float2(scaledScreenParams.y / scaledScreenParams.x, 1);
						positionSS /= input.positionSS.w;
						float hairDepth = SAMPLE_TEXTURE2D(_HairShadowRT, sampler_PointRepeat, positionSS).r;
						float depth = input.positionCS.z;
						
						hairDepth = LinearEyeDepth(hairDepth, _ZBufferParams);
						depth = LinearEyeDepth(depth, _ZBufferParams);

						half hairShadow = 1 - step(0.01, hairDepth);
						hairShadow = lerp(1, hairShadow, step(hairDepth, depth + 0.001));
						hairShadow = lerp(1, hairShadow, faceInfo.a);
					#endif
					//颜色混合
                    half3 rampColor = _ThirdLayerColor * albedoshadow + _SecondLayerColor * albedoShallow + _SSSColor * albedoSSS + _FirstLayerColor * albedoFront;
					#if defined(_HARI_SHADOW)
					rampColor = lerp(_ThirdLayerColor, albedo, hairShadow);
					#endif
                    half3 brdfDiffuse = albedo;
                    brdfDiffuse *= rampColor;
                    half3 radiance = lightColor;
                    mainLightColor = brdfDiffuse * radiance;   
                #else
                    //-----------------StockingArea---------------------
                    #if defined(_AREA_STOCKING)
                        half3 StockingColor = StockingRender(matcapStrength, _StockingMatcap, sampler_LinearRepeat, uv, matcapCoords, _StockingTint);
                        baseColor += StockingColor;
                    #endif
                    //------------------------------------------------
                    
                    //漫反射光
                    float NoL = dot(normalWS, lightDirWS);
                    float NoL01 = NoL * 0.5 + 0.5;
                    half3 radiance = lightColor;
                    half oneMinusReflectivity = OneMinusReflectivityMetallic(metallic);
                    half3 brdfDiffuse = albedo * oneMinusReflectivity;
                    float2 contrast = (1 - saturate(float2(_ShadowThresholdSoftness, _SecondShadowThresholdSoftness))) * 0.3;
                    float2 thresholdCenter = half2(_ShadowThresholdCenter, _SecondShadowThresholdCenter);
                    NoL01 += lightOffset;
                    Ramp = smoothstep(thresholdCenter - contrast,
                                        thresholdCenter + contrast, NoL01);
                    //颜色混合
                    half4 secondLayerColor = secondLayerColorMap * _SecondLayerColor;
                    half4 thirdLayerColor = thirdLayerColorMap * _ThirdLayerColor;

                    half3 rampColor = lerp(secondLayerColor, _FirstLayerColor, Ramp.x).rgb;
                    rampColor = lerp(thirdLayerColor.rgb, rampColor, Ramp.y);
                    brdfDiffuse *= rampColor;
                    half3 brdf = brdfDiffuse;
                    
                    //高光
                    half3 brdfSpecular = lerp(kDieletricSpec.rgb, albedo, metallic);
                    //背面的高光用Ramp结果遮一下
                    // Trick版本
                    //brdf += brdfSpecular * SpecularBRDF(viewDirWS, lightDirWS, normalWS, specularStrength, smoothness) * Ramp.y;
                    //PBR版本
                    brdf += brdfSpecular * SpecularBRDF_PBR(viewDirWS, lightDirWS, normalWS, specularStrength * 2, smoothness) * Ramp.y;
                         
                    mainLightColor = brdf * radiance;

                    //金属使用Matcap做环境光单独控制强度
                    half3 matcap1Color = SAMPLE_TEXTURE2D(_MatCap1, sampler_LinearRepeat, matcapCoords).rgb *
                        _MatCap1Strength * matcapStrength;   
                    half3 matcap2Color = SAMPLE_TEXTURE2D(_MatCap2, sampler_LinearRepeat, matcapCoords).rgb *
                        _MatCap2Strength * matcapStrength;   
                    half3 matcap3Color = SAMPLE_TEXTURE2D(_MatCap3, sampler_LinearRepeat, matcapCoords).rgb *
                        _MatCap3Strength * matcapStrength;   
                    half3 matcap4Color = SAMPLE_TEXTURE2D(_MatCap4, sampler_LinearRepeat, matcapCoords).rgb *
                        _MatCap4Strength * matcapStrength;   
                    half3 matcap5Color = SAMPLE_TEXTURE2D(_MatCap5, sampler_LinearRepeat, matcapCoords).rgb *
                        _MatCap5Strength * matcapStrength; 
                    half3 matcapColor = select(materialID, matcap1Color, matcap2Color, matcap3Color, matcap4Color, matcap5Color);
                    //half a = 0;
                    //half b = 0.2;
                    //half c = 0.4;
                    //half d = 0.6;
                    //half e = 0.8;
                    //half3 matcapColor = select(materialID, a, b, c, d, e);
                    //return matcapColor.rgbb;
                    indirectLightColor += matcapColor;
                #endif
                //菲涅尔边缘光
                half3 rimLightColor =0;
                #if !defined(_DEPTH_RIMLIGHT)
                    rimLightColor = RimLight(lightDirWS, input.normalWS, viewDirWS, mainLight.color, uv,
                       matcapCoords);
                #else
                    rimLightColor = DepthRimLight(input.normalWS, input.positionCS, mainLight.color);
                #endif

                half alpha = baseMapColor.a * _BaseColor.a;
                half4 finalColor = half4(0, 0, 0, alpha);


                half3 emissionColor = baseColor * emission * _EmissionColor.rgb;
                finalColor.rgb += mainLightColor + indirectLightColor;
                finalColor.rgb += rimLightColor * lerp(1, albedo.rgb, _RimLightMixAlbedo);
                finalColor.rgb += emissionColor;

				//其他基础计算
				#if defined(_ALPHAPREMULTIPLY_ON)
					finalColor.rgb *= alpha;
				#endif
				return finalColor;
			}
			ENDHLSL
		}

		Pass
		{
			Name "Outline"
			Tags { "LightMode" = "OutLine" }
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

            HLSLPROGRAM

            #pragma vertex DepthOnlyVertex
            #pragma fragment DepthOnlyFragment

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local_fragment _ALPHATEST_ON

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
			struct Attributes
			{
				float4 position     : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct Varyings
			{
				float4 positionCS   : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			Varyings DepthOnlyVertex(Attributes input)
			{
				Varyings output = (Varyings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				output.positionCS = TransformObjectToHClip(input.position.xyz);
				return output;
			}

			half4 DepthOnlyFragment(Varyings input) : SV_TARGET
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);
				return 0;
			}
            ENDHLSL

        }
        
	}

	FallBack "Hidden/Universal Render Pipeline/FallbackError"
	CustomEditor "ShaderLab.Editor.CommonShaderEditor"
}