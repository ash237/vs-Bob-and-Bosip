package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.misc.NumTween;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class Loading extends MusicBeatState
{
	var loadingBar:FlxBar;
	var progress:Float = 0;
	var songs:Array<String> = [];
	var progressAmount:Float;
	var songsDone:Int = 0;
	override public function create():Void
	{
		loadingBar = new FlxBar(0, 0, LEFT_TO_RIGHT, 100, 10, this,
			'progress', 0, 100);
		loadingBar.scrollFactor.set();
		loadingBar.createFilledBar(FlxColor.RED, FlxColor.GRAY);
		// healthBar
		add(loadingBar);
		super.create();

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			songs.push(data[0]);
		}
		progressAmount = 100 / songs.length;
		for (i in songs) {
			songsDone++;
			FlxG.sound.playMusic(Paths.inst(i), 0);
			progress += progressAmount;
		}
		
	}


	override function update(elapsed:Float)
	{
	
		if (songsDone == songs.length)
			FlxG.switchState(new TitleState());
		super.update(elapsed);
	}
}
