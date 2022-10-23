Shader "Thry/Convolution"
{
    Properties 
  { 
      [HideInInspector] shader_is_using_thry_editor("", Float)=0
        _MainTex ("Texture--{reference_properties:[_MainTexPan, _MainTexUV]}", 2D) = "white" { }
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos XZ, 5, Polar UV, 6, Distorted UV, 7)] _MainTexUV ("UV", Int) = 0
		[HideInInspector][Vector2]_MainTexPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][Vector2]_EnableAudioLink ("AudioLinkTest", Float) = 1

//#T#ThryConvolutionProperties
		[HideInInspector] m_start_convolution("Convolution--{reference_property:_ConvolutionEnabled}", Float) = 0
		[HideInInspector][ThryToggle(_CONVOLUTION_ENABLED)] _ConvolutionEnabled("Convolution Enabled", Float) = 0
		[ThryToggle(_CONVOLUTION_GRABPASS)] _Convolution_UseGrabPass("Use GrabPass", Float) = 0
		[ThryToggle(_CONVOLUTION_GRAYSCALE)] _Convolution_UseGrayscale("Use Grayscale", Float) = 0
		[ThryToggle(_CONVOLUTION_SEPERATE_KERNELS)] _Convolution_SeperateKernels("Second Kernel", Float) = 0

		_Convolution_Strength("Strength", Range(0, 1)) = 1

		[ThryWideEnum(None,0,Box Blur,1,Gaussian Blur,2,Sharpen,3,EdgeDetect,4,Sobel EdgeDetect,5)] _Convolution_Type("Presets--{on_value_actions:''
			0=> _Convolution_SeperateKernels=0; _Convolution_Kernel_X_0 = 0,0,0,0; _Convolution_Kernel_X_1 = 0,1,0,0; _Convolution_Kernel_X_2 = 0,0,0,0; _Convolution_Kernel_Y_0 = 0,0,0,0; _Convolution_Kernel_Y_1 = 0,0,0,0; _Convolution_Kernel_Y_2 = 0,0,0,0;
			1=> _Convolution_SeperateKernels=0; _Convolution_Kernel_X_0 = 0.11,0.11,0.11,0; _Convolution_Kernel_X_1 = 0.11,0.11,0.11,0; _Convolution_Kernel_X_2 = 0.11,0.11,0.11,0; _Convolution_Kernel_Y_0 = 0,0,0,0; _Convolution_Kernel_Y_1 = 0,0,0,0; _Convolution_Kernel_Y_2 = 0,0,0,0;
			2=> _Convolution_SeperateKernels=0; _Convolution_Kernel_X_0 = 0.0625,0.125,0.0625,0; _Convolution_Kernel_X_1 = 0.125,0.25,0.125,0; _Convolution_Kernel_X_2 = 0.0625,0.125,0.0625,0; _Convolution_Kernel_Y_0 = 0.0625,0.125,0.0625,0; _Convolution_Kernel_Y_1 = 0.125,0.25,0.125,0; _Convolution_Kernel_Y_2 = 0.0625,0.125,0.0625,0;
			3=> _Convolution_SeperateKernels=0; _Convolution_Kernel_X_0 = 0,-1,0,0; _Convolution_Kernel_X_1 = -1,5,-1,0; _Convolution_Kernel_X_2 = 0,-1,0,0; _Convolution_Kernel_Y_0 = 0,0,0,0; _Convolution_Kernel_Y_1 = 0,0,0,0; _Convolution_Kernel_Y_2 = 0,0,0,0;
			4=> _Convolution_SeperateKernels=0; _Convolution_Kernel_X_0 = 0,1,0,0; _Convolution_Kernel_X_1 = 1,-4,1,0; _Convolution_Kernel_X_2 = 0,1,0,0; _Convolution_Kernel_Y_0 = 0,0,0,0; _Convolution_Kernel_Y_1 = 0,0,0,0; _Convolution_Kernel_Y_2 = 0,0,0,0;
			5=> _Convolution_SeperateKernels=1; _Convolution_Kernel_X_0 = 1,0,-1,0; _Convolution_Kernel_X_1 = 2,0,-2,0; _Convolution_Kernel_X_2 = 1,0,-1,0; _Convolution_Kernel_Y_0 = 1,2,1,0; _Convolution_Kernel_Y_1 = 0,0,0,0; _Convolution_Kernel_Y_2 = -1,-2,-1,0;
		''}", Float) = 0

		[ThryHeaderLabel(Kernel X)]
		[Vector3] _Convolution_Kernel_X_0("", Vector) = (0,0,0,0)
		[Vector3] _Convolution_Kernel_X_1("", Vector) = (0,0,0,0)
		[Vector3] _Convolution_Kernel_X_2("", Vector) = (0,0,0,0)


		[ThryHeaderLabel(Kernel Y)]
		[Vector3] _Convolution_Kernel_Y_0("--{condition_show:_Convolution_SeperateKernels==1}", Vector) = (0,0,0,0)
		[Vector3] _Convolution_Kernel_Y_1("--{condition_show:_Convolution_SeperateKernels==1}", Vector) = (0,0,0,0)
		[Vector3] _Convolution_Kernel_Y_2("--{condition_show:_Convolution_SeperateKernels==1}", Vector) = (0,0,0,0)

		[Space(4)]
		[ThryToggleUI(true)] _Convolution_ALEnabled ("<size=13><b>  Audio Link</b></size>--{ condition_showS:_EnableAudioLink==1}", Float) = 0
		[MultiSlider]_Convolution_ALStrengthMod ("Emission Strength Add--{ condition_showS:(_Convolution_ALEnabled==1 && _EnableAudioLink==1)}", Vector) = (0, 1, 0, 1)
		[Enum(Bass, 0, Low Mid, 1, High Mid, 2, Treble, 3)] _Convolution_ALBand ("Emission Add Band--{ condition_showS:(_Convolution_ALEnabled==1 && _EnableAudioLink==1)}", Int) = 0

		[HideInInspector] m_end_convolution("End Convolution", Float) = 0
//#T#ThryConvolutionProperties
    }
	CustomEditor "Thry.ShaderEditor"
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

		GrabPass
		{
			"_PoiGrab2"
		}
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

//#T#ThryConvolutionKeywords
			#pragma shader_feature_local _CONVOLUTION_ENABLED
			#pragma shader_feature_local _CONVOLUTION_GRABPASS
			#pragma shader_feature_local _CONVOLUTION_GRAYSCALE
			#pragma shader_feature_local _CONVOLUTION_SEPERATE_KERNELS
//#T#ThryConvolutionKeywords

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float4 grabPos : TEXCOORD1;
            };

            UNITY_DECLARE_TEX2D(_MainTex);
            float4 _MainTex_ST;
			float2 _MainTexPan;
			float _MainTexUV;
			float4 _MainTex_TexelSize;

			UNITY_DECLARE_SCREENSPACE_TEXTURE(_PoiGrab2);

			#if defined(UNITY_COMPILER_HLSL)
				#define PoiInitStruct(type, name) name = (type)0;
			#else
				#define PoiInitStruct(type, name)
			#endif

			struct PoiFragData
			{
				float3 baseColor;
				float3 finalColor;
				float alpha;
				float3 emission;
			};

			struct PoiMesh
			{
				// 0 Vertex normal
				// 1 Fragment normal
				float3 normals[2];
				float3 objNormal;
				float3 tangentSpaceNormal;
				float3 binormal;
				float3 tangent;
				float3 worldPos;
				float3 localPos;
				float3 objectPosition;
				float isFrontFace;
				float4 vertexColor;
				float4 lightmapUV;
				// 0-3 UV0-UV3
				// 4 Panosphere UV
				// 5 world pos xz
				// 6 Polar UV
				// 7 Distorted UV
				float2 uv[8];
				float2 parallaxUV;
			};

			struct PoiMods
			{
				float4 Mask;
				float4 audioLink;
				float audioLinkAvailable;
				float audioLinkVersion;
				float4 audioLinkTexture;
				float2 detailMask;
				float2 backFaceDetailIntensity;
				float globalEmission;
				float4 globalColorTheme[12];
				float ALTime[8];
			};

			struct PoiCam
			{
				float3 viewDir;
				float3 forwardDir;
				float3 worldPos;
				float distanceToVert;
				float4 clipPos;
				float3 reflectionDir;
				float3 vertexReflectionDir;
				float3 tangentViewDir;
				float4 grabPos;
				float2 screenUV;
				float vDotN;
				float4 worldDirection;
				
			};

			float2 poiUV(float2 uv, float4 tex_st)
			{
				return uv * tex_st.xy + tex_st.zw;
			}
			
//#T#ThryConvolutionVariables
			#ifdef _CONVOLUTION_ENABLED
				float3 _Convolution_Kernel_X_0;
				float3 _Convolution_Kernel_X_1;
				float3 _Convolution_Kernel_X_2;

				float3 _Convolution_Kernel_Y_0;
				float3 _Convolution_Kernel_Y_1;
				float3 _Convolution_Kernel_Y_2;
			    
				float _Convolution_Strength;
				int _Convolution_ALEnabled;
				float4 _Convolution_ALStrengthMod;
				int _Convolution_ALBand;

            	float3 _PoiGrab2_TexelSize;
			#endif
//#T#ThryConvolutionVariables

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.grabPos = ComputeGrabScreenPos(o.vertex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

//#T#ThryConvolutionFunctions
			#ifdef _CONVOLUTION_ENABLED
				#ifdef _CONVOLUTION_GRABPASS
					#define CONVOLUTION_SAMPLE(tex,uv) UNITY_SAMPLE_SCREENSPACE_TEXTURE(tex,uv)
					#define CONVOLUTION_TEX_TYPE sampler2D
				#else
					#define CONVOLUTION_SAMPLE(tex,uv) UNITY_SAMPLE_TEX2D_SAMPLER(tex,_MainTex,uv)
					#define CONVOLUTION_TEX_TYPE Texture2D
				#endif

				inline float2 convolution_computeGrabScreenPos(in float4 pos)
				{
					float4 grabPos = pos;
					#if UNITY_UV_STARTS_AT_TOP
					float scale = -1.0;
					#else
					float scale = 1.0;
					#endif
					float halfPosW = grabPos.w * 0.5;
					grabPos.y = (grabPos.y - halfPosW) * _ProjectionParams.x * scale + halfPosW;
					#if SHADER_API_D3D9 || SHADER_API_D3D11
					grabPos.w += 0.00000000001;
					#endif
					return(grabPos / grabPos.w).xy;
				}

				float convolution_grayscale(float3 color) {
					return (color.r + color.g + color.b) / 3;
				}

				float3x3 convolution_samplePoints(float2 pos, CONVOLUTION_TEX_TYPE tex, float2 texelSize) {
					float3x3 m = (float3x3)0;

					m[0][0] = convolution_grayscale(CONVOLUTION_SAMPLE(tex, pos + float2( -1, +1) * texelSize));
					m[0][1] = convolution_grayscale(CONVOLUTION_SAMPLE(tex, pos + float2( -1, 0 ) * texelSize));
					m[0][2] = convolution_grayscale(CONVOLUTION_SAMPLE(tex, pos + float2( -1, -1) * texelSize));

					m[1][0] = convolution_grayscale(CONVOLUTION_SAMPLE(tex, pos + float2( 0, +1) * texelSize));
					m[1][1] = convolution_grayscale(CONVOLUTION_SAMPLE(tex, pos + float2( 0, 0 ) * texelSize));
					m[1][2] = convolution_grayscale(CONVOLUTION_SAMPLE(tex, pos + float2( 0, -1) * texelSize));

					m[2][0] = convolution_grayscale(CONVOLUTION_SAMPLE(tex, pos + float2( +1, +1) * texelSize));
					m[2][1] = convolution_grayscale(CONVOLUTION_SAMPLE(tex, pos + float2( +1, 0 ) * texelSize));
					m[2][2] = convolution_grayscale(CONVOLUTION_SAMPLE(tex, pos + float2( +1, -1) * texelSize));
					return m;
				}

				float3x3 convolution_samplePointsRGB(float2 pos, float x, CONVOLUTION_TEX_TYPE tex, float2 texelSize) {
					float3x3 m = (float3x3)0;
					m[0] = CONVOLUTION_SAMPLE(tex, pos + float2(x, +texelSize.y));
					m[1] = CONVOLUTION_SAMPLE(tex, pos + float2(x, 0));
					m[2] = CONVOLUTION_SAMPLE(tex, pos + float2(x, -texelSize.y));
					return m;
				}

				float convolution_filter(float3x3 filter, float3x3 points) {
					return (filter[0][0] * points[0][0] + filter[0][1] * points[0][1] + filter[0][2] * points[0][2] +
						filter[1][0] * points[1][0] + filter[1][1] * points[1][1] + filter[1][2] * points[1][2] +
						filter[2][0] * points[2][0] + filter[2][1] * points[2][1] + filter[2][2] * points[2][2]);
				}

				float3 convolution_filterRGB(float3x3 filter, float3x3 points1, float3x3 points2, float3x3 points3) {
					return (filter[0][0] * points1[0] + filter[0][1] * points1[1] + filter[0][2] * points1[2] +
						filter[1][0] * points2[0] + filter[1][1] * points2[1] + filter[1][2] * points2[2] +
						filter[2][0] * points3[0] + filter[2][1] * points3[1] + filter[2][2] * points3[2]);
				}

				void applyConvolution(inout PoiFragData poiFragData, in PoiCam poiCam, in PoiMesh poiMesh, in PoiMods poiMods){
					//UNITY_SAMPLE_TEX2D(_MainTex, poiUV(poiMesh.uv[_MainTexUV].xy, _MainTex_ST) + _Time.x * _MainTexPan);
					#ifdef _CONVOLUTION_GRABPASS
						CONVOLUTION_TEX_TYPE convTex = _PoiGrab2;
						float2 convTexSize = _PoiGrab2_TexelSize;
						float2 convUV = convolution_computeGrabScreenPos(poiCam.grabPos);
					#else
						CONVOLUTION_TEX_TYPE convTex = _MainTex;
						float2 convTexSize = _MainTex_TexelSize;
						float2 convUV = poiUV(poiMesh.uv[_MainTexUV].xy, _MainTex_ST) + _Time.x * _MainTexPan;
					#endif

					float3x3 kernel_X = { _Convolution_Kernel_X_0, _Convolution_Kernel_X_1, _Convolution_Kernel_X_2 };
					float3x3 kernel_Y = { _Convolution_Kernel_Y_0, _Convolution_Kernel_Y_1, _Convolution_Kernel_Y_2 };

					float3 convColor = poiFragData.baseColor;
					#ifdef _CONVOLUTION_GRAYSCALE
						float3x3 points = convolution_samplePoints(convUV, convTex, convTexSize);
						#ifdef _CONVOLUTION_SEPERATE_KERNELS
							convColor = sqrt(pow(convolution_filter(kernel_X, points), 2) + pow(convolution_filter(kernel_Y, points), 2));
						#else
							convColor = convolution_filter(kernel_X, points);
						#endif
					#else
						float3x3 points1 = convolution_samplePointsRGB(convUV, -convTexSize.x, convTex, convTexSize);
						float3x3 points2 = convolution_samplePointsRGB(convUV, 0             , convTex, convTexSize);
						float3x3 points3 = convolution_samplePointsRGB(convUV, +convTexSize.x, convTex, convTexSize);
						#ifdef _CONVOLUTION_SEPERATE_KERNELS
							convColor = sqrt(pow(convolution_filterRGB(kernel_X, points1, points2, points3), 2) + pow(convolution_filterRGB(kernel_Y, points1, points2, points3), 2));
						#else
							convColor = convolution_filterRGB(kernel_X, points1, points2, points3);
						#endif
					#endif
					#ifdef POI_AUDIOLINK
						if (poiMods.audioLinkAvailable && _Convolution_ALEnabled)
						{
							_Convolution_Strength += lerp(_Convolution_ALStrengthMod.x, _Convolution_ALStrengthMod.y, poiMods.audioLink[_Convolution_ALBand]);
						}
					#endif
					poiFragData.baseColor = lerp(poiFragData.baseColor, convColor, _Convolution_Strength);
				}
			#endif
//#T#ThryConvolutionFunctions

            fixed4 frag (v2f i) : SV_Target
            {

				PoiFragData poiFragData;
				PoiInitStruct(PoiFragData, poiFragData);

				PoiMesh poiMesh;
				PoiInitStruct(PoiMesh, poiMesh);

				PoiMods poiMods;
				PoiInitStruct(PoiMods, poiMods);

				PoiCam poiCam;
				PoiInitStruct(PoiCam, poiCam);

				poiCam.grabPos = i.grabPos;

				poiMesh.uv[0] = i.uv;
				poiFragData.baseColor = UNITY_SAMPLE_TEX2D(_MainTex, poiUV(poiMesh.uv[_MainTexUV].xy, _MainTex_ST) + _Time.x * _MainTexPan);

//#T#ThryConvolutionFunctionCalls
				#ifdef _CONVOLUTION_ENABLED
					applyConvolution(poiFragData, poiCam, poiMesh, poiMods);
				#endif
//#T#ThryConvolutionFunctionCalls

                return float4(poiFragData.baseColor,1);
            }
            ENDCG
        }
    }
}
