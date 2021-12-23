package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
	*DEBUG MODE
 */
class AnimationDebug extends FlxState
{
	var bf:Boyfriend;
	var dad:Character;
	var dad2:Character;
	var char:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var dad2animList:Array<String> = [];
	var curAnim:Int = 0;
	var curDad2Anim:Int = 0;
	var isDad:Bool = true;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;
	var dadBG:Character;

	public function new(daAnim:String = 'spooky')
	{
		super();
		this.daAnim = daAnim;
	}

	override function create()
	{
		FlxG.sound.music.stop();

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);

		if (daAnim == 'bf')
			isDad = false;

		if (isDad)
		{
			dadBG = new Character(0, 0, daAnim);
			dadBG.screenCenter();
			dadBG.debugMode = true;
			dadBG.alpha = 0.75;
			dadBG.color = 0xFF000000;

			add(dadBG);
			dad = new Character(0, 0, daAnim);
			dad.screenCenter();
			dad.debugMode = true;
			add(dad);

			dad2 = new Character(-490, 200, 'cerberus-ex');
			dad2.debugMode = true;
			add(dad2);

			char = dad;
			dad.flipX = false;
			dadBG.flipX = false;
		}
		else
		{
			bf = new Boyfriend(0, 0);
			bf.screenCenter();
			bf.debugMode = true;
			add(bf);

			char = bf;
			bf.flipX = false;
		}

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(300, 16);
		textAnim.size = 26;
		textAnim.scrollFactor.set();
		add(textAnim);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		super.create();
		for (anim => offsets in dad2.animOffsets)
		{
			dad2animList.push(anim);
		}
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{
		var daLoop:Int = 0;

		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
			text.scrollFactor.set();
			text.color = FlxColor.BLUE;
			dumbTexts.add(text);

			if (pushList)
				animList.push(anim);

			daLoop++;
		}

		var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, "x: " + dad.x + "y: " + dad.y, 15);
		text.scrollFactor.set();
		text.color = FlxColor.BLUE;
		dumbTexts.add(text);

		daLoop++;

		var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, "cerberus frame: " + dad2.animation.curAnim.curFrame, 15);
		text.scrollFactor.set();
		text.color = FlxColor.BLUE;
		dumbTexts.add(text);

		daLoop++;
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text, true);
		});
	}

	override function update(elapsed:Float)
	{
		textAnim.text = char.animation.curAnim.name;
		if (FlxG.keys.justPressed.V) {
			dad.setPosition(-280, 0);
			updateTexts();
			genBoyOffsets(false);
		}


		if (FlxG.keys.justPressed.COMMA) {
			curDad2Anim++;
			if (curDad2Anim >= dad2animList.length)
				curDad2Anim = 0;
			dad2.playAnim(dad2animList[curDad2Anim]);
			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.justPressed.PERIOD) {
			dad2.animation.pause();
			dad2.animation.curAnim.curFrame--;
			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.justPressed.SLASH) {
			dad2.animation.pause();
			dad2.animation.curAnim.curFrame++;
			updateTexts();
			genBoyOffsets(false);
		}

		
			
		if (FlxG.keys.justPressed.E)
			FlxG.camera.zoom += 0.25;
		if (FlxG.keys.justPressed.Q)
			FlxG.camera.zoom -= 0.25;

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}

		if (FlxG.keys.pressed.Z) {
			dad.flipX = !dad.flipX;
			dadBG.flipX = !dadBG.flipX;
		}
		if (FlxG.keys.justPressed.W)
		{
			curAnim -= 1;
		}

		if (FlxG.keys.justPressed.S)
		{
			curAnim += 1;
		}

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(animList[curAnim]);

			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.switchState(new PlayState());
		}

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);

		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (upP || rightP || downP || leftP)
		{
			updateTexts();
			if (upP)
				char.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
			if (downP)
				char.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
			if (leftP)
				char.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
			if (rightP)
				char.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;

			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}

		if (FlxG.keys.justPressed.B) {
			dad.x -= 1 * multiplier;
			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.justPressed.N) {
			dad.y -= 1 * multiplier;
			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.justPressed.M) {
			dad.x += 1 * multiplier;
			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.justPressed.H) {
			dad.y += 1 * multiplier;
			updateTexts();
			genBoyOffsets(false);
		}

		super.update(elapsed);
	}
}
