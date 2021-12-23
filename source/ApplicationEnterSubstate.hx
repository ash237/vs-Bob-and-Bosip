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
			TitleState.initialized = false;
			TitleState.leftOnce = false;
			MusicPlayerSubstate.textPlaying = '';
			MusicPlayerSubstate.bpm = 0;
			MusicPlayerSubstate.iconUsed = '';
			DesktopState.theSong.stop();
			openSubState(new LoadingsState());
			FlxTransitionableState.skipNextTransIn = true;
			var toSwitchToState = new TitleState();
			LoadingState.loadAndSwitchState(toSwitchToState, true,true);
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
