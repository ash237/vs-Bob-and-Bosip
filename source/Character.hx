package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;
	public var menuMode:Bool = false;
	public var noteSkin:String = 'normal';

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	public var iconColor:String = "FF50a5eb";
	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false, ?fromCache:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				noteSkin = 'gf';
				// GIRLFRIEND CODE
				iconColor = 'FFc42d06';
				tex = Paths.getSparrowAtlas('characters/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-ex':
				noteSkin = 'gf';
				// GIRLFRIEND CODE
				iconColor = 'FFE10096';
				tex = Paths.getSparrowAtlas('characters/extra/GF_ass_sets_outfit');
				frames = tex;
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByPrefix('alright', 'GF Alright', 24, false);
				animation.addByPrefix('spin', 'GF go for a spin', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('sad', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
				addOffset('spin', 0, -8);
				addOffset('alright', 0, -6);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);

				playAnim('danceRight');
			case 'gf-night':
				noteSkin = 'gf';
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GFnight_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
			case 'gf-night-ex':
				noteSkin = 'gf';
				tex = Paths.getSparrowAtlas('characters/extra/GF_ass_sets_outfit_with_bb');
				frames = tex;
				animation.addByIndices('sad', 'GF Dancing Beat EX instance 1', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat EX instance 1', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat EX instance 1', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);
				addOffset('sad', 0);

				playAnim('danceRight');
			case 'gf-bob':
				tex = Paths.getSparrowAtlas('characters/Bob_gf');
				frames = tex;
				animation.addByIndices('sad', 'gf sad', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);
				addOffset('sad', 0);

				playAnim('danceRight');
			case 'gf-ronsip':
				tex = Paths.getSparrowAtlas('characters/extra/GF_ANDRONCOOLGUYONSPEAKEROHMYGODHEISSOCOOL');
				frames = tex;
				animation.addByIndices('sad', 'gf sad', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);
				addOffset('sad', -559, -715);

				playAnim('danceRight');
			case 'gf-but-bosip':
				tex = Paths.getSparrowAtlas('characters/extra/worriedbosip');
				frames = tex;
				animation.addByPrefix('idle', 'BOSIP Scared', 24, false);

				addOffset('idle', 0);

				setGraphicSize(Std.int(width * 0.92));
				playAnim('idle');
			case 'gf-bosip':
				tex = Paths.getSparrowAtlas('characters/Bosip_gf');
				frames = tex;
				animation.addByIndices('sad', 'gf sad', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);
				addOffset('sad', 0);

				playAnim('danceRight');
			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
			case 'spooky':
				tex = Paths.getSparrowAtlas('characters/spooky_kids_assets');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);

				playAnim('danceRight');
			case 'mom':
				tex = Paths.getSparrowAtlas('characters/Mom_Assets');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('characters/momCar');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('characters/Monster_Assets');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -30, -40);
				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('characters/monsterChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);
				playAnim('idle');
			case 'pico':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				addOffset("singUPmiss", -19, 67);
				addOffset("singRIGHTmiss", -60, 41);
				addOffset("singLEFTmiss", 62, 64);
				addOffset("singDOWNmiss", 210, -28);

				playAnim('idle');

				flipX = true;

			case 'bf-anders':
				noteSkin = 'bf';
				var tex = Paths.getSparrowAtlas('characters/extra/anders', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note LEFT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singUPmiss', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHTmiss', 'Dad Sing Note LEFT', 24);
				animation.addByPrefix('singDOWNmiss', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFTmiss', 'Dad Sing Note RIGHT', 24);

				addOffset('idle');
				addOffset("singUP", 8, 99);
				addOffset("singLEFT", 119, 34);
				addOffset("singRIGHT", 79, 12);
				addOffset("singDOWN", 14, -20);
				addOffset("singUPmiss", 8, 99);
				addOffset("singLEFTmiss", 119, 34);
				addOffset("singRIGHTmiss", 79, 12);
				addOffset("singDOWNmiss", 14, -20);

				playAnim('idle');
			case 'bf':
				noteSkin = 'bf';
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;
			case 'bf-ex':
				iconColor = 'FF0EAEFE';
				noteSkin = 'bf';
				var tex = Paths.getSparrowAtlas('characters/extra/BoyFriend_Assets_EX', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;
			case 'bf-night-ex':
				noteSkin = 'bf';
				var tex = Paths.getSparrowAtlas('characters/extra/BoyFriend_Assets_EX_night', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;
			case 'bf-bob':
				var tex = Paths.getSparrowAtlas('characters/extra/bob_asset', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'bob_idle', 24, false);
				animation.addByPrefix('singUP', 'bob_UP', 24, false);
				animation.addByPrefix('singLEFT', 'bob_LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'bob_RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'bob_DOWN', 24, false);
				animation.addByPrefix('singUPmiss', 'bob_UP', 24, false);
				animation.addByPrefix('singLEFTmiss', 'bob_LEFT', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'bob_RIGHT', 24, false);
				animation.addByPrefix('singDOWNmiss', 'bob_DOWN', 24, false);
				animation.addByPrefix('hey', 'bob_idle', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");
				addOffset("hey");

				playAnim('idle');

				flipX = true;
			case 'bob-cool':
				noteSkin = 'gloopy';
				iconColor = 'FFFFFFFF';
				var tex = Paths.getSparrowAtlas('characters/extra/bob_asset', 'shared');
				frames = tex;

				trace(tex.frames.length);
				
				animation.addByPrefix('idle', 'bob_idle', 24, false);
				animation.addByPrefix('singUP', 'bob_UP', 24, false);
				animation.addByPrefix('singLEFT', 'bob_LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'bob_RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'bob_DOWN', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				playAnim('idle');

				flipX = true;
			case 'bf-night':
				noteSkin = 'bf';
				var tex = Paths.getSparrowAtlas('characters/BOYFRIENDnight', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;

			case 'senpai':
				frames = Paths.getSparrowAtlas('characters/senpai');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters/senpai');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				frames = Paths.getPackerAtlas('characters/spirit');
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				addOffset('idle', -220, -280);
				addOffset('singUP', -220, -240);
				addOffset("singRIGHT", -220, -280);
				addOffset("singLEFT", -200, -280);
				addOffset("singDOWN", 170, 110);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets');
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				addOffset('idle');
				addOffset("singUP", -47, 24);
				addOffset("singRIGHT", -1, -23);
				addOffset("singLEFT", -30, 16);
				addOffset("singDOWN", -31, -29);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);

				playAnim('idle');
			case 'amor':
				iconColor = "FFd73c92";
				noteSkin = 'amor';
				frames = Paths.getSparrowAtlas('characters/extra/amor_assets', 'shared');
				animation.addByPrefix('idle', 'Amor idle dance', 24, false);
				animation.addByPrefix('singUP', 'Amor Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'Amor Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Amor Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'Amor Sing Note RIGHT', 24, false);
				animation.addByPrefix('drop', 'Amor drop', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 41);
				addOffset("singRIGHT", -11, 2);
				addOffset("singLEFT", 25, 1);
				addOffset("singDOWN", -23, -16);
				addOffset("drop", 42, 156);

				playAnim('idle');
			case 'amorex':
				iconColor = "FF9E2947";
				noteSkin = 'amor';
				frames = Paths.getSparrowAtlas('characters/extra/amorex', 'shared');
				animation.addByPrefix('idle', 'amor idle big0', 24, false);
				animation.addByPrefix('singUP', 'amor up big', 24, false);
				animation.addByPrefix('singDOWN', 'amor down big', 24, false);
				animation.addByPrefix('singLEFT', 'amor left big', 24, false);
				animation.addByPrefix('singRIGHT', 'amor right big', 24, false);
				animation.addByPrefix('drop', 'amor fucking dies', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 41);
				addOffset("singRIGHT", -11, 2);
				addOffset("singLEFT", 24, 2);
				addOffset("singDOWN", -23, -22);
				addOffset("drop", 138, 94);

				playAnim('idle');
			case 'bob':
				iconColor = "FFebdd44";
				noteSkin = 'bob';
				frames = Paths.getSparrowAtlas('characters/extra/bob_assets', 'shared');
				animation.addByPrefix('idle', 'BOB idle dance', 24, false);
				animation.addByPrefix('singUP', 'BOB Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'BOB Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'BOB Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'BOB Sing Note RIGHT', 24, false);

				addOffset('idle');
				addOffset("singUP", -36, 57);
				addOffset("singRIGHT", -62, 32);
				addOffset("singLEFT",31, 13);
				addOffset("singDOWN", -31, -10);

				playAnim('idle');

			case 'bobex':
				iconColor = "FF2F2F2F";
				noteSkin = 'bob';
				frames = Paths.getSparrowAtlas('characters/extra/bobEX', 'shared');
				animation.addByPrefix('idle', 'BOB idle dance', 24, false);
				animation.addByPrefix('singUP', 'BOB Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'BOB Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'BOB Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'BOB Sing Note RIGHT', 24, false);

				addOffset('idle');
				addOffset("singUP", 114, 47);
				addOffset("singRIGHT", 78, -38);
				addOffset("singLEFT", 90, -14);
				addOffset("singDOWN", 19, -75);

				playAnim('idle');
			case 'bosip':
				iconColor = "FFe18b38";
				noteSkin = 'bosip';
				frames = Paths.getSparrowAtlas('characters/extra/bosip_assets', 'shared');
				animation.addByPrefix('idle', 'Bosip idle dance', 24, false);
				animation.addByPrefix('singUP', 'Bosip Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'Bosip Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Bosip Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'Bosip Sing Note RIGHT', 24, false);

				addOffset('idle');
				addOffset("singUP", 23, 24);
				addOffset("singRIGHT", -6, -18);
				addOffset("singLEFT", 64, 7);
				addOffset("singDOWN", 22, -18);

				playAnim('idle');
			case 'bosipex':
				iconColor = "FF533D3A";
				noteSkin = 'bosip';
				frames = Paths.getSparrowAtlas('characters/extra/bosipex', 'shared');
				animation.addByPrefix('idle', 'Bosip idle dance', 24, false);
				animation.addByPrefix('singUP', 'Bosip Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'Bosip Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Bosip Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'Bosip Sing Note RIGHT', 24, false);

				addOffset('idle');
				addOffset("singUP", 3, 50);
				addOffset("singRIGHT", -16, -13);
				addOffset("singLEFT", 66, 1);
				addOffset("singDOWN", 52, -63);

				playAnim('idle');
			case 'bobal':
				iconColor = "FFe18b38";
				frames = Paths.getSparrowAtlas('characters/extra/big boobal', 'shared');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				addOffset('idle');
				addOffset("singUP", 57, 171);
				addOffset("singRIGHT", -26, -49);
				addOffset("singLEFT", 73, 30);
				addOffset("singDOWN", 22, -97);

				playAnim('idle');
			case 'pc':
				iconColor = "FFd73c92";
				noteSkin = 'amor';
				frames = Paths.getSparrowAtlas('characters/extra/pc', 'shared');
				animation.addByPrefix('idle', 'PC idle', 24, false);
				animation.addByPrefix('singUP', 'PC Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'PC Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'PC Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'PC Note RIGHT', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				playAnim('idle');
			case 'cj':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/extra/cj_assets','shared');
				frames = tex;
				animation.addByPrefix('idle', 'cj idle dance', 24, false);
				animation.addByPrefix('singUP', 'cj Sing Note UP0', 24, false);
				animation.addByPrefix('singLEFT', 'cj Sing Note LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'cj Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'cj Sing Note DOWN0', 24, false);
				animation.addByPrefix('ha', 'cj singleha0', 24, false);
				animation.addByPrefix('haha', 'cj doubleha0', 24, false);
				animation.addByPrefix('intro', 'cj intro0', 24, false);

				addOffset('idle');
				addOffset('intro', 590, 232);
				addOffset("singUP", -46, 28);
				addOffset("singRIGHT", -20, 37);
				addOffset("singLEFT", -2, 3);
				addOffset("singDOWN", -20, -20);
				addOffset('ha', -46, 28);
				addOffset('haha', -46, 28);

				playAnim('idle');
			case 'jghost':
				noteSkin = 'jghost';
				iconColor = "FFE18450";
				frames = Paths.getSparrowAtlas('characters/extra/Jghost', 'shared');
				animation.addByPrefix('idle', 'Jghost idle dance', 24, false);
				animation.addByPrefix('singUP', 'Jghost Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'Jghost Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Jghost Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'Jghost Sing Note RIGHT', 24, false);

				addOffset('idle');
				addOffset("singUP", 54, 37);
				addOffset("singRIGHT", -22, -8);
				addOffset("singLEFT",301, -10);
				addOffset("singDOWN", -36, -55);

				playAnim('idle');

			case 'cerberus':
				iconColor = "FFF3F1DC";
				frames = Paths.getSparrowAtlas('characters/extra/Cerberus', 'shared');
				animation.addByPrefix('idle', 'Cerberus idle dance', 24, false);
				animation.addByPrefix('singUP', 'Cerberus Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'Cerberus Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Cerberus Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'Cerberus Sing Note RIGHT', 24, false);

				addOffset('idle');
				addOffset("singUP", -27, 4);
				addOffset("singRIGHT", 6, -12);
				addOffset("singLEFT",-25, -12);
				addOffset("singDOWN", -24, -11);

				playAnim('idle');
			case 'bluskys':
				iconColor = "FF4975ED";
				noteSkin = 'bluskys';
				frames = Paths.getSparrowAtlas('characters/extra/Bluskys', 'shared');
				animation.addByPrefix('idle', 'Bluskys idle dance', 24, false);
				animation.addByPrefix('singUP', 'Bluskys Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'Bluskys Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Bluskys Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'Bluskys Sing Note RIGHT', 24, false);
				animation.addByPrefix('drop', 'Bluskys Letsgo', 24, false);

				addOffset('idle');
				addOffset("singUP", -30, 36);
				addOffset("singRIGHT", -64, -13);
				addOffset("singLEFT",-30, -12);
				addOffset("singDOWN", -35, -23);
				addOffset("drop", 55, 84);

				playAnim('idle');

			case 'ash':
				iconColor = "FFFFFFFF";
				noteSkin = 'ash';
				frames = Paths.getSparrowAtlas('characters/extra/ASH', 'shared');
				animation.addByIndices('danceLeft', 'ASH idle dance', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], '', 24, false);
				animation.addByIndices('danceRight', 'ASH idle dance', [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25], '', 24, false);
				animation.addByIndices('danceRightStatic', 'ASH idle dance', [0], '', 0, false);
				animation.addByPrefix('singUP', 'ASH Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'ASH Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'ASH Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'ASH Sing Note RIGHT', 24, false);

				addOffset('danceLeft');
				addOffset('danceRight');
				
				addOffset("singUP", 93, 41);
				addOffset("singRIGHT", -74, -23);
				addOffset("singLEFT", 122, -74);
				addOffset("singDOWN", -35, -93);

				playAnim('danceRight');

			case 'cerbera':
				iconColor = "FF000000";
				frames = Paths.getSparrowAtlas('characters/extra/Cerb', 'shared');
				animation.addByPrefix('idle', 'Cerb idle dance', 24, false);
				animation.addByPrefix('singUP', 'Cerb Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'Cerb Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Cerb Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'Cerb Sing Note RIGHT', 24, false);

				addOffset('idle');
				addOffset("singUP", 18, 20);
				addOffset("singRIGHT", 5, -13);
				addOffset("singLEFT",13, 9);
				addOffset("singDOWN", -23, -32);

				playAnim('idle');
			case 'minishoey':
				noteSkin = 'minishoey';
				iconColor = "FF7C68A0";
				frames = Paths.getSparrowAtlas('characters/extra/Minishoey', 'shared');
				animation.addByPrefix('idle', 'Minishoey idle dance', 24, false);
				animation.addByPrefix('singUP', 'Minishoey Sing Note UP', 24, false);
				animation.addByPrefix('singDOWN', 'Minishoey Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Minishoey Sing Note LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'Minishoey Sing Note RIGHT', 24, false);

				addOffset('idle');
				addOffset("singUP", 16, 15);
				addOffset("singRIGHT", -27, 6);
				addOffset("singLEFT", 6, 4);
				addOffset("singDOWN", -18, -12);

				playAnim('idle');
			case 'gloopy':
				noteSkin = 'gloopy';
				iconColor = "FFebdd44";
				if (fromCache)
					frames = Paths.getSparrowAtlasFromCache('characters/extra/STUPID_GLOOP_MAN', 'shared');
				else
					frames = Paths.getSparrowAtlas('characters/extra/STUPID_GLOOP_MAN', 'shared');
				animation.addByPrefix('idle', 'bob_idle', 24, false);
				animation.addByPrefix('singUP', 'bob_up', 24, false);
				animation.addByPrefix('singDOWN', 'bob_down', 24, false);
				animation.addByPrefix('singLEFT', 'bob_left', 24, false);
				animation.addByPrefix('singRIGHT', 'bob_right', 24, false);
				animation.addByPrefix('drop', 'bobismad', 24, true);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("drop", -96, -21);

				playAnim('idle');
			case 'verb':
				noteSkin = 'gloopy';
				iconColor = "FFebdd44";
				if (fromCache)
					frames = Paths.getSparrowAtlasFromCache('characters/extra/verbalase', 'shared');
				else
					frames = Paths.getSparrowAtlas('characters/extra/verbalase', 'shared');
				animation.addByPrefix('idle', 'idle', 24, true);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				addOffset('idle');
				addOffset("singUP", 120, 130);
				addOffset("singRIGHT", 127);
				addOffset("singLEFT", 138, -2);
				addOffset("singDOWN", 160);

				playAnim('idle');

				flipX = false;
			case 'abungus':
				noteSkin = 'ronsip';
				iconColor = "FFebdd44";
				frames = Paths.getSparrowAtlas('characters/extra/abungus', 'shared');
				animation.addByPrefix('idle', 'idle', 24, true);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				playAnim('idle');

				flipX = false;
			case 'ronsip':
				noteSkin = 'ronsip';
				iconColor = "FFebdd44";
				frames = Paths.getSparrowAtlas('characters/extra/kill_yourself', 'shared');
				animation.addByPrefix('idle', 'RON_IDLE', 24, false);
				animation.addByPrefix('singUP', 'RON_UP', 24, false);
				animation.addByPrefix('singDOWN', 'RON_DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'RON_LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'RON_RIGHT', 24, false);

				//addOffset("singDOWN", 160 -180);
				animOffsets['singDOWN'] = [160, -180];
				addOffset('idle');
				addOffset("singUP", -20, -50);
				addOffset("singRIGHT", -30, -50);
				addOffset("singLEFT", 600, 220);
				
				playAnim('idle');
			case 'bf-worriedbob':
				noteSkin = 'bob';
				iconColor = "FFebdd44";
				frames = Paths.getSparrowAtlas('characters/extra/Worriedbob', 'shared');

				animation.addByPrefix('idle', 'BOB idle dance', 24, false);
				animation.addByPrefix('singUP', 'BOB Sing Note UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BOB Sing Note LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BOB Sing Note RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BOB Sing Note DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'Bob Miss up', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Bob Miss left', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Bob Miss right', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Bob Miss down', 24, false);

				animation.addByPrefix('firstDeath', "bob fucking dies0", 24, false);
				animation.addByPrefix('deathLoop', "bob fucking dies loop", 24, true);
				animation.addByPrefix('deathConfirm', "bob fucking dies confirm", 24, false);

				addOffset('idle');
				addOffset("singUP", 17, 26);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 94, 3);
				addOffset("singDOWN", -11, -61);
				addOffset("singUPmiss", 31, 24);
				addOffset("singRIGHTmiss", -40, -7);
				addOffset("singLEFTmiss", 102, -2);
				addOffset("singDOWNmiss", -7, -61);
				addOffset('firstDeath', 116, -60);
				addOffset('deathLoop', 115, -62);
				addOffset('deathConfirm', 115, -51);

				playAnim('idle');

				flipX = true;
			case 'deadron':
				frames = Paths.getSparrowAtlas('sunset/happy/RON_dies_lmaoripbozo_packwatch', 'shared');
				animation.addByIndices('idle', 'rip my boy ron', [57], '', 24, false);
				
				addOffset('idle');

				playAnim('idle');
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf') || menuMode)
		{
			if (animation.curAnim.name.startsWith('sing') || animation.curAnim.name.startsWith('haha'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				trace('dance');
				if (curCharacter == 'ash')
					playAnim('danceLeft');
				else
					dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
			case 'gf-night':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-ex' | 'gf-ronsip':
					if (!animation.curAnim.name.startsWith('hair') && !animation.curAnim.name.startsWith('alright') && !animation.curAnim.name.startsWith('spin') || animation.curAnim.name.startsWith('alright') && animation.curAnim.finished || animation.curAnim.name.startsWith('spin') && animation.curAnim.finished)
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-night':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-bob':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-bosip':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-night-ex':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				case 'ash':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				case 'amor' | 'bluskys' | 'amorex':
					if (!animation.curAnim.name.startsWith('drop'))
						playAnim('idle', true);
				case 'gloopy':
					if (!animation.curAnim.name.startsWith('drop'))
						playAnim('idle');
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'ash' && AnimName.startsWith('sing'))
			danced = true;
		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
