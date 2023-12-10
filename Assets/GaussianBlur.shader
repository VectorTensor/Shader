Shader "Examples/ImageEffect/GaussianBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
      

      
        Pass
        {

            Name "Horizontal"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment fragHorizontal
            #include "BlurHelper.cginc"


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
            ENDCG
        }

        Pass
        {

        Name "Vertical"
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment fragVertical
        #include "BlurHelper.cginc"
        float4 fragVertical (v2f i) : SV_Target
            {
            float3 col = float3(0.0f, 0.0f, 0.0f);
            float kernelSum = 0.0f;
            float sigma = _KernelSize / 8.0f;
            int upper = ((_KernelSize - 1) / 2);
            int lower = -upper;
            for (int y = lower; y <= upper; ++y)
                {
                float gauss = gaussian(y, sigma);
                kernelSum += gauss;
                float2 uv = i.uv + float2(0.0f, _MainTex_TexelSize.y * y);     
                col += max(0, gauss * tex2D(_MainTex, uv).xyz);
                }
            col /= kernelSum;
            return float4(col, 1.0f);
            }
        ENDCG      
        }
        
    }
}


