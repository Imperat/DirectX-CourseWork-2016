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

	float2 X0 = float2(Pos[0], Pos[2]);
	float2 K =  float2(1, 0);
	float w = 1.15; // w is frequency
	float a = 0.01; // a is amplitude
	/*
	    K is a wave vector

	*/
	// X = X0 - (K/k)(a*sin(K*X0 - wt);
	// y = a * cos (K*X0 - wt);
	float h = 0.01 * sin(dot(K, X0) + w*time*3);


	//
	Pos[0] = Pos[0] / 64 - 0.5f;
	Pos[1] = h;
	Pos[2] = Pos[2] / 64 - 0.5f;
	Pos[0] *= 7.5f;
	Pos[1] *= 7.5f;
	Pos[2] *= 7.5f;
    output.Pos = mul( Pos, World );
    output.Pos = mul( output.Pos, View );
    output.Pos = mul( output.Pos, Projection );
	float3 vLightDirection=(-1,0,0.25);
	float4 vLightColor=(0.5,0.5,1,0.7);
	output.Color=saturate( dot( (float3)vLightDirection,output.Pos*0.5f) * vLightColor);
	output.Color += float4(0.2, 0.2, 0.4, 1);
    return output;
}


//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( VS_OUTPUT input ) : SV_Target
{
    return input.Color;
}
