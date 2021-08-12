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
import flixel.math.FlxMath;
import openfl.geom.Point;
import flixel.system.FlxSound;

#if windows
import Discord.DiscordClient;
import Sys;
import sys.FileSystem;
#end

class MusicPlayerSubstate extends MusicBeatSubstate
{
	var bg:FlxSprite;

	var isExist:Bool = false;

	var grpButtons:FlxTypedGroup<FlxSprite>;

	var record:FlxSprite;
	var hole:FlxSprite;

	var songsToPlay:Array<String> = [];
	var songNames:Array<String> = [];
	var bpms:Array<Int> = [];

	var curSelected:Int = 0;
	var songLength:Int = 0;

	var selectionText:FlxText;
	var playingText:FlxText;

	var curTrackText:FlxSprite;
	var selTrackText:FlxSprite;

	public static var textPlaying:String;
	public static var bpm:Int = 0;
	public static var iconUsed:String;
	var closePosition:FlxPoint;

	var icon:HealthIcon;
	var iconArray:Array<String> = [];

	var theSong:FlxSound;
	public function new(s:FlxPoint, unlockedSongs:Array<Bool>)
	{
		super();
		closePosition = s;
		theSong = DesktopState.theSong;

		bpms.push(120);
		songsToPlay.push(Paths.music('menuIntro'));
		songNames.push('menu');
		iconArray.push('bob');
		songLength++;

		bpms.push(110);
		songsToPlay.push(Paths.music('oldmenuIntro'));
		songNames.push('old menu');
		iconArray.push('bob');
		songLength++;

		bpms.push(76);
		songsToPlay.push(Paths.music('desktop'));
		songNames.push('desktop');
		iconArray.push('amor');
		songLength++;

		if (FlxG.save.data.beatWeek) {
			bpms.push(110);
			songsToPlay.push(Paths.music('cutscene_day'));
			songNames.push('cutscene day');
			iconArray.push('bob');
			songLength++;

			bpms.push(102);
			songsToPlay.push(Paths.music('cutscene_night'));
			songNames.push('cutscene night');
			iconArray.push('amor');
			songLength++;

			bpms.push(95);
			songsToPlay.push(Paths.music('walk'));
			songNames.push('walk');
			iconArray.push('bosip');
			songLength++;
		}
		
		if (FlxG.save.data.beatITB) {
			bpms.push(110);
			songsToPlay.push(Paths.music('cutscene_itb'));
			songNames.push('cutscene itb');
			iconArray.push('bluskys');
			songLength++;
		}

		if (FlxG.save.data.beatBob) {
			bpms.push(95);
			songsToPlay.push(Paths.music('NoBudgedSad', 'shared'));
			songNames.push('no budged sad');
			iconArray.push('gloopy');
			songLength++;

			bpms.push(128);
			songsToPlay.push(Paths.music('Cutscene_Bob'));
			songNames.push('cutscene bob');
			iconArray.push('gloopy');
			songLength++;

			bpms.push(80);
			songsToPlay.push(Paths.music('Cutscene_Ronsip'));
			songNames.push('cutscene ronsip');
			iconArray.push('ronsip');
			songLength++;
		}
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			if (unlockedSongs[i]) {
				songsToPlay.push(Paths.inst(data[0]));
				songNames.push(data[0]);
				var daJson = Song.loadFromJson(data[0].toLowerCase() + '-hard', data[0].toLowerCase());
				bpms.push(Std.int(daJson.bpm));
				iconArray.push(data[1]);
				trace(daJson.bpm);
				songLength++;
				if (FlxG.save.data.unlockedEX && FileSystem.exists(Paths.instEXcheck(data[0]))) {
					var daJson = Song.loadFromJson(data[0].toLowerCase() + '-ex', data[0].toLowerCase());
					bpms.push(Std.int(daJson.bpm));
					trace(daJson.bpm);
					if (data[0] == 'split')
						songsToPlay.push(Paths.music('no blur split ex'));
					else
						songsToPlay.push(Paths.instEX(data[0]));
					songNames.push(data[0] + ' EX');
					if (data[1] == 'gf')
						iconArray.push(data[1] + '-ex');
					else
						iconArray.push(data[1] + 'ex');
					songLength++;
				}
			}
			if (data[0].toLowerCase() == 'split' && FlxG.save.data.beatSplitEX == true) {
				bpms.push(160);
				songsToPlay.push(Paths.music('8bit split', 'shared'));
				songNames.push('8-bit split');
				iconArray.push('pixel-amor');
				songLength++;
			}
		}

		var zoom:FlxSprite = new FlxSprite(s.x, s.y).loadGraphic(Paths.image('desktop/musicPlayer/zoom'));
		zoom.origin.set(0, 0);
		zoom.scale.set(0.1, 0.1);
		zoom.alpha = 0;
		add(zoom);
		FlxTween.tween(zoom.scale, {x: 1, y: 1}, 0.3, {ease: FlxEase.cubeOut});
		FlxTween.tween(zoom, {x: 0, y: 0, alpha: 1}, 0.3, {ease: FlxEase.cubeOut, onComplete: function(twn:FlxTween) {
			remove(zoom);
			bg = new FlxSprite().loadGraphic(Paths.image('desktop/musicPlayer/musicBackground'));
			add(bg);
			isExist = true;
			grpButtons = new FlxTypedGroup<FlxSprite>();
			add(grpButtons);

			record = new FlxSprite(-79, 113).loadGraphic(Paths.image('desktop/musicPlayer/record'));
			record.antialiasing = true;
			add(record);

			hole = new FlxSprite(277, 470).loadGraphic(Paths.image('desktop/musicPlayer/hole'));
			add(hole);

			icon = new HealthIcon();
			icon.setPosition(233, 428);
			if (iconUsed != null && iconUsed != '') {
				icon = new HealthIcon(iconUsed);
				icon.setPosition(233, 428);
				add(icon);	
			}
			for (i in 0...6) {
				var spr:FlxSprite = new FlxSprite();
				switch (i) {
					case 0:
						spr = new FlxSprite(15, 43).loadGraphic(Paths.image('desktop/gallery/xText'));
					case 1:
						spr = new FlxSprite(723, 491).loadGraphic(Paths.image('desktop/musicPlayer/arrowLeft'));
					case 2:
						spr = new FlxSprite(1179, 491).loadGraphic(Paths.image('desktop/musicPlayer/arrowRight'));
					case 3:
						spr = new FlxSprite(722, 604).loadGraphic(Paths.image('desktop/musicPlayer/playButton'));
					case 4:
						spr = new FlxSprite(906, 604).loadGraphic(Paths.image('desktop/musicPlayer/stopButton'));
					case 5:
						spr = new FlxSprite(1090, 604).loadGraphic(Paths.image('desktop/musicPlayer/defaultButton'));
				}
				grpButtons.add(spr);
			}

			selectionText = new FlxText(795, 491, 384, 'none', 71, true);
			selectionText.font = Paths.font('BADABB.ttf');
			selectionText.borderSize = 5;
			selectionText.borderStyle = FlxTextBorderStyle.OUTLINE;
			selectionText.borderColor = FlxColor.BLACK;
			selectionText.borderQuality = 2;
			selectionText.alignment = CENTER;
			selectionText.alpha = 0;
			add(selectionText);

			playingText = new FlxText(706, 241, 545, '', 90, true);
			playingText.font = Paths.font('BADABB.ttf');
			playingText.borderSize = 5;
			playingText.borderStyle = FlxTextBorderStyle.OUTLINE;
			playingText.borderColor = FlxColor.BLACK;
			playingText.borderQuality = 2;
			playingText.alignment = CENTER;
			if (textPlaying != null || textPlaying != '') {
				playingText.text = textPlaying;
			}
			playingText.alpha = 0;
			add(playingText);
			FlxTween.tween(playingText, {alpha: 1}, 0.3, {ease: FlxEase.cubeOut});
			FlxTween.tween(selectionText, {alpha: 1}, 0.3, {ease: FlxEase.cubeOut});
			curTrackText = new FlxSprite(719, 109).loadGraphic(Paths.image('desktop/musicPlayer/currentTrack'));
			add(curTrackText);

			selTrackText = new FlxSprite(837, 381).loadGraphic(Paths.image('desktop/musicPlayer/selectTrack'));
			add(selTrackText);

			if (bpm != 0) {
				Conductor.changeBPM(bpm);
			}

			changeSelection();
		},});
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (isExist) {
			theSong.volume = FlxG.sound.volume;
			record.scale.x = FlxMath.lerp(record.scale.x, 1, 0.09);
			record.scale.y = FlxMath.lerp(record.scale.y, 1, 0.09);
			icon.scale.x = FlxMath.lerp(icon.scale.x, 1, 0.09);
			icon.scale.y = FlxMath.lerp(icon.scale.y, 1, 0.09);
			if (FlxG.sound.music != null && FlxG.sound.music.playing) {
				if (theSong.playing) {
					FlxG.sound.music.time = theSong.time;
					FlxG.sound.music.volume = 0;
					Conductor.songPosition = theSong.time;
				} else 
					Conductor.songPosition = FlxG.sound.music.time;
				if (FlxG.sound.music.playing) {
					record.angle += bpm / 100;
					playingText.visible = true;
				} else playingText.visible = false;
			} else playingText.visible = false;

			if (FlxG.keys.justPressed.ESCAPE)
				exitMenu();
			for (i in grpButtons) {
				if (FlxG.mouse.overlaps(i)) {
					if (FlxG.mouse.pressed && grpButtons.members.indexOf(i) == 1 || FlxG.mouse.pressed && grpButtons.members.indexOf(i) == 2) {
						i.scale.set(0.95, 0.95);
					} else i.scale.set(1, 1);
					if (FlxG.mouse.justPressed) {
						switch (grpButtons.members.indexOf(i)) {
							case 0:
								exitMenu();
							case 1:
								changeSelection(-1);
							case 2:
								changeSelection(1);
							case 3:
								theSong.stop();
								FlxG.sound.playMusic(songsToPlay[curSelected]);
								FlxG.sound.music.volume = 0;
								theSong.loadEmbedded(songsToPlay[curSelected]);
								theSong.play();
								FlxG.sound.defaultMusicGroup.add(theSong);
								playingText.text = songNames[curSelected];
								textPlaying = songNames[curSelected];
								Conductor.changeBPM(bpms[curSelected]);
								bpm = bpms[curSelected];
								remove(icon);
								iconUsed = iconArray[curSelected];
								icon = new HealthIcon(iconArray[curSelected]);
								icon.visible = true;
								icon.setPosition(233, 428);
								record.scale.set(1.02, 1.02);
								icon.scale.set(1.1, 1.1);
								add(icon);
							case 4:
								if (FlxG.sound.music != null) {
									FlxG.sound.music.stop();
									theSong.stop();
								}
								playingText.text = '';
								textPlaying = '';
								Conductor.changeBPM(0);
								bpm = 0;
								iconUsed = '';
								icon.visible = false;
							case 5:
								FlxG.sound.play(Paths.sound('confirmMenu'));
								FlxG.save.data.defaultMusic = songsToPlay[curSelected];
						}
					}
					i.color = FlxColor.fromHSL(i.color.hue, i.color.saturation, 1, 1);
				} else {
					i.color = FlxColor.fromHSL(i.color.hue, i.color.saturation, 0.7, 1);
				}
			}

			
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;

		if (curSelected < 0)
			curSelected = songLength - 1;
		else if (curSelected > songLength - 1)
			curSelected = 0;

		selectionText.text = songNames[curSelected];
	}

	override function beatHit() {
		if (isExist && bpm != 0) {
			if (curBeat % 2 == 0)
				record.scale.set(1.02, 1.02);
			icon.scale.set(1.1, 1.1);
		}
	}
	function exitMenu() {
		isExist = false;
		bg.visible = false;
		selectionText.visible = false;
		playingText.visible = false;
		record.visible = false;
		curTrackText.visible = false;
		selTrackText.visible = false;
		hole.visible = false;
		icon.visible = false;
		for (i in grpButtons)
			i.visible = false;
		var zoom:FlxSprite = new FlxSprite().loadGraphic(Paths.image('desktop/musicPlayer/zoom'));
		zoom.origin.set(0, 0);
		add(zoom);
		FlxTween.tween(zoom.scale, {x: 0.1, y: 0.1}, 0.3, {ease: FlxEase.cubeOut});
		FlxTween.tween(zoom, {x: closePosition.x, y: closePosition.y, alpha: 0}, 0.3, {ease: FlxEase.cubeOut, onComplete: function(twn:FlxTween) {
			close();
			if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
				if (FlxG.save.data.defaultMusic != null) {
					FlxG.sound.playMusic(FlxG.save.data.defaultMusic, 0.5);
				} else {
					FlxG.sound.playMusic(Paths.music('desktop'), 0.5);
				}
			}
		},});
	}
}