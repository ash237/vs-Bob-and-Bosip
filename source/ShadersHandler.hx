package;

import openfl.display.Shader;
import openfl.filters.ShaderFilter;

class ShadersHandler
{
	public static var chromaticAberration:ShaderFilter = new ShaderFilter(new ChromaticAberration());
	public static var radialBlur:ShaderFilter = new ShaderFilter(new RadialBlur());
	public static var directionalBlur:ShaderFilter = new ShaderFilter(new DirectionalBlur());
	public static var scanline:ShaderFilter = new ShaderFilter(new Scanline());

	public static function setChrome(chromeOffset:Float):Void
	{
		chromaticAberration.shader.data.rOffset.value = [chromeOffset];
		chromaticAberration.shader.data.gOffset.value = [0.0];
		chromaticAberration.shader.data.bOffset.value = [chromeOffset * -1];
	}
	public static function setRadialBlur(x:Float=640,y:Float=360,power:Float=0.03):Void
	{
		radialBlur.shader.data.blurWidth.value = [power];
		radialBlur.shader.data.cx.value = [x/2560];
		radialBlur.shader.data.cy.value = [y/1440];
	}
	public static function setBlur(angle:Float,power:Float=0.1):Void
	{
		radialBlur.shader.data.angle.value = [angle];
		radialBlur.shader.data.strength.value = [power];
	}
}
