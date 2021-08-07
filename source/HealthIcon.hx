package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;
	public var char:String;
	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		antialiasing = true;
		this.char = char;
		switch (char) {
			case 'abungus':
				frames = Paths.getSparrowAtlas('icons/abungus');
				animation.addByPrefix('abungus', 'icon', 24, true);
			case 'verb':
				frames = Paths.getSparrowAtlas('icons/verb');
				animation.addByPrefix('verb', 'idle', 24, true);
				/*loadGraphic(Paths.image('icons/ronsip'), true, 150, 150);
				animation.add('ronsip', [0], 0, false, isPlayer);*/
			case 'ronsip':
				loadGraphic(Paths.image('icons/ronsip'), true, 150, 150);
				animation.add('ronsip', [0, 1, 2], 0, false, isPlayer);
			case 'gloopy':
				loadGraphic(Paths.image('icons/gloopy'), true, 150, 150);
				animation.add('gloopy', [0, 1, 2], 0, false, isPlayer);
			case 'nothing':
				loadGraphic(Paths.image('icons/smile'), true, 150, 150);
				animation.add('nothing', [0], 0, false, isPlayer);
			case 'lock':
				loadGraphic(Paths.image('icons/lock'), true, 150, 150);
				animation.add('lock', [0], 0, false, isPlayer);
			case 'gf-ronsip':
				loadGraphic(Paths.image('icons/gf-ex'), true, 150, 150);
				animation.add('gf-ronsip', [0, 1, 2], 0, false, isPlayer);
			case 'gf-ex':
				loadGraphic(Paths.image('icons/gf-ex'), true, 150, 150);
				animation.add('gf-ex', [0, 1, 2], 0, false, isPlayer);
			case 'bf-ex' | 'bf-night-ex':
				loadGraphic(Paths.image('icons/bf-ex'), true, 150, 150);
				animation.add(char, [0, 1, 2], 0, false, isPlayer);
			case 'bf-bob':
				loadGraphic(Paths.image('icons/bob'), true, 150, 150);
				animation.add('bf-bob', [0, 1], 0, false, isPlayer);
			case 'bob-cool':
				loadGraphic(Paths.image('icons/bob'), true, 150, 150);
				animation.add('bob-cool', [0, 1, 0], 0, false, isPlayer);
			case 'bobex':
				loadGraphic(Paths.image('icons/bobex'), true, 150, 150);
				animation.add('bobex', [0, 1, 2], 0, false, isPlayer);
			case 'bosipex':
				loadGraphic(Paths.image('icons/bosipex'), true, 150, 150);
				animation.add('bosipex', [0, 1, 2], 0, false, isPlayer);
			case 'amorex':
				loadGraphic(Paths.image('icons/amorex'), true, 150, 150);
				animation.add('amorex', [0, 1, 2], 0, false, isPlayer);
			case 'minishoey':
				loadGraphic(Paths.image('icons/minishoey'), true, 150, 150);
				animation.add('minishoey', [0, 1, 2], 0, false, isPlayer);
			case 'ashandcerb':
				loadGraphic(Paths.image('icons/ash n cerb'), true, 150, 150);
				animation.add('ashandcerb', [9, 10, 11], 0, false, isPlayer);
			case 'ash':
				loadGraphic(Paths.image('icons/ash n cerb'), true, 150, 150);
				animation.add('ash', [0, 1, 2], 0, false, isPlayer);
				animation.add('smallcerbash', [3, 4, 5], 0, false, isPlayer);
				animation.add('smallashcerb', [6, 7, 8], 0, false, isPlayer);
				animation.add('ashcerb', [9, 10, 11], 0, false, isPlayer);
			case 'cerbera':
				loadGraphic(Paths.image('icons/ash n cerb'), true, 150, 150);
				animation.add('ash', [0, 1, 2], 0, false, isPlayer);
				animation.add('smallcerbash', [3, 4, 5], 0, false, isPlayer);
				animation.add('cerbera', [6, 7, 8], 0, false, isPlayer);
				animation.add('ashcerb', [9, 10, 11], 0, false, isPlayer);
			case 'bluskys':
				loadGraphic(Paths.image('icons/bluskys'), true, 150, 150);
				animation.add('bluskys', [0, 1, 2], 0, false, isPlayer);
			case 'cerberus':
				loadGraphic(Paths.image('icons/cerberus and jghost'), true, 150, 150);
				animation.add('cerberus', [0, 1, 2, 3, 4], 0, false, isPlayer);
				animation.add('jghost', [5, 7, 6], 0, false, isPlayer);
			case 'jghost':
				loadGraphic(Paths.image('icons/cerberus and jghost'), true, 150, 150);
				animation.add('cerberus', [0, 1, 2, 3, 4], 0, false, isPlayer);
				animation.add('jghost', [5, 7, 6], 0, false, isPlayer);
			case 'bf-anders':
				loadGraphic(Paths.image('icons/anders'), true, 150, 150);
				animation.add('bf-anders', [0, 1, 0], 0, false, isPlayer);
			default:
				loadGraphic(Paths.image('iconGrid'), true, 150, 150);

				
				animation.add('bf', [0, 1, 35], 0, false, isPlayer);
				animation.add('bf-ex', [0, 1, 35], 0, false, isPlayer);
				animation.add('bf-night-ex', [0, 1, 35], 0, false, isPlayer);
				animation.add('bf-night', [0, 1, 35], 0, false, isPlayer);
				animation.add('bf-car', [0, 1], 0, false, isPlayer);
				animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
				animation.add('bf-pixel', [21, 21], 0, false, isPlayer);
				animation.add('spooky', [2, 3], 0, false, isPlayer);
				animation.add('pico', [4, 5], 0, false, isPlayer);
				animation.add('mom', [6, 7], 0, false, isPlayer);
				animation.add('mom-car', [6, 7], 0, false, isPlayer);
				animation.add('tankman', [8, 9], 0, false, isPlayer);
				animation.add('face', [10, 11], 0, false, isPlayer);
				animation.add('dad', [12, 13], 0, false, isPlayer);
				animation.add('senpai', [22, 22], 0, false, isPlayer);
				animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
				animation.add('spirit', [23, 23], 0, false, isPlayer);
				animation.add('bf-old', [14, 15], 0, false, isPlayer);
				animation.add('gf', [16, 33, 34], 0, false, isPlayer);
				animation.add('gf-ex', [16, 33, 34], 0, false, isPlayer);
				animation.add('gf-night-ex', [16, 33, 34], 0, false, isPlayer);
				animation.add('gf-christmas', [16], 0, false, isPlayer);
				animation.add('gf-pixel', [16], 0, false, isPlayer);
				animation.add('parents-christmas', [17, 18], 0, false, isPlayer);
				animation.add('monster', [19, 20], 0, false, isPlayer);
				animation.add('monster-christmas', [19, 20], 0, false, isPlayer);
				animation.add('bob', [27, 29, 28], 0, false, isPlayer);
				animation.add('bf-worriedbob', [27, 29, 28], 0, false, isPlayer);
				animation.add('bobex', [27, 29, 28], 0, false, isPlayer);
				animation.add('bosip', [30, 32, 31], 0, false, isPlayer);
				animation.add('bosipex', [30, 32, 31], 0, false, isPlayer);
				animation.add('amor', [24, 25, 26], 0, false, isPlayer);
				animation.add('amorex', [24, 25, 26], 0, false, isPlayer);
				animation.add('pc', [24, 25, 26], 0, false, isPlayer);
				animation.add('cj', [24, 25, 26], 0, false, isPlayer);
				animation.add('bobal', [24, 25, 26], 0, false, isPlayer);
				

				switch(char)
				{
					case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
						antialiasing = false;
				}

		}
		animation.play(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
