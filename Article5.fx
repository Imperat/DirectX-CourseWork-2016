//--------------------------------------------------------------------------------------
// File: Article5.fx
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------
cbuffer ConstantBuffer : register( b0 )
{
	matrix World;
	matrix View;
	matrix Projection;
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
	int u = 32;
	int v = 32;
	float i = Pos[0];
	float j = Pos[2];
	float x = ((float)i / (float)u) - 0.25f;
	float y = ((float)j / (float)v) - 0.25f;
	float xx = ((float)i / (float)u) - 0.5f;
	float yy = ((float)j / (float)v) - 0.5f;
	float h = xx*yy*xx*yy + 0.3f / (1.0f + (x*x + y*y)*50.0f);
	Pos[0] = Pos[0] / 32 - 0.5f;
	Pos[1] = h;
	Pos[2] = Pos[2] / 32 - 0.5f;
	Pos[0] *= 7.5f;
	Pos[1] *= 7.5f;
	Pos[2] *= 7.5f;
    output.Pos = mul( Pos, World );
    output.Pos = mul( output.Pos, View );
    output.Pos = mul( output.Pos, Projection );
	float3 vLightDirection=(-1,0,0.25);
	float4 vLightColor=(1,1,1,1);
	output.Color=saturate( dot( (float3)vLightDirection,output.Pos*0.5f) * vLightColor);
	output.Kefal = true;
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
