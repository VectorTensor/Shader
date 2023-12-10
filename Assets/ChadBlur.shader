Shader "Unlit/ChadBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _KernelSize ("kernel size", Range(1,100)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment fragGeneralFilter
           

            #include "UnityCG.cginc"
            static const float E = 2.71828f;
            static const float PI = 3.14159f;

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

            sampler2D _MainTex;
            float2 _MainTex_TexelSize;
            uint _KernelSize = 3;
            float3x3 _filter = {
                             1/16,1/8,1/16,
                1/8,1/4,1/8,
                1/16,1/8,1/16
                };
            float gaussian(int x , float sigma){
                float twoSigmaSqr = 2*sigma*sigma;
                return (1/sqrt(PI * twoSigmaSqr)) * pow(E, -(x*x)/(2*twoSigmaSqr));

            }
            v2f vert (appdata v)
            {
                v2f o;
                o.positionCS = UnityObjectToClipPos(v.positionOS);
                o.uv = v.uv;
                return o;
            }

            float4 fragHorizontal(v2f i ): SV_Target {
                
                float3  col = float3(0.0f , 0.0f, 0.0f);
                float kernelSum = 0.0f;
                int upper = ((_KernelSize -1 )/2);
                float sigma = _KernelSize / 8.0f;
                int lower = -upper;
                for(int x= lower; x<= upper;++x){
                    float gauss = gaussian(x, sigma);
                    kernelSum += gauss;
                    
                    float2 uv = i.uv + float2(_MainTex_TexelSize.x *x, 0.0f);
                    col += max(0, gauss*tex2D(_MainTex,uv).xyz);
                }
            col /= kernelSum;



                
            return float4(col,1.0f);
            }

            float4 fragGeneralFilter(v2f i ): SV_Target {
                
                float3  col = float3(0.0f , 0.0f, 0.0f);
                float kernelSum = 0.0f;
                int upper = ((_KernelSize -1 )/2);
                float sigma = _KernelSize / 8.0f;
                int lower = -upper;
                for(int x= lower; x<= upper;++x){

                    for(int y = lower; y<=upper; ++y)
                    {
                        float gauss = _filter[x+1,y+1];
                        kernelSum += gauss;
                    
                        float2 uv = i.uv + float2(_MainTex_TexelSize.x *x,_MainTex_TexelSize.y *y );
                        col += max(0, gauss*Luminance(tex2D(_MainTex,uv).xyz));
                    }
                    
                }
            //col /= kernelSum;

                //return float4(_filter[i.uv.x,i.uv.y],1);
               // return _filter[x+1,y+1];
            return float4(col,1.0f);
            }
            ENDCG
        }
    }
}
