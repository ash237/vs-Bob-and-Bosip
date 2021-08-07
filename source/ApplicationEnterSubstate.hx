package;

import haxe.macro.Expr.Function;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.transition.FlxTransitionableState;
import openfl.geom.Point;

class ApplicationEnterSubstate extends MusicBeatSubstate
{

	public function new()
	{
		super();
		FlxG.camera.flash(FlxColor.WHITE, 0.6);
		var blackscreen:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(blackscreen);

		FlxG.mouse.visible = false;

		new FlxTimer().start(0.6, function(tmr:FlxTimer)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			TitleState.initialized = false;
			TitleState.leftOnce = false;
			MusicPlayerSubstate.textPlaying = '';
			MusicPlayerSubstate.bpm = 0;
			MusicPlayerSubstate.iconUsed = '';
			DesktopState.theSong.stop();
			FlxG.switchState(new TitleState());
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
