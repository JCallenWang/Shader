// Using HLSL

// add a path in inspector.shaderSelector
Shader "Tutorial/Tutorial_01"
{
	Properties
	{
		// �s�W����ﶵ(�p�C��,����,���ݫ׵�)
		// �ܼƦW��("��ܦW��", type) = �q�{ {}
		// type = (Color (r,g,b,a),
		//		   2D (2�����ƪ�image),
		//		   Rect (�D2���ƪ�image),
		//		   Cube (6�i�۳simage,�Χ@skybox),
		//		   <<2D & Rect & Cube �q�{�ݨϥ�"tint"�C��r��, {option}�u�@�Φb�����O��>>
	
		//		   Range(min,max) (float between min&max),
		//		   Float, Vector
		_MainTexture("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
	}


	// to alter how it render on different hardware (platform, mobile...etc)
	SubShader
	{
		// using {"RenderType"} tags to decide which shader to use
		// using {"Queue"} tags to change the rendering order 
		Tags { "RenderType"="Opaque" }
		Tags { "Queue"="Transparent+100"}
		// LOD (level of detail, �w�藍�PLOD�ĥΤ��Pshader)
		LOD 200


		// different pass have different purpose (camera, shader...etc)
		// one pass = complete drawing process
		Pass
		{
			// declare using Cg/HLSL 
			CGPROGRAM

			// #pragma stand for functions
			// funcType = 
			//			vertex(caculate mesh pixel), 
			//			fragment(draw pixel),
			
			// #pragma funcType funcName
			#pragma vertex vertexFunc
			#pragma fragment fragmentFunc

			// using Nvidia CG library (GPU accelarate)
			#include "UnityCG.cginc"

			// store current data
			struct appdata {
				// float4 = (a,b,c,d)
				// POSITION = object.Position
				// TEXCOORD = object.TextureCoordinate
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			// vertex to fragment
			struct v2f {
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			// fixed(11bit) = half(16bit) = floar(32bit) {fixed & half only work on portable device}
			// fixed4 = (a,b,c,d)
			fixed4 _Color;				// using _Color variable in properties
			sampler2D _MainTexture;		// sampler2D = 2D texture


			// returnType funcName(IN: input, OUT: output)
			// Vertex shader
			v2f vertexFunc(appdata IN)
			{
				v2f OUT;

				// let object shows in camera clipping
				OUT.position = UnityObjectToClipPos(IN.vertex);
				OUT.uv = IN.uv;

				return OUT;
			}

			// Fragment shader
			fixed4 fragmentFunc(v2f IN) : SV_Target
			{
				//tex2D(resource texture, using vertexShader.uv)
				fixed4 pixelColor = tex2D(_MainTexture, IN.uv);
				
			return pixelColor * _Color;
			}

			ENDCG
		}
	}
}