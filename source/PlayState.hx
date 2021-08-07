package;

//import PixelateShader.Pixelate;

import sys.io.Process;
import openfl.filters.BitmapFilter;
import flixel.math.FlxRandom;
import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;

import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var desktopMode:Bool = false;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;
	public static var playCutscene:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;

	public var fuckingVolume:Float = 1;
	public var useVideo = false;

	public static var webmHandler:WebmHandler;

	public var playingDathing = false;

	public var videoSprite:FlxSprite;

	public var stopUpdate = false;
	public var removedVideo = false;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	var weekNames:Array<String> = [
		'Tutorial',
		'B&B',
		'ITB',
		'BT'
	];
	#end

	private var vocals:FlxSound;
	private var secondaryVocals:FlxSound;

	public static var dad:Character;
	var dad2:Character;
	var useCamChange:Bool = true;
	var hasDad2:Bool = false;
	var usesDad2Chart:Bool = false;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	var SAD:FlxTypedGroup<FlxSprite>;
	var SADorder:Int = 0;
	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cerbStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	var dadCamOffset:FlxPoint;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var grpIcons:FlxTypedGroup<HealthIcon>;
	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var healthDrainTimer:Int = -1;
	var healthDrainTarget:Float;
	var healthDraining:Bool = false;
	var healthBarColor1:FlxColor;
	var iconP1Prefix:String;
	var iconP2Prefix:String;
	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	var waaaa:FlxSprite;
	var unregisteredHypercam:FlxSprite;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var coolGlowyLights:FlxTypedGroup<FlxSprite>;
	var coolGlowyLightsMirror:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	var cpuNoteTimer:Array<Int> = [0, 0, 0, 0];
	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	var dadShouldIdle:Bool = true;
	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Float> = [];

	

	private var executeModchart = false;
	var walked:Bool = false;
	var walkingRight:Bool = true;
	var stopWalkTimer:Int = 0;
	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }

	var blackness:FlxSprite;

	var pc:Character;

	var areYouReady:FlxTypedGroup<FlxSprite>;

	var theEntireFuckingStage:FlxTypedGroup<FlxSprite>;

	var mini:FlxSprite;
	var mordecai:FlxSprite;
	var thirdBop:FlxSprite;
	public static var didTheSex:Bool = false;

	public static var effectSONG:SwagSong;
	private var effectNotes:FlxTypedGroup<Note>;

	public static var dad2SONG:SwagSong;
	private var dad2Notes:FlxTypedGroup<Note>;
	var healthColorSwitch1:Bool = false;
	var healthColorSwitch2:Bool = false;
	var lightsTimer:Array<Int> = [200, 700];

	var dadTrail:FlxTrail;

	var splitMode:Bool = false;
	var splitSoftMode:Bool = false;
	var splitCamMode:Bool = false;
	var splitExtraZoom:Bool = false;
	var coolerText:Bool = false;

	var songSpeedMultiplier:Float = 0;
	
	var grpDieStage:FlxTypedGroup<FlxSprite>;
	var grpSlaughtStage:FlxTypedGroup<FlxSprite>;

	var resyncingVocals:Bool = true;

	public static var obsIsOpen:Bool = false;

	override public function create()
	{
		removedVideo = false;

		instance = this;
		healthBarColor1 = new FlxColor(200);
		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		dadCamOffset = new FlxPoint();
		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		
		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase  + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
			case 3:
				storyDifficultyText = "EX";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			if (storyWeek == 0)
				detailsText = "Tutorial";
			else
				detailsText = "Week " + weekNames[storyWeek] + ' | ';
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		if (playCutscene) {
			camGame.visible = false;
			camHUD.visible = false;
		}
		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + FlxG.save.data.botplay);
	
		//dialogue shit
		if (isStoryMode) {
			switch (songLowercase)
			{
				case 'tutorial':
					dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
				case 'bopeebo':
					dialogue = [
						'HEY!',
						"You think you can just sing\nwith my daughter like that?",
						"If you want to date her...",
						"You're going to have to go \nthrough ME first!"
					];
				case 'fresh':
					dialogue = ["Not too shabby boy.", ""];
				case 'dadbattle':
					dialogue = [
						"gah you think you're hot stuff?",
						"If you can beat me here...",
						"Only then I will even CONSIDER letting you\ndate my daughter!"
					];
				case 'jump-out':
					dialogue = CoolUtil.coolTextFile(Paths.txt('jump-out/gloopy'));
				case 'ronald-mcdonald-slide':
					dialogue = CoolUtil.coolTextFile(Paths.txt('ronald mcdonald slide/haha'));
					if (obsIsOpen) {
						dialogue = CoolUtil.coolTextFile(Paths.txt('ronald mcdonald slide/hahaifoundu'));
					}
				case 'senpai':
					dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
				case 'roses':
					dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
				case 'thorns':
					dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
			}
		}
		switch(SONG.stage)
		{
			case 'halloween': 
			{
				curStage = 'spooky';
				halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('halloween_bg','week2');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

				isHalloween = true;
			}
			case 'philly': 
					{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					if(FlxG.save.data.distractions){
						add(phillyCityLights);
					}

					for (i in 0...5)
					{
							var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
							light.scrollFactor.set(0.3, 0.3);
							light.visible = false;
							light.setGraphicSize(Std.int(light.width * 0.85));
							light.updateHitbox();
							light.antialiasing = true;
							phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain','week3'));
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train','week3'));
					if(FlxG.save.data.distractions){
						add(phillyTrain);
					}

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes','week3'));
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street','week3'));
					add(street);
			}
			case 'limo':
			{
					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset','week4'));
					skyBG.scrollFactor.set(0.1, 0.1);
					add(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo','week4');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					add(bgLimo);
					if(FlxG.save.data.distractions){
						grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						add(grpLimoDancers);
	
						for (i in 0...5)
						{
								var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
								dancer.scrollFactor.set(0.4, 0.4);
								grpLimoDancers.add(dancer);
						}
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay','week4'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive','week4');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = true;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol','week4'));
					// add(limo);
			}
			case 'mall':
			{
					curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls','week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop','week5');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = true;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(upperBoppers);
					}


					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator','week5'));
					bgEscalator.antialiasing = true;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree','week5'));
					tree.antialiasing = true;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);

					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop','week5');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = true;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bottomBoppers);
					}


					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow','week5'));
					fgSnow.active = false;
					fgSnow.antialiasing = true;
					add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa','week5');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = true;
					if(FlxG.save.data.distractions){
						add(santa);
					}
			}
			case 'mallEvil':
			{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG','week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree','week5'));
					evilTree.antialiasing = true;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow",'week5'));
						evilSnow.antialiasing = true;
					add(evilSnow);
					}
			case 'school':
			{
					curStage = 'school';

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky','week6'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool','week6'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet','week6'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack','week6'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees','week6');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals','week6');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (songLowercase == 'roses')
						{
							if(FlxG.save.data.distractions){
								bgGirls.getScared();
							}
						}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bgGirls);
					}
			}
			case 'schoolEvil':
			{
					curStage = 'schoolEvil';

					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool','week6');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);

					/* 
							var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
							bg.scale.set(6, 6);
							// bg.setGraphicSize(Std.int(bg.width * 6));
							// bg.updateHitbox();
							add(bg);
							var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
							fg.scale.set(6, 6);
							// fg.setGraphicSize(Std.int(fg.width * 6));
							// fg.updateHitbox();
							add(fg);
							wiggleShit.effectType = WiggleEffectType.DREAMY;
							wiggleShit.waveAmplitude = 0.01;
							wiggleShit.waveFrequency = 60;
							wiggleShit.waveSpeed = 0.8;
						*/

					// bg.shader = wiggleShit.shader;
					// fg.shader = wiggleShit.shader;

					/* 
								var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
								var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
								// Using scale since setGraphicSize() doesnt work???
								waveSprite.scale.set(6, 6);
								waveSpriteFG.scale.set(6, 6);
								waveSprite.setPosition(posX, posY);
								waveSpriteFG.setPosition(posX, posY);
								waveSprite.scrollFactor.set(0.7, 0.8);
								waveSpriteFG.scrollFactor.set(0.9, 0.8);
								// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
								// waveSprite.updateHitbox();
								// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
								// waveSpriteFG.updateHitbox();
								add(waveSprite);
								add(waveSpriteFG);
						*/
			}
			case 'stage':
				{
						defaultCamZoom = 0.9;
						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);
	
						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
	
						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;
	
						add(stageCurtains);
				}
			case 'day':
				{
						defaultCamZoom = 0.75;
						curStage = 'day';
						var bg1:FlxSprite = new FlxSprite(-970, -580).loadGraphic(Paths.image('day/BG1', 'shared'));
						bg1.antialiasing = true;
						bg1.scale.set(0.8, 0.8);
						bg1.scrollFactor.set(0.3, 0.3);
						bg1.active = false;
						add(bg1);

						var bg2:FlxSprite = new FlxSprite(-1240, -650).loadGraphic(Paths.image('day/BG2', 'shared'));
						bg2.antialiasing = true;
						bg2.scale.set(0.5, 0.5);
						bg2.scrollFactor.set(0.6, 0.6);
						bg2.active = false;
						add(bg2);

						if (storyDifficulty == 3) {
							mini = new FlxSprite(-270, -90);
							mini.frames = Paths.getSparrowAtlas('day/ex_crowd','shared');
							mini.animation.addByPrefix('idle', 'bobidlebig', 24, false);
							mini.animation.play('idle');
							//mini.scale.set(0.5, 0.5);
							//mini.scrollFactor.set(0.6, 0.6);
							add(mini);
	
							mordecai = new FlxSprite(141, 103);
						}
						else {
							mini = new FlxSprite(849, 189);
							mini.frames = Paths.getSparrowAtlas('day/mini','shared');
							mini.animation.addByPrefix('idle', 'mini', 24, false);
							mini.animation.play('idle');
							mini.scale.set(0.4, 0.4);
							mini.scrollFactor.set(0.6, 0.6);
							add(mini);

							mordecai = new FlxSprite(130, 160);
							mordecai.frames = Paths.getSparrowAtlas('day/bluskystv','shared');
							mordecai.animation.addByIndices('walk1', 'bluskystv', [29, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13] , '', 24, false);
							mordecai.animation.addByIndices('walk2', 'bluskystv', [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28] , '', 24, false);
							mordecai.animation.play('walk1');
							mordecai.scale.set(0.4, 0.4);
							mordecai.scrollFactor.set(0.6, 0.6);
							add(mordecai);
						}

						var bg3:FlxSprite = new FlxSprite(-630, -330).loadGraphic(Paths.image('day/BG3', 'shared'));
						bg3.antialiasing = true;
						bg3.scale.set(0.8, 0.8);
						bg3.active = false;
						add(bg3);
				}
			case 'die':
				{
					defaultCamZoom = 0.75;
					curStage = 'die';

					grpDieStage = new FlxTypedGroup<FlxSprite>();
					add(grpDieStage);

					var bg1:FlxSprite = new FlxSprite(-970, -580).loadGraphic(Paths.image('day/happy/happy_sky', 'shared'));
					bg1.antialiasing = true;
					bg1.scale.set(0.8, 0.8);
					bg1.scrollFactor.set(0.3, 0.3);
					bg1.active = false;
					grpDieStage.add(bg1);

					var bg2:FlxSprite = new FlxSprite(-1240, -650).loadGraphic(Paths.image('day/happy/happy_back', 'shared'));
					bg2.antialiasing = true;
					bg2.scale.set(0.5, 0.5);
					bg2.scrollFactor.set(0.6, 0.6);
					bg2.active = false;
					grpDieStage.add(bg2);

					var bg3:FlxSprite = new FlxSprite(-630, -330).loadGraphic(Paths.image('day/happy/happy_front', 'shared'));
					bg3.antialiasing = true;
					bg3.scale.set(0.8, 0.8);
					bg3.active = false;
					grpDieStage.add(bg3);
				}
			case 'sunset':
				{
					defaultCamZoom = 0.75;
					curStage = 'sunset';
					var bg1:FlxSprite = new FlxSprite(-970, -580).loadGraphic(Paths.image('sunset/BG1', 'shared'));
					bg1.antialiasing = true;
					bg1.scale.set(0.8, 0.8);
					bg1.scrollFactor.set(0.3, 0.3);
					bg1.active = false;
					add(bg1);

					var bg2:FlxSprite = new FlxSprite(-1240, -680).loadGraphic(Paths.image('sunset/BG2', 'shared'));
					bg2.antialiasing = true;
					bg2.scale.set(0.5, 0.5);
					bg2.scrollFactor.set(0.6, 0.6);
					bg2.active = false;
					add(bg2);
				
					if (storyDifficulty == 3) {
						mini = new FlxSprite(-270, -90);
						mini.frames = Paths.getSparrowAtlas('sunset/ex_crowd_sunset','shared');
						mini.animation.addByPrefix('idle', 'bobidlebig', 24, false);
						mini.animation.play('idle');
						//mini.scale.set(0.5, 0.5);
						//mini.scrollFactor.set(0.6, 0.6);
						add(mini);

						mordecai = new FlxSprite(141, 103);
					}
					else {
						mini = new FlxSprite(817, 190);
						mini.frames = Paths.getSparrowAtlas('sunset/femboy and edgy jigglypuff','shared');
						mini.animation.addByPrefix('idle', 'femboy', 24, false);
						mini.animation.play('idle');
						mini.scale.set(0.5, 0.5);
						mini.scrollFactor.set(0.6, 0.6);
						add(mini);

						mordecai = new FlxSprite(141, 103);
						mordecai.frames = Paths.getSparrowAtlas('sunset/jacob','shared');
						mordecai.animation.addByPrefix('idle', 'jacob', 24, false);
						mordecai.animation.play('idle');
						mordecai.scale.set(0.5, 0.5);
						mordecai.scrollFactor.set(0.6, 0.6);
						add(mordecai);
					}

					var bg3:FlxSprite = new FlxSprite(-630, -330).loadGraphic(Paths.image('sunset/BG3', 'shared'));
					bg3.antialiasing = true;
					bg3.scale.set(0.8, 0.8);
					bg3.active = false;
					add(bg3);
						
				}
			case 'sunshit':
				{
					defaultCamZoom = 0.75;
					curStage = 'sunshit';

					grpDieStage = new FlxTypedGroup<FlxSprite>();
					add(grpDieStage);


					var bg1:FlxSprite = new FlxSprite(-970, -580).loadGraphic(Paths.image('sunset/happy/bosip_sky', 'shared'));
					bg1.antialiasing = true;
					bg1.scale.set(0.8, 0.8);
					bg1.scrollFactor.set(0.3, 0.3);
					bg1.active = false;
					grpDieStage.add(bg1);

					var bg2:FlxSprite = new FlxSprite(-1240, -680).loadGraphic(Paths.image('sunset/happy/bosip_back', 'shared'));
					bg2.antialiasing = true;
					bg2.scale.set(0.5, 0.5);
					bg2.scrollFactor.set(0.6, 0.6);
					bg2.active = false;
					grpDieStage.add(bg2);

					var bg3:FlxSprite = new FlxSprite(-630, -330).loadGraphic(Paths.image('sunset/happy/bosip_front', 'shared'));
					bg3.antialiasing = true;
					bg3.scale.set(0.8, 0.8);
					bg3.active = false;
					grpDieStage.add(bg3);
						
				}
			case 'night':
			{
				defaultCamZoom = 0.75;
				curStage = 'night';
				theEntireFuckingStage = new FlxTypedGroup<FlxSprite>();
				add(theEntireFuckingStage);

				var bg1:FlxSprite = new FlxSprite(-970, -580).loadGraphic(Paths.image('night/BG1', 'shared'));
				bg1.antialiasing = true;
				bg1.scale.set(0.8, 0.8);
				bg1.scrollFactor.set(0.3, 0.3);
				bg1.active = false;
				theEntireFuckingStage.add(bg1);

				var bg2:FlxSprite = new FlxSprite(-1240, -650).loadGraphic(Paths.image('night/BG2', 'shared'));
				bg2.antialiasing = true;
				bg2.scale.set(0.5, 0.5);
				bg2.scrollFactor.set(0.6, 0.6);
				bg2.active = false;
				theEntireFuckingStage.add(bg2);

				mini = new FlxSprite(818, 189);
				mini.frames = Paths.getSparrowAtlas('night/bobsip','shared');
				mini.animation.addByPrefix('idle', 'bobsip', 24, false);
				mini.animation.play('idle');
				mini.scale.set(0.5, 0.5);
				mini.scrollFactor.set(0.6, 0.6);
				if (storyDifficulty != 3)
					theEntireFuckingStage.add(mini);

				var bg3:FlxSprite = new FlxSprite(-630, -330).loadGraphic(Paths.image('night/BG3', 'shared'));
				bg3.antialiasing = true;
				bg3.scale.set(0.8, 0.8);
				bg3.active = false;
				theEntireFuckingStage.add(bg3);

				var bg4:FlxSprite = new FlxSprite(-1390, -740).loadGraphic(Paths.image('night/BG4', 'shared'));
				bg4.antialiasing = true;
				bg4.scale.set(0.6, 0.6);
				bg4.active = false;
				theEntireFuckingStage.add(bg4);

				var bg5:FlxSprite = new FlxSprite(-34, 90);
				bg5.antialiasing = true;
				bg5.scale.set(1.4, 1.4);
				bg5.frames = Paths.getSparrowAtlas('night/pixelthing', 'shared');
				bg5.animation.addByPrefix('idle', 'pixelthing', 24);
				bg5.animation.play('idle');
				add(bg5);

				pc = new Character(115, 166, 'pc');
				pc.debugMode = true;
				pc.antialiasing = true;
				add(pc);

					
			}
			case 'ITB':
				defaultCamZoom = 0.70;
				curStage = 'ITB';
				var bg17:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('ITB/Layer 5', 'shared'));
				bg17.antialiasing = true;
				bg17.scrollFactor.set(0.3, 0.3);
				bg17.active = false;
				add(bg17);

				var bg16:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('ITB/Layer 4', 'shared'));
				bg16.antialiasing = true;
				bg16.scrollFactor.set(0.4, 0.4);
				bg16.active = false;
				add(bg16);

				var bg15:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('ITB/Layer 3', 'shared'));
				bg15.antialiasing = true;
				bg15.scrollFactor.set(0.6, 0.6);
				bg15.active = false;
				add(bg15);

				var bg14:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('ITB/Layer 2', 'shared'));
				bg14.antialiasing = true;
				bg14.scrollFactor.set(0.7, 0.7);
				bg14.active = false;
				add(bg14);

				var bg1:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('ITB/Layer 1 (back tree)', 'shared'));
				bg1.antialiasing = true;
				bg1.scrollFactor.set(0.7, 0.7);
				bg1.active = false;
				add(bg1);

				var bg13:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('ITB/Layer 1 (Tree)', 'shared'));
				bg13.antialiasing = true;
				bg13.active = false;
				add(bg13);

				var bg4:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('ITB/Layer 1 (flower and grass)', 'shared'));
				bg4.antialiasing = true;
				bg4.active = false;
				add(bg4);

				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				add(phillyCityLights);

				var bg9:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('ITB/layer 1 (light 1)', 'shared'));
				bg9.antialiasing = true;
				bg9.scrollFactor.set(0.8, 0.8);
				bg9.alpha = 0;
				bg9.active = false;
				phillyCityLights.add(bg9);

				var bg10:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('ITB/Layer 1 (Light 2)', 'shared'));
				bg10.antialiasing = true;
				bg10.scrollFactor.set(0.8, 0.8);
				bg10.alpha = 0;
				bg10.active = false;
				phillyCityLights.add(bg10);

				var bg5:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('ITB/Layer 1 (Grass 2)', 'shared'));
				bg5.antialiasing = true;
				bg5.active = false;
				add(bg5);

				switch (SONG.song.toLowerCase()) {
					case 'yap squad' | 'intertwined':
						mini = new FlxSprite(-571, -68);
						mini.frames = Paths.getSparrowAtlas('ITB/itb_crowd_back', 'shared');
						mini.animation.addByPrefix('idle', 'itb_crowd_back', 24, false);
						mini.animation.play('idle');
						mini.scale.set(0.55, 0.55);
						add(mini);
				}
			default:
			{
				defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				add(stageCurtains);
			}
		}
		var gfVersion:String = 'gf';

		switch (SONG.gfVersion)
		{
			case 'gf-car':
				gfVersion = 'gf-car';
			case 'gf-christmas':
				gfVersion = 'gf-christmas';
			case 'gf-pixel':
				gfVersion = 'gf-pixel';
			case 'gf-bob':
				gfVersion = 'gf-bob';
			case 'gf-ronsip':
				gfVersion = 'gf-ronsip';
			case 'gf-bosip':
				gfVersion = 'gf-bosip';
			case 'gf-night':
				gfVersion = 'gf-night';
			case 'gf-ex':
				gfVersion = 'gf-ex';
			case 'gf-night-ex':
				gfVersion = 'gf-night-ex';
			case 'gf-but-bosip':
				gfVersion = 'gf-but-bosip';
				gfSpeed = 2;
				trace('shithdhfdof');
			default:
				gfVersion = 'gf';
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);
		switch (SONG.song.toLowerCase()) {
			case 'ronald mcdonald slide':
				waaaa = new FlxSprite().loadGraphic(Paths.image('sunset/happy/waaaaa', 'shared'));
				add(waaaa);
				waaaa.cameras = [camHUD];
				waaaa.visible = false;

				unregisteredHypercam = new FlxSprite().loadGraphic(Paths.image('sunset/happy/unregistered-hypercam-2-png-Transparent-Images-Free', 'shared'));
				add(unregisteredHypercam);
				unregisteredHypercam.cameras = [camHUD];
				unregisteredHypercam.visible = false;

				
				SAD = new FlxTypedGroup<FlxSprite>();
				SAD.cameras = [camHUD];
				add(SAD);
				for (i in 0...4) {
					var suffix:String = '';
					switch (i) {
						case 0:
							suffix = 'AMOR';
						case 1:
							suffix = 'BF';
						case 2:
							suffix = 'BOB';
						case 3:
							suffix = 'BOSIP';
					}
					var spr = new FlxSprite().loadGraphic(Paths.image('sad/original size/SAD ' + suffix, 'shared'));
					spr.cameras = [camHUD];
					spr.screenCenter();
					spr.alpha = 0;
					SAD.add(spr);
				}
				var angyRonsip:FlxSprite = new FlxSprite(-1200, -100);
				angyRonsip.frames = Paths.getSparrowAtlas('sunset/happy/RON_dies_lmaoripbozo_packwatch', 'shared');
				

				
			case 'jump-out':
				dad = new Character(100, 100, 'verb');
				boyfriend = new Boyfriend(100, 100, 'bf-anders');
				SAD = new FlxTypedGroup<FlxSprite>();
				SAD.cameras = [camHUD];
				add(SAD);
				for (i in 0...4) {
					var suffix:String = '';
					switch (i) {
						case 0:
							suffix = 'AMOR';
						case 1:
							suffix = 'BF';
						case 2:
							suffix = 'BOB';
						case 3:
							suffix = 'BOSIP';
					}
					var spr = new FlxSprite().loadGraphic(Paths.image('sad/original size/SAD ' + suffix, 'shared'));
					spr.cameras = [camHUD];
					spr.screenCenter();
					spr.alpha = 0;
					SAD.add(spr);
				}
				
				grpSlaughtStage = new FlxTypedGroup<FlxSprite>();
				add(grpSlaughtStage);

				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('onslaught/scary_sky'));
				bg.updateHitbox();
				bg.active = false;
				bg.antialiasing = true;
				bg.scrollFactor.set(0.1, 0.7);
				grpSlaughtStage.add(bg);
				
				var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(Paths.image('onslaught/GlitchedGround'));
				ground.updateHitbox();
				ground.active = false;
				ground.antialiasing = true;
				grpSlaughtStage.add(ground);
				bg.y += FlxG.height * 2;
				ground.y += FlxG.height * 2;
		}
		dad = new Character(100, 100, SONG.player2);
		
		
		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);
		switch (SONG.gfVersion)
		{
			case 'gf-bosip':
				gf.y -= 40;
				gf.x -= 30;
			case 'gf-night-ex':
				gf.x -= 30;
				gf.y -= 40;
			case 'gf-ronsip':
				gf.x -= 820;
				gf.y -= 700;
			case 'gf-but-bosip':
				gf.x += 350;
				gf.y -= 30;
			case 'none':
				gf.visible = false;
		}
		
		switch (SONG.player2)
		{
			case 'gf' | 'gf-ex':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				/*gf.x += 200;
				gf.y -= 50;*/
				if (isStoryMode)
				{
					camPos.x += 600;
					//tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'verb':
				dad.y += 330;
			case 'abungus':
				dad.y += 20;
			case 'bob-cool' | 'gloopy':
				camPos.x += 600;
				dad.y += 280;
			case 'jghost':
				dad.x -= 40;
				dad.y -= 20;
			case 'bluskys':
				dad.y += 100;
			case 'minishoey':
				dad.y += 50;
			case 'ash':
				dad.y += 20;
			case 'cerberus':
				dad.y += 230;
				dad.x += 50;
			case 'cerbera':
				dad.y += 420;
				dad.x += 50;
			case 'pc':
				dad.y += 350;
			case 'bob':
				dad.y += 50;
			case 'bobex':
				dad.y += 80;
			case 'cj':
				dad.y += 20;
			case 'bosip':
				dad.y -= 50;
			case 'bosipex':
				dad.y += 0;
			case 'bobal':
				dad.y += 160;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'ronsip':
				dad.y += 100;
		}


		
		boyfriend = new Boyfriend(770, 450, SONG.player1);
		dadTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
		//add(dadTrail);
		dadTrail.visible = false;
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				if(FlxG.save.data.distractions){
					resetFastCar();
					add(fastCar);
				}

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				if(FlxG.save.data.distractions){
				// trailArea.scrollFactor.set();
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);
				}


				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'day' | 'sunset' | 'sunshit' | 'die':
				dad.x -= 150;
				dad.y -= 11;
				boyfriend.x += 191;
				boyfriend.y -= 20;
				if (SONG.player1 == 'bf-bob') {
					boyfriend.x -= 60;
					boyfriend.y -= 70;
				}
				gf.x -= 70;
				gf.y -= 50;
				camPos.x = 536.63;
				camPos.y = 449.94;
				trace(dad.x);
				trace(dad.y);
			case 'night':
				dad.x -= 370;
				dad.y + 39	;
				boyfriend.x += 191;
				boyfriend.y -= 20;
				gf.x += 300;
				gf.y -= 50;
			case 'ITB':
				dad.x -= 380;
				dad.y -= 10;
				gf.x -= 239;
				gf.y -= 70;
				gf.scrollFactor.set(1, 1);
				camPos.x = 272.46;
				camPos.y = 420.96;
				//gfOffset.set(-239, -130);
		}
		switch (SONG.player1) {
			case 'bf-worriedbob':
				boyfriend.y = 130;
			case 'bf-anders':
				boyfriend.y -= 330;
				boyfriend.x -= 150;
		}
		add(gf);
		switch (curStage) {
			case 'ITB':
				var bg8:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('ITB/Layer 1 (Lamp)', 'shared'));
				bg8.antialiasing = true;
				//bg8.scale.set(0.6, 0.6);
				//bg8.scrollFactor.set(0.8, 0.8);
				bg8.active = false;
				add(bg8);

				var bg6:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('ITB/Layer 1 (Grass)', 'shared'));
				bg6.antialiasing = true;
				//bg6.scrollFactor.set(0.9, 0.9);
				//bg6.scale.set(0.6, 0.6);
				bg6.active = false;
				add(bg6);

				var bg7:FlxSprite = new FlxSprite(-701, -300).loadGraphic(Paths.image('ITB/Layer 1 (Ground)', 'shared'));
				bg7.antialiasing = true;
				//bg7.scale.set(0.6, 0.6);
				bg7.active = false;
				add(bg7);

				switch (SONG.song.toLowerCase()) {
					case 'conscience' | 'yap squad' | 'intertwined':
						mordecai = new FlxSprite(-1531, -230);
						mordecai.frames = Paths.getSparrowAtlas('ITB/itb_crowd_middle', 'shared');
						mordecai.animation.addByPrefix('idle', 'itb_crowd_middle', 24, false);
						mordecai.animation.play('idle');
						mordecai.scale.set(0.6, 0.6);
						add(mordecai);
				}
		}
		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		switch (SONG.song.toLowerCase()) {
			case 'yap squad':
				dad2 = new Character(-200, 330, 'cerberus');
				add(dad2);
				hasDad2 = true;
				usesDad2Chart = true;
		}
		add(dad);
		switch (SONG.song.toLowerCase()) {
			case 'intertwined':
				dad2 = new Character(0, 520, 'cerbera');
				add(dad2);
				hasDad2 = true;
		}
		add(boyfriend);

		switch (SONG.song.toLowerCase()) {
			case 'intertwined':
				thirdBop = new FlxSprite(-1560, 542);
				thirdBop.scale.set(0.6, 0.6);
				thirdBop.scrollFactor.set(1.3, 1.3);
				thirdBop.frames = Paths.getSparrowAtlas('ITB/itb_crowd_front', 'shared');
				thirdBop.animation.addByPrefix('idle', 'itb_crowd_front', 24, false);
				thirdBop.animation.play('idle');
				add(thirdBop);
		}
		if (curStage == 'day') {
			phillyTrain = new FlxSprite(200, 200).loadGraphic(Paths.image('day/PP_truck','shared'));
			phillyTrain.scale.set(1.2, 1.2);
			phillyTrain.visible = false;
			add(phillyTrain);
		}
		if (curStage == 'sunset') {
			phillyTrain = new FlxSprite(200, 200).loadGraphic(Paths.image('sunset/CJ_car','shared'));
			phillyTrain.scale.set(1.2, 1.2);
			phillyTrain.visible = false;
			add(phillyTrain);
		}
		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			
			FlxG.save.data.botplay = true;
			FlxG.save.data.scrollSpeed = rep.replay.noteSpeed;
			FlxG.save.data.downscroll = rep.replay.isDownscroll;
			// FlxG.watch.addQuick('Queued',inputsQueued);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();
		cerbStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		trace('generated');

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.fromString('#FFEF2D'));
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));
		// healthBar
		add(healthBar);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " " + (storyDifficulty == 3 ? "EX" : storyDifficulty == 2 ? "Hard" : storyDifficulty == 1 ? "Normal" : "Easy") + (Main.watermarks ? " - KE " + MainMenuState.kadeEngineVer : ""), 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		if (offsetTesting)
			scoreTxt.x += 300;
		if(FlxG.save.data.botplay) scoreTxt.x = FlxG.width / 2 - 20;													  
		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		
		if(FlxG.save.data.botplay && !loadRep) add(botPlayState);

		grpIcons = new FlxTypedGroup<HealthIcon>();
		add(grpIcons);

		iconP1Prefix = SONG.player1;
		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		grpIcons.add(iconP1);
	
		iconP2Prefix = SONG.player2;
		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		grpIcons.add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		grpIcons.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		
		trace('starting');

		if (isStoryMode)
		{
			switch (StringTools.replace(curSong," ", "-").toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'jump-in':
					if (playCutscene) {
						FlxTransitionableState.skipNextTransIn = false;
						FlxTransitionableState.skipNextTransOut = false;
						LoadingState.loadAndSwitchState(new VideoState("assets/videos/Cutscene1Subtitles.webm", new PlayState()));
						FlxG.log.add('FUCKKKKK');
						playCutscene = false;
					} else {
						camHUD.visible = true;
						camGame.visible = true;
						startCountdown();
					}
				case 'groovy-brass':
					if (playCutscene) {
						FlxTransitionableState.skipNextTransIn = false;
						FlxTransitionableState.skipNextTransOut = false;
						LoadingState.loadAndSwitchState(new VideoState("assets/videos/ITB/Subtitles ITB-1.webm", new PlayState()));
						playCutscene = false;
					} else {
						camHUD.visible = true;
						camGame.visible = true;
						startCountdown();
					}
				case 'copy-cat':
					if (playCutscene) {
						FlxTransitionableState.skipNextTransIn = false;
						FlxTransitionableState.skipNextTransOut = false;
						LoadingState.loadAndSwitchState(new VideoState("assets/videos/bob takeover/Subtitles-Onslaught-1.webm", new PlayState()));
						playCutscene = false;
					} else {
						camHUD.visible = true;
						camGame.visible = true;
						startCountdown();
					}
				case 'jump-out':
					schoolIntro(doof);
				case 'ronald-mcdonald-slide':
					schoolIntro(doof);
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		if (curStage == 'night') {
			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			coolGlowyLights = new FlxTypedGroup<FlxSprite>();
			add(coolGlowyLights);
			coolGlowyLightsMirror = new FlxTypedGroup<FlxSprite>();
			add(coolGlowyLightsMirror);
			for (i in 0...4)
			{
				var light:FlxSprite = new FlxSprite().loadGraphic(Paths.image('night/light' + i, 'shared'));
				light.scrollFactor.set(0, 0);
				light.cameras = [camHUD];
				light.visible = false;
				light.updateHitbox();
				light.antialiasing = true;
				phillyCityLights.add(light);

				var glow:FlxSprite = new FlxSprite().loadGraphic(Paths.image('night/Glow' + i, 'shared'));
				glow.scrollFactor.set(0, 0);
				glow.cameras = [camHUD];
				glow.visible = false;
				glow.updateHitbox();
				glow.antialiasing = true;
				coolGlowyLights.add(glow);

				var glow2:FlxSprite = new FlxSprite().loadGraphic(Paths.image('night/Glow' + i, 'shared'));
				glow2.scrollFactor.set(0, 0);
				glow2.cameras = [camHUD];
				glow2.visible = false;
				glow2.updateHitbox();
				glow2.antialiasing = true;
				coolGlowyLightsMirror.add(glow2);
			}
		}
		super.create();
		areYouReady = new FlxTypedGroup<FlxSprite>();
		add(areYouReady);
		for (i in 0...3) {
			var shit:FlxSprite = new FlxSprite();
			switch (i) {
				case 0:
					shit = new FlxSprite().loadGraphic(Paths.image('ARE', 'shared'));
				case 1:
					shit = new FlxSprite().loadGraphic(Paths.image('YOU', 'shared'));
				case 2:
					shit = new FlxSprite().loadGraphic(Paths.image('READY', 'shared'));
			}
			shit.cameras = [camHUD];
			shit.visible = false;
			areYouReady.add(shit);
		} 

		trace(dad.x);
		trace(dad.y);
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();



		// pre lowercasing the song name (schoolIntro)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		if (songLowercase == 'roses' || songLowercase == 'thorns')
		{
			remove(black);

			if (songLowercase == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;
					add(dialogueBox);
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);
		if (SONG.song.toLowerCase() == 'intertwined')
			generateStaticArrows(2);

		#if windows
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[PlayState.SONG.song]);
		}
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			if (hasDad2)
				dad2.dance();
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					switch (SONG.player2) {
						case 'bob' | 'bobex':
							FlxG.sound.play(Paths.sound('bob/3', 'shared'), 0.6);
						case 'bosip' | 'bosipex':
							FlxG.sound.play(Paths.sound('bosip/3', 'shared'), 0.6);
						case 'amor' | 'amorex':
							FlxG.sound.play(Paths.sound('amor/3', 'shared'), 0.6);
						case 'jghost':
							FlxG.sound.play(Paths.sound('jghost/3', 'shared'), 0.6);
						case 'minishoey':
							FlxG.sound.play(Paths.sound('mini/3', 'shared'), 0.6);
						case 'ash':
							FlxG.sound.play(Paths.sound('ash/3', 'shared'), 0.6);
						case 'bluskys':
							FlxG.sound.play(Paths.sound('bluskys/3', 'shared'), 0.6);
						case 'gloopy' | 'bob-cool':
							FlxG.sound.play(Paths.sound('gloopy/3', 'shared'), 0.6);
						case 'ronsip':
							FlxG.sound.play(Paths.sound('ron/3', 'shared'), 0.6);
						default:
							FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
					}
					var three:FlxSprite = new FlxSprite().loadGraphic(Paths.image('3', 'shared'));
					three.scrollFactor.set();
					three.screenCenter();
					add(three);
					FlxTween.tween(three, {y: three.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							three.destroy();
						}
					});
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image('2', 'shared'));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					switch (SONG.player2) {
						case 'bob' | 'bobex':
							FlxG.sound.play(Paths.sound('bob/2', 'shared'), 0.6);
						case 'bosip' | 'bosipex':
							FlxG.sound.play(Paths.sound('bosip/2', 'shared'), 0.6);
						case 'amor' | 'amorex':
							FlxG.sound.play(Paths.sound('amor/2', 'shared'), 0.6);
						case 'jghost':
							FlxG.sound.play(Paths.sound('jghost/2', 'shared'), 0.6);
						case 'minishoey':
							FlxG.sound.play(Paths.sound('mini/2', 'shared'), 0.6);
						case 'ash':
							FlxG.sound.play(Paths.sound('ash/2', 'shared'), 0.6);
						case 'bluskys':
							FlxG.sound.play(Paths.sound('bluskys/2', 'shared'), 0.6);
						case 'gloopy' | 'bob-cool':
							FlxG.sound.play(Paths.sound('gloopy/2', 'shared'), 0.6);
						case 'ronsip':
							FlxG.sound.play(Paths.sound('ron/2', 'shared'), 0.6);
						default:
							FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
					}
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image('1', 'shared'));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					switch (SONG.player2) {
						case 'bob' | 'bobex':
							FlxG.sound.play(Paths.sound('bob/1', 'shared'), 0.6);
						case 'bosip' | 'bosipex':
							FlxG.sound.play(Paths.sound('bosip/1', 'shared'), 0.6);
						case 'amor' | 'amorex':
							FlxG.sound.play(Paths.sound('amor/1', 'shared'), 0.6);
						case 'jghost':
							FlxG.sound.play(Paths.sound('jghost/1', 'shared'), 0.6);
						case 'minishoey':
							FlxG.sound.play(Paths.sound('mini/1', 'shared'), 0.6);
						case 'ash':
							FlxG.sound.play(Paths.sound('ash/1', 'shared'), 0.6);
						case 'bluskys':
							FlxG.sound.play(Paths.sound('bluskys/1', 'shared'), 0.6);
						case 'gloopy' | 'bob-cool':
							FlxG.sound.play(Paths.sound('gloopy/1', 'shared'), 0.6);
						case 'ronsip':
							FlxG.sound.play(Paths.sound('ron/1', 'shared'), 0.6);
						default:
							FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
					}
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image('go', 'shared'));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					switch (SONG.player2) {
						case 'bob' | 'bobex':
							FlxG.sound.play(Paths.sound('bob/Go', 'shared'), 0.6);
						case 'bosip' | 'bosipex':
							FlxG.sound.play(Paths.sound('bosip/Go', 'shared'), 0.6);
						case 'amor' | 'amorex':
							FlxG.sound.play(Paths.sound('amor/Go', 'shared'), 0.6);
						case 'jghost':
							FlxG.sound.play(Paths.sound('jghost/Go', 'shared'), 0.6);
						case 'minishoey':
							FlxG.sound.play(Paths.sound('mini/Go', 'shared'), 0.6);
						case 'ash':
							FlxG.sound.play(Paths.sound('ash/Go', 'shared'), 0.6);
						case 'bluskys':
							FlxG.sound.play(Paths.sound('bluskys/Go', 'shared'), 0.6);
						case 'gloopy' | 'bob-cool':
							FlxG.sound.play(Paths.sound('gloopy/Go', 'shared'), 0.6);
						case 'ronsip':
							FlxG.sound.play(Paths.sound('ron/Go', 'shared'), 0.6);
						default:
							FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
					}
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;


	var songStarted = false;

	function startSong():Void
	{
		if (useVideo)
			BackgroundVideo.get().resume();
		//healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			if (storyDifficulty == 3)
				FlxG.sound.playMusic(Paths.instEX(PlayState.SONG.song), 1, false);
			else
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		if (SONG.song.toLowerCase() == 'ronald mcdonald slide' && isStoryMode)
			FlxG.sound.music.onComplete = nooooron;
		else
			FlxG.sound.music.onComplete = endSong;
		vocals.play();
		secondaryVocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);


			if (SONG.song.toLowerCase() == 'tutorial' && storyDifficulty == 3) {
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, (songLength * 0.44) - 1000);
			} else {
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, songLength - 1000);
			}
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.fromString('#FFEF2D'));
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly Nice' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			if (storyDifficulty == 3) {
				vocals = new FlxSound().loadEmbedded(Paths.voicesEX(PlayState.SONG.song));
				if (SONG.player2 == 'bob' && SONG.song.toLowerCase() == 'swing' || SONG.player2 == 'bobex' && SONG.song.toLowerCase() == 'swing') {
					secondaryVocals = new FlxSound().loadEmbedded(Paths.voicesEXcharacter(PlayState.SONG.song, 'bob'));
					vocals = new FlxSound().loadEmbedded(Paths.voicesEXcharacter(PlayState.SONG.song, 'bf'));
				} else
					secondaryVocals = new FlxSound();
			} else {
				vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				secondaryVocals = new FlxSound();
			}
		else {
			vocals = new FlxSound();
			secondaryVocals = new FlxSound();
		}
		secondaryVocals.volume = 1;
		trace('loaded vocals');

		FlxG.sound.list.add(vocals);
		FlxG.sound.list.add(secondaryVocals);
		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// pre lowercasing the song name (generateSong)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		// Per song offset check
		#if windows
			var songPath = 'assets/data/' + songLowercase + '/';
			
			/*for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}*/
		#end
		if (hasDad2 && usesDad2Chart) {
			var dad2NoteData = dad2SONG.notes;
			dad2Notes = new FlxTypedGroup<Note>();
			for (section in dad2NoteData)
			{
				var coolSection:Int = Std.int(section.lengthInSteps / 4);
				for (songNotes in section.sectionNotes)
				{
					var daStrumTime:Float = songNotes[0];
					if (daStrumTime < 0)
						daStrumTime = 0;
					var daNoteData:Int = Std.int(songNotes[1]);
					var gottaHitNote:Bool = section.mustHitSection;
					var daType = songNotes[3];
					if (songNotes[1] > 3)
					{
						gottaHitNote = !section.mustHitSection;
					}

					var oldNote:Note;
					if (dad2Notes.members.length > 0)
						oldNote = dad2Notes.members[Std.int(dad2Notes.members.length - 1)];
					else
						oldNote = null;

					var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daType);
					swagNote.sustainLength = songNotes[2];
					dad2Notes.add(swagNote);
				}
			}
		}
		
		if (storyDifficulty == 3) {
			//var abelSongData = abelSONG;
			var effectNoteData = effectSONG.notes;
			effectNotes = new FlxTypedGroup<Note>();
			for (section in effectNoteData)
			{
				var coolSection:Int = Std.int(section.lengthInSteps / 4);
				for (songNotes in section.sectionNotes)
				{
					var daStrumTime:Float = songNotes[0];
					if (daStrumTime < 0)
						daStrumTime = 0;
					var daNoteData:Int = Std.int(songNotes[1]);
					var gottaHitNote:Bool = section.mustHitSection;
					var daType = songNotes[3];
					if (songNotes[1] > 3)
					{
						gottaHitNote = !section.mustHitSection;
					}

					var oldNote:Note;
					if (effectNotes.members.length > 0)
						oldNote = effectNotes.members[Std.int(effectNotes.members.length - 1)];
					else
						oldNote = null;

					var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daType);
					swagNote.sustainLength = songNotes[2];
					effectNotes.add(swagNote);
				}
			}
		}
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;
				var daType = songNotes[3];
				var swagNote:Note;
				if (gottaHitNote) {
					swagNote = new Note(daStrumTime, daNoteData, oldNote, false, daType, boyfriend.noteSkin);
				} else {
					swagNote = new Note(daStrumTime, daNoteData, oldNote, false, daType, dad.noteSkin);
				}
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					var sustainNote:Note;
					if (gottaHitNote) {
						sustainNote = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType, boyfriend.noteSkin);
					} else {
						sustainNote = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType, dad.noteSkin);
					}
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					switch (sustainNote.noteType) {
						case 'drop' | 'are' | 'you' | 'ready' | 'kill' | '4' | '5' | '6' | '7':
							sustainNote.mustPress = false;
						default:
							sustainNote.mustPress = gottaHitNote;
					}

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}
				switch (swagNote.noteType) {
					case 'drop' | 'are' | 'you' | 'ready' | 'kill' | '4' | '5' | '6' | '7':
						swagNote.mustPress = false;
					default:
						swagNote.mustPress = gottaHitNote;
				}

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (SONG.noteStyle)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				
				case 'normal':
					if (player == 0)
						babyArrow.frames = Paths.getSparrowAtlas('notes/' + dad.noteSkin, 'shared');
					else if (player == 2) 
						babyArrow.frames = Paths.getSparrowAtlas('notes/cerbera', 'shared');
					else 
						babyArrow.frames = Paths.getSparrowAtlas('notes/' + boyfriend.noteSkin, 'shared');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}

				default:
					if (player == 0)
						babyArrow.frames = Paths.getSparrowAtlas('notes/' + dad.noteSkin, 'shared');
					else if (player == 2) 
						babyArrow.frames = Paths.getSparrowAtlas('notes/cerbera', 'shared');
					else 
						babyArrow.frames = Paths.getSparrowAtlas('notes/' + boyfriend.noteSkin, 'shared');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
				case 2:
					cerbStrums.add(babyArrow);
					babyArrow.visible = false;
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			if (player == 2)
				babyArrow.x += ((FlxG.width / 2) * 0);
			else
				babyArrow.x += ((FlxG.width / 2) * player);
			
			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			cerbStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
				secondaryVocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		if (resyncingVocals) {
			vocals.pause();
			secondaryVocals.pause();

			FlxG.sound.music.play();
			Conductor.songPosition = FlxG.sound.music.time;
			vocals.time = Conductor.songPosition;
			vocals.play();
			secondaryVocals.time = Conductor.songPosition;
			secondaryVocals.play();

			#if windows
			DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
		}
		else {
			if (FlxG.save.data.songPosition)
			{

			}
			Conductor.songPosition = 0;
			FlxG.sound.music.time = 0;
		}
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end
		switch (curStage) {
			case 'ITB':
				for (i in 0...phillyCityLights.members.length) {
					if (lightsTimer[i] == 0) {
						lightsTimer[i] = -1;
						FlxTween.tween(phillyCityLights.members[i], {alpha: 1}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadOut, 
							onComplete: function(tween:FlxTween)
							{
								FlxTween.tween(phillyCityLights.members[i], {alpha: 0}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadIn, 
									onComplete: function(tween:FlxTween)
									{
										var daRando = new FlxRandom();
										lightsTimer[i] = daRando.int(1000, 1500);
									}, 
								});
							}, 
						});
					} else
						lightsTimer[i]--;
				}
		}
		if (FlxG.save.data.botplay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;

		if (useVideo && BackgroundVideo.get() != null && !stopUpdate)
		{
			if (BackgroundVideo.get().ended && !removedVideo)
			{
				remove(videoSprite);
				FlxG.stage.window.onFocusOut.remove(focusOut);
				FlxG.stage.window.onFocusIn.remove(focusIn);
				removedVideo = true;
				useVideo = false;
			}
		}
		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.text = "Score: " + songScore;

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			
			if (useVideo)
				{
					BackgroundVideo.get().stop();
					remove(videoSprite);
					#if sys
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					#end
					removedVideo = true;
				}
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			ChartingState.effectsMode = false;
			FlxG.switchState(new ChartingState());
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP1.width, 150, 0.09)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP2.width, 150, 0.09)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;
			
		if (iconP1Prefix == 'verb' || iconP1Prefix == 'abungus') {
			iconP1.animation.play(iconP1Prefix, false, false);
		} else {
			if (healthBar.percent > 80 && healthBar.percent > 30)
				iconP1.animation.play(iconP1Prefix, true, false, 2);
			else if (healthBar.percent < 80 && healthBar.percent < 30)
				iconP1.animation.play(iconP1Prefix, true, false, 1);
			else if (healthBar.percent < 80 && healthBar.percent > 30) {
				iconP1.animation.play(iconP1Prefix, true, false, 0);
			}
		}

		if (SONG.song.toLowerCase() != 'yap squad'|| SONG.song.toLowerCase() == 'yap squad' && iconP2.animation.curAnim.name != 'cerberus') {
			if (iconP2Prefix == 'verb' || iconP2Prefix == 'abungus') {
				iconP2.animation.play(iconP2Prefix, false, false);
			} else {
				if (healthBar.percent > 80 && healthBar.percent > 30)
					iconP2.animation.play(iconP2Prefix, true, false, 1);
				else if (healthBar.percent < 80 && healthBar.percent < 30)
					iconP2.animation.play(iconP2Prefix, true, false, 2);
				else if (healthBar.percent < 80 && healthBar.percent > 30) {
					iconP2.animation.play(iconP2Prefix, true, false, 0);
				}
			}
		}

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
		{
			if (useVideo)
			{
				BackgroundVideo.get().stop();
				remove(videoSprite);
				FlxG.stage.window.onFocusOut.remove(focusOut);
				FlxG.stage.window.onFocusIn.remove(focusIn);
				removedVideo = true;
			}

			FlxG.switchState(new AnimationDebug(SONG.player2));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		#end

		
		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			if (resyncingVocals)
				songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}
		if (generatedMusic && startedCountdown) {
			for (i in 0...cpuNoteTimer.length) {
				if (cpuNoteTimer[i] > 0) {
					cpuNoteTimer[i]--;
				} else if (cpuNoteTimer[i] == 0) {
					cpuStrums.members[i].animation.play('static', true);
					cpuStrums.members[i].centerOffsets();
					if (SONG.song.toLowerCase() == 'intertwined') {
						cerbStrums.members[i].animation.play('static', true);
						cerbStrums.members[i].centerOffsets();
					}
					cpuNoteTimer[i]--;
				}	
			}
			
		}
		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly Nice':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && useCamChange)
			{
				if (curStage == 'night') {
					for (i in coolGlowyLights) {
						i.flipX = false;
					}
					for (i in coolGlowyLightsMirror) {
						i.flipX = true;
					}	
				}
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				switch (curStage) {
					case 'day' | 'sunset' | 'night' | 'ITB' | 'die' | 'sunshit':
						//nothing :D
					default:
						camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
				}

				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerTwoTurn', []);
				#end
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}
				switch (curStage)
				{
					case 'die' | 'sunshit':
						camFollow.x = FlxMath.lerp(536.63, camFollow.x, 0.1);
						camFollow.y = FlxMath.lerp(449.94, camFollow.y, 0.1);
					case 'day':
						/*camFollow.x = 56.63 + dadCamOffset.x;
						camFollow.y = 449.94 + dadCamOffset.y;*/
						camFollow.x = FlxMath.lerp(536.63, camFollow.x, 0.1);
						camFollow.y = FlxMath.lerp(449.94, camFollow.y, 0.1);
					case 'sunset':
						if (storyDifficulty == 3) {
							camFollow.x = FlxMath.lerp(536.63, camFollow.x, 0.1);
							camFollow.y = FlxMath.lerp(350.94, camFollow.y, 0.1);
						} else {
							camFollow.x = FlxMath.lerp(536.63, camFollow.x, 0.1);
							camFollow.y = FlxMath.lerp(300.94, camFollow.y, 0.1);
						}
					case 'night':
						if (splitCamMode) {
							camFollow.x = 600.92;
							camFollow.y = 447.52;
						} else {
							camFollow.x = FlxMath.lerp(295.92, camFollow.x, 0.1);
							camFollow.y = FlxMath.lerp(447.52, camFollow.y, 0.1);
						}
					case 'ITB':
						camFollow.x = FlxMath.lerp(272.46, camFollow.x, 0.1);
						camFollow.y = FlxMath.lerp(420.96, camFollow.y, 0.1);
				}
				if (dad.curCharacter == 'mom')
					vocals.volume = 1;
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && useCamChange)
			{
				if (curStage == 'night') {
					for (i in coolGlowyLights) {
						i.flipX = true;
					}
					for (i in coolGlowyLightsMirror) {
						i.flipX = false;
					}
				}
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				switch (curStage) {
					case 'day' | 'sunset' | 'night' | 'ITB' | 'sunshit' | 'die':
						//nothing :D
					default:
						camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);
				}
				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);
				#end

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'day':
						camFollow.x = FlxMath.lerp(788.96, camFollow.x, 0.1);
						if (SONG.player1 == 'bf-worriedbob')
							camFollow.y = FlxMath.lerp(430.95, camFollow.y, 0.1);
						else
							camFollow.y = FlxMath.lerp(475.95, camFollow.y, 0.1);
					case 'die' | 'sunshit':
						camFollow.x = FlxMath.lerp(788.96, camFollow.x, 0.1);
						camFollow.y = FlxMath.lerp(475.95, camFollow.y, 0.1);
					case 'sunset':
						camFollow.x = FlxMath.lerp(788.96, camFollow.x, 0.1);
						camFollow.y = FlxMath.lerp(475.95, camFollow.y, 0.1);
					case 'night':
						if (splitCamMode) {
							camFollow.x = 600.92;
							camFollow.y = 447.52;
						} else {
							camFollow.x = FlxMath.lerp(790.36, camFollow.x, 0.1);
							camFollow.y = FlxMath.lerp(480.91, camFollow.y, 0.1);
						}
					case 'ITB':
						camFollow.x = FlxMath.lerp(626.31, camFollow.x, 0.1);
						camFollow.y = FlxMath.lerp(420.96, camFollow.y, 0.1);
				}
			}
		}
		if (storyDifficulty == 3 && SONG.song.toLowerCase() == 'split')
			camZooming = true;
		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			secondaryVocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
 		if (FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					secondaryVocals.stop();
					FlxG.sound.music.stop();
		
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
					#end
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);
				
				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				if (SAD != null) {
					for (i in SAD) {
						i.alpha = FlxMath.lerp(i.alpha, 0, 0.02);
						if (i.alpha < 0.1)
							i.alpha = 0;
					}
				}
				if (coolerText) {
					for (spr in areYouReady) {
						spr.color = FlxColor.fromHSL(spr.color.hue + 2, spr.color.saturation, 1, 1);
						if (spr.color.hue > 358)
							spr.color = FlxColor.fromHSL(0, spr.color.saturation, 1, 1);
					}
				}
				if (healthDraining && SONG.song.toLowerCase() == 'yap squad') {
					//healthBarColor1 = FlxColor.interpolate(healthBarColor1, FlxColor.fromString('#' + dad2.iconColor), 0.2);
					//healthBarColor1 = FlxColor.fromString('#' + dad2.iconColor);
					
					health = FlxMath.lerp(health, healthDrainTarget, 0.2);
				}
				if (healthDrainTimer == 0) {
					healthDrainTimer = -1;
					iconP2.animation.play('jghost', true, false, 0);
					//healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));
					/*remove(iconP2);
					iconP2 = new HealthIcon(SONG.player2, false);
					iconP2.y = healthBar.y - (iconP2.height / 2);
					iconP2.cameras = [camHUD];
					add(iconP2);*/
					healthDraining = false;
					healthBar.createFilledBar(FlxColor.fromString('#' + dad.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));
				} else {
					//healthBarColor1 = FlxColor.interpolate(healthBarColor1, FlxColor.fromString('#' + dad.iconColor), 0.2);
					//healthBarColor1 = FlxColor.fromString('#' + dad.iconColor);
					
					healthDrainTimer--;
				}
				if (dad.animation.curAnim.name == 'idle' && curStage == 'night') {
					pc.animation.play('idle');
				}
				if (hasDad2 && usesDad2Chart) {
					dad2Notes.forEach(function(daNote:Note) {
						if (daNote.strumTime - Conductor.songPosition < (Conductor.stepCrochet / 2)) {
							switch (SONG.song.toLowerCase()) {
								case 'yap squad':
									healthDrainTimer = 100;
									healthDraining = true;
									healthBar.createFilledBar(FlxColor.fromString('#' + dad2.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));
									switch (daNote.noteData % 4) {
										default:
											healthDrainTarget = health - 0.4;
											FlxG.camera.shake(0.02, 0.1);
										case 2:
											healthDrainTarget = health - 1;
											FlxG.camera.shake(0.04, 0.2);
									}
									switch (daNote.noteData % 4) {
										case 2:
											iconP2.animation.play('cerberus', true, false, 4);
											boyfriend.playAnim('singUPmiss', true);
										case 3:
											iconP2.animation.play('cerberus', true, false, 3);
											boyfriend.playAnim('singRIGHTmiss', true);
										case 1:
											iconP2.animation.play('cerberus', true, false, 2);
											boyfriend.playAnim('singDOWNmiss', true);
										case 0:
											iconP2.animation.play('cerberus', true, false, 1);
											boyfriend.playAnim('singLEFTmiss', true);
									}
							}
							switch (daNote.noteData % 4) {
								case 2:
									dad2.playAnim('singUP', true);
								case 3:
									dad2.playAnim('singRIGHT', true);
								case 1:
									dad2.playAnim('singDOWN', true);
								case 0:
									dad2.playAnim('singLEFT', true);	
							}
							dad2Notes.remove(daNote, true);
						}
					});
				}
				/*(switch (SONG.song.toLowerCase()) {
					case 'split':*/
						if (storyDifficulty == 3) {
							effectNotes.forEach(function(daNote:Note) {
								if (daNote.strumTime - Conductor.songPosition < (Conductor.stepCrochet / 2)) {
									switch (daNote.noteData) {
										case 0:
											switch (SONG.song.toLowerCase()) {
												case 'jump-in' | 'swing':
													var daTrain;
													if (SONG.song.toLowerCase() == 'swing')
														daTrain = new FlxSprite(200, 200).loadGraphic(Paths.image('sunset/CJ_car','shared'));
													else
														daTrain = new FlxSprite(200, 200).loadGraphic(Paths.image('day/PP_truck','shared'));
													daTrain.scale.set(1.2, 1.2);
													daTrain.visible = false;
													add(daTrain);
													FlxG.sound.play(Paths.sound('carPass1', 'shared'), 0.7);
													new FlxTimer().start(1.3, function(tmr:FlxTimer)
													{
														daTrain.x = 2000;
														daTrain.flipX = false;
														daTrain.visible = true;
														FlxTween.tween(daTrain, {x: -2000}, 0.18, {
															onComplete: function(twn:FlxTween) {
																remove(daTrain);
															}
														});
													});
												case 'split':
													switch (daNote.noteType) {
														case 'drop':
															FlxG.camera.zoom += 0.030;
															camHUD.zoom += 0.04;
														default:
															if (FlxG.save.data.flashing) {
																areYouReady.members[0].visible = true;
																phillyCityLights.forEach(function(light:FlxSprite)
																{
																	light.visible = false;
																});
																phillyCityLights.members[0].visible = true;
																phillyCityLights.members[0].alpha = 1;
																FlxTween.tween(phillyCityLights.members[0], {alpha: 0}, 0.2, {
																});
															}
													}

													

													
												case 'tutorial':
													songSpeedMultiplier += 0.4;
											}
											/*FlxG.camera.zoom += 0.015;
											camHUD.zoom += 0.03;*/
										case 1:
											switch (SONG.song.toLowerCase()) {
												case 'jump-in':
													var daTrain;
													if (SONG.song.toLowerCase() == 'swing')
														daTrain = new FlxSprite(200, 200).loadGraphic(Paths.image('sunset/CJ_car','shared'));
													else
														daTrain = new FlxSprite(200, 200).loadGraphic(Paths.image('day/PP_truck','shared'));
													daTrain.scale.set(1.2, 1.2);
													daTrain.visible = false;
													add(daTrain);
													FlxG.sound.play(Paths.sound('carPass1', 'shared'), 0.7);
													new FlxTimer().start(1.3, function(tmr:FlxTimer)
													{
														daTrain.x = -2000;
														daTrain.flipX = true;
														daTrain.visible = true;
														FlxTween.tween(daTrain, {x: 2000}, 0.18, {
															onComplete: function(twn:FlxTween) {
																remove(daTrain);
															}
														});
													});
												case 'split':
													switch (daNote.noteType) {
														case 'drop':
															splitCamMode = !splitCamMode;
														default:
															if (FlxG.save.data.flashing) {
																areYouReady.members[1].visible = true;
																phillyCityLights.forEach(function(light:FlxSprite)
																{
																	light.visible = false;
																});
																phillyCityLights.members[0].visible = true;
																phillyCityLights.members[0].alpha = 1;
																FlxTween.tween(phillyCityLights.members[0], {alpha: 0}, 0.2, {
																});
															}
													}
												case 'tutorial':
													camZooming = true;
													defaultCamZoom += 0.2;
													dadCamOffset.x = 60;
													dadCamOffset.y = -40;
											}
											
										case 2:
											switch (SONG.song.toLowerCase()) {
												case 'tutorial':
													defaultCamZoom -= 0.2;
													dadCamOffset.x = 0;
													dadCamOffset.y = 0;
												case 'split':
													switch (daNote.noteType) {
														case 'drop':
															splitExtraZoom = !splitExtraZoom;
														default:
															if (FlxG.save.data.flashing) {
																areYouReady.members[2].visible = true;
																phillyCityLights.forEach(function(light:FlxSprite)
																{
																	light.visible = false;
																});
																phillyCityLights.members[0].visible = true;
																phillyCityLights.members[0].alpha = 1;
																FlxTween.tween(phillyCityLights.members[0], {alpha: 0}, 0.2, {});
															}
													}
											}
										case 3:
											switch (SONG.song.toLowerCase()) {
												case 'split':
													switch (daNote.noteType) {
														case 'drop':
															camHUD.flash(FlxColor.WHITE, 0.7);
														default:
															for (i in areYouReady) {
																i.visible = false;
															}
													}
											}
										case 4:
											switch (SONG.song.toLowerCase()) {
												case 'split':
													if (FlxG.save.data.flashing) {
														phillyCityLights.forEach(function(light:FlxSprite)
														{
															light.visible = false;
														});
														phillyCityLights.members[1].visible = true;
														phillyCityLights.members[1].alpha = 1;
														FlxTween.tween(phillyCityLights.members[1], {alpha: 0}, 0.2, {});
													}
												case 'tutorial':
													if (FlxG.save.data.songPosition)
													{
														FlxTween.num(songPosBar.max, songLength - 1000, 1.3, {ease: FlxEase.cubeOut}, function (v:Float) {
															remove(songPosBar);
															songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
															'songPositionBar', 0, v);
															songPosBar.numDivisions = 1000;
															songPosBar.scrollFactor.set();
															songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.fromString('#FFEF2D'));
															songPosBar.cameras = [camHUD];
															add(songPosBar);
														});
													}
													dad.playAnim('spin', true);
											}
										case 5:
											switch (SONG.song.toLowerCase()) {
												case 'split':
													splitMode = !splitMode;
												case 'tutorial':
													dad.playAnim('alright', true);
											}
										case 6:
											switch (SONG.song.toLowerCase()) {
												case 'split':
													splitSoftMode = !splitSoftMode;
											}
										case 7:
											switch (SONG.song.toLowerCase()) {
												case 'split':
													for (spr in areYouReady) {
														spr.color = FlxColor.RED;
													}
													coolerText = !coolerText;
											}
									}
									effectNotes.remove(daNote, true);
								}
							});
						}
				//}
				notes.forEachAlive(function(daNote:Note)
				{

					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
					if (!daNote.modifiedByLua)
						{
							if (FlxG.save.data.downscroll)
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed + songSpeedMultiplier : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed + songSpeedMultiplier: FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									// Remember = minus makes notes go up, plus makes them go down
									if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
										daNote.y += daNote.prevNote.height;
									else
										daNote.y += daNote.height / 2;
	
									// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
	
										daNote.clipRect = swagRect;
									}
								}
							}else
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed + songSpeedMultiplier : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed  + songSpeedMultiplier: FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									daNote.y -= daNote.height / 2;
	
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
	
										daNote.clipRect = swagRect;
									}
								}
							}
						}
		
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}
						switch (daNote.noteType) {
							case 'drop':
								if (SONG.song.toLowerCase() == 'groovy brass')
									useCamChange = false;
									camFollow.x = 272.46;
									camFollow.y = 420.96;
								dad.playAnim('drop', true);
							case 'are':
								switch (SONG.song.toLowerCase()) {
									case 'jump-out':
										remove(dad);
										dad = new Character(-50, 439, 'verb');
										iconP2Prefix = 'verb';
										grpIcons.remove(iconP2);
										iconP2 = new HealthIcon('verb', false);
										iconP2.y = healthBar.y - (iconP2.height / 2);
										iconP2.cameras = [camHUD];
										grpIcons.add(iconP2);
										add(dad);
									case 'ronald mcdonald slide':
										var elShader = new PixelateShader();
										#if (openfl >= "8.0.0")
										elShader.data.uBlocksize.value = [5, 5];
										#else
										elShader.uBlocksize = [5, 5];
										#end
										dad.shader = elShader;
										boyfriend.shader = elShader;
										gf.shader = elShader;
										var bgShader = new PixelateShader();
										#if (openfl >= "8.0.0")
										bgShader.data.uBlocksize.value = [10, 10];
										#else
										bgShader.uBlocksize = [10, 10];
										#end
										for (i in grpDieStage)
											i.shader = bgShader;

										unregisteredHypercam.visible = true;
									default:
										if (FlxG.save.data.flashing) {
											areYouReady.members[0].visible = true;
											phillyCityLights.forEach(function(light:FlxSprite)
											{
												light.visible = false;
											});
											phillyCityLights.members[0].visible = true;
											phillyCityLights.members[0].alpha = 1;
											FlxTween.tween(phillyCityLights.members[0], {alpha: 0}, 0.2, {
											});
										}
								}
							case 'you':
								switch (SONG.song.toLowerCase()) {
									case 'jump-out' | 'ronald mcdonald slide':
										for (i in SAD) {
											i.alpha = 0;
											if (SAD.members.indexOf(i) == SADorder) {
												i.alpha = 1;
											}
										}
										SADorder++;
										if (SADorder > 3)
											SADorder = 0;
									default:
										if (FlxG.save.data.flashing) {
											areYouReady.members[1].visible = true;
											phillyCityLights.forEach(function(light:FlxSprite)
											{
												light.visible = false;
											});
											phillyCityLights.members[0].visible = true;
											phillyCityLights.members[0].alpha = 1;
											FlxTween.tween(phillyCityLights.members[0], {alpha: 0}, 0.2, {
											});
										}
								}
								
							case 'ready':
								switch (SONG.song.toLowerCase()) {
									case 'ronald mcdonald slide':
										backgroundVideo("assets/videos/stop_posting_about_among_us.webm");
										
										remove(dad);
										dad = new Character(-50, 109, 'abungus', false, true);
										grpIcons.remove(iconP2);
										iconP2Prefix = 'abungus';
										iconP2 = new HealthIcon('abungus', false);
										iconP2.y = healthBar.y - (iconP2.height / 2);
										iconP2.cameras = [camHUD];
										grpIcons.add(iconP2);
										
										remove(gf);
										add(gf);
										add(dad);
										healthBar.visible = false;
										healthBarBG.visible = false;
										iconP2.visible = false;
										iconP1.visible = false;
									case 'jump-out':
										backgroundVideo("assets/videos/sandwitch.webm");
									default:
										if (FlxG.save.data.flashing) {
											areYouReady.members[2].visible = true;
											phillyCityLights.forEach(function(light:FlxSprite)
											{
												light.visible = false;
											});
											phillyCityLights.members[0].visible = true;
											phillyCityLights.members[0].alpha = 1;
											FlxTween.tween(phillyCityLights.members[0], {alpha: 0}, 0.2, {
											});
										}
								}
							case 'kill':
								switch (SONG.song.toLowerCase()) {
									case 'ronald mcdonald slide':
										if (useVideo)
										{
											BackgroundVideo.get().stop();
											FlxG.stage.window.onFocusOut.remove(focusOut);
											FlxG.stage.window.onFocusIn.remove(focusIn);
											PlayState.instance.remove(PlayState.instance.videoSprite);
											useVideo = false;
										}
										waaaa.visible = false;
										dadShouldIdle = true;
										unregisteredHypercam.visible = false;

										for (i in grpDieStage)
											i.shader = null;

										dad.shader = null;
										boyfriend.shader = null;
										gf.shader = null;

										if (dad.curCharacter != 'ronsip') {
											remove(dad);
											dad = new Character(-50, 189, 'ronsip', false, true);
											grpIcons.remove(iconP2);
											iconP2Prefix = 'ronsip';
											iconP2 = new HealthIcon('ronsip', false);
											iconP2.y = healthBar.y - (iconP2.height / 2);
											iconP2.cameras = [camHUD];
											grpIcons.add(iconP2);
											
											remove(gf);
											add(gf);
											add(dad);
										}

										if (boyfriend.curCharacter != 'bf') {
											remove(boyfriend);
											boyfriend = new Boyfriend(961, 430, 'bf');
											grpIcons.remove(iconP1);
											iconP1Prefix = 'bf';
											iconP1 = new HealthIcon('bf', true);
											iconP1.y = healthBar.y - (iconP1.height / 2);
											iconP1.cameras = [camHUD];
											grpIcons.add(iconP1);
											remove(gf);
											add(gf);
											add(boyfriend);
										}
									case 'jump-out':
										if (useVideo)
										{
											BackgroundVideo.get().stop();
											FlxG.stage.window.onFocusOut.remove(focusOut);
											FlxG.stage.window.onFocusIn.remove(focusIn);
											PlayState.instance.remove(PlayState.instance.videoSprite);
											useVideo = false;
										}
										dad.playAnim('idle');
										if (dad.curCharacter != 'gloopy') {
											remove(dad);
											dad = new Character(-50, 369, 'gloopy', false, true);
											grpIcons.remove(iconP2);
											iconP2Prefix = 'gloopy';
											iconP2 = new HealthIcon('gloopy', false);
											iconP2.y = healthBar.y - (iconP2.height / 2);
											iconP2.cameras = [camHUD];
											grpIcons.add(iconP2);
											
											remove(gf);
											add(gf);
											add(dad);
										}

										if (boyfriend.curCharacter != 'bf') {
											remove(boyfriend);
											boyfriend = new Boyfriend(961, 430, 'bf');
											grpIcons.remove(iconP1);
											iconP1Prefix = 'bf';
											iconP1 = new HealthIcon('bf', true);
											iconP1.y = healthBar.y - (iconP1.height / 2);
											iconP1.cameras = [camHUD];
											grpIcons.add(iconP1);
											remove(gf);
											add(gf);
											add(boyfriend);
										}
										
									default:
										for (i in areYouReady) {
											i.visible = false;
										}
										useCamChange = true;
								}
							case '4':
								switch (SONG.song.toLowerCase()) {
									case 'ronald mcdonald slide':
										if (useVideo)
										{
											BackgroundVideo.get().stop();
											FlxG.stage.window.onFocusOut.remove(focusOut);
											FlxG.stage.window.onFocusIn.remove(focusIn);
											PlayState.instance.remove(PlayState.instance.videoSprite);
											useVideo = false;
										}
										healthBar.visible = true;
										healthBarBG.visible = true;
										iconP2.visible = true;
										iconP1.visible = true;
									case 'jump-out':
										backgroundVideo("assets/videos/TV static noise HD 1080p.webm");
								}
								
							case '5':
								switch (SONG.song.toLowerCase()) {
									case 'ronald mcdonald slide':
										waaaa.visible = true;
									case 'jump-out':
										remove(boyfriend);
										boyfriend = new Boyfriend(811, 100, 'bf-anders');
										grpIcons.remove(iconP1);
										iconP1Prefix = 'bf-anders';
										iconP1 = new HealthIcon('bf-anders', true);
										iconP1.y = healthBar.y - (iconP1.height / 2);
										iconP1.cameras = [camHUD];
										grpIcons.add(iconP1);
										remove(gf);
										add(gf);
										add(boyfriend);
								}
							case '6':
								switch (SONG.song.toLowerCase()) {
									case 'ronald mcdonald slide':
										dadShouldIdle = false;
									case 'jump-out':
										for (i in grpSlaughtStage) {
											i.y -= FlxG.height * 2;
										}
										gf.visible = false;
										defaultCamZoom = 0.9;
								}
							case '7':
								switch (SONG.song.toLowerCase()) {
									case 'jump-out':
										for (i in grpSlaughtStage) {
											i.y += FlxG.height * 2;
										}
										gf.visible = true;
										defaultCamZoom = 0.75;
								}
								
								
							default:
								cpuStrums.forEach(function(spr:FlxSprite)
								{
									if (Math.abs(daNote.noteData) == spr.ID)
									{
										spr.animation.play('confirm', true);
										cpuNoteTimer[daNote.noteData] = 10;
									}
									if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
									{
										spr.centerOffsets();
										spr.offset.x -= 13;
										spr.offset.y -= 13;
									}
									else
										spr.centerOffsets();
								});
								if (SONG.song.toLowerCase() == 'intertwined') {
									cerbStrums.forEach(function(spr:FlxSprite)
									{
										if (Math.abs(daNote.noteData) == spr.ID)
										{
											spr.animation.play('confirm', true);
										}
										if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
										{
											spr.centerOffsets();
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										}
										else
											spr.centerOffsets();
									});
								}
								var daSprite = dad;
								switch (daNote.noteType) {
									case 'cerb':
										daSprite = dad2;
										for (i in cerbStrums) {
											i.visible = true;
										}
										for (i in cpuStrums) {
											i.visible = false;
										}
										if (!healthColorSwitch1) {
											healthColorSwitch1 = true;
											healthBar.createFilledBar(FlxColor.fromString('#' + dad2.iconColor), FlxColor.fromString('#' + boyfriend.iconColor));
										}
										iconP2Prefix = 'smallashcerb';
									case 'duet':
										iconP2Prefix = 'ashcerb';
										if (!healthColorSwitch2) {
											healthColorSwitch2 = true;
											healthBar.createFilledBar(FlxColor.GRAY, FlxColor.fromString('#' + boyfriend.iconColor));
										}
										for (i in cerbStrums) {
											i.visible = false;
											if (cerbStrums.members.indexOf(i) == 3 || cerbStrums.members.indexOf(i) == 1)
												i.visible = true;
										}
										for (i in cpuStrums) {
											i.visible = false;
											if (cpuStrums.members.indexOf(i) == 0 || cpuStrums.members.indexOf(i) == 2)
												i.visible = true;
										}
										switch (Math.abs(daNote.noteData))
										{
											case 2:
												dad2.playAnim('singUP' + altAnim, true);
											case 3:
												dad2.playAnim('singRIGHT' + altAnim, true);
											case 1:
												dad2.playAnim('singDOWN' + altAnim, true);
											case 0:
												dad2.playAnim('singLEFT' + altAnim, true);
										}
									default:
										for (i in cerbStrums) {
											i.visible = false;
										}
										for (i in cpuStrums) {
											i.visible = true;
										}
								}
								if (SONG.player2 == 'gloopy') { 
									if (!dad.animation.curAnim.name.startsWith('drop')) {
										switch (Math.abs(daNote.noteData))
										{
											case 2:
												daSprite.playAnim('singUP' + altAnim, true);
											case 3:
												daSprite.playAnim('singRIGHT' + altAnim, true);
											case 1:
												daSprite.playAnim('singDOWN' + altAnim, true);
											case 0:
												daSprite.playAnim('singLEFT' + altAnim, true);
										}
									}
								} else {
									switch (Math.abs(daNote.noteData))
									{
										case 2:
											daSprite.playAnim('singUP' + altAnim, true);
										case 3:
											daSprite.playAnim('singRIGHT' + altAnim, true);
										case 1:
											daSprite.playAnim('singDOWN' + altAnim, true);
										case 0:
											daSprite.playAnim('singLEFT' + altAnim, true);
									}
								}
								if (curStage == 'night') {
									switch (Math.abs(daNote.noteData))
									{
										case 2:
											pc.playAnim('singUP', true);
										case 3:
											pc.playAnim('singRIGHT', true);
										case 1:
											pc.playAnim('singDOWN', true);
										case 0:
											pc.playAnim('singLEFT', true);
									}
								}
						}
						
						
						
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
						#end
						if (hasDad2)
							dad2.holdTimer = 0;
						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						//daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						//daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						//daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						//daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					
					switch (daNote.noteType) {
						case 'drop' | 'are' | 'you' | 'ready' | 'kill' | '4' | '5' | '6' | '7':
							daNote.visible = false;
					}

					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 17;

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if ((daNote.mustPress && daNote.tooLate && !FlxG.save.data.downscroll || daNote.mustPress && daNote.tooLate && FlxG.save.data.downscroll) && daNote.mustPress)
					{
							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
							}
							else
							{
								health -= 0.075;
								vocals.volume = 0;
								if (theFunne)
									noteMiss(daNote.noteData, daNote);
							}
		
							daNote.visible = false;
							daNote.kill();
							notes.remove(daNote, true);
						}
					
				});
			}

		cpuStrums.forEach(function(spr:FlxSprite)
		{
			if (spr.animation.finished)
			{
				spr.animation.play('static');
				spr.centerOffsets();
			}
		});
		if (SONG.song.toLowerCase() == 'intertwined') {
			cerbStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
		}

		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();

		if (FlxG.keys.justPressed.TWO)
			nooooron();
		#end
	}

	function nooooron():Void
	{
		if (FlxG.save.data.beatBob == null || FlxG.save.data.beatBob == false) {
			MainMenuState.firsttimeGloopy = true;
			FlxG.save.data.beatBob = true;
		}
		for (i in strumLineNotes)
			i.visible = false;
		healthBar.visible = false;
		healthBarBG.visible = false;
		iconP2.visible = false;
		iconP1.visible = false;
		camZooming = false;
		resyncingVocals = false;
		canPause = false;
		FlxG.sound.music.stop();
		vocals.stop();
		var dialogue = CoolUtil.coolTextFile(Paths.txt('ronald mcdonald slide/AAAAAAAAAAAAA'));
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		doof.scrollFactor.set();
		doof.finishThing = killron;
		doof.cameras = [camHUD];
		add(doof);
	}

	function killron():Void {
		
		dad.visible = false;
		camHUD.visible = false;
		var angyRonsip:FlxSprite = new FlxSprite(-1200, -100);
		angyRonsip.frames = Paths.getSparrowAtlas('sunset/happy/RON_dies_lmaoripbozo_packwatch', 'shared');
		angyRonsip.animation.addByIndices('idle', 'rip my boy ron', [0], '', 24, false);
		angyRonsip.animation.addByPrefix('die', 'rip my boy ron', 24, false);
		angyRonsip.animation.play('idle');

		add(angyRonsip);
		FlxTween.tween(FlxG.camera, {zoom: 1}, 1, {
			ease: FlxEase.cubeOut
		});
		var cutsceneCam:FlxObject = new FlxObject(camFollow.x, camFollow.y, 1, 1);
		FlxG.camera.follow(cutsceneCam);
		FlxTween.tween(cutsceneCam, {x: 400.63, y: 500.94}, 1, {
			onComplete: function(tween:FlxTween)
			{
				new FlxTimer().start(0.45, function(tmr:FlxTimer)
				{
					angyRonsip.animation.play('die');
					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						FlxG.sound.play(Paths.sound('ronsip_diesonce', 'shared'), 1);
						var scream = new FlxSound().loadEmbedded(Paths.sound('third_scream', 'shared'));
						FlxG.sound.list.add(scream);
						scream.volume = 0.5;
						scream.fadeOut(2, 0);
						scream.play();

						
					});
					new FlxTimer().start(0.3, function(tmr:FlxTimer)
					{
						var songHighscore = StringTools.replace(PlayState.SONG.song, " ", "-");
						switch (songHighscore) {
							case 'Dad-Battle': songHighscore = 'Dadbattle';
							case 'Philly-Nice': songHighscore = 'Philly';
						}
						#if !switch
						Highscore.saveScore(songHighscore, Math.round(songScore), storyDifficulty);
						Highscore.saveMisses(songHighscore, misses, storyDifficulty);
						#end
						persistentUpdate = false;
						persistentDraw = false;
						openSubState(new CoolSubstate());
					});
				});
			},
			ease: FlxEase.cubeOut
		});

	}	
	
	function endSong():Void
	{
		if (useVideo)
		{
			BackgroundVideo.get().stop();
			FlxG.stage.window.onFocusOut.remove(focusOut);
			FlxG.stage.window.onFocusIn.remove(focusIn);
			PlayState.instance.remove(PlayState.instance.videoSprite);
		}

		if (!loadRep)
			rep.SaveReplay(saveNotes);
		else
		{
			FlxG.save.data.botplay = false;
			FlxG.save.data.scrollSpeed = 1;
			FlxG.save.data.downscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			// adjusting the highscore song name to be compatible
			// would read original scores if we didn't change packages
			var songHighscore = StringTools.replace(PlayState.SONG.song, " ", "-");
			switch (songHighscore) {
				case 'Dad-Battle': songHighscore = 'Dadbattle';
				case 'Philly-Nice': songHighscore = 'Philly';
			}

			#if !switch
			Highscore.saveScore(songHighscore, Math.round(songScore), storyDifficulty);
			Highscore.saveMisses(songHighscore, misses, storyDifficulty);
			#end
		}
		if (SONG.song.toLowerCase() == 'split' && storyDifficulty == 3) {
			FlxG.save.data.beatSplitEX = true;
			MainMenuState.firsttimeSplitEX = true;
		}
		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('menuIntro'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					FlxG.sound.playMusic(Paths.music('menuIntro'));

					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
					switch (PlayState.SONG.song.toLowerCase()) {
						case 'split':
							FlxTransitionableState.skipNextTransIn = true;
							FlxTransitionableState.skipNextTransOut = true;
							LoadingState.loadAndSwitchState(new VideoState("assets/videos/Cutscene4Subtitles-credits.webm", new VideoState("assets/videos/Bobal.webm", new MainMenuState())));
							if (FlxG.save.data.beatWeek == null || FlxG.save.data.beatWeek == false) {
								MainMenuState.firsttimeBob = true;
								FlxG.save.data.beatWeek = true;
								FlxG.save.data.unlockedEX = true;
							}
						case 'intertwined':
							FlxTransitionableState.skipNextTransIn = true;
							FlxTransitionableState.skipNextTransOut = true;
							LoadingState.loadAndSwitchState(new VideoState("assets/videos/ITB/Subtitles ITB-5.webm", new MainMenuState()));
							if (FlxG.save.data.beatITB == null || FlxG.save.data.beatITB == false) {
								MainMenuState.firsttimeITB = true;
								FlxG.save.data.beatITB = true;
							}
						default:
							FlxG.switchState(new StoryMenuState());
					}

					#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end

					// if ()
					//StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					//FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = "";

					if (storyDifficulty == 0)
						difficulty = '-easy';

					if (storyDifficulty == 2)
						difficulty = '-hard';

					trace('LOADING NEXT SONG');
					// pre lowercasing the next story song name
					/*var nextSongLowercase = StringTools.replace(PlayState.storyPlaylist[0], " ", "-").toLowerCase();
						switch (nextSongLowercase) {
							case 'dad-battle': nextSongLowercase = 'dadbattle';
							case 'philly-nice': nextSongLowercase = 'philly';
						}*/
					var nextSongLowercase = PlayState.storyPlaylist[0].toLowerCase();
					trace(nextSongLowercase + difficulty);

					// pre lowercasing the song name (endSong)
					var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
					switch (songLowercase) {
						case 'dad-battle': songLowercase = 'dadbattle';
						case 'philly-nice': songLowercase = 'philly';
					}
					if (songLowercase == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;
					switch (PlayState.storyPlaylist[0].toLowerCase()) {
						case 'yap squad':
							PlayState.dad2SONG = Song.loadFromJson('woof', PlayState.storyPlaylist[0]);
					}
					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();
					switch (nextSongLowercase) {
						case 'swing':
							LoadingState.loadAndSwitchState(new VideoState("assets/videos/Cutscene2Subtitles.webm", new PlayState()));
						case 'split':
							LoadingState.loadAndSwitchState(new VideoState("assets/videos/Cutscene3Subtitles.webm", new PlayState()));
						case 'conscience':
							LoadingState.loadAndSwitchState(new VideoState("assets/videos/ITB/Subtitles ITB-2.webm", new PlayState()));
						case 'yap squad':
							LoadingState.loadAndSwitchState(new VideoState("assets/videos/ITB/Subtitles ITB-3.webm", new PlayState()));
						case 'intertwined':
							LoadingState.loadAndSwitchState(new VideoState("assets/videos/ITB/Subtitles ITB-4.webm", new PlayState()));
						case 'jump-out':
							LoadingState.loadAndSwitchState(new VideoState("assets/videos/bob takeover/Subtitles-Onslaught-2.webm", new PlayState()));
						default:
							LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				if (desktopMode)
					FlxG.switchState(new DesktopState());
				else
					FlxG.switchState(new FreeplayState());
			}
		}
	}


	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
			var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.45;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				case 'shit':
					score = -300;
					combo = 0;
					misses++;
					health -= 0.2;
					ss = false;
					shits++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.25;
				case 'bad':
					daRating = 'bad';
					score = 0;
					health -= 0.06;
					ss = false;
					bads++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.50;
				case 'good':
					daRating = 'good';
					score = 200;
					ss = false;
					goods++;
					if (health < 2)
						health += 0.02;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.75;
				case 'sick':
					if (health < 2)
						health += 0.05;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 1;
					sicks++;
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(FlxG.save.data.botplay) msTiming = 0;							   

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if(!FlxG.save.data.botplay) add(currentTimingShown);
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if(!FlxG.save.data.botplay) add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			// make sure we have 3 digits to display (looks weird otherwise lol)
			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
				#if windows
				if (luaModchart != null){
				if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
				if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
				if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
				if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
				};
				#end
		 
				// Prevent player input if botplay is on
				if(FlxG.save.data.botplay)
				{
					holdArray = [false, false, false, false];
					pressArray = [false, false, false, false];
					releaseArray = [false, false, false, false];
				} 
				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				}
		 
				// PRESSES, check for note hits
				if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					boyfriend.holdTimer = 0;
		 
					var possibleNotes:Array<Note> = []; // notes that can be hit
					var directionList:Array<Int> = []; // directions that can be hit
					var dumbNotes:Array<Note> = []; // notes to kill later
					var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
					
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
						{
							if (!directionsAccounted[daNote.noteData])
							{
								if (directionList.contains(daNote.noteData))
								{
									directionsAccounted[daNote.noteData] = true;
									for (coolNote in possibleNotes)
									{
										if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
										{ // if it's the same note twice at < 10ms distance, just delete it
											// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
											dumbNotes.push(daNote);
											break;
										}
										else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
										{ // if daNote is earlier than existing note (coolNote), replace
											possibleNotes.remove(coolNote);
											possibleNotes.push(daNote);
											break;
										}
									}
								}
								else
								{
									possibleNotes.push(daNote);
									directionList.push(daNote.noteData);
								}
							}
						}
					});

					trace('\nCURRENT LINE:\n' + directionsAccounted);
		 
					for (note in dumbNotes)
					{
						FlxG.log.add("killing dumb ass note at " + note.strumTime);
						note.kill();
						notes.remove(note, true);
						note.destroy();
					}
		 
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
		 
					var dontCheck = false;

					for (i in 0...pressArray.length)
					{
						if (pressArray[i] && !directionList.contains(i))
							dontCheck = true;
					}

					if (perfectMode)
						goodNoteHit(possibleNotes[0]);
					else if (possibleNotes.length > 0 && !dontCheck)
					{
						if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								{ // if a direction is hit that shouldn't be
									if (pressArray[shit] && !directionList.contains(shit))
										noteMiss(shit, null);
								}
						}
						for (coolNote in possibleNotes)
						{
							if (pressArray[coolNote.noteData])
							{
								if (mashViolations != 0)
									mashViolations--;
								scoreTxt.color = FlxColor.WHITE;
								goodNoteHit(coolNote);
							}
						}
					}
					else if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								if (pressArray[shit])
									noteMiss(shit, null);
						}

					if(dontCheck && possibleNotes.length > 0 && FlxG.save.data.ghost && !FlxG.save.data.botplay)
					{
						if (mashViolations > 8)
						{
							trace('mash violations ' + mashViolations);
							scoreTxt.color = FlxColor.RED;
							noteMiss(0,null);
						}
						else
							mashViolations++;
					}

				}
				
				notes.forEachAlive(function(daNote:Note)
				{
					if(FlxG.save.data.downscroll && daNote.y > strumLine.y ||
					!FlxG.save.data.downscroll && daNote.y < strumLine.y)
					{
						// Force good note hit regardless if it's too late to hit it or not as a fail safe
						if(FlxG.save.data.botplay && daNote.canBeHit && daNote.mustPress ||
						FlxG.save.data.botplay && daNote.tooLate && daNote.mustPress)
						{
							if(loadRep)
							{
								//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
								if(rep.replay.songNotes.contains(HelperFunctions.truncateFloat(daNote.strumTime, 2)))
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = daNote.sustainLength;
								}
							}else {
								goodNoteHit(daNote);
								boyfriend.holdTimer = daNote.sustainLength;
							}
						}
					}
				});
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || FlxG.save.data.botplay))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
						boyfriend.playAnim('idle');
				}
		 
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!holdArray[spr.ID])
						spr.animation.play('static');
		 
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end


			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy()
	{
		totalPlayed += 1;
		accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
		accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
	}

	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff);

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

				note.rating = Ratings.CalculateRating(noteDiff);

				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
	

					switch (note.noteData)
					{
						case 2:
							boyfriend.playAnim('singUP', true);
						case 3:
							boyfriend.playAnim('singRIGHT', true);
						case 1:
							boyfriend.playAnim('singDOWN', true);
						case 0:
							boyfriend.playAnim('singLEFT', true);
					}
		
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end


					if(!loadRep && note.mustPress)
						saveNotes.push(HelperFunctions.truncateFloat(note.strumTime, 2));
					
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});
					
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if(FlxG.save.data.distractions){
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if(FlxG.save.data.distractions){
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		if(FlxG.save.data.distractions){
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if(FlxG.save.data.distractions){
			if (trainSound.time >= 4700)
				{
					startedMoving = true;
					gf.playAnim('hairBlow');
				}
		
				if (startedMoving)
				{
					phillyTrain.x -= 400;
		
					if (phillyTrain.x < -2000 && !trainFinishing)
					{
						phillyTrain.x = -1150;
						trainCars -= 1;
		
						if (trainCars <= 0)
							trainFinishing = true;
					}
		
					if (phillyTrain.x < -4000 && trainFinishing)
						trainReset();
				}
		}

	}

	function trainReset():Void
	{
		if(FlxG.save.data.distractions){
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	var danced:Bool = false;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end
		if (storyDifficulty != 3) {
			if (curSong.toLowerCase() == 'split' && curStep == 124 && camZooming || curSong.toLowerCase() == 'split' && curStep == 126 && camZooming || curSong.toLowerCase() == 'split' && curStep == 1144 && camZooming || curSong.toLowerCase() == 'split' && curStep == 1147 && camZooming || curSong.toLowerCase() == 'split' && curStep == 1150 && camZooming)
			{
		
				FlxG.camera.zoom += 0.05;
				camHUD.zoom += 0.01;
			}
		}
		

		switch (SONG.song.toLowerCase()) {
			case 'ronald mcdonald slide':
				switch (curStep) {
					case 1535:
						makeBackgroundTheVideo("assets/videos/space.webm");
				}
		}
		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;
	function fuckUpHealth(v:Float) {
		health = v;
	}
	public function focusOut()
	{
		if (paused)
			return;
		persistentUpdate = false;
		persistentDraw = true;
		paused = true;

		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.pause();
			vocals.pause();
		}

		openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
	}

	public function focusIn()
	{
		// nada
	}

	public function backgroundVideo(source:String) // for background videos
	{
		#if cpp
		useVideo = true;

		FlxG.stage.window.onFocusOut.add(focusOut);
		FlxG.stage.window.onFocusIn.add(focusIn);

		var ourSource:String = "assets/videos/DO NOT DELETE OR GAME WILL CRASH/dontDelete.webm";
		//WebmPlayer.SKIP_STEP_LIMIT = 90;
		var str1:String = "WEBM SHIT";
		webmHandler = new WebmHandler();
		webmHandler.source(ourSource);
		webmHandler.makePlayer();
		webmHandler.webm.name = str1;

		BackgroundVideo.setWebm(webmHandler);

		BackgroundVideo.get().source(source);
		BackgroundVideo.get().clearPause();
		if (BackgroundVideo.isWebm)
		{
			BackgroundVideo.get().updatePlayer();
		}
		BackgroundVideo.get().show();

		if (BackgroundVideo.isWebm)
		{
			BackgroundVideo.get().restart();
		}
		else
		{
			BackgroundVideo.get().play();
		}

		var data = webmHandler.webm.bitmapData;

		videoSprite = new FlxSprite(0, 0).loadGraphic(data);

		//videoSprite.setGraphicSize(Std.int(videoSprite.width * 1.2));
		videoSprite.scrollFactor.set();
		videoSprite.cameras = [camHUD];
		remove(gf);
		remove(boyfriend);
		remove(dad);
		add(videoSprite);
		add(gf);
		add(boyfriend);
		add(dad);

		trace('poggers');

		if (!songStarted)
			webmHandler.pause();
		else
			webmHandler.resume();
		#end
	}

	public function makeBackgroundTheVideo(source:String) // for background videos
	{
		#if cpp
		useVideo = true;

		FlxG.stage.window.onFocusOut.add(focusOut);
		FlxG.stage.window.onFocusIn.add(focusIn);

		var ourSource:String = "assets/videos/DO NOT DELETE OR GAME WILL CRASH/dontDelete.webm";
		//WebmPlayer.SKIP_STEP_LIMIT = 90;
		var str1:String = "WEBM SHIT";
		webmHandler = new WebmHandler();
		webmHandler.source(ourSource);
		webmHandler.makePlayer();
		webmHandler.webm.name = str1;

		BackgroundVideo.setWebm(webmHandler);

		BackgroundVideo.get().source(source);
		BackgroundVideo.get().clearPause();
		if (BackgroundVideo.isWebm)
		{
			BackgroundVideo.get().updatePlayer();
		}
		BackgroundVideo.get().show();

		if (BackgroundVideo.isWebm)
		{
			BackgroundVideo.get().restart();
		}
		else
		{
			BackgroundVideo.get().play();
		}

		var data = webmHandler.webm.bitmapData;

		videoSprite = new FlxSprite(0, 0).loadGraphic(data);

		videoSprite.setGraphicSize(Std.int(videoSprite.width * 1.4));
		videoSprite.scrollFactor.set();
		//videoSprite.cameras = [camHUD];
		remove(gf);
		remove(boyfriend);
		remove(dad);
		add(videoSprite);
		add(gf);
		add(boyfriend);
		add(dad);

		trace('poggers');

		if (!songStarted)
			webmHandler.pause();
		else
			webmHandler.resume();
		#end
	}

	override function beatHit()
	{
		super.beatHit();

		switch (SONG.song.toLowerCase()) {
			case 'ronald mcdonald slide':
				switch (curBeat) {
					case 209:
						backgroundVideo("assets/videos/PP_by_AmorAltra__BoomKitty_Geometry_dash.webm");
				}
			/*case 'jump-out':
				switch (curBeat) {
					case 212:
						for (i in grpSlaughtStage) {
							i.y -= FlxG.height * 2;
						}
						gf.visible = false;
						defaultCamZoom = 0.9;
					case 246:
						for (i in grpSlaughtStage) {
							i.y += FlxG.height * 2;
						}
						gf.visible = true;
						defaultCamZoom = 0.75;
				}*/
		}
		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end
		if (curBeat % 2 == 0) {
			switch (SONG.song.toLowerCase()) {
				case 'intertwined':
					mini.animation.play('idle', true);
					mordecai.animation.play('idle', true);
					thirdBop.animation.play('idle', true);
				case 'yap squad':
					mini.animation.play('idle', true);
					mordecai.animation.play('idle', true);
				case 'conscience':
					mordecai.animation.play('idle', true);
			}
		}

		if (curStage == 'night') {
			mini.animation.play('idle', true);
		}
		if (curStage == 'sunset') {
			mini.animation.play('idle', true);
			mordecai.animation.play('idle', true);
		}
		if (curStage == 'day') {
			mini.animation.play('idle', true);
			if (stopWalkTimer == 0) {
				if (walkingRight)
					mordecai.flipX = false;
				else
					mordecai.flipX = true;
				if (walked)
					mordecai.animation.play('walk1');
				else
					mordecai.animation.play('walk2');
				if (walkingRight)
					mordecai.x += 10;
				else
					mordecai.x -= 10;
				walked = !walked;
				trace(mordecai.x);
				if (mordecai.x == 480 && walkingRight) { 
					stopWalkTimer = 10;
					walkingRight = false;
				} else if (mordecai.x == -80 && !walkingRight) { 
					stopWalkTimer = 8;
					walkingRight = true;
				}
			} else 
				stopWalkTimer--;
		}
		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			/*if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.curCharacter != 'gf')
				dad.dance();*/

			if (hasDad2) {

				if (!dad2.animation.curAnim.name.startsWith('sing') && dad2.curCharacter != 'gf') {
				
					dad2.dance();
				}
			}
			if (!dad.animation.curAnim.name.startsWith('sing') && dad.curCharacter != 'gf' && dadShouldIdle) {
				dad.dance();
			}
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (splitCamMode) {
			defaultCamZoom = 0.65;
			if (splitExtraZoom)
				defaultCamZoom = 0.75;
		}

		if (FlxG.save.data.flashing && splitMode) {
			for (spr in theEntireFuckingStage) {
				spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 0.7, 1);
			}

			phillyCityLights.forEach(function(light:FlxSprite)
			{
				light.visible = false;
			});

			coolGlowyLights.forEach(function(light:FlxSprite)
			{
				light.visible = false;
			});

			coolGlowyLightsMirror.forEach(function(light:FlxSprite)
			{
				light.visible = false;
			});

			curLight++;
			if (curLight > phillyCityLights.length - 1)
				curLight = 0;

			phillyCityLights.members[curLight].visible = true;
			phillyCityLights.members[curLight].alpha = 1;

			coolGlowyLights.members[curLight].visible = true;
			coolGlowyLights.members[curLight].alpha = 0.8;

			FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, 0.3, {
			});
			FlxTween.tween(coolGlowyLights.members[curLight], {alpha: 0}, 0.3, {
			});
			if (!splitCamMode)
				defaultCamZoom = 0.9;
			else {
				coolGlowyLightsMirror.members[curLight].visible = true;
				coolGlowyLightsMirror.members[curLight].alpha = 0.8;
				FlxTween.tween(coolGlowyLightsMirror.members[curLight], {alpha: 0}, 0.3, {
				});
			}
			FlxG.camera.zoom += 0.030;
			camHUD.zoom += 0.04;
		} else if (!splitSoftMode && SONG.song.toLowerCase() == 'split' && storyDifficulty == 3) {
			if (theEntireFuckingStage.members[0].color.lightness < 1) {
				for (spr in theEntireFuckingStage) {
					spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 1, 1);
				}
				defaultCamZoom = 0.75;
			}
		}
		
		if (FlxG.save.data.flashing && splitSoftMode) {
			for (spr in theEntireFuckingStage) {
				spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 0.8, 1);
			}
			if (curBeat % 2 == 0) {
				phillyCityLights.forEach(function(light:FlxSprite)
				{
					light.visible = false;
				});

				curLight++;
				if (curLight > phillyCityLights.length - 1)
					curLight = 0;

				phillyCityLights.members[curLight].visible = true;
				phillyCityLights.members[curLight].alpha = 0.8;

				FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, 0.3, {
				});
			}
			defaultCamZoom = 0.75;
			FlxG.camera.zoom += 0.030;
			camHUD.zoom += 0.04;
		} else if (!splitMode && SONG.song.toLowerCase() == 'split' && storyDifficulty == 3) {
			if (theEntireFuckingStage.members[0].color.lightness < 1) {
				for (spr in theEntireFuckingStage) {
					spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 1, 1);
				}
			}
		}

		if (storyDifficulty != 3) {
			if (curSong.toLowerCase() == 'split' && curBeat == 188) //|| curSong.toLowerCase() == 'split' && curBeat == 190)
			{
				if (FlxG.save.data.flashing) {
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight++;
					if (curLight > phillyCityLights.length - 1)
						curLight = 0;

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;
					FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, 0.2, {
					});
					for (spr in theEntireFuckingStage) {
						spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 0.9, 1);
					}
				}
			}
			if (curSong.toLowerCase() == 'split' && curBeat >= 192 && curBeat < 256 && camZooming && FlxG.camera.zoom < 1.35)
			{
				if (FlxG.save.data.flashing) {
					for (spr in theEntireFuckingStage) {
						spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 0.7, 1);
					}
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight++;
					if (curLight > phillyCityLights.length - 1)
						curLight = 0;

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;
					FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, 0.3, {
					});
			
					FlxG.camera.zoom += 0.030;
					camHUD.zoom += 0.04;
				}
			}
			if (curSong.toLowerCase() == 'split' && curBeat >= 32 && curBeat < 160 && camZooming && FlxG.camera.zoom < 1.35 && curBeat != 95 || curSong.toLowerCase() == 'split' && curBeat >= 288 && curBeat < 316 && camZooming && FlxG.camera.zoom < 1.35 || curSong.toLowerCase() == 'split' && curBeat >= 352 && curBeat < 385 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
			if (curSong.toLowerCase() == 'split' && curBeat == 256)
			{
				for (spr in theEntireFuckingStage) {
					spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 1, 1);
				}
			}
		}
		if (storyDifficulty != 3) {
			if (curSong.toLowerCase() == 'jump-in' && curBeat == 4 || curSong.toLowerCase() == 'swing' && curBeat == 64 || curSong.toLowerCase() == 'swing' && curBeat == 224)
			{
				FlxG.sound.play(Paths.sound('carPass1', 'shared'), 0.7);
				new FlxTimer().start(1.3, function(tmr:FlxTimer)
				{
					phillyTrain.x = 2000;
					phillyTrain.flipX = false;
					phillyTrain.visible = true;
					FlxTween.tween(phillyTrain, {x: -2000}, 0.18, {
						onComplete: function(twn:FlxTween) {
							phillyTrain.visible = false;
						}
					});
				});
				
			}
			if (curSong.toLowerCase() == 'jump-in' && curBeat == 68 || curSong.toLowerCase() == 'swing' && curBeat == 144)
			{
				FlxG.sound.play(Paths.sound('carPass1', 'shared'), 0.7);
				new FlxTimer().start(1.3, function(tmr:FlxTimer)
				{
					phillyTrain.x = -2000;
					phillyTrain.flipX = true;
					phillyTrain.visible = true;
					FlxTween.tween(phillyTrain, {x: 2000}, 0.18, {
						onComplete: function(twn:FlxTween) {
							phillyTrain.visible = false;
						}
					});
				});
				
			}
		}
		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}
		

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat == 30 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' || curBeat == 46 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' )
			{
				dad.playAnim('cheer', true);
			}

		switch (curStage)
		{
			case 'school':
				if(FlxG.save.data.distractions){
					bgGirls.dance();
				}

			case 'mall':
				if(FlxG.save.data.distractions){
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);
				}

			case 'limo':
				if(FlxG.save.data.distractions){
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
						{
							dancer.dance();
						});
		
						if (FlxG.random.bool(10) && fastCarCanDrive)
							fastCarDrive();
				}
			case "philly":
				if(FlxG.save.data.distractions){
					if (!trainMoving)
						trainCooldown += 1;
	
					if (curBeat % 4 == 0)
					{
						phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});
	
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
	
						phillyCityLights.members[curLight].visible = true;
						// phillyCityLights.members[curLight].alpha = 1;
				}

				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					if(FlxG.save.data.distractions){
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if(FlxG.save.data.distractions){
				lightningStrikeShit();
			}
		}
	}

	var curLight:Int = 0;
}
