 
 
#include "UnityCG.cginc"
static const float E = 2.71828f;
static const float PI = 3.14159f;


sampler2D _MainTex;
float2 _MainTex_TexelSize;
uint _KernelSize = 3;


float gaussian(int x , float sigma){
    float twoSigmaSqr = 2*sigma*sigma;
    return (1/sqrt(PI * twoSigmaSqr)) * pow(E, -(x*x)/(2*twoSigmaSqr));

}

struct appdata
{
    float4 positionOS : POSITION;
    float2 uv : TEXCOORD0;
};

struct v2f
{
    float2 uv : TEXCOORD0;
    float4 positionCS : SV_POSITION;
};

v2f vert (appdata v)
{
    v2f o;
    o.positionCS = UnityObjectToClipPos(v.positionOS);
    o.uv = v.uv;
    return o;
}


        