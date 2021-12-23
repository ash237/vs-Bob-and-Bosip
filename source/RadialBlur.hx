package;

import flixel.*;
import flixel.system.FlxAssets.FlxShader;
/**
 * ...
 * @author bbpanzu
 */
class RadialBlur extends FlxShader
{

	@:glFragmentSource('
		#pragma header

	uniform float cx = 0.0;
	uniform float cy = 0.0;
    uniform float blurWidth = 10.0;
	
	const int nsamples = 30;
	
	void main(){
		vec4 color = texture2D(bitmap, openfl_TextureCoordv);
			vec2 res;
			res = openfl_TextureCoordv;
		vec2 pp;
		pp = vec2(cx, cy);
		vec2 center = pp.xy /res.xy;
		float blurStart = 1.0;

		
		vec2 uv = openfl_TextureCoordv.xy;
		
		uv -= center;
		float precompute = blurWidth * (1.0 / float(nsamples - 1));
		
		for(int i = 0; i < nsamples; i++)
		{
			float scale = blurStart + (float(i)* precompute);
		color += texture(bitmap, uv * scale + center);
		}
		
		
		color /= float(nsamples);
		
		gl_FragColor = color; 
	
	}')
	public function new()
	{
		super();
		
		
	}
	
}