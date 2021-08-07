package;

import haxe.macro.Expr.Function;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.geom.Point;

#if windows
import Sys;
import sys.FileSystem;
#end

import openfl.Lib;

class CoolSubstate extends MusicBeatSubstate
{
	var bg:FlxSprite;

	public function new()
	{
		super();
		var fuckfuckfuckfuckfuckfuckfuckfuckfuckfuck:FlxObject = new FlxObject(FlxG.width / 2, FlxG.height / 2, 1, 1);
		FlxG.camera.follow(fuckfuckfuckfuckfuckfuckfuckfuckfuckfuck);
		FlxG.sound.playMusic(Paths.music('NoBudgedSad', 'shared'));
		FlxG.sound.music.fadeIn(0.8, 0, 1);
		bg = new FlxSprite().loadGraphic(Paths.image('onslaught/goodbyeron', 'shared'));
		add(bg);
		MainMenuState.showRon = true;
		FreeplayState.curSong = '';
		FreeplayState.bpm = 95;
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (controls.ACCEPT) {
			FlxG.switchState(new MainMenuState());
			close();
		}
	}
}
