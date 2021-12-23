package;

import haxe.macro.Expr.Function;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import LoadingState.LoadingsState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.transition.FlxTransitionableState;
import openfl.geom.Point;

class BoyPlaceSubState extends MusicBeatSubstate
{
	var theBoy:FlxSprite;
	var end:(xPos:Float, yPos:Float)->Void;
	public function new(?firstTime:Bool = false, endFunc:(xPos:Float, yPos:Float)->Void)
	{
		super();
		end = endFunc;
		var blackscreen:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackscreen.alpha = 0.5;
		add(blackscreen);

		var text:FlxText = new FlxText(0, 600, 0, 'place the soda', 32, false);
		text.font = Paths.font('PUSAB.otf');
		text.color = FlxColor.WHITE;
		text.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 15, 1);
		text.screenCenter(X);
		if (firstTime)
			add(text);

		theBoy = new FlxSprite().loadGraphic(Paths.image('ash_soda'));
		theBoy.alpha = 0.6;
		theBoy.antialiasing = true;
		theBoy.scale.set(0.5, 0.5);
		theBoy.updateHitbox();
		add(theBoy);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		theBoy.setPosition(FlxG.mouse.x - (theBoy.width / 2), FlxG.mouse.y - (theBoy.height / 2));
		if (FlxG.mouse.justPressed) {
			end(theBoy.x, theBoy.y);
			close();
		}
	}
}
