Shader "Custom/skyanima"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        t0 ("t0", 2D) = "white" {}
        t1 ("t1", 2D) = "white" {}
        _t2 ("t2", 2D) = "white" {}
        t3 ("t3", 2D) = "white" {}
        t4 ("t4", 2D) = "white" {}
        t5 ("t5", 2D) = "white" {}

cb0_44("cb0_44 w=0 云存在", Color) = (0.0002600000,0.0005100000,0.0000000000,0.0000000000)
cb0_45("cb0_45 w=0 云存在", Vector) = (0.0000400000,-0.0000200000,-0.0005700000,0.0000000000)
cb0_46("cb0_46", Vector) = (0.0000000000,0.0000000000,0.0000000000,0.1000000000)
cb0_47("cb0_47 z云翻页  w=0 云存在", Vector) = (0.7079800000,-0.7677800000,0.2891800000,0.0000000000)

cb0_70("cb0_70 失效", Vector) = (11204.2314500000,-9.4793800000,-1067.1501500000,0.0000000000)
cb0_135("cb0_135 y亮度", Vector) = (0.0000000000,1.4142100000,0.7071100000,0.0000000000)
cb0_140("cb0_140 失效", Vector) = (0.0000000000,0.0000000000,0.0000000000,0.0000000000)
cb0_142("cb0_142 云抖动", Color) = (10.0000000000,179.4840700000,140.6828900000,1025.3576700000)
cb0_143("cb0_143", Color) = (0.0158000000,0.0000000000,1.0000000000,0.0000000000)

cb1_0("cb1[0]  云运动 y", Vector) = (6.0000000000,0.3500000000,0.3500000000,2000.0000000000)
cb1_3("cb1[3] x全局曝光", Vector) = (1.0000000000,-500.0000000000,5.0000000000,0.5000000000)
cb1_4("cb1[4] z 星星亮度", Color) = (5000.0000000000,0.0000000000,0.0000000000,0.1500000000)
cb1_6("cb1[6] y全局曝光", Color) = (0.0000000000,1.0000000000,1.0000000000,1.0000000000)
cb1_8("cb1[8] w星星亮度", Vector) = (1.0000000000,1.0000000000,0.0000000000,0.0000000000)
cb1_12("cb1[12]", Color) = (0.1000000000,0.2000000000,0.5000000000,0.0000000000)
cb1_13("cb1[13] 云颜色正片叠底", Color) = (0.8557800000,0.8000000000,1.0000000000,1.0000000000)

cb3_4("cb3[4] xy树uv ", Vector) = (10.0000000000,1.0000000000,0.0000000000,0.0000000000)
cb3_6("cb3[6]", Vector) = (0.0000000000,0.0100000000,0.0200000000,0.0000000000)
cb3_7("cb3[7]", Vector) = (0.0000000000,0.0000000000,0.0000000000,0.0000000000)
cb3_8("cb3[8]", Color) = (10.0000000000,0.0000000000,3.0000000000,4.0000000000)
cb3_9("cb3[9] 云亮度补偿 x" , Color) = (1.0000000000,0.0000000000,1.3000000000,1.0000000000)
cb3_10("cb3[10] y噪点红", Color) = (0.0000000000,1.5000000000,0.0000000000,0.0000000000)
cb3_11("cb3[11] 树位置 树亮度 爆暖", Vector) = (0.0000000000,0.0000000000,0.0000000000,0.0000000000)
cb2_0("cb3[11] z全局亮度", Vector) = (-1.13288,-0.54167,0.0000000000,0.0000000000)


    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline"}
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            //  #include "UnityCG.cginc"

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 v0 : TEXCOORD0;
                float2 v01 : TEXCOORD1;
                float2 v1 : TEXCOORD2;
                float2 v11 : TEXCOORD3;
                float2 v4 : TEXCOORD4;
                float4 v41 : TEXCOORD5;
                float4 v5 : TEXCOORD6;
                float2 v51 : TEXCOORD7;

            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float fogCoord : TEXCOOR1;
                float4 o0 : TEXCOOR2;
                float4 o1 : TEXCOOR3;
                float4 o2 : TEXCOOR4;
                float4 o5 : TEXCOOR5;
                // float o2 : TEXCOOR4;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D t0;
            float4 t0_ST;
            
            sampler2D t1;
            float4 t1_ST;

            sampler2D _t2;
            float4 _t2_ST;

            sampler2D t3;
            float4 t3_ST;

            sampler2D t4;
            float4 t4_ST;

            sampler2D t5;
            float4 t5_ST;
            

            // float4_100 cb0;
//   uniform float4 cb0_100;
//   uniform float4 cb1_2;

float4 cb0_44;
float4 cb0_45;
float4 cb0_46;
float4 cb0_47;
float4 cb0_70;
float4 cb0_135;
float4 cb0_140;
float4 cb0_142;
float4 cb0_143;

float4 cb1_0;
float4 cb1_3;
float4 cb1_4;
float4 cb1_6;
float4 cb1_8;
float4 cb1_12;
float4 cb1_13;

float4 cb3_4;
float4 cb3_6;
float4 cb3_7;
float4 cb3_8;
float4 cb3_9;
float4 cb3_10;
float4 cb3_11;

float4 cb2_0;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.fogCoord = ComputeFogFactor(o.vertex.z);                 //注意，这里函数内输入是顶点位置是转换完的。

                o.o0=float4(v.v0.xy,v.v01.xy);
                o.o1=float4(v.v1,v.v11);
                o.o2=float4(v.v4,v.v41.xy);

                // o.o5=float4(v.v5,v.v51);
                o.o5=v.v41;

                return o;
            }

            half4 frag (v2f i) : SV_Target
            {

                float4 v0= i.o0;
                float4 v1= i.o1;
                // float4 v2 =i.vertex;

                float4 v2 =i.o2;
                float4 v4= i.o5;
                float v3 =v3;//PRIMITIVE_ID0
                float v5=0;//SV_IsFrontFace0

                half4 col = tex2D(_MainTex, i.uv);
                col=i.o1;

                // col.rgb = MixFog(col, i.fogCoord);                          //这里注意，雾函数是half3的类型，不能直接给half4赋值，需要改成rgb
         
                t1_ST.z=_Time.y/50%10;
                _t2_ST.z=_Time.y/100%10;

                _t2_ST.z=_Time.y/50%10;
                  float4 r0,r1,r2,r3,r4,r5,r6;
  float4 bitmask, uiDest;
  float4 fDest;

float3 end=float3(1,0,0);
end=v0.xyz;
  r0.xyzw = cb0_45.xyzw * v4.yyyy;
  r0.xyzw = v4.xxxx * cb0_44.xyzw + r0.xyzw;
  r0.xyzw = v4.zzzz * cb0_46.xyzw + r0.xyzw;
  r0.xyzw = cb0_47.xyzw + r0.xyzw;
  r0.xyz = r0.xyz / r0.www;
  r1.xyz = -cb0_70.xyz + r0.xyz;
  r0.x = dot(-r0.xyz, -r0.xyz);
  r0.x = rsqrt(r0.x);
  r0.x = -r0.z * r0.x;
  float cb01 =cb1_0.y%10;
  r0.y = -cb01.x * cb3_8.x + 1;
  r0.z = r0.y * -2 + 1;
  r0.y = cb3_8.y * r0.z + r0.y;
  r0.y = cb0_142.z * r0.y;
  r2.xy = float2(0.00200000009,0.00100000005) * r0.yy;
  r2.z = 0;
  r2.xyzw = v2.xyxy + r2.xzyz;
  r0.yz = r2.xy * float2(1,0.800000012) + float2(0,0.200000003);

  r0.yz=r0.yz*t1_ST.xy+t1_ST.zw;
// end=r0.yyy+10;
end =v2.yyy;
// end=r0.yyy+10;
  r0.y  = tex2D(t1,r0.yz).x;
//   half4 col = SAMPLE_TEXTURE2D(_MainTex,sampler_MainTex,i.uv); 作者：那个人真狗 https://www.bilibili.com/read/cv14184392/ 出处：bilibili
    // r0.y  = SAMPLE_TEXTURE2D(t1,sampler_t1,r0.yz).x;
end=r0.yyy;
  r2.zw=r2.zw*_t2_ST.xy+_t2_ST.zw;
  r0.z  = tex2D(_t2,r2.zw).x;
  r0.x = saturate(-r0.x);
  r0.z = r0.z * cb3_8.z + -r0.y;

  r0.x = r0.x * r0.z + r0.y;
// end=r0.xxx;
  r0.y = mad((int)v3.x, 36, 5);
//   r0.z = t0[r0.y].val[8/4];
r0.z=4912;
//   r0.w = t0[r0.y].val[8/4+1];
r0.w=14112;
  r0.z = r1.z + -r0.z;
  r0.w = -0.300000012 * r0.w;
  r0.z = saturate(r0.z / r0.w);
  r0.z = 1 + -r0.z;
  r0.z = cb1_3.x * r0.z;
  r0.x = r0.z * r0.x;
  r0.z  = step(0 , r0.x)-1;
  r0.x = r0.x * r0.x;
  r0.x = r0.z ? 0 : r0.x;
  r2.xyzw = float4(0.5,0.5,12,12) * v2.xyzw;

  r2.xy=r2.xy*_t2_ST.xy+_t2_ST.zw;
  r0.z  = tex2D(_t2,r2.xy).x;
  r0.w = -cb3_9.x + cb3_8.w;
  r0.z = r0.z * r0.w + cb3_9.x;
  r0.w  = step(0 , r0.x)-1;
  r0.x = log2(r0.x);
  r0.x = r0.z * r0.x;
  r0.x = exp2(r0.x);
  r0.x = r0.w ? 0 : r0.x;
//end=r0.xxx;
  r3.xyz = float3(-0.100000001,-0.100000001,-0.100000001) + cb1_13.xyz;
  r3.xyz = cb1_6.yyy * r3.xyz + float3(0.100000001,0.100000001,0.100000001);
  r4.xyz = float3(-0.00400000019,-0.00499999989,-0.00499999989) + cb1_12.xyz;
  r4.xyz = cb1_6.yyy * r4.xyz + float3(0.00400000019,0.00499999989,0.00499999989);
  r5.xyzw = cb3_9.yyyy * v2.zwzw;
  r2.xyzw = r5.xyzw * float4(6,6,8,8) + r2.zwzw;

  float2 r2xy =r2.xy*_t2_ST.xy+_t2_ST.zw;
  r5.xyz  = tex2D(t3,r2xy).xyz;
  r0.zw = float2(-0.5,-0.5) + r2.zw;
  r2.x = dot(r0.zw, float2(-4.32051017e-008,-1));
  r2.y = dot(r0.zw, float2(1,-4.32051017e-008));
  r0.zw = float2(0.5,0.5) + r2.xy;
  r2.xyz  = tex2D(t3,r0.zw).xyz;
  r6.z = -0.0500000007 * cb0_142.z;
  r0.zw = float2(4,4) * v2.zw;
  r0.zw = cb0_142.zz * float2(0.100000001,0.100000001) + r0.zw;
  r0.z  = tex2D(t4,r0.zw).x;
  r2.xyz = r2.xyz + -r5.xyz;

  r2.xyz = r0.zzz * r2.xyz + r5.xyz;
end =r2.xyz;
  r0.z = cb3_9.z * cb1_4.z;//星星亮度 cb3_9.z  cb1_4.z
  r0.w = 1 + -cb1_8.w;//星星亮度 cb1_8
  end =r0.zzz;
  r0.z = r0.z * r0.w;//星星亮度 cb3_9.z  cb1_4.z
  // end =r2.xyz;
  r2.xyz = r2.xyz * r0.zzz;
  // end=r2.xyz;
  // end = r0.zzz;
  r6.y = 0;
  r0.zw = v2.zw * float2(8,4) + r6.yz;
  r0.z  = tex2D(t4,r0.zw).x;
  r0.w = -cb3_10.x + cb3_9.w;
  r0.w = cb3_9.y * r0.w + cb3_10.x;
  r1.w  = step(0 , r0.z)-1;
  r0.z = log2(r0.z);
  r0.z = r0.w * r0.z;
  r0.z = exp2(r0.z);
  r0.z = r1.w ? 0 : r0.z;
  
  r2.xyz = r2.xyz * r0.zzz;
  
// end=r2.xyz;
  r5.xyz  = step(float3(0,0,0) , r2.xyz)-1;
  r2.xyz = log2(r2.xyz);
  r2.xyz = cb3_10.yyy * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = r5.xyz ? float3(0,0,0) : r2.xyz;

  r2.xyz = r4.xyz + r2.xyz;
  r0.xzw = r0.xxx * r3.xyz + r2.xyz;
// end=r0.xxx * r3.xyz + r2.xyz;
//end=r3.xyz;
//end=r2.xyz;
  r2.xyz = max(float3(0.00800000038,0.00800000038,0.00800000038), cb1_12.xyz);
  r2.xyz = min(float3(1,1,1), r2.xyz);
  r3.x = cb3_10.w * cb0_142.z;
  r3.y = cb3_11.x * cb0_142.z;
  r3.xy = v2.xy * cb3_4.xy + r3.xy;

  r3.xy=r3.xy*t5_ST.xy+t5_ST.zw;
  r3.xyzw  = tex2D(t5,r3.xy).xyzw;
  r2.xyz = r3.xyz * r2.xyz;
  r1.w = max(0.200000003, cb1_6.y);
  r1.w = min(1, r1.w);
  r2.xyz = r2.xyz * r1.www + -r0.xzw;
  r0.xzw = r3.www * r2.xyz + r0.xzw;
  r2.xyz = cb3_6.xyz * r3.xyz;
  r2.xyz = r3.www * r2.xyz;
  r2.xyz = r1.www * r2.xyz + -r0.xzw;
  r0.xzw = cb3_11.yyy * r2.xyz + r0.xzw;
  r1.w = cb2_0.z * -0.949999988 + 1;
  r2.xyz = r1.www * r0.xzw;
  r0.xzw = -r0.xzw * r1.www + cb3_7.xyz;
  r0.xzw = cb3_11.zzz * r0.xzw + r2.xyz;
  r0.xzw = max(float3(0,0,0), r0.xzw);
  r1.w  = step(cb0_140.x , 0)-1;
                col.xyz=cb0_135.yyy * r0.xzw;
                // col.xyz=end;
                // col.xyz=_Time.yyy%1;
                
                return col;
            }
            ENDHLSL
        }
    }
}