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

class DifficultySelectSubstate extends MusicBeatSubstate
{
	var bg:FlxSprite;

	var hasEX:Bool = false;
	var song:String;

	var easy:FlxSprite;
	var easyText:FlxSprite;
	var normal:FlxSprite;
	var normalText:FlxSprite;
	var hard:FlxSprite;
	var hardText:FlxSprite;
	var ex:FlxSprite;
	var exText:FlxSprite;

	var exitButton:FlxSprite;

	var selected:Bool = false;

	public var closeFunction:Void->Void = null;

	var canDoShit:Bool = true;

	var bobmadshake:FlxSprite;
	var bobsound:FlxSound;

	public function new(song:String)
	{
		this.song = song;
		super();
		bg = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
		bg.alpha = 0.2;
		add(bg);

		if (FileSystem.exists(Paths.instEXcheck(song))) 
			hasEX = true;
	
		//please don't do this, use FlxTypedGroup, I"m just being dumb because I'm lazy

		if (hasEX) {
			easy = new FlxSprite().makeGraphic(640, 360, FlxColor.BLACK);
			easy.alpha = 0;
			add(easy);
			normal = new FlxSprite(640).makeGraphic(640, 360, FlxColor.BLACK);
			normal.alpha = 0;
			add(normal);
			hard = new FlxSprite(0, 360).makeGraphic(640, 360, FlxColor.BLACK);
			hard.alpha = 0;
			add(hard);
			ex = new FlxSprite(640, 360).makeGraphic(640, 360, FlxColor.BLACK);
			ex.alpha = 0;
			add(ex);

			easyText = new FlxSprite(177, 123).loadGraphic(Paths.image('storymenu/easyText'));
			add(easyText);
			normalText = new FlxSprite(761, 107).loadGraphic(Paths.image('storymenu/normalText'));
			add(normalText);
			hardText = new FlxSprite(162, 481).loadGraphic(Paths.image('storymenu/hardText'));
			add(hardText);
			if (FlxG.save.data.unlockedEX)
				exText = new FlxSprite(851, 477).loadGraphic(Paths.image('freeplay/exUnlocked'));
			else
				exText = new FlxSprite(851, 477).loadGraphic(Paths.image('freeplay/exLocked'));
			add(exText);

		} else {
			easy = new FlxSprite().makeGraphic(427, 720, FlxColor.BLACK);
			easy.alpha = 0;
			add(easy);
			normal = new FlxSprite(427).makeGraphic(427, 720, FlxColor.BLACK);
			normal.alpha = 0;
			add(normal);
			hard = new FlxSprite(854).makeGraphic(427, 720, FlxColor.BLACK);
			hard.alpha = 0;
			add(hard);

			easyText = new FlxSprite(88, 310).loadGraphic(Paths.image('storymenu/easyText'));
			add(easyText);
			normalText = new FlxSprite(465, 303).loadGraphic(Paths.image('storymenu/normalText'));
			add(normalText);
			hardText = new FlxSprite(960, 303).loadGraphic(Paths.image('storymenu/hardText'));
			add(hardText);
		}

		bobmadshake = new FlxSprite( -198, -118).loadGraphic(Paths.image('storymenu/bobscreen'));
		bobmadshake.scrollFactor.set(0, 0);
		bobmadshake.visible = false;
		add(bobmadshake);
		bobsound = new FlxSound().loadEmbedded(Paths.sound('bob/bobscreen', 'shared'));

		exitButton = new FlxSprite(18, 17).loadGraphic(Paths.image('desktop/gallery/backText'));
		add(exitButton);
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (canDoShit) {
			if (FlxG.keys.justPressed.ESCAPE && !selected)
				closeMenu();
			if (hasEX) {
				if (FlxG.mouse.overlaps(ex) && FlxG.save.data.unlockedEX) {
					ex.alpha = 0.4;
					exText.color = FlxColor.fromHSL(normalText.color.hue, normalText.color.saturation, 1, 1);
					if (FlxG.mouse.justPressed)
						enterSong(3);
				} else {
					ex.alpha = 0;
					exText.color = FlxColor.fromHSL(normalText.color.hue, normalText.color.saturation, 0.7, 1);
				}
			} 
			if (FlxG.mouse.overlaps(exitButton)) {
				exitButton.color = FlxColor.fromHSL(normalText.color.hue, exitButton.color.saturation, 1, 1);
				if (FlxG.mouse.justPressed) {
					closeMenu();
				}
			} else {
				exitButton.color = FlxColor.fromHSL(exitButton.color.hue, exitButton.color.saturation, 0.7, 1);
			}
			if (FlxG.mouse.overlaps(easy) && !FlxG.mouse.overlaps(exitButton)) {
				easy.alpha = 0.4;
				easyText.color = FlxColor.fromHSL(normalText.color.hue, normalText.color.saturation, 1, 1);
				if (FlxG.mouse.justPressed)
					checkIfShouldEnter(0);
			} else {
				easy.alpha = 0;
				easyText.color = FlxColor.fromHSL(normalText.color.hue, normalText.color.saturation, 0.7, 1);
			}
			if (FlxG.mouse.overlaps(normal)) {
				normal.alpha = 0.4;
				normalText.color = FlxColor.fromHSL(normalText.color.hue, normalText.color.saturation, 1, 1);
				if (FlxG.mouse.justPressed)
					checkIfShouldEnter(1);
			} else {
				normal.alpha = 0;
				normalText.color = FlxColor.fromHSL(normalText.color.hue, normalText.color.saturation, 0.7, 1);
			}
			if (FlxG.mouse.overlaps(hard)) {
				hard.alpha = 0.4;
				hardText.color = FlxColor.fromHSL(normalText.color.hue, normalText.color.saturation, 1, 1);
				if (FlxG.mouse.justPressed)
					checkIfShouldEnter(2);
			} else {
				hard.alpha = 0;
				hardText.color = FlxColor.fromHSL(normalText.color.hue, normalText.color.saturation, 0.7, 1);
			}
		}
	}

	function closeMenu()
	{
		if (closeFunction != null)
			closeFunction();
		close();
	}
	function checkIfShouldEnter(diff:Int)
	{
		switch (song.toLowerCase()) {
			case 'jump-out' | 'ronald mcdonald slide' | 'copy-cat':
				if (diff == 2)
					enterSong(diff);
				else
					Bobismad();
			default:
				enterSong(diff);
		}
		
	}

	function enterSong(diff:Int) {
		selected = true;
		var poop:String = Highscore.formatSong(song.toLowerCase(), diff);

		if (diff == 3) {
			PlayState.effectSONG = Song.loadFromJson('effects-ex', song.toLowerCase());
		}
		switch (song.toLowerCase()) {
			case 'yap squad':
				PlayState.dad2SONG = Song.loadFromJson('woof', song.toLowerCase());
		}
		PlayState.SONG = Song.loadFromJson(poop, song.toLowerCase());
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = diff;
		PlayState.desktopMode = true;
		PlayState.storyWeek = 0;
		MusicPlayerSubstate.textPlaying = '';
		MusicPlayerSubstate.bpm = 0;
		MusicPlayerSubstate.iconUsed = '';
		DesktopState.theSong.stop();
		FlxG.camera.flash(FlxColor.WHITE, 0.6);
		var blackscreen:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(blackscreen);

		FlxG.mouse.visible = false;

		new FlxTimer().start(0.6, function(tmr:FlxTimer)
		{
			LoadingState.loadAndSwitchState(new PlayState());
		});
	}
	function Bobismad():Void
	{
		canDoShit = false;
		FlxG.camera.zoom = 1;
		bobmadshake.visible = true;
		bobsound.play();
		bobsound.volume = 1;
		shakescreen();
		Lib.application.window.fullscreen = false;
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			resetBobismad();
		});
	}
	function resetBobismad():Void
	{
		close();
		FlxG.camera.zoom = 1;
		bobsound.pause();
		bobmadshake.visible = false;
		bobsound.volume = 0;
	}

	function shakescreen()
	{
		new FlxTimer().start(0.01, function(tmr:FlxTimer)
		{
			Lib.application.window.move(Lib.application.window.x + FlxG.random.int(-10, 10), Lib.application.window.y + FlxG.random.int(-8, 8));
		}, 50);
	}

}
