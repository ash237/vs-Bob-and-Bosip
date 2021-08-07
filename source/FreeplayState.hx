package;

//import js.html.FileSystem;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.math.FlxPoint;
#if windows
import Sys;
import sys.FileSystem;
#end
import openfl.Lib;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];
	var songsUnlocked:Array<Bool> = [];

	var selector:FlxText;
	var curSelected:Int = 1;
	var curDifficulty:Int = 1;
	var inEX:Bool = false;

	var scoreText:FlxText;
	//var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var realLength:Int = 0;

	private var grpSongs:FlxTypedGroup<MenuItem>;
	private var grpDiff:FlxTypedGroup<FlxSprite>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];
	var bg:FlxSprite;
	var bgEX:FlxSprite;
	var character:Character;
	var targetX:Int;
	var canDoShit:Bool = true;
	var leftPanelEX:FlxSprite;
	var rightPanelEX:FlxSprite;
	var leftPanel:FlxSprite;
	var rightPanel:FlxSprite;
	var freeplayLogo:FlxSprite;
	var diffText:FlxSprite;
	var arrow:FlxSprite;
	var lerpArrow:Bool = false;
	
	public static var bpm:Float = 0;
	public static var curSong:String;
	public static var isEX:Bool;

	var oldPositions:Array<FlxPoint> = [];

	var bobmadshake:FlxSprite;
	var bobsound:FlxSound;
	
	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		FlxG.camera.zoom = 0.8;
		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			songs.push(new SongMetadata(data[0], Std.parseInt(data[2]), data[1]));
		}

		/*
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		*/

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Freeplay Menu", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS
		
		bg = new FlxSprite(0).loadGraphic(Paths.image('freeplay/panelMiddle'));
		bg.scrollFactor.set();
		bg.updateHitbox();
		bg.antialiasing = true;
		add(bg);
		bg.alpha = 0;

		bgEX = new FlxSprite(0).loadGraphic(Paths.image('freeplay/panelMiddleEX'));
		bgEX.scrollFactor.set();
		bgEX.updateHitbox();
		bgEX.antialiasing = true;
		add(bgEX);
		bgEX.alpha = 0;

		leftPanel = new FlxSprite(-800).loadGraphic(Paths.image('freeplay/panelLeft'));
		leftPanel.scrollFactor.set();
		leftPanel.updateHitbox();
		leftPanel.antialiasing = true;
		add(leftPanel);

		leftPanelEX = new FlxSprite().loadGraphic(Paths.image('freeplay/panelLeftEX'));
		leftPanelEX.scrollFactor.set();
		leftPanelEX.updateHitbox();
		leftPanelEX.antialiasing = true;
		add(leftPanelEX);
		leftPanelEX.visible = false;

		rightPanel = new FlxSprite(800).loadGraphic(Paths.image('freeplay/panelRight'));
		rightPanel.scrollFactor.set();
		rightPanel.updateHitbox();
		rightPanel.antialiasing = true;
		add(rightPanel);

		rightPanelEX = new FlxSprite(0).loadGraphic(Paths.image('freeplay/panelRightEX'));
		rightPanelEX.scrollFactor.set();
		rightPanelEX.updateHitbox();
		rightPanelEX.antialiasing = true;
		add(rightPanelEX);
		rightPanelEX.visible = false;

		if (FlxG.save.data.unlockedEX == false) {
			rightPanelEX.color = FlxColor.fromHSL(rightPanelEX.color.hue, 0.2, rightPanelEX.color.lightness, rightPanelEX.color.alpha);
			leftPanelEX.color = FlxColor.fromHSL(leftPanelEX.color.hue, 0.2, leftPanelEX.color.lightness, leftPanelEX.color.alpha);
			bgEX.color = FlxColor.fromHSL(bgEX.color.hue, 0.2, bgEX.color.lightness, bgEX.color.alpha);
		}
		canDoShit = false;
		
		
		/*var line:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/Black line'));
		line.scrollFactor.set();
		line.updateHitbox();
		line.antialiasing = true;
		add(line);*/

		

		grpSongs = new FlxTypedGroup<MenuItem>();
		add(grpSongs);

		arrow = new FlxSprite(-1500, 277).loadGraphic(Paths.image('mainmenu/menuArrow'));
		arrow.updateHitbox();
		arrow.antialiasing = true;
		add(arrow);

		diffText = new FlxSprite(979, -200).loadGraphic(Paths.image("storymenu/difficultyText"));
		diffText.antialiasing = true;
		diffText.angle = 7;
		diffText.scale.set(0.7, 0.7);
		add(diffText);

		grpDiff = new FlxTypedGroup<FlxSprite>();
		add(grpDiff);

		bobmadshake = new FlxSprite( -198, -118).loadGraphic(Paths.image('storymenu/bobscreen'));
		bobmadshake.scrollFactor.set(0, 0);
		bobmadshake.visible = false;
		add(bobmadshake);
		bobsound = new FlxSound().loadEmbedded(Paths.sound('bob/bobscreen', 'shared'));

		for (i in 0...4) {
			var text:FlxSprite = new FlxSprite();
			switch (i) {
				case 0:
					text = new FlxSprite(989, 88).loadGraphic(Paths.image("storymenu/easyText"));
				case 1:
					text = new FlxSprite(965, 86).loadGraphic(Paths.image("storymenu/normalText"));
				case 2:
					text = new FlxSprite(989, 88).loadGraphic(Paths.image("storymenu/hardText"));
				case 3:
					if (FlxG.save.data.unlockedEX == true)
						text = new FlxSprite(989, 75).loadGraphic(Paths.image("freeplay/exUnlocked"));
					else
						text = new FlxSprite(979, 75).loadGraphic(Paths.image("freeplay/exLocked"));
			}
			switch (i) {
				case 0 | 1 | 2:
					text.antialiasing = true;
					text.angle = 7;
					text.scale.set(0.7, 0.7);
				case 3:
					text.antialiasing = true;
					text.scale.set(0.6, 0.6);
			}
			text.visible = false;
			grpDiff.add(text);
		}
		
		//add(easyText);
		for (i in 0...songs.length) {
			for (diff in 0...3) {
				var songHighscore = StringTools.replace(songs[i].songName, " ", "-");
				switch (songHighscore) {
					case 'Dad-Battle': songHighscore = 'Dadbattle';
					case 'Philly-Nice': songHighscore = 'Philly';
				}
				if (Highscore.getScore(songHighscore, diff) > 0)
					songsUnlocked[i] = true;
			}
		}
		songsUnlocked[0] = true;
		generateSongText(false);

		freeplayLogo = new FlxSprite(-1500, 30);
		freeplayLogo.frames = Paths.getSparrowAtlas('FNF_main_menu_assets');
		freeplayLogo.scrollFactor.set(1, 0);
		freeplayLogo.antialiasing = true;
		freeplayLogo.animation.addByPrefix('bump', 'freeplay basic', 24, true);
		freeplayLogo.animation.play('bump');
		freeplayLogo.updateHitbox();
		freeplayLogo.scale.set(0.6, 0.6);
		//add(freeplayLogo);

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		//add(scoreBG);

		//add(scoreText);

		FlxTween.tween(FlxG.camera, {zoom: 1.01}, 1.4, {
			ease: FlxEase.cubeOut,
			onComplete: function (twn:FlxTween) {
				FlxTween.tween(FlxG.camera, {zoom: 1}, 0.2, {
					ease: FlxEase.quadIn
				});
			}
		});
		FlxTween.tween(leftPanel, {x: 0}, 1, {
			ease: FlxEase.quadOut,
			//startDelay: 0.2,
		});
		FlxTween.tween(rightPanel, {x: 0}, 1, {
			ease: FlxEase.quadOut,
			//startDelay: 0.2,
		});
		FlxTween.tween(bg, {alpha: 1}, 1.2, {
			ease: FlxEase.cubeOut,
			startDelay: 0.4,
		});
		for (i in grpDiff) {
			i.alpha = 0;
			FlxTween.tween(i, {alpha: 1}, 0.6, {
				ease: FlxEase.cubeOut,
				startDelay: 0.8,
			});
		}
		FlxTween.tween(diffText, {y: 48}, 1.2, {
			ease: FlxEase.quadOut,
			startDelay: 0.2,
		});
		FlxTween.tween(arrow, {x: -506}, 0.6, {
			ease: FlxEase.quadIn,
			startDelay: 0.4,
			onComplete: function(twn:FlxTween) {
				lerpArrow = true;
			}
		});
		/*FlxTween.tween(character, {x: targetX}, 0.6, {
			ease: FlxEase.quadIn,
			startDelay: 0.2,
			onComplete: function(twn:FlxTween) {
				if (cjChance == 25) {
					character.playAnim('haha', true);
					new FlxTimer().start(0.7, function(tmr:FlxTimer)
					{
						character.playAnim('idle', true, false, 10);
					});
					FlxG.sound.play(Paths.sound('cjhaha', 'shared'), 0.4);
				}
				canDoShit = true;
			}
		});*/
		FlxTween.tween(freeplayLogo, {x: -20}, 0.6, {
			ease: FlxEase.quadIn,
			startDelay: 0.2,
		});
		for (i in grpSongs) {
			
			FlxTween.tween(i, {lerpxOffset: 0}, 1, {
				ease: FlxEase.quadOut,
				startDelay: 0.2,
				onComplete: function(twn:FlxTween) {
					canDoShit = true;
				}
			});
		}
		/*new FlxTimer().start(0.61, function(tmr:FlxTimer)
		{
			for (i in grpSongs) {
				i.visible = true;
			}
			for (i in iconArray) {
				i.visible = true;
			}
		});*/
		
		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			if (MainMenuState.firsttimeSplitEX) {
				achievementArray.push('unlocked 8-bit split in the sound test!');
				MainMenuState.firsttimeSplitEX = false;
			}

		});
		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['dad'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		if (lerpArrow)
			arrow.x = FlxMath.lerp(arrow.x, -506, 0.03);
		for (item in grpSongs.members){
			//im sorry this is all so shit
			var offsetX:Int = 0;
			var offsetY:Int = 0;
			if (Math.abs(item.targetY) == 1) {
				offsetX = 30;
				item.scale.set(0.8, 0.8);
			} else if (Math.abs(item.targetY) >= 2) {
				offsetX = 80;
				item.scale.set(0.6, 0.6);
				if (Math.abs(item.targetY) >= 3)
					offsetX += 40;
			}
			item.x += item.anotherFuckingXOffset / 3.5;
			item.x = FlxMath.lerp(item.x, (Math.abs(item.targetY) * 30 + offsetX) + 154 + item.lerpxOffset, 0.16);
			if (item.targetY == 0) {
				item.scale.set(1.25, 1.25);
			}
			//trace(grpSongs.members.indexOf(item));
			switch (songs[grpSongs.members.indexOf(item)].songName.toLowerCase()) {
				case 'groovy brass' | 'conscience' | 'yap squad' | 'intertwined':
					if (Math.abs(item.targetY) == 1) 
						item.x -= 5;
					else if (Math.abs(item.targetY) == 2) 
						item.x -= 8; 
			}
			item.y = FlxMath.lerp(item.y, (item.targetY * 160) + offsetY + 318, 0.16);
		}
		super.update(elapsed);
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		if (FlxG.sound.music.volume < 1)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		if (canDoShit) {
			var upP = controls.UP_P;
			var downP = controls.DOWN_P;
			var accepted = controls.ACCEPT;

			if (upP)
			{
				changeSelection(-1);
			}
			if (downP)
			{
				changeSelection(1);
			}

			if (controls.LEFT_P) {
				if (curDifficulty == 0 || curDifficulty == 3) {
					canDoShit = false;
					FlxG.camera.shake(0.001, 0.1, function() {
						FlxG.camera.shake(0.002, 0.1, function() {
							FlxG.camera.shake(0.005, 0.05, function() {
								FlxG.camera.flash(FlxColor.WHITE, 0.5);
								changeDiff(-1);
								canDoShit = true;
								FlxG.camera.shake(0.002, 0.1, function() {
									FlxG.camera.shake(0.001, 0.1, function() {
										
									});
								});
							});
						});
					});
				} else
				changeDiff(-1);
			}
				
			if (controls.RIGHT_P) {
				if (curDifficulty == 2 || curDifficulty == 3) {
					canDoShit = false;
					FlxG.camera.shake(0.001, 0.1, function() {
						FlxG.camera.shake(0.002, 0.1, function() {
							FlxG.camera.shake(0.005, 0.05, function() {
								FlxG.camera.flash(FlxColor.WHITE, 0.5);
								changeDiff(1);
								canDoShit = true;
								FlxG.camera.shake(0.002, 0.1, function() {
									FlxG.camera.shake(0.001, 0.1, function() {
										
									});
								});
							});
						});
					});
				} else
				changeDiff(1);
			}
			if (controls.BACK)
			{
				
				leaveTransition();
				new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					FlxG.switchState(new MainMenuState());
				});
				
			}
			if (accepted)
			{
				if (songsUnlocked[curSelected]) {
					switch (songs[curSelected].songName.toLowerCase()) {
						case 'jump-out' | 'ronald mcdonald slide' | 'copy-cat':
							if (curDifficulty == 2)
								enterSong();
							else {
								Bobismad();
								grpDiff.members[curDifficulty].visible = false;
								curDifficulty = 2;
								changeDiff();
							}
						default:
							enterSong();
					}
					
				}
			}
		}
	}

	function enterSong() {
		FlxG.sound.play(Paths.sound('confirmMenu'));
		// pre lowercasing the song name (update)
		var songLowercase = StringTools.replace(songs[curSelected].songName, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}
		// adjusting the highscore song name to be compatible (update)
		// would read original scores if we didn't change packages
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}
		
		trace(songLowercase);

		var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

		trace(poop);
		if (curDifficulty == 3) {
			PlayState.effectSONG = Song.loadFromJson('effects-ex', songs[curSelected].songName.toLowerCase());
		}
		switch (songs[curSelected].songName.toLowerCase()) {
			case 'yap squad':
				PlayState.dad2SONG = Song.loadFromJson('woof', songs[curSelected].songName.toLowerCase());
		}
		PlayState.playCutscene = false;
		PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = curDifficulty;
		PlayState.storyWeek = songs[curSelected].week;
		PlayState.desktopMode = false;
		
		trace('CUR WEEK' + PlayState.storyWeek);
		enterTransition();
		bpm = 0;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			LoadingState.loadAndSwitchState(new PlayState());
		});
	}
	function leaveTransition() {
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		canDoShit = false;
		if (curDifficulty == 3) {
			FlxTween.tween(leftPanelEX, {x: -50}, 0.6, {
				ease: FlxEase.quadOut,
			});
			FlxTween.tween(leftPanelEX, {alpha: 0, x: -100}, 0.6, {
				ease: FlxEase.quadOut,
				startDelay:0.6
			});
		} else {
			FlxTween.tween(leftPanel, {x: -50}, 0.6, {
				ease: FlxEase.quadOut,
			});
			FlxTween.tween(leftPanel, {alpha: 0, x: -100}, 0.6, {
				ease: FlxEase.quadOut,
				startDelay:0.6
			});
		}
		if (curDifficulty == 3) {
			FlxTween.tween(rightPanelEX, {x: 50}, 0.6, {
				ease: FlxEase.quadOut,
			});
			FlxTween.tween(rightPanelEX, {alpha: 0, x: 100}, 0.6, {
				ease: FlxEase.quadOut,
				startDelay:0.6
			});
		} else {
			FlxTween.tween(rightPanel, {x: 50}, 0.6, {
				ease: FlxEase.quadOut,
			});
			FlxTween.tween(rightPanel, {alpha: 0, x: 100}, 0.6, {
				ease: FlxEase.quadOut,
				startDelay:0.6
			});
		}
		FlxTween.tween(freeplayLogo, {x: freeplayLogo.x - 50}, 0.6, {
			ease: FlxEase.quadOut,
		});
		FlxTween.tween(freeplayLogo, {x: -1500}, 0.6, {
			ease: FlxEase.quadOut,
			startDelay:0.6
		});
		if (curDifficulty == 3) {
			FlxTween.tween(bgEX, {alpha: 0}, 0.6, {
				startDelay:0.6
			});
		} else {
			FlxTween.tween(bg, {alpha: 0}, 0.6, {
				startDelay:0.6
			});
		}
		FlxTween.tween(diffText, {alpha: 0}, 0.6, {
			startDelay:0.6
		});
		FlxTween.tween(grpDiff.members[curDifficulty], {alpha: 0}, 0.6, {
			startDelay:0.6
		});
		lerpArrow = false;
		FlxTween.tween(arrow, {x: arrow.x - 1000}, 0.6, {
			ease: FlxEase.quadIn,
			//startDelay:0.6
		});
		FlxTween.tween(FlxG.camera, {zoom: 0.8}, 0.6, {
			startDelay:0.6
		});
		/*for (i in grpSongs) {
			FlxTween.tween(i, {lerpxOffset: 50}, 0.6, {
				ease: FlxEase.quadOut,
			});
			FlxTween.tween(i, {lerpxOffset: 2000}, 0.6, {
				ease: FlxEase.quadOut,
				startDelay: 0.6,
			});
		}*/
		for (i in grpSongs) {
			FlxTween.tween(i, {alpha:0}, 0.6, {
				ease: FlxEase.quadOut,
				startDelay: 0.6
			});
		}
	}
	function enterTransition() {
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		canDoShit = false;
		if (curDifficulty == 3) {
			FlxTween.tween(leftPanelEX, {x: -50}, 0.6, {
				ease: FlxEase.quadOut,
			});
			FlxTween.tween(leftPanelEX, {alpha: 0}, 0.6, {
				ease: FlxEase.quadOut,
				startDelay:0.6
			});
		} else {
			FlxTween.tween(leftPanel, {x: -50}, 0.6, {
				ease: FlxEase.quadOut,
			});
			FlxTween.tween(leftPanel, {alpha: 0}, 0.6, {
				ease: FlxEase.quadOut,
				startDelay:0.6
			});
		}
		if (curDifficulty == 3) {
			FlxTween.tween(rightPanelEX, {x: 50}, 0.6, {
				ease: FlxEase.quadOut,
			});
			FlxTween.tween(rightPanelEX, {alpha: 0}, 0.6, {
				ease: FlxEase.quadOut,
				startDelay:0.6
			});
		} else {
			FlxTween.tween(rightPanel, {x: 50}, 0.6, {
				ease: FlxEase.quadOut,
			});
			FlxTween.tween(rightPanel, {alpha: 0}, 0.6, {
				ease: FlxEase.quadOut,
				startDelay:0.6
			});
		}
		FlxTween.tween(freeplayLogo, {x: freeplayLogo.x - 50}, 0.6, {
			ease: FlxEase.quadOut,
		});
		FlxTween.tween(freeplayLogo, {x: -1500}, 0.6, {
			ease: FlxEase.quadOut,
			startDelay:0.6
		});
		if (curDifficulty == 3) {
			FlxTween.tween(bgEX, {alpha: 0}, 0.6, {
				startDelay:0.6
			});
		} else {
			FlxTween.tween(bg, {alpha: 0}, 0.6, {
				startDelay:0.6
			});
		}
		FlxTween.tween(diffText, {alpha: 0}, 0.6, {
			startDelay:0.6
		});
		FlxTween.tween(grpDiff.members[curDifficulty], {alpha: 0}, 0.6, {
			startDelay:0.6
		});
		lerpArrow = false;
		FlxTween.tween(arrow, {x: arrow.x - 500}, 0.6, {
			startDelay:0.6
		});
		FlxTween.tween(FlxG.camera, {zoom: 1.5}, 0.6, {
			startDelay:0.6
		});
		/*for (i in grpSongs) {
			FlxTween.tween(i, {lerpxOffset: 50}, 0.6, {
				ease: FlxEase.quadOut,
			});
			FlxTween.tween(i, {lerpxOffset: 2000}, 0.6, {
				ease: FlxEase.quadOut,
				startDelay: 0.6,
			});
		}*/
		for (i in grpSongs) {
			if (i.targetY != 0) {
				FlxTween.tween(i, {alpha:0}, 0.6, {
					ease: FlxEase.quadOut,
				});
			} else {
				FlxTween.tween(i, {alpha:0}, 0.6, {
					ease: FlxEase.quadOut,
					startDelay: 0.6
				});
			}
		}
	}
	function changeDiff(change:Int = 0)
	{
		grpDiff.members[curDifficulty].visible = false;
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 3;
		if (curDifficulty > 3)
			curDifficulty = 0;

		grpDiff.members[curDifficulty].visible = true;
		// adjusting the highscore song name to be compatible (changeDiff)
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}
		if (inEX) {
			leftPanelEX.visible = false;
			rightPanelEX.visible = false;
			leftPanel.visible = true;
			rightPanel.visible = true;
			bg.alpha = 1;
			bgEX.alpha = 0;
			realLength = 0;
			oldPositions.splice(0, oldPositions.length);
			for (i in 0...grpSongs.length) {
				oldPositions.push(new FlxPoint(grpSongs.members[i].x, grpSongs.members[i].y));
			}
			remove(grpSongs);
			grpSongs = new FlxTypedGroup<MenuItem>();
			add(grpSongs);
			for (i in 0...iconArray.length) {
				iconArray.splice(i, i);
			}
			generateSongText(true);
			//curSelected = 1;
			inEX = false;
			changeSelection();
		}
		if (curDifficulty == 3) {
			leftPanelEX.visible = true;
			rightPanelEX.visible = true;
			leftPanel.visible = false;
			rightPanel.visible = false;
			bg.alpha = 0;
			bgEX.alpha = 1;
			realLength = 0;
			oldPositions.splice(0, oldPositions.length);
			for (i in 0...grpSongs.length) {
				oldPositions.push(new FlxPoint(grpSongs.members[i].x, grpSongs.members[i].y));
			}
			remove(grpSongs);
			grpSongs = new FlxTypedGroup<MenuItem>();
			add(grpSongs);
			for (i in 0...iconArray.length) {
				iconArray.splice(i, i);
			}

			generateSongText(true, true);
			if (curSelected >= realLength)
				curSelected = 1;
			inEX = true;
			changeSelection();
		}
		#if !switch
		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		#end
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		arrow.x += 10;
		curSelected += change;

		if (curSelected < 0)
			curSelected = realLength - 1;
		if (curSelected >= realLength)
			curSelected = 0;
		
		// selector.y = (70 * curSelected) + 30;
		
		// adjusting the highscore song name to be compatible (changeSelection)
		// would read original scores if we didn't change packages
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}

		#if !switch
		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		if (curDifficulty == 3 && FlxG.save.data.unlockedEX == true) {
			if (songsUnlocked[curSelected] == true) {
				FlxG.sound.playMusic(Paths.instEX(songs[curSelected].songName), 0);
				isEX = true;
				curSong = songs[curSelected].songName;
				var daJson = Song.loadFromJson(songs[curSelected].songName.toLowerCase() + '-hard', songs[curSelected].songName.toLowerCase());
				bpm = daJson.bpm;
				Conductor.changeBPM(daJson.bpm);
			}
		} else if (curDifficulty != 3) {
			if (songsUnlocked[curSelected] == true) {
				isEX = false;
				FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
				curSong = songs[curSelected].songName;
				var daJson = Song.loadFromJson(songs[curSelected].songName.toLowerCase() + '-hard', songs[curSelected].songName.toLowerCase());
				bpm = daJson.bpm;
				Conductor.changeBPM(daJson.bpm);
			}
		}
		
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		//iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			//item.alpha = 0.6;
			//item.color
			item.color = FlxColor.fromHSL(item.color.hue, item.color.saturation, 0.5, 1);
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.color = FlxColor.fromHSL(item.color.hue, item.color.saturation, 1, 1);
				//item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	override function beatHit()
	{
		super.beatHit();

		/*if (character.animation.curAnim.name != 'haha')
			character.playAnim('idle', true);*/

		
	}
	function generateSongText(presetPos:Bool, ?ex:Bool = false)
	{
		for (i in 0...songs.length)
			{
				var songText:MenuItem = new MenuItem();
				if (ex) {
					if (songsUnlocked[i] && FlxG.save.data.unlockedEX == true) {
						switch (songs[i].songName.toLowerCase()) {
							case 'tutorial':
								songText.anotherFuckingXOffset = 40;
							case 'jump-in':
								songText.anotherFuckingXOffset = 25;
							case 'swing':
								songText.anotherFuckingXOffset = 15;
							case 'split':
								songText.anotherFuckingXOffset = 2;
							case 'yap squad':
								songText.anotherFuckingXOffset = 70;
							case 'intertwined':
								songText.anotherFuckingXOffset = 92;
							case 'groovy brass':
								songText.anotherFuckingXOffset = 110;
							case 'conscience':
								songText.anotherFuckingXOffset = 80;
						}
		
						songText.loadGraphic(Paths.image('freeplay/text/' + songs[i].songName.toLowerCase() + 'Title'));
					} else {
						songText.anotherFuckingXOffset = 25;
						songText.loadGraphic(Paths.image('freeplay/text/lockedOut'));
					}
				} else {
					if (songsUnlocked[i]) {
						switch (songs[i].songName.toLowerCase()) {
							case 'tutorial':
								songText.anotherFuckingXOffset = 40;
							case 'jump-in':
								songText.anotherFuckingXOffset = 25;
							case 'swing':
								songText.anotherFuckingXOffset = 15;
							case 'split':
								songText.anotherFuckingXOffset = 2;
							case 'yap squad':
								songText.anotherFuckingXOffset = 70;
							case 'intertwined':
								songText.anotherFuckingXOffset = 92;
							case 'groovy brass':
								songText.anotherFuckingXOffset = 110;
							case 'conscience':
								songText.anotherFuckingXOffset = 80;
						}
		
						songText.loadGraphic(Paths.image('freeplay/text/' + songs[i].songName.toLowerCase() + 'Title'));
					} else {
						songText.anotherFuckingXOffset = 25;
						songText.loadGraphic(Paths.image('freeplay/text/lockedOut'));
					}
				}
				
				//songText.visible = false;
				//songText.lerpxOffset = 2000;
				//songText.isMenuItem = true;
				songText.targetY = i;
				songText.antialiasing = true;
				if (!presetPos)
					songText.lerpxOffset = FlxG.width;
				
				
	
				var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
				icon.sprTracker = songText;

				// using a FlxGroup is too much fuss!
				
				icon.visible = false;
				if (ex) {
					if (FileSystem.exists(Paths.instEXcheck(songs[i].songName.toLowerCase()))) {
						grpSongs.add(songText);
						realLength++;
						iconArray.push(icon);
					}
				} else {
					grpSongs.add(songText);
					realLength++;
					iconArray.push(icon);
				}
				
				if (FileSystem.exists(Paths.instEXcheck(songs[i].songName.toLowerCase())) && presetPos) {
					songText.x = oldPositions[i].x;
					songText.y = oldPositions[i].y;
				} else {
					var offsetX:Int = 0;
					var offsetY:Int = 0;
					if (Math.abs(i) == 1) {
						offsetX = 30;
						songText.scale.set(0.8, 0.8);
					} else if (Math.abs(i) >= 2) {
						offsetX = 80;
						songText.scale.set(0.6, 0.6);
						if (Math.abs(i) >= 3)
							offsetX += 40;
					}
					songText.x += songText.anotherFuckingXOffset / 3.5;
					songText.x = (Math.abs(i) * 30 + offsetX) + 154 + songText.lerpxOffset;
					if (songText.targetY == 0) {
						songText.scale.set(1.25, 1.25);
					}
					
					switch (songs[i].songName.toLowerCase()) {
						case 'groovy brass' | 'conscience' | 'yap squad' | 'intertwined':
							if (Math.abs(i) == 1) 
								songText.x -= 5;
							else if (Math.abs(i) == 2) 
								songText.x -= 8; 
					}
					songText.y = (i * 160) + offsetY + 318;
				}
			}
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
		canDoShit = true;
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

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
