package;

import flixel.FlxSprite;

class CreditIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var link:String;

	public function new(icon:String, ?daLink:String = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ')
	{
		super();
		link = daLink;
		loadGraphic(Paths.image('credits/' + icon, 'shared'));
	}
}
