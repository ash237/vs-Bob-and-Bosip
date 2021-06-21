package;

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


#if windows
import Discord.DiscordClient;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];
	var yellow:FlxSprite;
	var character:Character;
	var targetX:Int;
	var canDoShit:Bool = true;
	var blue:FlxSprite;
	var freeplayLogo:FlxSprite;
	public static var bpm:Float;
	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

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
		
		
		blue = new FlxSprite(-800).loadGraphic(Paths.image('mainmenu/Blue'));
		blue.scrollFactor.set();
		blue.updateHitbox();
		blue.antialiasing = true;
		add(blue);
		canDoShit = false;
		yellow = new FlxSprite(FlxG.width).loadGraphic(Paths.image('freeplaybg'));
		yellow.scrollFactor.set();
		yellow.updateHitbox();
		yellow.antialiasing = true;
		add(yellow);
		
		var line:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/Black line'));
		line.scrollFactor.set();
		line.updateHitbox();
		line.antialiasing = true;
		add(line);

		
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);
		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false, true);
			songText.visible = false;
			songText.lerpxOffset = 2000;
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			icon.visible = false;
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		var random = FlxG.random.int(0,2);
		if (random == MainMenuState.prevCharacter) {
			random++;
			if (random > 2) 
				random = 0;
		}

		switch (random) {
			case 2:
				character = new Character(-920, 180, 'bob');
				targetX = 0;
			case 1:
				character = new Character(-800, 150, 'bosip');
				targetX = 20;
			case 0:
				character = new Character(-2000, 400, 'bf');
				targetX = -40;
		}
		MainMenuState.prevCharacter = random;
		var cjChance = FlxG.random.int(0, 50);
		if (cjChance == 25) {
			character = new Character(-800, 170, 'cj');
			targetX = -40;
		}
		character.debugMode = true;
		character.scale.set(0.8, 0.8);
		character.scrollFactor.set(0, 0);
		add(character);

		freeplayLogo = new FlxSprite(-1500, 30);
		freeplayLogo.frames = Paths.getSparrowAtlas('FNF_main_menu_assets');
		freeplayLogo.scrollFactor.set(1, 0);
		freeplayLogo.antialiasing = true;
		freeplayLogo.animation.addByPrefix('bump', 'freeplay basic', 24, true);
		freeplayLogo.animation.play('bump');
		freeplayLogo.updateHitbox();
		freeplayLogo.scale.set(0.6, 0.6);
		add(freeplayLogo);

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);
		FlxTween.tween(blue, {x: 0}, 0.6, {
			ease: FlxEase.quadIn,
			startDelay: 0.2,
		});
		FlxTween.tween(yellow, {x: 0}, 0.6, {
			ease: FlxEase.quadIn,
			startDelay: 0.2,
		});
		FlxTween.tween(character, {x: targetX}, 0.6, {
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
		});
		FlxTween.tween(freeplayLogo, {x: -20}, 0.6, {
			ease: FlxEase.quadIn,
			startDelay: 0.2,
		});
		for (i in grpSongs) {
			
			FlxTween.tween(i, {lerpxOffset: 540}, 0.6, {
				ease: FlxEase.quadIn,
				startDelay: 0.2,
			});
		}
		new FlxTimer().start(0.61, function(tmr:FlxTimer)
		{
			for (i in grpSongs) {
				i.visible = true;
			}
			for (i in iconArray) {
				i.visible = true;
			}
		});
		
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
		super.update(elapsed);
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		if (FlxG.sound.music.volume < 0.7)
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

			if (controls.LEFT_P)
				changeDiff(-1);
			if (controls.RIGHT_P)
				changeDiff(1);

			if (controls.BACK)
			{
				
				outTransition();
				new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					FlxG.switchState(new MainMenuState());
				});
				
			}
			if (accepted)
			{
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
	
				var poop:String = Highscore.formatSong(songHighscore, curDifficulty);
	
				trace(poop);
				
				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
				PlayState.storyWeek = songs[curSelected].week;
				trace('CUR WEEK' + PlayState.storyWeek);
				outTransition();
				new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
				
			}
		}
	
		
	}
	function outTransition() {
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		canDoShit = false;
		FlxTween.tween(blue, {x: -50}, 0.6, {
			ease: FlxEase.quadOut,
		});
		FlxTween.tween(blue, {x: -800}, 0.6, {
			ease: FlxEase.quadOut,
			startDelay:0.6
		});
		FlxTween.tween(freeplayLogo, {x: freeplayLogo.x - 50}, 0.6, {
			ease: FlxEase.quadOut,
		});
		FlxTween.tween(freeplayLogo, {x: -1500}, 0.6, {
			ease: FlxEase.quadOut,
			startDelay:0.6
		});
		FlxTween.tween(yellow, {x: 50}, 0.6, {
			ease: FlxEase.quadOut,
		});
		FlxTween.tween(yellow, {x: FlxG.width}, 0.6, {
			ease: FlxEase.quadOut,
			startDelay: 0.6,
		});
		FlxTween.tween(character, {x: character.x - 50}, 0.6, {ease: FlxEase.quadOut});
		FlxTween.tween(character, {x: -800}, 0.6, {
			ease: FlxEase.quadOut,
			startDelay:0.6
		});
		for (i in grpSongs) {
			FlxTween.tween(i, {lerpxOffset: 590}, 0.6, {
				ease: FlxEase.quadOut,
			});
			FlxTween.tween(i, {lerpxOffset: 2000}, 0.6, {
				ease: FlxEase.quadOut,
				startDelay: 0.6,
			});
		}
	}
	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		// adjusting the highscore song name to be compatible (changeDiff)
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}
		
		#if !switch
		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "HARD";
		}
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
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
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		var daJson = Song.loadFromJson(songs[curSelected].songName.toLowerCase(), songs[curSelected].songName.toLowerCase());
		Conductor.changeBPM(daJson.bpm);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (character.animation.curAnim.name != 'haha')
			character.playAnim('idle', true);

		
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
