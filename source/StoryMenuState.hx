package;

import flixel.FlxG;
import flixel.FlxSprite;
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

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	var weekData:Array<Dynamic> = [
		['Tutorial'],
		['jump-in', 'swing', 'split'],
		['nothing lol']
	];
	var curDifficulty:Int = 2;

	public static var weekUnlocked:Array<Bool> = [true, true, false];

	var weekCharacters:Array<String> = [
		'Bf and Gff',
		'bob and bosip',
		'nobody'
	];

	var weekNames:Array<String> = [
		"Tutorial",
		"week bob",
		"Coming_soon"
	];

	var weekColors:Array<String> = [
		"tutorial color bg",
		"BG",
		"Coming_soon_bg"
	];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<FlxSprite>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;
	var grpWeekDifficulties:FlxTypedGroup<FlxSprite>;
	var grpWeekBackgrounds:FlxTypedGroup<FlxSprite>;
	var grpWeekSprites:FlxTypedGroup<FlxSprite>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var bg:FlxSprite;

	//this code was made at 2:48 AM sorry lol
	var bop1:FlxTween;
	var bop2:FlxTween;
	var bop3:FlxTween;
	var bop4:FlxTween;
	var bop5:FlxTween;
	var bop6:FlxTween;

	var storymodeLogo:FlxSprite;
	
	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		
		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		//add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		//add(grpLocks);
		grpWeekBackgrounds = new FlxTypedGroup<FlxSprite>();
		add(grpWeekBackgrounds);
		
		grpWeekSprites = new FlxTypedGroup<FlxSprite>();
		add(grpWeekSprites);

		grpWeekText = new FlxTypedGroup<FlxSprite>();
		add(grpWeekText);

		storymodeLogo = new FlxSprite(-20, -FlxG.height);
		storymodeLogo.frames = Paths.getSparrowAtlas('FNF_main_menu_assets');
		storymodeLogo.scrollFactor.set(1, 0);
		storymodeLogo.antialiasing = true;
		storymodeLogo.animation.addByPrefix('bump', 'story mode basic', 24, true);
		storymodeLogo.animation.play('bump');
		storymodeLogo.updateHitbox();
		storymodeLogo.scale.set(0.6, 0.6);
		add(storymodeLogo);
		
		grpWeekDifficulties = new FlxTypedGroup<FlxSprite>();
		add(grpWeekDifficulties);
		movedBack = true;
		for (i in 0...3) {
			var diffSprite:FlxSprite = new FlxSprite();
			switch (i) {
				case 0:
					diffSprite = new FlxSprite(0, FlxG.height).loadGraphic(Paths.image('storymenu/Easy'));
				case 1:
					diffSprite = new FlxSprite(0, FlxG.height).loadGraphic(Paths.image('storymenu/Normal'));
				case 2:
					diffSprite = new FlxSprite(0, FlxG.height).loadGraphic(Paths.image('storymenu/Hard'));
			}
			grpWeekDifficulties.add(diffSprite);
		}

		
		for (i in weekColors) {
			bg = new FlxSprite(0, 0).loadGraphic(Paths.image("storymenu/" + i));
			grpWeekBackgrounds.add(bg);
			bg.visible = false;
			bg.alpha = 0;
		}
		grpWeekBackgrounds.members[0].visible = true;
		for (i in weekCharacters) {
			var daSprite:FlxSprite = new FlxSprite(0, FlxG.height).loadGraphic(Paths.image("storymenu/" + i));
			daSprite.visible = false;
			grpWeekSprites.add(daSprite);
		}
		grpWeekSprites.members[0].visible = true;

		for (i in weekNames) {
			var weekThing:FlxSprite = new FlxSprite(0, -FlxG.height).loadGraphic(Paths.image('storymenu/' + i));
			weekThing.antialiasing = true;
			weekThing.visible = false;
			grpWeekText.add(weekThing);
		}
		grpWeekText.members[0].visible = true;
		for (i in grpWeekBackgrounds) {
			FlxTween.tween(i, {alpha: 1}, 0.6, {
				ease: FlxEase.quadOut,
			});
		}
		for (i in grpWeekText) {
			FlxTween.tween(i, {y: 0}, 2, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween) {
					bopOpposite(i);
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
			FlxTween.tween(i, {y: 0}, 1.5, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween) {
					bopbutFUCKYOU(i);
				},
				startDelay: 0.3
			});
		}

		FlxTween.tween(storymodeLogo, {y: 30}, 1.5, {
			ease: FlxEase.quadOut,
			startDelay: 0.5
		});

		trace("Line 70");

		
		
		leftArrow = new FlxSprite().loadGraphic(Paths.image("storymenu/left arrow"));
		leftArrow.antialiasing = true;
		add(leftArrow);

		rightArrow = new FlxSprite().loadGraphic(Paths.image("storymenu/right arrow"));
		rightArrow.antialiasing = true;
		add(rightArrow);
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
	function bopOpposite(i:FlxSprite):Void {
		bop5 = FlxTween.tween(i, {y: -30}, 3, {
			ease: FlxEase.quadInOut,
			onComplete: function(tween:FlxTween)
			{
				bop6 = FlxTween.tween(i, {y: 40}, 3, {
					ease: FlxEase.quadInOut,
					onComplete: function(tween:FlxTween)
					{
							bopOpposite(i);
					}
				});
			}
		});
	}
	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		// FlxG.watch.addQuick('font', scoreText.font);

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

				/*if (controls.RIGHT)
					rightArrow.scale.set(0.95, 0.95);
				else
					rightArrow.scale.set(1, 1);

				if (controls.LEFT)
					leftArrow.scale.set(0.95, 0.95);
				else
					leftArrow.scale.set(1, 1);*/

				if (controls.UP_P)
					changeDifficulty(1);
				if (controls.DOWN_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
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
		for (i in grpWeekSprites) {
			FlxTween.tween(i, {y: i.y + 50}, 0.6, {ease: FlxEase.quadOut});
			FlxTween.tween(i, {y: FlxG.height}, 0.6, {ease: FlxEase.quadOut,startDelay: 0.6});
		}
		for (i in grpWeekDifficulties) {
			FlxTween.tween(i, {y: i.y+ 50}, 0.6, {ease: FlxEase.quadOut,startDelay: 0.2});
			FlxTween.tween(i, {y: FlxG.height}, 0.6, {ease: FlxEase.quadOut,startDelay: 0.8});
		}
		for (i in grpWeekText) {
			FlxTween.tween(i, {y: i.y - 50}, 0.6, {ease: FlxEase.quadOut,startDelay: 0.1});
			FlxTween.tween(i, {y: -FlxG.height}, 0.6, {ease: FlxEase.quadOut,startDelay: 0.7});
		}
		FlxTween.tween(storymodeLogo, {y: storymodeLogo.y - 50}, 0.6, {ease: FlxEase.quadOut,startDelay: 0.2});
		FlxTween.tween(storymodeLogo, {y: -FlxG.height}, 0.6, {ease: FlxEase.quadOut,startDelay: 0.8});
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
			
			PlayState.storyDifficulty = curDifficulty;
			switch (StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase()) {
				case 'jump-in':
					PlayState.playCutscene = true;
			}
			PlayState.SONG = Song.loadFromJson(StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase() + diffic, StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
			
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
			i.alpha = 0;
		}
		grpWeekDifficulties.members[curDifficulty].alpha = 1;

		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		var daBG = grpWeekBackgrounds.members[curWeek];
		var daSpr = grpWeekSprites.members[curWeek];
		var daTxt = grpWeekText.members[curWeek];
		//FlxTween.tween(daBG, {x: FlxG.width * change}, 0.6, {ease: FlxEase.quadOut});
		FlxTween.tween(daBG, {alpha: 0}, 0.6, {ease: FlxEase.quadOut});
		FlxTween.tween(daSpr, {x: FlxG.width * -change}, 0.6, {ease: FlxEase.quadOut});
		FlxTween.tween(daTxt, {x: FlxG.width * -change}, 0.6, {ease: FlxEase.quadOut, 
			onComplete: function(twn:FlxTween) {
				daBG.visible = false;
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

		grpWeekSprites.members[curWeek].x = FlxG.width * change;
		grpWeekSprites.members[curWeek].visible = true;

		grpWeekText.members[curWeek].x = FlxG.width * change;
		grpWeekText.members[curWeek].visible = true;
		//FlxTween.tween(grpWeekBackgrounds.members[curWeek], {x: 0}, 0.6, {ease: FlxEase.quadOut});
		FlxTween.tween(grpWeekBackgrounds.members[curWeek], {alpha: 1}, 0.6, {ease: FlxEase.quadOut});
		FlxTween.tween(grpWeekSprites.members[curWeek], {x: 0}, 0.6, {ease: FlxEase.quadOut});
		FlxTween.tween(grpWeekText.members[curWeek], {x: 0}, 0.6, {ease: FlxEase.quadOut,
			onComplete: function(twn:FlxTween) {
				movedBack = false;
			},
		});
		var bullShit:Int = 0;
		
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}
