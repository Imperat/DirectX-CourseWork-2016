//--------------------------------------------------------------------------------------
// File: Shader.fx
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------
cbuffer ConstantBuffer : register( b0 )
{
	matrix World;
	matrix View;
	matrix Projection;
	float time;
}

//--------------------------------------------------------------------------------------
struct VS_OUTPUT
{
    float4 Pos : SV_POSITION;
    float4 Color : COLOR0;
	bool Kefal : KEFAL;
};

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
VS_OUTPUT VS( float4 Pos : POSITION, float4 Color : COLOR )
{
    VS_OUTPUT output = (VS_OUTPUT)0;
	// width and height of grid
	int u = 128;
	int v = 128;

	float s_X = 0;
	float s_Y = 0;
	float s_Z = 0;


	float2 X0 = float2(Pos[0], Pos[2]);
		float height = 0;
		for (int i = 0; i < 3; i++){
			float2 K = float2(1, i);
				float w = 1.5; // w is frequency
			float a = 0.01; // a is amplitude
			/*
				K is a wave vector

				*/
			// X = X0 - (K/k)(a*sin(K*X0 - wt);
			// y = a * cos (K*X0 - wt);
			//float h = 0.01 * sin(dot(K, X0) + w*time*3);

			float2 X = X0 - K * a*sin(dot(K, X0) - w*time * 3);
				float  y = a * cos(dot(K, X0) - w*time * 3);
			s_X += X[0] / 64 - 0.5f;
			s_Y += X[1] / 64 - 0.5f;
			s_Z += y;
		}
		Pos[0] = s_X;
		Pos[2] = s_Y;
		Pos[1] = s_Z;


	/*Pos[0] *= 7.5f;
	Pos[1] *= 7.5f;
	Pos[2] *= 7.5f;*/
	Pos *= 7.5f;
	Pos[3] /= 7.5f;
    output.Pos = mul( Pos, World );
    output.Pos = mul( output.Pos, View );
    output.Pos = mul( output.Pos, Projection );
	float3 vLightDirection=(-1,0,0.25);
	float4 vLightColor=(0.2,0.7,0.8,0.7);
	output.Color=saturate( dot( (float3)vLightDirection,output.Pos*0.5f) * vLightColor);
	output.Color += float4(0.1, 0.2, 0.5, 1);
	output.Color /= 1.75;
    return output;
}


//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( VS_OUTPUT input ) : SV_Target
{
    return input.Color;
}
