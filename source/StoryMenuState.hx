package;

import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.FlxSprite;
import sys.io.Process;
import openfl.Lib;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.tweens.FlxEase;
import flixel.system.frontEnds.SoundFrontEnd;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import webm.WebmPlayer;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	var weekData:Array<Dynamic> = [
		['Tutorial'],
		['jump-in', 'swing', 'split'],
		['groovy brass', 'conscience', 'yap squad', 'intertwined'],
		['copy-cat', 'jump-out', 'ronald mcdonald slide']
	];
	var curDifficulty:Int = 2;

	var weekUnlocked:Array<Bool> = [true, true, true, true];

	var weekCharacters:Array<String> = [
		'Bf and Gff',
		'bob and bosip',
		'ITB',
		'Bob_and_Ron'
	];

	var weekNames:Array<Dynamic> = [
		["tutorialText", '169', '292'],
		["bobandbosipText", '175', '239'],
		["inthebackgroundText", '170', '231'],
		["bobtakeoverText", '170', '231']
	];

	var weekColors:Array<String> = [
		"Orange",
		"Blue",
		"Sky",
		"Ron"
	];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<FlxSprite>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;
	var grpWeekDifficulties:FlxTypedGroup<FlxSprite>;
	var grpWeekBackgrounds:FlxTypedGroup<FlxSprite>;
	var grpWeekBackgroundsBottom:FlxTypedGroup<FlxSprite>;
	var grpWeekSprites:FlxTypedGroup<FlxSprite>;
	var bobmadshake:FlxSprite;
	var bobsound:FlxSound;
	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var corruptleftArrow:FlxSprite;
	var corruptrightArrow:FlxSprite;
	var diffText:FlxSprite;

	//this code was made at 2:48 AM sorry lol
	var bop1:FlxTween;
	var bop2:FlxTween;
	var bop3:FlxTween;
	var bop4:FlxTween;
	var bop5:FlxTween;
	var bop6:FlxTween;

	var storymodeLogo:FlxSprite;

	var dumbCounter:Int = 0;

	var spookyMenu:FlxSound;
	override function create()
	{	
		
		spookyMenu = FlxG.sound.play(Paths.music('nightmaremenu_remix'));//new FlxSound().loadEmbedded(Paths.music('nightmaremenu_remix'));
		spookyMenu.volume = 0;
		add(spookyMenu);
		if (!FlxG.save.data.beatWeek) {
			weekUnlocked[2] = false;
			weekCharacters[2] = 'ITBgray';
			weekColors[2] = 'Sky(desat)';
			weekNames[2] = ["lockedOutITB", '170', '291'];
		}
		if (!FlxG.save.data.beatITB) {
			weekUnlocked[3] = false;
			weekCharacters[3] = 'Bob_and_Ron2';
			weekColors[3] = 'Corrupt';
			weekNames[3] = ["questionMark", '170', '291'];
		}
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('menuIntro'));
		}

		persistentUpdate = persistentDraw = true;

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		
		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		//add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();
		FlxG.camera.zoom = 0.8;
		grpLocks = new FlxTypedGroup<FlxSprite>();
		//add(grpLocks);
		grpWeekBackgrounds = new FlxTypedGroup<FlxSprite>();
		add(grpWeekBackgrounds);

		grpWeekBackgroundsBottom = new FlxTypedGroup<FlxSprite>();
		add(grpWeekBackgroundsBottom);
		
		grpWeekSprites = new FlxTypedGroup<FlxSprite>();
		add(grpWeekSprites);

		grpWeekText = new FlxTypedGroup<FlxSprite>();
		add(grpWeekText);

		storymodeLogo = new FlxSprite(-50, -FlxG.height);
		storymodeLogo.frames = Paths.getSparrowAtlas('FNF_main_menu_assets');
		storymodeLogo.scrollFactor.set(1, 0);
		storymodeLogo.antialiasing = true;
		storymodeLogo.animation.addByPrefix('bump', 'story mode basic', 24, true);
		storymodeLogo.animation.play('bump');
		storymodeLogo.updateHitbox();
		storymodeLogo.scale.set(0.6, 0.6);
		storymodeLogo.angle = -2;
		add(storymodeLogo);
		
		grpWeekDifficulties = new FlxTypedGroup<FlxSprite>();
		add(grpWeekDifficulties);
		movedBack = true;
		for (i in 0...3) {
			var diffSprite:FlxSprite = new FlxSprite();
			switch (i) {
				case 0:
					diffSprite = new FlxSprite(57, 1078).loadGraphic(Paths.image('storymenu/easyText'));
				case 1:
					diffSprite = new FlxSprite(11, 1070).loadGraphic(Paths.image('storymenu/normalText'));
				case 2:
					diffSprite = new FlxSprite(46, 1074).loadGraphic(Paths.image('storymenu/hardText'));
			}
			grpWeekDifficulties.add(diffSprite);
		}

		
		for (i in weekColors) {
			var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("storymenu/" + 'background' + i));
			bg.visible = false;
			bg.alpha = 0;
			grpWeekBackgrounds.add(bg);
			
			var bgBottom:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("storymenu/" + 'bottom' + i));
			bgBottom.visible = false;
			bgBottom.alpha = 0;
			grpWeekBackgroundsBottom.add(bgBottom);
			
		}
		
		grpWeekBackgrounds.members[0].visible = true;
		grpWeekBackgroundsBottom.members[0].visible = true;
		for (i in weekCharacters) {
			var daSprite:FlxSprite = new FlxSprite(0, FlxG.height * 1.3).loadGraphic(Paths.image("storymenu/" + i));
			daSprite.visible = false;
			grpWeekSprites.add(daSprite);
		}
		grpWeekSprites.members[0].visible = true;

		for (i in weekNames) {
			var weekThing:FlxSprite = new FlxSprite(i[1], -FlxG.height).loadGraphic(Paths.image('storymenu/' + i[0]));
			weekThing.antialiasing = true;
			weekThing.visible = false;
			grpWeekText.add(weekThing);
		}
		
		grpWeekText.members[0].visible = true;
		diffText = new FlxSprite(40, 510).loadGraphic(Paths.image("storymenu/difficultyText"));
		diffText.alpha = 0;
		add(diffText);
		FlxTween.tween(diffText, {alpha: 1}, 0.3, {startDelay: 0.6});
		if (FreeplayState.bpm > 0)
			Conductor.changeBPM(FreeplayState.bpm);
		else
			Conductor.changeBPM(120);

		for (i in grpWeekBackgrounds) {
			FlxTween.tween(i, {alpha: 1, y: 0}, 0.6, {
				ease: FlxEase.quadOut,
				//startDelay: 0.4
			});
		}
		for (i in grpWeekBackgroundsBottom) {
			FlxTween.tween(i, {alpha: 1, y: 0}, 0.6, {
				ease: FlxEase.quadOut,
				//startDelay: 0.4
			});
		}
		FlxTween.tween(FlxG.camera, {zoom: 1.05}, 1.4, {
			ease: FlxEase.cubeOut,
			onComplete: function (twn:FlxTween) {
				FlxTween.tween(FlxG.camera, {zoom: 1}, 0.2, {
					ease: FlxEase.quadIn
				});
			}
		});
		for (i in grpWeekText) {
			FlxTween.tween(i, {y: weekNames[grpWeekText.members.indexOf(i)][2]}, 2, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween) {
					bopOpposite(i, weekNames[grpWeekText.members.indexOf(i)][2]);
					movedBack = false;
				},
				startDelay: 0.3
			});
			
		}
		for (i in grpWeekSprites) {
			FlxTween.tween(i, {y: 0}, 0.6, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween) {
					bop(i);
				},
				startDelay: 0.3
			});
		}
		for (i in grpWeekDifficulties) {
			FlxTween.tween(i, {y: i.y - 500}, 1.5, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween) {
					//bopbutFUCKYOU(i);
				},
				startDelay: 0.3
			});
		}

		FlxTween.tween(storymodeLogo, {y: 30}, 1.5, {
			ease: FlxEase.quadOut,
			startDelay: 0.5
		});

		trace("Line 70");
		
		leftArrow = new FlxSprite(-600, 312).loadGraphic(Paths.image("storymenu/arrowLeft"));
		leftArrow.antialiasing = true;
		add(leftArrow);

		corruptleftArrow = new FlxSprite(28, 312).loadGraphic(Paths.image("storymenu/arrowLeftCorrupt"));
		corruptleftArrow.antialiasing = true;
		corruptleftArrow.alpha = 0;
		add(corruptleftArrow);

		rightArrow = new FlxSprite(3000, 312).loadGraphic(Paths.image("storymenu/arrowRight"));
		rightArrow.antialiasing = true;
		add(rightArrow);

		corruptrightArrow = new FlxSprite(1134, 312).loadGraphic(Paths.image("storymenu/arrowRightCorrupt"));
		corruptrightArrow.antialiasing = true;
		corruptrightArrow.alpha = 0;
		add(corruptrightArrow);

		FlxTween.tween(leftArrow, {x: 28}, 1.5, {
			ease: FlxEase.quadOut,
			startDelay: 0.5
		});

		FlxTween.tween(rightArrow, {x: 1134}, 1.5, {
			ease: FlxEase.quadOut,
			startDelay: 0.5
		});
		trace("Line 96");
		
		//add(difficultySelectors);

		trace("Line 124");

		trace("Line 150");

		//add(yellowBG);
		//add(grpWeekCharacters);
		//add(txtTracklist);
		// add(rankText);
		//add(scoreText);
		//add(txtWeekTitle);
	

		trace("Line 165");

		super.create();
		changeDifficulty();
		bobmadshake = new FlxSprite( -198, -118).loadGraphic(Paths.image('storymenu/bobscreen'));
		bobmadshake.scrollFactor.set(0, 0);
		bobmadshake.visible = false;
		add(bobmadshake);
		bobsound = new FlxSound().loadEmbedded(Paths.sound('bob/bobscreen', 'shared'));
	}
	//sorry for this LOL
	function bop(i:FlxSprite):Void {
		bop1 = FlxTween.tween(i, {y: 40}, 3, {
			ease: FlxEase.quadInOut,
			onComplete: function(tween:FlxTween)
			{
				bop2 = FlxTween.tween(i, {y: 10}, 3, {
					ease: FlxEase.quadInOut,
					onComplete: function(tween:FlxTween)
					{
							bop(i);
					}
				});
			}
		});
	}
	function bopbutFUCKYOU(i:FlxSprite):Void {
		bop3 = FlxTween.tween(i, {y: 10}, 1.5, {
			ease: FlxEase.quadIn,
			onComplete: function(tween:FlxTween)
			{
				bop4 = FlxTween.tween(i, {y: -10}, 1.5, {
					ease: FlxEase.quadInOut,
					onComplete: function(tween:FlxTween)
					{
							bopbutFUCKYOU(i);
					}
				});
			}
		});
	}
	function bopOpposite(i:FlxSprite, ogY:Float):Void {
		bop5 = FlxTween.tween(i, {y: ogY - 30}, 3, {
			ease: FlxEase.quadInOut,
			onComplete: function(tween:FlxTween)
			{
				bop6 = FlxTween.tween(i, {y: ogY + 40}, 3, {
					ease: FlxEase.quadInOut,
					onComplete: function(tween:FlxTween)
					{
							bopOpposite(i, ogY);
					}
				});
			}
		});
	}
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		for (i in grpWeekDifficulties) {
			if (i.scale.x > 1)
				i.scale.x = FlxMath.lerp(i.scale.x, 1, 0.09);
			if (i.scale.y > 1)
				i.scale.y = FlxMath.lerp(i.scale.y, 1, 0.09);
		}
		if (storymodeLogo.scale.x > 0.6)
			storymodeLogo.scale.x = FlxMath.lerp(storymodeLogo.scale.x, 0.6, 0.09);
		if (storymodeLogo.scale.y > 0.6)
			storymodeLogo.scale.y = FlxMath.lerp(storymodeLogo.scale.y, 0.6, 0.09);
		// FlxG.watch.addQuick('font', scoreText.font);
		if (controls.RIGHT) {
			rightArrow.scale.set(0.95, 0.95);
			corruptrightArrow.scale.set(0.95, 0.95);
		} else {
			rightArrow.scale.set(1, 1);
			corruptrightArrow.scale.set(1, 1);
		}
		if (controls.LEFT && !controls.RIGHT) {
			leftArrow.scale.set(0.95, 0.95);
			corruptleftArrow.scale.set(0.95, 0.95);
		} else {
			leftArrow.scale.set(1, 1);
			corruptleftArrow.scale.set(1, 1);
		}
		if (!movedBack)
		{
			
			if (!selectedWeek)
			{
				if (controls.LEFT_P)
				{
					changeWeek(-1);
				}

				if (controls.RIGHT_P)
				{
					changeWeek(1);
				}

				

				if (controls.UP_P)
					changeDifficulty(1);
				if (controls.DOWN_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				if (!selectedWeek)
					selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			
			outTransition();
			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				FlxG.switchState(new MainMenuState());
			});
			
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;
	function outTransition()
	{
		movedBack = true;
		if (bop1 != null) {
			if (!bop1.finished)
				bop1.cancel();
		}
		if (bop2 != null) {
			if (!bop2.finished)
				bop2.cancel();
		}
		if (bop3 != null) {
			if (!bop3.finished)
				bop3.cancel();
		}
		if (bop4 != null) {
			if (!bop4.finished)
				bop4.cancel();
		}
		if (bop5 != null) {
			if (!bop5.finished)
				bop5.cancel();
		}
		if (bop6 != null) {
			if (!bop6.finished)
				bop6.cancel();
		}
		for (i in grpWeekBackgrounds) {
			FlxTween.tween(i, {alpha: 0}, 0.6, {ease: FlxEase.quadOut,startDelay: 0.6});
		}
		for (i in grpWeekBackgroundsBottom) {
			FlxTween.tween(i, {alpha: 0}, 0.6, {ease: FlxEase.quadOut,startDelay: 0.6,});
		}
		for (i in grpWeekSprites) {
			FlxTween.tween(i, {y: i.y + 50}, 0.6, {ease: FlxEase.quadOut});
			FlxTween.tween(i, {y: FlxG.height * 1.3}, 0.6, {ease: FlxEase.quadOut, startDelay: 0.6, onComplete: function(twn:FlxTween) {
				i.visible = false;
			},});
		}
		for (i in grpWeekDifficulties) {
			FlxTween.tween(i, {y: i.y+ 50}, 0.6, {ease: FlxEase.quadOut,});
			FlxTween.tween(i, {y: i.y + 1000}, 0.6, {ease: FlxEase.quadOut,startDelay: 0.6});
		}
		for (i in grpWeekText) {
			FlxTween.tween(i, {y: i.y - 50}, 0.6, {ease: FlxEase.quadOut,startDelay: 0.1});
			FlxTween.tween(i, {y: -FlxG.height}, 0.6, {ease: FlxEase.quadOut,startDelay: 0.7, onComplete: function(twn:FlxTween) {
				i.visible = false;
			},});
		}
		FlxTween.tween(diffText, {alpha: 0}, 0.6, {startDelay: 0.6});
		FlxTween.tween(FlxG.camera, {zoom: 0.8}, 0.6, {startDelay: 0.6});
		FlxTween.tween(storymodeLogo, {y: storymodeLogo.y - 50}, 0.6, {ease: FlxEase.quadOut,startDelay: 0.2});
		FlxTween.tween(storymodeLogo, {y: -FlxG.height}, 0.6, {ease: FlxEase.quadOut,startDelay: 0.8});

		FlxTween.tween(leftArrow, {x: -2000}, 1.5, {
			ease: FlxEase.quadOut,
			startDelay: 0.7
		});

		FlxTween.tween(rightArrow, {x: 3000}, 1.5, {
			ease: FlxEase.quadOut,
			startDelay: 0.7
		});

		FlxTween.tween(corruptleftArrow, {x: -2000}, 1.5, {
			ease: FlxEase.quadOut,
			startDelay: 0.7
		});

		FlxTween.tween(corruptrightArrow, {x: 3000}, 1.5, {
			ease: FlxEase.quadOut,
			startDelay: 0.7
		});

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			var blackness:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			add(blackness);
		});
	}
	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (curWeek == 3 && curDifficulty != 2) {
				selectedWeek = true;
				Bobismad();
				curDifficulty = 2;
				changeDifficulty();
			} else {
					trace(curWeek);
				if (stopspamming == false)
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
					stopspamming = true;
				}

				PlayState.storyPlaylist = weekData[curWeek];
				PlayState.isStoryMode = true;
				selectedWeek = true;

				var diffic = "";

				switch (curDifficulty)
				{
					case 0:
						diffic = '-easy';
					case 2:
						diffic = '-hard';
				}
				outTransition();
				
				/*var ourSource:String = "assets/videos/DO NOT DELETE OR GAME WILL CRASH/dontDelete.webm";

				#if web
				var str1:String = "HTML CRAP";
				var vHandler = new VideoHandler();
				vHandler.init1();
				vHandler.video.name = str1;
				vHandler.init2();
				GlobalVideo.setVid(vHandler);
				vHandler.source(ourSource);
				#elseif desktop
				var str1:String = "WEBM SHIT"; 
				var webmHandle = new WebmHandler();
				webmHandle.source(ourSource);
				webmHandle.makePlayer();
				webmHandle.webm.name = str1;
				WebmPlayer.SKIP_STEP_LIMIT = 90;
				GlobalVideo.setWebm(webmHandle);
				GlobalVideo.get().updatePlayer();
				#end*/
				PlayState.obsIsOpen = false;
				if (FreeplayState.bpm > 0)
					FreeplayState.bpm = 0;	
				PlayState.storyDifficulty = curDifficulty;
				switch (StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase()) {
					case 'jump-in' | 'groovy-brass':
						PlayState.playCutscene = true;
					case 'copy-cat':
							var elProcess = new Process("tasklist", []);
							var output = elProcess.stdout.readAll().toString().toLowerCase();
							
							
							var blockedShit:Array<String> = ['obs64.exe', 'obs32.exe', 'streamlabs obs.exe', 'streamlabs obs32.exe'];
							for (i in 0...blockedShit.length)
							{
								if (output.contains(blockedShit[i]))
								{
									PlayState.obsIsOpen = true;
								}
							}
							elProcess.close();
							
						PlayState.playCutscene = true;
				}
				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
				PlayState.storyWeek = curWeek;
				PlayState.campaignScore = 0;
				new FlxTimer().start(1.5, function(tmr:FlxTimer)
				{
					LoadingState.loadAndSwitchState(new PlayState(), true);
				});
			}
			
			
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;
	
		for (i in grpWeekDifficulties) {
			i.visible = false;
		}
		grpWeekDifficulties.members[curDifficulty].visible = true;

		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	override function beatHit()
	{
		if (curBeat % 2 == 0) {
			for (i in grpWeekDifficulties) {
				i.scale.x += 0.03;
				i.scale.y += 0.03;
			}
		}
		storymodeLogo.scale.x += 0.02;
		storymodeLogo.scale.y += 0.02;
		super.beatHit();
	}
	function changeWeek(change:Int = 0):Void
	{
		var daBG = grpWeekBackgrounds.members[curWeek];
		var daBGbottom = grpWeekBackgroundsBottom.members[curWeek];
		var daSpr = grpWeekSprites.members[curWeek];
		var daTxt = grpWeekText.members[curWeek];
		//FlxTween.tween(daBG, {x: FlxG.width * change}, 0.6, {ease: FlxEase.quadOut});
		FlxTween.tween(daBG, {alpha: 0}, 0.6, {ease: FlxEase.quadOut});
		FlxTween.tween(daBGbottom, {alpha: 0}, 0.6, {ease: FlxEase.quadOut});
		FlxTween.tween(daSpr, {x: FlxG.width * -change}, 0.6, {ease: FlxEase.quadOut});
		FlxTween.tween(daTxt, {x: FlxG.width * -change}, 0.6, {ease: FlxEase.quadOut, 
			onComplete: function(twn:FlxTween) {
				daBG.visible = false;
				daBGbottom.visible = false;
				daSpr.visible = false;
				daTxt.visible = false;
			},
		});
		curWeek += change;
		movedBack = true;
		
		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		//grpWeekBackgrounds.members[curWeek].x = FlxG.width * -change;
		grpWeekBackgrounds.members[curWeek].visible = true;
		grpWeekBackgrounds.members[curWeek].alpha = 0;

		grpWeekBackgroundsBottom.members[curWeek].visible = true;
		grpWeekBackgroundsBottom.members[curWeek].alpha = 0;

		grpWeekSprites.members[curWeek].x = FlxG.width * change;
		grpWeekSprites.members[curWeek].visible = true;

		grpWeekText.members[curWeek].x = FlxG.width * change;
		grpWeekText.members[curWeek].visible = true;
		//FlxTween.tween(grpWeekBackgrounds.members[curWeek], {x: 0}, 0.6, {ease: FlxEase.quadOut});
		FlxTween.tween(grpWeekBackgrounds.members[curWeek], {alpha: 1}, 0.6, {ease: FlxEase.quadOut});
		FlxTween.tween(grpWeekBackgroundsBottom.members[curWeek], {alpha: 1}, 0.6, {ease: FlxEase.quadOut});
		FlxTween.tween(grpWeekSprites.members[curWeek], {x: 0}, 0.6, {ease: FlxEase.quadOut});
		FlxTween.tween(grpWeekText.members[curWeek], {x: weekNames[curWeek][1]}, 0.6, {ease: FlxEase.quadOut,
			onComplete: function(twn:FlxTween) {
				movedBack = false;
			},
		});
		if (curWeek == 3 && !weekUnlocked[3]) {
			FlxG.sound.music.fadeOut(0.6, 0);
			spookyMenu.fadeIn(0.6, 0, 1);
			FlxTween.tween(leftArrow, {alpha: 0}, 0.6, {});
			FlxTween.tween(rightArrow, {alpha: 0}, 0.6, {});
			FlxTween.tween(corruptleftArrow, {alpha: 1}, 0.6, {});
			FlxTween.tween(corruptrightArrow, {alpha: 1}, 0.6, {});
		} else if (leftArrow.alpha == 0) {
			spookyMenu.fadeOut(0.6, 0);
			FlxG.sound.music.fadeIn(0.6, 0, 1);
			FlxTween.tween(leftArrow, {alpha: 1}, 0.6, {});
			FlxTween.tween(rightArrow, {alpha: 1}, 0.6, {});
			FlxTween.tween(corruptleftArrow, {alpha: 0}, 0.6, {});
			FlxTween.tween(corruptrightArrow, {alpha: 0}, 0.6, {});
		}
		if (weekUnlocked[curWeek] == false) {
			FlxTween.tween(diffText, {alpha: 0}, 0.6, {ease: FlxEase.quadOut});
			for (i in grpWeekDifficulties) {
				FlxTween.tween(i, {alpha: 0}, 0.6, {ease: FlxEase.quadOut});
			}
		} else if (diffText.alpha < 1) {
			FlxTween.tween(diffText, {alpha: 1}, 0.6, {ease: FlxEase.quadOut});
			for (i in grpWeekDifficulties) {
				FlxTween.tween(i, {alpha: 1}, 0.6, {ease: FlxEase.quadOut});
			}
		}
		var bullShit:Int = 0;
		
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function Bobismad():Void
	{
		FlxG.camera.zoom = 1 + (0.2 * (dumbCounter));
		bobmadshake.visible = true;
		bobsound.play();
		bobsound.volume = 1;
		shakescreen();
		Lib.application.window.fullscreen = false;
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			resetBobismad();
		});
		dumbCounter++;
	}
	function resetBobismad():Void
	{
		FlxG.camera.zoom = 1;
		bobsound.pause();
		bobmadshake.visible = false;
		bobsound.volume = 0;
		
		if (dumbCounter == 5) {
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = "";

			switch (curDifficulty)
			{
				case 0:
					diffic = '-easy';
				case 2:
					diffic = '-hard';
			}
			outTransition();
			
			
			
			PlayState.obsIsOpen = false;
			if (FreeplayState.bpm > 0)
				FreeplayState.bpm = 0;
			PlayState.storyDifficulty = curDifficulty;
			switch (StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase()) {
				case 'jump-in' | 'groovy-brass':
					PlayState.playCutscene = true;
				case 'copy-cat':
					var elProcess = new Process("tasklist", []);
					var output = elProcess.stdout.readAll().toString().toLowerCase();
					
					
					var blockedShit:Array<String> = ['obs64.exe', 'obs32.exe', 'streamlabs obs.exe', 'streamlabs obs32.exe'];
					for (i in 0...blockedShit.length)
					{
						if (output.contains(blockedShit[i]))
						{
							PlayState.obsIsOpen = true;
						}
					}
					elProcess.close();
					
					PlayState.playCutscene = true;
			}
			PlayState.SONG = Song.loadFromJson(StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase() + diffic, StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			PlayState.desktopMode = false;
			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		} else
			selectedWeek = false;
	}

	function shakescreen()
	{
		new FlxTimer().start(0.01, function(tmr:FlxTimer)
		{
			Lib.application.window.move(Lib.application.window.x + FlxG.random.int( -10 * (dumbCounter + 1), 10 * (dumbCounter + 1)),Lib.application.window.y + FlxG.random.int( -8 * (dumbCounter + 1), 8 * (dumbCounter + 1)));
		}, 50);
	}
}
