package;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;

class CreditIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var link:String;
	public var xPos:Float;
	public var yPos:Float;
	public var theTween:FlxTween;

	public function new(xPos:Float = 0, yPos:Float = 0, icon:String = 'Amor', ?daLink:String = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ')
	{
		this.xPos = xPos;
		this.yPos = yPos;
		super(xPos, yPos);
		link = daLink;
		loadGraphic(Paths.image('credits/icons/icon' + icon));
		theTween = FlxTween.tween(this, {x: x}, 0, {});
	}
}
