package;

import flixel.FlxSprite;

class CreditIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var link:String;

	public function new(xPos:Float = 0, yPos:Float = 0, icon:String = 'Amor', ?daLink:String = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ')
	{
		super(xPos, yPos);
		link = daLink;
		loadGraphic(Paths.image('credits/icons/icon' + icon));
	}
}
