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
	int u = 64;
	int v = 64;
	float i = Pos[0];
	float j = Pos[2];
	float x = ((float)i / (float)u) - 0.25f;
	float y = ((float)j / (float)v) - 0.25f;
	float xx = ((float)i / (float)u) - 0.5f;
	float yy = ((float)j / (float)v) - 0.5f;
	float w = 1;
	float h = 0.01 * sin(dot(float2(1, 0), float2(i, j))*w + time*3);
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
	output.Kefal = true;
	output.Color += float4(0.2, 0.2, 0.4, 1);
    return output;
}


//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( VS_OUTPUT input ) : SV_Target
{
	if (input.Kefal == false){
		return 0;
	}
    return input.Color;
}
