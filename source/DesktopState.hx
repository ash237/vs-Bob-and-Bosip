package;

import lime.utils.Bytes;
import openfl.display.Shader;
import openfl.filters.ShaderFilter;
import flixel.FlxSubState;
import openfl.filters.BitmapFilter;
import openfl.display.BitmapData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxExtendedSprite;
import flixel.addons.plugin.FlxMouseControl;
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
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
//import io.newgrounds.NG;
import flixel.util.FlxSpriteUtil;
import lime.app.Application;
import openfl.Assets;
import flash.geom.Point;
import D;

#if windows
import Discord.DiscordClient;
import Sys;
import sys.FileSystem;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class DesktopState extends MusicBeatState
{
	var freeplayFolder:FlxSprite;
	var freeplayScreen:FlxSprite;

	var optionsFolder:FlxSprite;
	var optionsScreen:FlxSprite;
	var bobAndBosipApp:FlxSprite;
	var bg:FlxSprite;
	var galleryBG:FlxSprite;
	var fuckyouText:FlxText;
	var inCat:Int = 0;
	var transitioning:Bool = false;
	var exFolder:Bool = false;

	var currentMenu:String = 'desktop';
	var trText:FlxText;
	var sstuff:FlxTypedGroup<FlxSprite>;

	public var folders:FlxTypedGroup<FlxExtendedSprite>;
	public var folderLabels:FlxTypedGroup<FlxSprite>;

	var folderData:Array<String> = [
		'freeplay',
		'gallery',
		'bob & bosip',
		'options',
		'stats',
		'sound test',
		'trophy rack'
	];

	var myButt:Bool = false;
	var achievementsUnlocked:Map<String, Bool> = new Map();
	var freeplayName:String = 'freeplay';
	var draggingFolder:Bool = false;
	var visualDragFolder:Bool = false;
	var folder:FlxTypedGroup<FlxSprite>;
	var folderOffsets:Array<FlxPoint> = [];
	var folderDrag:FlxExtendedSprite;
	var stickers:FlxTypedGroup<FlxSprite>;

	var freeplayStuff:FlxTypedGroup<HealthIcon>;
	var freeplayLocks:FlxTypedGroup<HealthIcon>;
	var freeplayOffsets:Array<FlxPoint> = [];
	var freeplayLabels:FlxTypedGroup<FlxSprite>;
	var folderSelect:FlxSprite;

	var desktopStickers:Map<String, FlxPoint> = new Map();

	var gallery:FlxTypedGroup<FlxExtendedSprite>;

	var prevPos:FlxPoint;

	public var galleryWall:FlxSprite;
	public var fWall:FlxSprite;
	public var officialImageLocations:Array<String> = [];
	public var fanmadeImageLocations:Array<String> = [];        
	public var uImageLocations:Array<String> = [];   

	public static var officialGallery:FlxTypedGroup<FlxSprite>;
	public static var officialPictures:FlxTypedGroup<FlxSprite>;
	public static var uGallery:FlxTypedGroup<FlxSprite>;
	public static var uPictures:FlxTypedGroup<FlxSprite>;
	public static var fanmadeGallery:FlxTypedGroup<FlxSprite>;
	public static var fanmadePictures:FlxTypedGroup<FlxSprite>;
	public var loadingImageLocations:Array<String> = [];  
	public static var loadingGallery:FlxTypedGroup<FlxSprite>;
	public static var loadingPictures:FlxTypedGroup<FlxSprite>;

	var trophies:Array<FlxSprite> = [];
	var songs:Array<String> = [];
	var songsUnlocked:Array<Bool> = [];
	var iconArray:Array<String> = [];

	var folderBorder:FlxSprite;

	var closingFolder:Bool = false;
	var canOpenFolder:Bool = true;
	var canOpenNotepad:Bool = true;
	var canOpenTR:Bool = true;

	var notepadDrag:FlxExtendedSprite;
	var notepad:FlxTypedGroup<FlxSprite>;
	var notepadOffsets:Array<FlxPoint> = [];
	var notepadTextArray:Array<FlxSprite> = [];

	var trDrag:FlxExtendedSprite;
	var tr:FlxTypedGroup<FlxSprite>;
	var trOffsets:Array<FlxPoint> = [];
	var trTextArray:Array<FlxSprite> = [];
	

	var statsScroll:Int = 0;
	var statsScrollMax:Int = 0;

	public static var theSong:FlxSound;

	var theCode:Array<Dynamic> = [
		[65],
		[86],
		[69],
		[83]
	];
	var theCodeOrder:Int = 0;

	var theCode2:Array<Dynamic> = [
		[70],
		[77],
		[66],
	];
	var theCodeOrder2:Int = 0;

	var theBoy:FlxSprite;
	var theThing:Array<Bool> = [];


	
	override public function create():Void
	{
		if (FlxG.save.data.desktopStickers != null)
			desktopStickers = FlxG.save.data.desktopStickers;
		#if debug
			folderData.push('perfect all songs');
		#end
		theSong = new FlxSound();
		
		//IM SORRY PLEASE DONT DO ANY OF THIS, USE CLASSES AND DO SHIT PROPERLY LOL, I GOT LAZY
		prevPos = new FlxPoint();
		var pasdasd = new FlxMouseControl();
		FlxG.plugins.add(pasdasd);

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Desktop", null);
		#end
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			if (MainMenuState.firsttimeSplitEX) {
				if (!FlxG.save.data.beatSplitEX) {
					achievementArray.push('unlocked 8-bit split in the sound test!');
					FlxG.save.data.beatSplitEX = true;
				}
				if (!FlxG.save.data.beatSplitEX2) {
					achievementArray.push('unlocked oblique fracture in the desktop!');
					FlxG.save.data.beatSplitEX2 = true;
				}
				MainMenuState.firsttimeSplitEX = false;
			}

		});
		
		super.create();

		FlxG.save.bind('funkin', 'bobandbosip');

		KadeEngineData.initSave();

		Highscore.load();

		FlxG.mouse.visible = true;
		
		if (FlxG.save.data.beatWeek && !FlxG.save.data.unlockedEX) {
			achievementArray.push('unlocked EX difficulty in freeplay! (previously beat week 1)');
			FlxG.save.data.unlockedEX = true;
		}
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		var goldFolderCheck:Bool = true;
		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			songs.push(data[0]);
			iconArray.push(data[1]);
			songsUnlocked[i] = false;
			var songHighscore = StringTools.replace(data[0], " ", "-");
				switch (songHighscore) {
					case 'Dad-Battle': songHighscore = 'Dadbattle';
					case 'Philly-Nice': songHighscore = 'Philly';
			}
			for (diff in 0...3) {
				
				if (Highscore.getScore(songHighscore, diff) > 0)
					songsUnlocked[i] = true;
				if (data[0].toLowerCase() == 'oblique fracture') {
					if (FlxG.save.data.beatSplitEX2)
						songsUnlocked[i] = true;
				}
			}
			if (data[0] == 'ronald mcdonald slide' || data[0] == 'jump-out') {
				if (Highscore.getMissesString(songHighscore, 2) == 'N/A')
					goldFolderCheck = false;
			} else {
				if (Highscore.getScore(songHighscore, 3) > 0 && Highscore.getMissesString(songHighscore, 3) == '0') {
					myButt = true;
				} else myButt = false;

				if (Highscore.getScore(songHighscore, 3) > 0) {
					achievementsUnlocked.set('ex-normal', true);
				} else achievementsUnlocked.set('ex-normal', false);

				if (Highscore.getMissesString(songHighscore, 2) != '0')
					goldFolderCheck = false;
			//	if (FileSystem.exists(Paths.instEXcheck(data[0]))) {
					if (Highscore.getMissesString(songHighscore, 3) != '0')
						goldFolderCheck = false;
				}
			}
			
			if (data[0] == 'jump-in'|| data[0] == 'swing' || data[0] == 'split') {
				var passedDiff:Bool = false;
				for (diff in 0...3) {
					if (Highscore.getScore(songHighscore, diff) > 0) {
						passedDiff = true;
					}
				}

				if (Highscore.getScore(songHighscore, 2) > 0 && Highscore.getMissesString(songHighscore, 2) == '0' && Highscore.getScore(songHighscore, 3) > 0 && Highscore.getMissesString(songHighscore, 3) == '0') {
					achievementsUnlocked.set('bnb-perfect', true);
				} else achievementsUnlocked.set('bnb-perfect', false);

				if (Highscore.getScore(songHighscore, 3) > 0) {
					if (passedDiff) {
						achievementsUnlocked.set('bnb-normal', true);
					} else
						achievementsUnlocked.set('bnb-normal', false);
				}
			}
			if (data[0] == 'jump-out' || data[0] == 'ronald mcdonald slide' || data[0] == 'copy cat') {
				var passedDiff:Bool = false;
				for (diff in 0...3) {
					if (Highscore.getScore(songHighscore, diff) > 0) {
						passedDiff = true;
					}
				}

				if (Highscore.getScore(songHighscore, 3) > 0) {
					if (passedDiff) {
						achievementsUnlocked.set('takeover-normal', true);
					} else
						achievementsUnlocked.set('takeover-normal', false);
				}
			}
			
		}
		if (goldFolderCheck) {
			FlxG.save.data.sol = true;
		}
		songsUnlocked[0] = true;
		FlxG.camera.flash(FlxColor.WHITE, 1);

		bg = new FlxSprite(0, 0).loadGraphic(Paths.image('desktop/desktop1'));
		if (FlxG.save.data.wallpaper != null) 
			bg = new FlxSprite(0, 0).loadGraphic(Paths.image(FlxG.save.data.wallpaper));
		bg.setGraphicSize(1280, 720);
		bg.updateHitbox();
		add(bg);
		
		sstuff = new FlxTypedGroup<FlxSprite>();
		add(sstuff);
		reloadInterractables();

		stickers = new FlxTypedGroup<FlxSprite>();
		add(stickers);

		folders = new FlxTypedGroup<FlxExtendedSprite>();
		add(folders);

		folderLabels = new FlxTypedGroup<FlxSprite>();
		add(folderLabels);
	
		folderBorder = new FlxSprite().loadGraphic(Paths.image('desktop/folderSelect'));
		add(folderBorder);
		folderBorder.alpha = 0.8;
		folderBorder.visible = false;

		folder = new FlxTypedGroup<FlxSprite>();
		add(folder);

		notepad = new FlxTypedGroup<FlxSprite>();
		add(notepad);

		tr = new FlxTypedGroup<FlxSprite>();
		add(tr);

		freeplayStuff = new FlxTypedGroup<HealthIcon>();
		add(freeplayStuff);
		
		freeplayLocks = new FlxTypedGroup<HealthIcon>();
		add(freeplayLocks);

		freeplayLabels = new FlxTypedGroup<FlxSprite>();
		add(freeplayLabels);

		folderSelect = new FlxSprite().loadGraphic(Paths.image('desktop/folderSelect'));
		add(folderSelect);
		folderSelect.alpha = 0.8;
		folderSelect.visible = false;
		
		/*gallery = new FlxTypedGroup<FlxExtendedSprite>();
		add(gallery);*/
		galleryWall = new FlxSprite().loadGraphic(Paths.image('desktop/gallery/galleryBackground'));
		galleryWall.visible = false;
		add(galleryWall);

		fWall = new FlxSprite().loadGraphic(Paths.image('desktop/gallery/cool/bg'));
		fWall.visible = false;
		add(fWall);

		officialGallery = new FlxTypedGroup<FlxSprite>();
		add(officialGallery);

		officialPictures = new FlxTypedGroup<FlxSprite>();
		add(officialPictures);

		uGallery = new FlxTypedGroup<FlxSprite>();
		add(uGallery);

		uPictures = new FlxTypedGroup<FlxSprite>();
		add(uPictures);

		fanmadeGallery = new FlxTypedGroup<FlxSprite>();
		add(fanmadeGallery);

		fanmadePictures = new FlxTypedGroup<FlxSprite>();
		add(fanmadePictures);

		loadingGallery = new FlxTypedGroup<FlxSprite>();
		add(loadingGallery);

		loadingPictures = new FlxTypedGroup<FlxSprite>();
		add(loadingPictures);

		theBoy = new FlxSprite(810, 282).loadGraphic(Paths.image('ash_soda'));
		add(theBoy);
		theBoy.alpha = 0;
		
		//theBoy.visible = false;
		trace(Paths.image('desktop/folderSelect', 'shared'));

		for (i in 0...24) {
			var spr:FlxSprite = new FlxSprite(21, 1271).loadGraphic(Paths.image('desktop/gallery/thumbnailPad'));
			var image:FlxSprite = new FlxSprite();
			image = new FlxSprite(spr.x + 15, spr.y + 13).loadGraphic(Paths.image('desktop/gallery/official/' + i));
			if (i == 2 || i == 3 || i == 5) {
				if (!FlxG.save.data.beatITB)
					image = new FlxSprite(spr.x + 15, spr.y + 13).loadGraphic(Paths.image('desktop/gallery/official/' + i + 'locked'));
			}
			if (i == 6) {
				if (!FlxG.save.data.beatBob)
					image = new FlxSprite(spr.x + 15, spr.y + 13).loadGraphic(Paths.image('desktop/gallery/official/' + i + 'locked'));
			}
			officialImageLocations.push('desktop/gallery/official/' + Std.string(i));
			officialPictures.add(image);
			image.origin.set(0, 0);
			image.setGraphicSize(292, 165);
			image.updateHitbox();
				
			//image.setPosition(spr.x + 15, spr.y + 13);
			image.visible = false;
			spr.visible = false;
			officialGallery.add(spr);
			spr.y += FlxG.height;
			image.y += FlxG.height;
			//image.origin.set(image.width / 2, image.height / 2);
		}
		
		for (i in 0...3) {
			var spr:FlxSprite = new FlxSprite(21, 1271).loadGraphic(Paths.image('desktop/gallery/thumbnailPad'));
			var image:FlxSprite = new FlxSprite();
			image = new FlxSprite(spr.x + 15, spr.y + 13).loadGraphic(Paths.image('desktop/gallery/cool/' + i));
			uImageLocations.push('desktop/gallery/cool/' + Std.string(i));
			uPictures.add(image);
			image.origin.set(0, 0);
			image.setGraphicSize(292, 165);
			image.updateHitbox();
			image.visible = false;
			spr.visible = false;
			uGallery.add(spr);
			spr.y += FlxG.height;
			image.y += FlxG.height;
		}

		for (i in 0...36) {
			var spr:FlxSprite = new FlxSprite(21, 113).loadGraphic(Paths.image('desktop/gallery/thumbnailPad'));
			var image:FlxSprite = new FlxSprite();
			image = new FlxSprite(spr.x + 15, spr.y + 13).loadGraphic(Paths.image('desktop/gallery/fanmade/' + i));
			fanmadeImageLocations.push('desktop/gallery/fanmade/' + Std.string(i));
			fanmadePictures.add(image);
			image.origin.set(0, 0);
			image.setGraphicSize(292, 165);
			image.updateHitbox();
			image.visible = false;
			spr.visible = false;
			fanmadeGallery.add(spr);
			spr.y += FlxG.height;
			image.y += FlxG.height;
		}

		for (i in 0...59) {
			var spr:FlxSprite = new FlxSprite(21, 113).loadGraphic(Paths.image('desktop/gallery/thumbnailPad'));
			var image:FlxSprite = new FlxSprite();
			image = new FlxSprite(spr.x + 15, spr.y + 13).loadGraphic(Paths.image('loading/' + i));
			loadingImageLocations.push('loading/' + Std.string(i));
			loadingPictures.add(image);
			image.origin.set(0, 0);
			image.setGraphicSize(1280, 720);
			//image.scale.set(0.23, 0.23);
			image.setGraphicSize(292, 165);
			image.updateHitbox();
			image.visible = false;
			spr.visible = false;
			loadingGallery.add(spr);
			spr.y += FlxG.height;
			image.y += FlxG.height;

			
		}
		var spr = new FlxSprite(479, 1200).loadGraphic(Paths.image('desktop/gallery/thumbnailPad'));
		var image = new FlxSprite(spr.x + 15, spr.y + 13).loadGraphic(Paths.image('bitmaps/bitmaps/bitmaps/bitmaps/bitmaps/bitmaps/bitmaps'));
		loadingImageLocations.push('bitmaps/bitmaps/bitmaps/bitmaps/bitmaps/bitmaps/bitmaps');
		loadingPictures.add(image);
		image.origin.set(0, 0);
		image.setGraphicSize(292, 165);
		image.updateHitbox();
		image.visible = false;
		spr.visible = false;
		loadingGallery.add(spr);
		spr.y += FlxG.height;
		image.y += FlxG.height;

	var sprite:FlxSprite;
		
		freeplayName = D.cfN;
		sprite = new FlxSprite().loadGraphic(Paths.image(D.cfD), false, 100, 100, true);
		
		var sprite2:FlxSprite = new FlxSprite().loadGraphic(Paths.image('desktop/galleryIcon'), false, 0, 0, true);
		var sprite3:FlxSprite = new FlxSprite().loadGraphic(Paths.image('desktop/bob and bosip'), false, 0, 0, true);
		var sprite4:FlxSprite = new FlxSprite().loadGraphic(Paths.image('desktop/cogIcon'), false, 0, 0, true);
		var sprite5:FlxSprite = new FlxSprite().loadGraphic(Paths.image('desktop/notepadIcon'), false, 0, 0, true);
		var sprite6:FlxSprite = new FlxSprite().loadGraphic(Paths.image('desktop/recordIcon'), false, 0, 0, true);
		var sprite7:FlxSprite = new FlxSprite().loadGraphic(Paths.image('desktop/coolIcon'), false, 0, 0, true);
		var sprite8:FlxSprite = new FlxSprite().loadGraphic(Paths.image('desktop/trophyIcon'), false, 0, 0, true);
		
		var sprFolder:FlxExtendedSprite = new FlxExtendedSprite(307.5, 65, sprite.graphic);
		folders.add(sprFolder);
		if (D.cfi == 3) {
			sprFolder.scale.set(5.85, 5.85);
			sprFolder.updateHitbox();
		}
		var sprFolder2:FlxExtendedSprite = new FlxExtendedSprite(184.5, 65, sprite2.graphic);
		folders.add(sprFolder2);

		var sprFolder3:FlxExtendedSprite = new FlxExtendedSprite(61.5, 65, sprite3.graphic);
		folders.add(sprFolder3);

		var sprFolder4:FlxExtendedSprite = new FlxExtendedSprite(430.5, 65, sprite4.graphic);
		folders.add(sprFolder4);

		var sprFolder5:FlxExtendedSprite = new FlxExtendedSprite(184.5, 195, sprite5.graphic);
		folders.add(sprFolder5);

		var sprFolder6:FlxExtendedSprite = new FlxExtendedSprite(307.5, 195, sprite6.graphic);
		folders.add(sprFolder6);

		var sprFolder8:FlxExtendedSprite = new FlxExtendedSprite(61.5, 195, sprite8.graphic);
		folders.add(sprFolder8);


		var sprFolder7:FlxExtendedSprite = new FlxExtendedSprite(738, 260, sprite7.graphic);
		if (folderData.contains('perfect all songs'))
			folders.add(sprFolder7);

		

		if (FlxG.save.data.folders != null) {
			loadFolders();
		}
	

		reloadStickers();
		for (i in folders) {
			/*if (FlxG.mouse.overlaps(i)) {
				if (FlxG.mouse.justPressedRight && D.gfU || FlxG.mouse.justPressedRight && D.gfU) {
					D.cfi++;
					FlxG.resetState();
				}
			}*/

			
			
			i.mouseStartDragCallback = function (obj:FlxExtendedSprite, xPos:Int, yPos:Int) {
				new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					draggingFolder = true;
					
				});
				visualDragFolder = true;
				prevPos = i.getPosition();
			};
			
			i.mouseReleasedCallback = function (obj:FlxExtendedSprite, xPos:Int, yPos:Int) {
				if (!draggingFolder && !closingFolder) {
					var doStuff:Bool = false;
					if (folderDrag.visible == true) {
						if (!FlxG.mouse.overlaps(folder.members[0]))
							doStuff = true;
					} else if (notepadDrag.visible == true) {
						if (!FlxG.mouse.overlaps(notepad.members[0]))
							doStuff = true;
					} else doStuff = true;
					
					if (doStuff) {
						enterFolder(folderData[folders.members.indexOf(i)], i);
					}
				}
			}

			i.mouseStopDragCallback = centerFolder;
			i.enableMouseSnap(123, 130, false, true);
			i.enableMouseDrag(false);
			i.boundsRect = new FlxRect(0, 0, FlxG.width, FlxG.height);

			var folderText:FlxText = new FlxText(i.x - 32, i.y + 80, 150, folderData[folders.members.indexOf(i)], 16, true);
			if (FlxG.save.data.wallpaperTextColor != null)
				folderText.setFormat(Paths.font('PUSAB.otf'), 20, FlxG.save.data.wallpaperTextColor, CENTER);
			else
				folderText.setFormat(Paths.font('PUSAB.otf'), 20, FlxColor.WHITE, CENTER);
			if (folderData[folders.members.indexOf(i)] == 'freeplay')
				folderText.text = freeplayName;
			folderText.antialiasing = true;
			folderLabels.add(folderText);
		}
		for (i in 0...10) {
			var spr:FlxSprite = new FlxSprite();
			switch (i) 
			{
				case 0:
					if (D.gfU) {
						switch (D.cfi) {
							case 1:
								spr = new FlxSprite().loadGraphic(Paths.image('desktop/folder/cool/folderMainGold'));
							default:
								spr = new FlxSprite().loadGraphic(Paths.image('desktop/folder/folderMain'));
						}
					} else {
						spr = new FlxSprite().loadGraphic(Paths.image('desktop/folder/folderMain'));
					}
					
					
				case 1:
					spr = new FlxSprite(23, 105).loadGraphic(Paths.image('desktop/folder/textTitles'));
				case 2:
					spr = new FlxSprite(93, 42).loadGraphic(Paths.image('desktop/folder/textHome'));
				case 3:
					spr = new FlxSprite(164, 42).loadGraphic(Paths.image('desktop/folder/textShare'));
				case 4:
					spr = new FlxSprite(45, 132).loadGraphic(Paths.image('desktop/folder/textAshArt'));
				case 5:
					spr = new FlxSprite(45, 208).loadGraphic(Paths.image('desktop/folder/textFreeplay'));
				case 6:
					spr = new FlxSprite(46, 231).loadGraphic(Paths.image('desktop/folder/textGallery'));
				case 7:
					spr = new FlxSprite(45, 254).loadGraphic(Paths.image('desktop/folder/textMods'));
				case 8:
					spr = new FlxSprite(45, 278).loadGraphic(Paths.image('desktop/folder/textOptions'));
				case 9:
					spr = new FlxSprite(13, 11).loadGraphic(Paths.image('desktop/folder/buttonExit'));
			}
			folderOffsets.push(new FlxPoint(spr.x, spr.y));
			spr.antialiasing = true;
			spr.visible = false;
			folder.add(spr);
			spr.x += 176;
			spr.y += 88;
		}
		
		for (i in 0...9) {
			checkAchievements();
			var spr:Dynamic;
			switch (i) 
			{
				case 0:
					spr = new FlxSprite().loadGraphic(Paths.image('desktop/rack/trophyBackground'));
				case 1:
					if (achievementsUnlocked.get('bnb-perfect'))
						spr = new FlxSprite(70, 61).loadGraphic(Paths.image('desktop/rack/bobGold'));
					else
						spr = new FlxSprite(70, 61).loadGraphic(Paths.image('desktop/rack/bobGold(outline)'));
					trophies.push(spr);
				case 2:
					if (achievementsUnlocked.get('itb-perfect'))
						spr = new FlxSprite(70, 227).loadGraphic(Paths.image('desktop/rack/bluGold'));
					else
						spr = new FlxSprite(70, 227).loadGraphic(Paths.image('desktop/rack/bluGold(outline)'));
					trophies.push(spr);
				case 3:
					if (myButt)
						spr = new FlxSprite(70, 400).loadGraphic(Paths.image('desktop/rack/exGold'));
					else
						spr = new FlxSprite(70, 400).loadGraphic(Paths.image('desktop/rack/exGold(outline)'));
					trophies.push(spr);
				case 4:
					if (achievementsUnlocked.get('takeover-normal'))
						spr = new FlxSprite(347, 56).loadGraphic(Paths.image('desktop/rack/bobnron'));
					else
						spr = new FlxSprite(347, 56).loadGraphic(Paths.image('desktop/rack/bobnron(outline)'));
					trophies.push(spr);
				case 5:
					if (achievementsUnlocked.get('itb-normal'))
						spr = new FlxSprite(332, 227).loadGraphic(Paths.image('desktop/rack/bluSilver'));
					else
						spr = new FlxSprite(332, 227).loadGraphic(Paths.image('desktop/rack/bluSilver(outline)'));
					trophies.push(spr);
				case 6:
					if (achievementsUnlocked.get('ex-normal'))
						spr = new FlxSprite(332, 396).loadGraphic(Paths.image('desktop/rack/exSilver'));
					else
						spr = new FlxSprite(332, 396).loadGraphic(Paths.image('desktop/rack/exSilver(outline)'));
					trophies.push(spr);
				case 7:
					spr = new FlxSprite(374, 7).loadGraphic(Paths.image('desktop/rack/trophyRoom'));
				case 8:
					spr = new FlxText(548, 402, 487,'Hover over a trophy to see how you unlock it!', 15, true);
					spr.setFormat(Paths.font('PUSAB.otf'), 19, FlxColor.BLACK, LEFT);
					trText = spr;
				default:
					spr = new FlxSprite();

			}
			
			trOffsets.push(new FlxPoint(spr.x, spr.y));
			spr.antialiasing = true;
			spr.visible = false;
			tr.add(spr);
				
			spr.x += 107;
			spr.y += 83;
		}
		
		for (i in 0...4) {
			switch (i) {
				case 0:
					var notespr = new FlxSprite().loadGraphic(Paths.image('desktop/notepad/notepadBackground'));
					notepadOffsets.push(new FlxPoint(notespr.x, notespr.y));
					notespr.visible = false;
					notespr.x += 306;
					notespr.y += 25;
					notepad.add(notespr);
				case 1:
					var notespr = new FlxText(30, 70, 600,':)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))', 15, true);
					notespr.setFormat(Paths.font('PUSAB.otf'), 19, FlxColor.BLACK, LEFT);
					var easyFormat = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromString('0x319E16'), true, true), '@');
					var normalFormat = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromString('0x1685AD'), true, true), '#');
					var hardFormat = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromString('0xDB5F00'), true, true), '^');
					var exFormat = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromString('0xE60A85'), true, true), '%');
					var blackFormat = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromString('0x000000'), true, true), '&');
					var goldFormat = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromString('0xFFA538'), true, true), '*');

					var theText:String = '';

					for (i in songs) {
						if (songsUnlocked[songs.indexOf(i)]) { 
							var songHighscore = StringTools.replace(i, " ", "-");
							switch (songHighscore) {
								case 'Dad-Battle': songHighscore = 'Dadbattle';
								case 'Philly-Nice': songHighscore = 'Philly';
							}
							theText +=  '&' + i + '&\n';
							switch (i.toLowerCase()) {
								case 'jump-out' | 'ronald mcdonald slide':
									theText += '&-& ^hard^ &score:& ^' + Highscore.getScore(songHighscore, 2) + '^\n';
									if (Highscore.getMissesString(songHighscore, 2) == '0')
										theText += '&-& ^hard^ &misses:& *Cheater!*\n';
									else if (Highscore.getMissesString(songHighscore, 2) == 'N/A')
										theText += '&-& ^hard^ &misses:& ^' + Highscore.getMissesString(songHighscore, 2) + '^\n';
									else
										theText += '&-& ^hard^ &misses:& *Clear!* &(' + Highscore.getMissesString(songHighscore, 2) + ')&\n';
								case 'copy-cat':
									theText += '&-& ^hard^ &score:& ^' + Highscore.getScore(songHighscore, 2) + '^\n';
									if (Highscore.getMissesString(songHighscore, 2) == '0')
										theText += '&-& ^hard^ &misses:& *Perfect!*\n';
									else
										theText += '&-& ^hard^ &misses:& ^' + Highscore.getMissesString(songHighscore, 2) + '^\n';
								default:
									for (diff in 0...3) {
								
										switch (diff) {
											case 0:
												theText += '&-& @easy@ &score:& @' + Highscore.getScore(songHighscore, diff) + '@\n';
												if (Highscore.getMissesString(songHighscore, diff) == '0')
													theText += '&-& @easy@ &misses:& *Perfect!*\n';
												else
													theText += '&-& @easy@ &misses:& @' + Highscore.getMissesString(songHighscore, diff) + '@\n';
											case 1:
												theText += '&-& #normal# &score:& #' + Highscore.getScore(songHighscore, diff) + '#\n';
												if (Highscore.getMissesString(songHighscore, diff) == '0')
													theText += '&-& #normal# &misses:& *Perfect!*\n';
												else
													theText += '&-& #normal# &misses:& #' + Highscore.getMissesString(songHighscore, diff) + '#\n';
											case 2:
												theText += '&-& ^hard^ &score:& ^' + Highscore.getScore(songHighscore, diff) + '^\n';
												if (Highscore.getMissesString(songHighscore, diff) == '0')
													theText += '&-& ^hard^ &misses:& *Perfect!*\n';
												else
													theText += '&-& ^hard^ &misses:& ^' + Highscore.getMissesString(songHighscore, diff) + '^\n';
										}
									}
							}
							
							if (FileSystem.exists(Paths.instEXcheck(i))) {
								theText += '&-& %ex% &score:& %' + Highscore.getScore(songHighscore, 3) + '%\n';
								if (Highscore.getMissesString(songHighscore, 3) == '0')
									theText += '&-& %ex% &misses:& *Perfect!*\n';
								else
									theText += '&-& %ex% &misses:& %' + Highscore.getMissesString(songHighscore, 3) + '%\n';
								
							}
						}
					}
					
					//statsScrollMax = -890;
					
					notespr.applyMarkup(theText, [easyFormat, normalFormat, hardFormat, exFormat, blackFormat, goldFormat]);
					var textArray:Array<String> = theText.split('\n');
					for (i in 0...textArray.length) { 
						var theTextSprite:FlxText = new FlxText(30, 70, 600,'', 15, true);
						theTextSprite.setFormat(Paths.font('PUSAB.otf'), 19, FlxColor.BLACK, LEFT);
						theTextSprite.applyMarkup(textArray[i], [easyFormat, normalFormat, hardFormat, exFormat, blackFormat, goldFormat]);
						theTextSprite.y += 30 * i;
						notepadOffsets.push(new FlxPoint(theTextSprite.x, theTextSprite.y));
						statsScrollMax -= 30;
						theTextSprite.visible = false;
						theTextSprite.x += 306;
						theTextSprite.y += 25;
						notepadTextArray.push(theTextSprite);
						notepad.add(theTextSprite);
					}
					statsScrollMax += 23 * 30;
					trace(statsScrollMax);
				case 2:
					var notespr = new FlxSprite().loadGraphic(Paths.image('desktop/notepad/notepadBorder'));
					notepadOffsets.push(new FlxPoint(notespr.x, notespr.y));
					notespr.visible = false;
					notespr.x += 306;
					notespr.y += 25;
					notepad.add(notespr);
				case 3:
					var notespr = new FlxSprite(30, 15).loadGraphic(Paths.image('desktop/gallery/xText'));
					notepadOffsets.push(new FlxPoint(notespr.x, notespr.y));
					notespr.visible = false;
					notespr.x += 306;
					notespr.y += 25;
					notepad.add(notespr);
			}
			
		}

		for (i in 0...songs.length) {
			if (songs[i].toLowerCase() != 'gameover' || songs[i].toLowerCase() == 'gameover' && FlxG.save.data.playedGO) {
				var mod:String = '';
				if (freeplayName == 'freeplay EX') 
					mod = '-ex';
				var spr:HealthIcon = new HealthIcon(iconArray[i] + mod);
				var locks:HealthIcon = new HealthIcon('nothing');
				if (!songsUnlocked[i]) {
					spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 0.2, 1);
					locks = new HealthIcon('lock');
				}
				locks.visible = false;
				locks.scale.set(0.8, 0.8);
				locks.updateHitbox();
				locks.width = 86;
				locks.height = 77;
				locks.offset.set(30, 35);
	
				spr.visible = false;
				spr.scale.set(0.8, 0.8);
				spr.updateHitbox();
				spr.width = 86;
				spr.height = 77;
				spr.offset.set(30, 35);
				freeplayStuff.add(spr);
				
				freeplayOffsets.push(new FlxPoint((136 * (i % 5)) + 261, 95 + (130 * Math.floor(i / 5))));
				spr.setPosition(freeplayOffsets[i].x + 176, freeplayOffsets[i].y + 88);
	
				var ftext:FlxText = new FlxText(spr.x - 18, spr.y + 80, 120, songs[i], 15, true);
				ftext.setFormat(Paths.font('PUSAB.otf'), 19, FlxColor.WHITE, CENTER);
				if (!songsUnlocked[i]) {
					ftext.text = '???';
					ftext.setFormat(Paths.font('PUSAB.otf'), 19, FlxColor.GRAY, CENTER);
				}
				ftext.antialiasing = true;
				ftext.visible = false;
				freeplayLabels.add(ftext);
	
				locks.setPosition(spr.x, spr.y);
				freeplayLocks.add(locks);
			}
			
		}
		
		var imDumb:FlxSprite = new FlxSprite().makeGraphic(926, 26, FlxColor.TRANSPARENT);
		folderDrag = new FlxExtendedSprite(176, 88, imDumb.graphic);
		folderDrag.boundsRect = new FlxRect(0, 0, FlxG.width, FlxG.height);
		folderDrag.enableMouseDrag(false);
		folderDrag.visible = false;

		var imDumb2:FlxSprite = new FlxSprite().makeGraphic(669, 54, FlxColor.TRANSPARENT);
		notepadDrag = new FlxExtendedSprite(306, 25, imDumb2.graphic);
		notepadDrag.boundsRect = new FlxRect(0, 0, FlxG.width, FlxG.height);
		notepadDrag.enableMouseDrag(false);
		notepadDrag.visible = false;

		var imDumb3:FlxSprite = new FlxSprite().makeGraphic(1056, 50, FlxColor.TRANSPARENT);
		trDrag = new FlxExtendedSprite(107, 83, imDumb3.graphic);
		trDrag.boundsRect = new FlxRect(0, 0, FlxG.width, FlxG.height);
		trDrag.enableMouseDrag(false);
		trDrag.visible = false;

		if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
			if (FlxG.save.data.defaultMusic != null)
				FlxG.sound.playMusic(FlxG.save.data.defaultMusic, 0.5);
			else
				FlxG.sound.playMusic(Paths.music('desktop'), 0.5);
			
		}
	}

	function reloadStickers()
	{
		if (stickers != null)
			stickers.clear();
		if (desktopStickers.exists('ash_soda')) {
			var ashSodaSticker:FlxSprite = new FlxSprite(desktopStickers.get('ash_soda').x, desktopStickers.get('ash_soda').y).loadGraphic(Paths.image('ash_soda'));
			ashSodaSticker.antialiasing = true;
			ashSodaSticker.scale.set(0.5, 0.5);
			ashSodaSticker.updateHitbox();
			stickers.add(ashSodaSticker);
		}
	}

	function reloadInterractables()
	{
		if (sstuff != null)
			sstuff.clear();
		for (i in 0...5) {
			var light1:FlxSprite = new FlxSprite(167, 24).loadGraphic(Paths.image('bitmaps/bitmaps/bitmaps/bitmaps/bitmaps/bitmaps/on'));
			light1.antialiasing = true;
			sstuff.add(light1);
			switch (i) {
				case 0:
					light1.setPosition(167, 24);
				case 1:
					light1.setPosition(245, 24);
				case 2:
					light1.setPosition(320, 24);
				case 3:
					light1.setPosition(398, 24);
				case 4:
					light1.setPosition(472, 24);
			}
			light1.visible = false;
		}
		if (FlxG.save.data.wallpaper == 'bitmaps/bitmaps/bitmaps/bitmaps/bitmaps/bitmaps/bitmaps') {
			if (D.efU) {
				sstuff.members[0].visible = true;
			}
			if (D.pfU) {
				sstuff.members[1].visible = true;
			}
			if (D.gfU) {
				sstuff.members[2].visible = true;
			}
			if (D.afU) {
				sstuff.members[4].visible = true;
			}
		}
	}
	function centerFolder(obj:FlxExtendedSprite, xPos:Int, yPos:Int) 
	{
		obj.x += 61.5;
		obj.y += 65;
		for (i in folders) {
			if (i != obj) {
				if (obj.x == i.x && obj.y == i.y) {
					obj.x = prevPos.x;
					obj.y = prevPos.y;
				}
			}
		}
		new FlxTimer().start(0.05, function(tmr:FlxTimer)
		{
			draggingFolder = false;
			visualDragFolder = false;
		});
		saveFolders();
	}

	function enterFolder(fol:String, spr:FlxSprite) {
		switch (fol) {
			case 'gallery':
				var leState:GallerySubstate = new GallerySubstate(spr.getPosition(), galleryWall);
				leState.updateBackground = updateBG;
				leState.fanmadeGallery = fanmadeGallery;
				leState.officialGallery = officialGallery;
				leState.fanmadePictures = fanmadePictures;
				leState.officialPictures = officialPictures;
				leState.officialImageLocations = officialImageLocations;
				leState.fanmadeImageLocations = fanmadeImageLocations;

				leState.loadingPictures = loadingPictures;
				leState.loadingGallery = loadingGallery;
				leState.loadingImageLocations = loadingImageLocations;
				openSubState(leState);
			case 'freeplay' | 'ex freeplay':
				if (folderDrag.visible && canOpenFolder) {
					closeFolder();
				}
				else if (canOpenFolder) {
					canOpenFolder = false;
					folder.members[0].scale.set(0.9, 0.9);
					for (i in freeplayStuff) {
						i.alpha = 0;
						i.visible = true;
						FlxTween.tween(i, {alpha: 1}, 0.2, {ease: FlxEase.cubeOut, startDelay: 0.05});
					}
					for (i in freeplayLocks) {
						i.alpha = 0;
						i.visible = true;
						FlxTween.tween(i, {alpha: 1}, 0.2, {ease: FlxEase.cubeOut, startDelay: 0.05});
					}
					
					for (i in freeplayLabels) {
						i.alpha = 0;
						i.visible = true;
						FlxTween.tween(i, {alpha: 1}, 0.2, {ease: FlxEase.cubeOut, startDelay: 0.05});
					}
					for (i in folder) {
						i.alpha = 0;
						i.visible = true;
						FlxTween.tween(i, {alpha: 1}, 0.2, {ease: FlxEase.cubeOut, 
						onComplete: function (twn:FlxTween) {
							canOpenFolder = true;
						},});
						if (folder.members.indexOf(i) == 0) 
							FlxTween.tween(folder.members[0].scale, {x: 1, y: 1}, 0.2, {ease: FlxEase.cubeOut});
						currentMenu = 'freeplay';
						add(folderDrag);
						folderDrag.visible = true;
					}
					remove(notepad);
					remove(folder);
					remove(freeplayStuff);
					remove(freeplayLocks);
					remove(freeplayLabels);
					add(notepad);
					add(folder);
					add(freeplayStuff);
					add(freeplayLocks);
					add(freeplayLabels);
				}
			case 'bob & bosip':
				openSubState(new ApplicationEnterSubstate());
			case 'options':
				OptionsSubState.inDesktop = true;
				openSubState(new OptionsSubState(spr.getPosition()));
			case 'stats':
				if (notepadDrag.visible) {
					closeNotepad();
				} else {
					if (canOpenNotepad) {
						canOpenNotepad = false;
						notepad.members[0].scale.set(0.9, 0.9);
						notepad.members[notepad.length - 2].scale.set(0.9, 0.9);
						for (i in notepad) {
							i.alpha = 0;
							i.visible = true;
							FlxTween.tween(i, {alpha: 1}, 0.2, {ease: FlxEase.cubeOut, 
							onComplete: function (twn:FlxTween) {
								canOpenNotepad = true;
							},});
							if (notepad.members.indexOf(i) == 0 || notepad.members.indexOf(i) == notepad.length - 2) 
								FlxTween.tween(notepad.members[notepad.members.indexOf(i)].scale, {x: 1, y: 1}, 0.2, {ease: FlxEase.cubeOut});
							currentMenu = 'notepad';
							
							
						}
						add(notepadDrag);
						notepadDrag.visible = true;
						for (i in 0...notepadTextArray.length) {
							if (notepadOffsets[i + 1].y < 30)
								notepadTextArray[i].visible = false;
							else if (notepadOffsets[i + 1].y > 660)
								notepadTextArray[i].visible = false;
							else 
								notepadTextArray[i].visible = true;
						}
						remove(notepad);
						remove(folder);
						remove(freeplayStuff);
						remove(freeplayLocks);
						remove(freeplayLabels);
						add(folder);
						add(freeplayStuff);
						add(freeplayLocks);
						add(freeplayLabels);
						add(notepad);
					}
				}
			case 'trophy rack':
				if (trDrag.visible) {
					closeTR();
				} else {
					if (canOpenTR) {
						canOpenTR = false;
						tr.members[0].scale.set(0.9, 0.9);
						tr.members[tr.length - 2].scale.set(0.9, 0.9);
						for (i in tr) {
							i.alpha = 0;
							i.visible = true;
							FlxTween.tween(i, {alpha: 1}, 0.2, {ease: FlxEase.cubeOut, 
							onComplete: function (twn:FlxTween) {
								canOpenTR = true;
							},});
							if (tr.members.indexOf(i) == 0 || tr.members.indexOf(i) == tr.length - 2) 
								FlxTween.tween(tr.members[tr.members.indexOf(i)].scale, {x: 1, y: 1}, 0.2, {ease: FlxEase.cubeOut});
							currentMenu = 'trophy rack';
						}
						add(trDrag);
						trDrag.visible = true;
						remove(notepad);
						remove(folder);
						remove(tr);
						remove(freeplayStuff);
						remove(freeplayLocks);
						remove(freeplayLabels);
						add(folder);
						add(freeplayStuff);
						add(freeplayLocks);
						add(freeplayLabels);
						add(notepad);
						add(tr);
					}
				}
			case 'sound test':
				openSubState(new MusicPlayerSubstate(spr.getPosition(), songsUnlocked));
			case 'perfect all songs':
				FlxG.save.data.beatWeek = true;
				FlxG.save.data.unlockedEX = true;
				FlxG.save.data.beatITB = true;
				for (i in 0...songs.length)
				{
					songsUnlocked[i] = true;
					var songHighscore = StringTools.replace(songs[i], " ", "-");
						switch (songHighscore) {
							case 'Dad-Battle': songHighscore = 'Dadbattle';
							case 'Philly-Nice': songHighscore = 'Philly';
					}
					for (diff in 0...3) {
						switch (diff) {
							case 0:
								Highscore.setScore(songHighscore + '-easy', 1);
								Highscore.saveMisses(songHighscore, 0, 0);
							case 1:
								Highscore.setScore(songHighscore, 1);
								Highscore.saveMisses(songHighscore, 0, 1);
							case 2:
								Highscore.setScore(songHighscore + '-hard', 1);
								Highscore.saveMisses(songHighscore, 0, 2);
						}
						
					}
					Highscore.saveMisses(songHighscore, 0, 3);
					FlxG.save.data.unlockedEX = true;
				}
				FlxG.resetState();

		}
	}

	public function saveFolders() 
	{
		FlxG.save.data.folders = new Array<FlxPoint>();
		for (i in 0...folders.length) {
			FlxG.save.data.folders[i] = folders.members[i].getPosition();
		}
	}

	function loadFolders() {
		for (i in 0...folders.length) {
			if (FlxG.save.data.folders[i] != null)
				folders.members[i].setPosition(FlxG.save.data.folders[i].x, FlxG.save.data.folders[i].y);
		}
	}

	function checkFolders():Bool
	{
		var yes:Bool = true;
		if (folderDrag.visible == true) {
			if (FlxG.mouse.overlaps(folder.members[0]))
				yes = false;
		}

		if (notepadDrag.visible == true) {
			if (FlxG.mouse.overlaps(notepad.members[0]))
				yes = false;
		}

		if (trDrag.visible == true) {
			if (FlxG.mouse.overlaps(tr.members[0]))
				yes = false;
		}
		if (FlxG.mouse.overlaps(folders))
			yes = false;


		return yes;
	}
	override function update(elapsed:Float)
	{
		if (theSong != null)
			theSong.volume = FlxG.sound.volume;
		FlxG.watch.addQuick("menu: ", currentMenu);	
		FlxG.watch.addQuick("closingFolder: ", closingFolder);
		for (i in folders) {
			if (FlxG.mouse.overlaps(i) && !i.isDragged) {
				var doStuff:Bool = false;
				if (folderDrag.visible == true) {
					if (!FlxG.mouse.overlaps(folder.members[0]))
						doStuff = true;
				} else if (notepadDrag.visible == true) {
					if (!FlxG.mouse.overlaps(notepad.members[0]))
						doStuff = true;
				} else if (trDrag.visible == true) {
					if (!FlxG.mouse.overlaps(tr.members[0]))
						doStuff = true;
				} else doStuff = true;

				if (doStuff) {
					folderBorder.x = i.x - 18;
					folderBorder.y = i.y - 24;
					folderBorder.visible = true;
				}
			}
		}
		if (!FlxG.mouse.overlaps(folders) || visualDragFolder || FlxG.mouse.overlaps(folder.members[0]) && folderDrag.visible == true || FlxG.mouse.overlaps(notepad.members[0]) && notepadDrag.visible == true || FlxG.mouse.overlaps(tr.members[0]) && trDrag.visible == true)
			folderBorder.visible = false;
		if (visualDragFolder) {
			for (i in 0...folders.length) {
				var spr = folders.members[i];
				folderLabels.members[i].setPosition(spr.x - 32, spr.y + 80);
			}
		}
		for (i in stickers) {
			if (checkFolders() && FlxG.mouse.overlaps(i) && FlxG.mouse.justPressed) {
				desktopStickers.remove('ash_soda');
				reloadStickers();
				openSubState(new BoyPlaceSubState(false, addSoda));
			}
			if (checkFolders() && FlxG.mouse.overlaps(i) && FlxG.mouse.justPressedRight) {
				desktopStickers.remove('ash_soda');
				reloadStickers();
			}
		}
		if (FlxG.keys.justPressed.ANY) {

			var hitCorrectKey:Bool = false;
			for (i in 0...theCode[theCodeOrder].length) {
				if (FlxG.keys.checkStatus(theCode[theCodeOrder][i], JUST_PRESSED))
					hitCorrectKey = true;
			}
			if (hitCorrectKey) {
				if (theCodeOrder == (theCode.length - 1)) {
					if (!FlxG.save.data.pol) {
						achievementArray.push('Unlocked a new folder skin for &finding a secret&');
						FlxG.save.data.pol = true;
						reloadInterractables();
					}
				} else {
					theCodeOrder++;
					
				}
			} else {
				theCodeOrder = 0;
				for (i in 0...theCode[0].length) {
					if (FlxG.keys.checkStatus(theCode[0][i], JUST_PRESSED))
						theCodeOrder = 1;
				}
			}
		}
		//sorry i got very lazy ; w ;
		if (FlxG.keys.justPressed.ANY) {

			var hitCorrectKey:Bool = false;
			for (i in 0...theCode2[theCodeOrder2].length) {
				if (FlxG.keys.checkStatus(theCode2[theCodeOrder2][i], JUST_PRESSED))
					hitCorrectKey = true;
			}
			if (hitCorrectKey) {
				if (theCodeOrder2 == (theCode2.length - 1)) {
					var leState:Um = new Um(new FlxPoint(FlxG.width / 2, FlxG.height / 2), fWall);
					leState.updateBackground = updateBG;
					leState.gallery = uGallery;
					leState.pictures = uPictures;
					leState.imageLocations = uImageLocations;
					openSubState(leState);
				} else {
					theCodeOrder2++;
					
				}
			} else {
				theCodeOrder2 = 0;
				for (i in 0...theCode2[0].length) {
					if (FlxG.keys.checkStatus(theCode2[0][i], JUST_PRESSED))
						theCodeOrder2 = 1;
				}
			}
		}
		if (FlxG.mouse.overlaps(theBoy) && FlxG.mouse.justPressed && checkFolders() && FlxG.save.data.wallpaper == 'loading/14') {
			openSubState(new BoyPlaceSubState(true, addSoda));
			FlxG.save.data.wallpaper = 'loading/14-alt';
			updateBG();
		}
		

		if (FlxG.mouse.overlaps(folders)) {
			for (i in 0...folders.length) {
				switch (folderData[i]) {
					case 'freeplay':
						if (FlxG.mouse.justPressedRight && D.gfU || FlxG.mouse.justPressedRight && D.efU || FlxG.mouse.justPressedRight && D.pfU) {
							D.cfi++;
							FlxG.resetState();
						}
				}
			}
			
		}
		if (notepadDrag.visible) {
			if (FlxG.keys.justPressed.ESCAPE && canOpenNotepad && currentMenu == 'notepad') {
				closeNotepad();
				
			}
			
			var exitButton = notepad.members[notepad.length - 1];
			if (FlxG.mouse.overlaps(notepad.members[notepad.length - 1])) {
				exitButton.color = FlxColor.fromHSL(exitButton.color.hue, exitButton.color.saturation, 1, 1);
				if (canOpenNotepad && currentMenu == 'notepad' && FlxG.mouse.justPressed) {
					closeNotepad();
					closingFolder = true;
				}
			} else {
				exitButton.color = FlxColor.fromHSL(exitButton.color.hue, exitButton.color.saturation, 0.7, 1);
			}
			if (FlxG.mouse.justReleased)
				closingFolder = false;

			if (notepadDrag.isDragged) {
				for (i in notepad) {
					i.setPosition(notepadDrag.x + notepadOffsets[notepad.members.indexOf(i)].x, notepadDrag.y + notepadOffsets[notepad.members.indexOf(i)].y);
				}
			}
			if (FlxG.mouse.y > 54 + notepad.members[0].y && FlxG.mouse.overlaps(notepad.members[0])) {
				var doStuff:Bool = false;
				if (folderDrag.visible && currentMenu == 'freeplay') {
					if (!FlxG.mouse.overlaps(folder.members[0]))
						doStuff = true;
				} else
					doStuff = true;
				
				if (doStuff) {
					if (FlxG.mouse.wheel > 0 && notepadOffsets[1].y < 70) { //&& notepadOffsets[notepadTextArray.length - 1].y < statsScrollMax) {
						for (i in 0...notepadTextArray.length) {
							notepadOffsets[i + 1].y += FlxG.mouse.wheel * 30;
							notepadTextArray[i].setPosition(notepadDrag.x + notepadOffsets[i + 1].x, notepadDrag.y + notepadOffsets[i + 1].y);
							if (notepadOffsets[i + 1].y < 30)
								notepadTextArray[i].visible = false;
							else if (notepadOffsets[i + 1].y > 660)
								notepadTextArray[i].visible = false;
							else 
								notepadTextArray[i].visible = true;
						}
					}
					
					if (FlxG.mouse.wheel < 0 && notepadOffsets[1].y > statsScrollMax) { //&& notepadOffsets[notepadTextArray.length - 1].y < statsScrollMax) {
						for (i in 0...notepadTextArray.length) {
							notepadOffsets[i + 1].y += FlxG.mouse.wheel * 30;
							notepadTextArray[i].setPosition(notepadDrag.x + notepadOffsets[i + 1].x, notepadDrag.y + notepadOffsets[i + 1].y);
							if (notepadOffsets[i + 1].y < 30)
								notepadTextArray[i].visible = false;
							else if (notepadOffsets[i + 1].y > 660)
								notepadTextArray[i].visible = false;
							else 
								notepadTextArray[i].visible = true;
						}
						trace(notepadOffsets[1].y);
					}
						/*notepadOffsets[1].y += FlxG.mouse.wheel * 24;
						notepad.members[1].setPosition(notepadDrag.x + notepadOffsets[1].x, notepadDrag.y + notepadOffsets[1].y);*/

					/*}
					if (FlxG.mouse.wheel > 0 && notepadOffsets[1].y < 70) {
						notepadOffsets[1].y += FlxG.mouse.wheel * 24;
						notepad.members[1].setPosition(notepadDrag.x + notepadOffsets[1].x, notepadDrag.y + notepadOffsets[1].y);
					}*/
				}
			}

			if (currentMenu == 'notepad' && folderDrag.visible == true && !FlxG.mouse.overlaps(notepad.members[0]) && FlxG.mouse.overlaps(folder.members[0]) && FlxG.mouse.justPressed) {
				remove(notepad);
				remove(folder);
				remove(tr);
				remove(freeplayStuff);
				remove(freeplayLocks);
				remove(freeplayLabels);
				add(tr);
				add(notepad);
				add(folder);
				add(freeplayStuff);
				add(freeplayLocks);
				add(freeplayLabels);
				currentMenu = 'freeplay';
			}
		}

		if (trDrag.visible) {
			if (FlxG.keys.justPressed.ESCAPE && canOpenTR && currentMenu == 'trophy rack') {
				closeTR();
				
			}
			var overlappingTrophy:Bool = false;
			 
			for (i in trophies) {
				if (FlxG.mouse.overlaps(i)) {
					overlappingTrophy = true;
				}
			}
			if (overlappingTrophy) {
				for (i in 0...trophies.length) {
					if (FlxG.mouse.overlaps(trophies[i])) {
						switch (i) {
							case 0:
								trText.text = 'Beat every song in Week Bob & Bosip with 0 misses!';
							case 1:
								trText.text = 'Beat every song in Week In The Background with 0 misses!';
							case 2:
								trText.text = 'Beat every EX difficulty song with 0 misses!\n(except Jump-Out and Ronald McDonald Slide)';
							case 3:
								trText.text = 'Beat every song in Week Bob Takeover in standard and EX!';
							case 4:
								trText.text = 'Beat every song in Week In The Background in standard and EX!';
							case 5:
								trText.text = 'Beat every EX difficulty song!';
						}
					}
				}
			} else 
				trText.text = 'Hover over a trophy to see how you unlock it!';
			if (FlxG.mouse.justReleased)
				closingFolder = false;

			if (trDrag.isDragged) {
				for (i in tr) {
					i.setPosition(trDrag.x + trOffsets[tr.members.indexOf(i)].x, trDrag.y + trOffsets[tr.members.indexOf(i)].y);
				}
			}

			if (currentMenu == 'trophy rack' && folderDrag.visible == true && !FlxG.mouse.overlaps(notepad.members[0]) && FlxG.mouse.overlaps(folder.members[0]) && FlxG.mouse.justPressed) {
				remove(notepad);
				remove(folder);
				remove(tr);
				remove(freeplayStuff);
				remove(freeplayLocks);
				remove(freeplayLabels);
				add(tr);
				add(notepad);
				add(folder);
				add(freeplayStuff);
				add(freeplayLocks);
				add(freeplayLabels);
				currentMenu = 'freeplay';
			}
			if (currentMenu == 'trophy rack' && notepadDrag.visible == true && FlxG.mouse.overlaps(notepad.members[0]) && !FlxG.mouse.overlaps(folder.members[0]) && FlxG.mouse.justPressed) {
				remove(notepad);
				remove(folder);
				remove(tr);
				remove(freeplayStuff);
				remove(freeplayLocks);
				remove(freeplayLabels);
				add(folder);
				add(freeplayStuff);
				add(freeplayLocks);
				add(freeplayLabels);
				add(tr);
				add(notepad);
				currentMenu = 'notepad';
			}
		}

		if (folderDrag.visible) {
			if (FlxG.keys.justPressed.ESCAPE && canOpenFolder && currentMenu == 'freeplay') {
				closeFolder();
				closingFolder = false;
			}
		
			if (currentMenu == 'freeplay' && notepadDrag.visible == true && FlxG.mouse.overlaps(notepad.members[0]) && !FlxG.mouse.overlaps(folder.members[0]) && FlxG.mouse.justPressed) {
				remove(notepad);
				remove(folder);
				remove(tr);
				remove(freeplayStuff);
				remove(freeplayLocks);
				remove(freeplayLabels);
				add(folder);
				add(tr);
				add(freeplayStuff);
				add(freeplayLocks);
				add(freeplayLabels);
				add(notepad);
				currentMenu = 'notepad';
			}
			if (FlxG.mouse.justReleased)
				closingFolder = false;
			for (i in freeplayStuff) {
				if (FlxG.mouse.overlaps(i)) {
					var runShit:Bool = false;
					if (notepadDrag.visible && currentMenu == 'notepad') {
						if (!FlxG.mouse.overlaps(notepad.members[0]))
							runShit = true;
					} else
						runShit = true;
					
					if (runShit) {
						folderSelect.x = i.x - 18;
						folderSelect.y = i.y - 24;
						folderSelect.visible = true;
						if (FlxG.mouse.justPressed && songsUnlocked[freeplayStuff.members.indexOf(i)]) {
							var diffState:DifficultySelectSubstate = new DifficultySelectSubstate(songs[freeplayStuff.members.indexOf(i)]);
							diffState.closeFunction = function() {
								closingFolder = true;
							};
							openSubState(diffState);
						}
					}
				}
			}
			if (!FlxG.mouse.overlaps(freeplayStuff))
				folderSelect.visible = false;
			if (folderDrag.isDragged) {
				for (i in folder) {
					i.setPosition(folderDrag.x + folderOffsets[folder.members.indexOf(i)].x, folderDrag.y + folderOffsets[folder.members.indexOf(i)].y);
				}
				for (i in freeplayStuff) {
					i.setPosition(folderDrag.x + freeplayOffsets[freeplayStuff.members.indexOf(i)].x, folderDrag.y + freeplayOffsets[freeplayStuff.members.indexOf(i)].y);
					freeplayLabels.members[freeplayStuff.members.indexOf(i)].setPosition(i.x - 18, i.y + 80);
					freeplayLocks.members[freeplayStuff.members.indexOf(i)].setPosition(i.x, i.y);
				}
				
			}
			for (i in 0...folder.length) {
				var spr = folder.members[i];
				if (i >= 2 && i <= 9) {
					if (FlxG.mouse.overlaps(spr)) {
						spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 1, 1);
					} else {
						spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 0.7, 1);
					}
					if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(spr)) {
						switch (i) {
							case 8:
								OptionsSubState.inDesktop = true;
								openSubState(new OptionsSubState(spr.getPosition()));
							case 6:
								var leState:GallerySubstate = new GallerySubstate(spr.getPosition(), galleryWall);
								leState.updateBackground = updateBG;
								leState.fanmadeGallery = fanmadeGallery;
								leState.officialGallery = officialGallery;
								leState.fanmadePictures = fanmadePictures;
								leState.officialPictures = officialPictures;
								leState.officialImageLocations = officialImageLocations;
								leState.fanmadeImageLocations = fanmadeImageLocations;
								openSubState(leState);
							case 9 | 2:
								closeFolder();
							case 3:
								#if linux
								Sys.command('/usr/bin/xdg-open', ['https://gamebanana.com/mods/297087', "&"]);
								#else
								FlxG.openURL('https://gamebanana.com/mods/297087');
								#end
						}
					}
				}
				
			}		
		}
		if (FlxG.mouse.justReleased)
			closingFolder = false;
		switch (currentMenu) {
			case 'desktop':
				if (folderSelect.visible)
					folderSelect.visible = false;
			case 'freeplay':
				folderDrag.priorityID = 1;
				if (notepadDrag.visible)
					notepadDrag.priorityID = 0;
				if (FlxG.mouse.justReleased) {
					for (i in folder) {
						i.setPosition(folderDrag.x + folderOffsets[folder.members.indexOf(i)].x, folderDrag.y + folderOffsets[folder.members.indexOf(i)].y);
					}
					for (i in freeplayStuff) {
						i.setPosition(folderDrag.x + freeplayOffsets[freeplayStuff.members.indexOf(i)].x, folderDrag.y + freeplayOffsets[freeplayStuff.members.indexOf(i)].y);
						freeplayLabels.members[freeplayStuff.members.indexOf(i)].setPosition(i.x - 18, i.y + 80);
						freeplayLocks.members[freeplayStuff.members.indexOf(i)].setPosition(i.x, i.y);
					}
				}
			case 'notepad':
				notepadDrag.priorityID = 1;
				if (folderDrag.visible)
					folderDrag.priorityID = 0;
				if (FlxG.mouse.justReleased) {
					for (i in notepad) {
						i.setPosition(notepadDrag.x + notepadOffsets[notepad.members.indexOf(i)].x, notepadDrag.y + notepadOffsets[notepad.members.indexOf(i)].y);
					}
				}	
		}
		super.update(elapsed);
	}
	public function updateBG() {
		remove(bg);
		bg = new FlxSprite(0, 0).loadGraphic(Paths.image('desktop/desktop1'));
		if (FlxG.save.data.wallpaper != null) 
			bg = new FlxSprite(0, 0).loadGraphic(Paths.image(FlxG.save.data.wallpaper));
		bg.setGraphicSize(1280, 720);
		bg.updateHitbox();
		add(bg);

		folderLabels.clear();
		for (i in folders) {
			var folderText:FlxText = new FlxText(i.x - 32, i.y + 80, 150, folderData[folders.members.indexOf(i)], 16, true);
			if (FlxG.save.data.wallpaperTextColor != null)
				folderText.setFormat(Paths.font('PUSAB.otf'), 20, FlxG.save.data.wallpaperTextColor, CENTER);
			else
				folderText.setFormat(Paths.font('PUSAB.otf'), 20, FlxColor.WHITE, CENTER);
			if (folderData[folders.members.indexOf(i)] == 'freeplay')
				folderText.text = freeplayName;
			folderText.antialiasing = true;
			folderLabels.add(folderText);
		}
			for (i in sstuff)
				i.visible = false;
		reloadInterractables();
	}

	function closeNotepad() {
		closingFolder = false;
		canOpenNotepad = false;
		remove(notepadDrag);
		notepadDrag.visible = false;
		for (i in notepad) {
			FlxTween.tween(i, {alpha: 0}, 0.2, {ease: FlxEase.cubeOut});
			if (notepad.members.indexOf(i) == 0) 
				FlxTween.tween(notepad.members[0].scale, {x: 0.9, y: 0.9}, 0.2, {ease: FlxEase.cubeOut, onComplete: function (twn:FlxTween) {
					for (i in notepad)
						i.visible = false;	
					canOpenNotepad = true;

					if (folderDrag.visible)
						currentMenu = 'freeplay';
					else
						currentMenu = 'desktop';

				},});
		}
	}

	function closeTR() {
		closingFolder = false;
		canOpenTR = false;
		remove(trDrag);
		trDrag.visible = false;
		for (i in tr) {
			FlxTween.tween(i, {alpha: 0}, 0.2, {ease: FlxEase.cubeOut});
			if (tr.members.indexOf(i) == 0) 
				FlxTween.tween(tr.members[0].scale, {x: 0.9, y: 0.9}, 0.2, {ease: FlxEase.cubeOut, onComplete: function (twn:FlxTween) {
					for (i in tr)
						i.visible = false;	
					canOpenTR = true;

					if (trDrag.visible)
						currentMenu = 'freeplay';
					else
						currentMenu = 'desktop';

				},});
		}
	}
	function closeFolder() {
		if (canOpenFolder) {
			canOpenFolder = false;
			closingFolder = true;
			remove(folderDrag);
			folderDrag.visible = false;
			for (i in folder) {
				FlxTween.tween(i, {alpha: 0}, 0.2, {ease: FlxEase.cubeOut});
				if (folder.members.indexOf(i) == 0) 
					FlxTween.tween(folder.members[0].scale, {x: 0.9, y: 0.9}, 0.2, {ease: FlxEase.cubeOut, onComplete: function (twn:FlxTween) {
						for (i in folder)
							i.visible = false;	
						canOpenFolder = true;
					},});
			}
			for (i in freeplayStuff) {
				FlxTween.tween(i, {alpha: 0}, 0.2, {ease: FlxEase.cubeOut});
			}
			for (i in freeplayLocks) {
				FlxTween.tween(i, {alpha: 0}, 0.2, {ease: FlxEase.cubeOut});
			}
			for (i in freeplayLabels) {
				FlxTween.tween(i, {alpha: 0}, 0.2, {ease: FlxEase.cubeOut});
			}
			if (notepadDrag.visible)
				currentMenu = 'notepad';
			else
				currentMenu = 'desktop';
		}
	}
	override function stepHit() {
		
		super.stepHit();
	}
	
	override function beatHit()
	{

		super.beatHit();
	}
	function addSoda(xPos:Float, yPos:Float)
	{
		desktopStickers.set('ash_soda', new FlxPoint(xPos, yPos));
		if (xPos >= 498 && xPos <= 502 && yPos >= 124 && yPos <= 128) {
			desktopStickers.set('ash_soda', new FlxPoint(500, 126));
		}
		FlxG.save.data.desktopStickers = desktopStickers;
		reloadStickers();
		if (FlxG.save.data.wallpaper == 'bitmaps/bitmaps/bitmaps/bitmaps/bitmaps/bitmaps/bitmaps' && desktopStickers.get('ash_soda').x == 500 && desktopStickers.get('ash_soda').y == 126 && desktopStickers.exists('ash_soda') || D.afU) {
			sstuff.members[4].visible = true;
			if (!D.afU) {
				achievementArray.push('Unlocked a new folder skin for &finding a secret&');
				FlxG.save.data.aol = true;
			}
		} else {
			sstuff.members[4].visible = false;
		}
		reloadInterractables();
	}
	function checkAchievements() {
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			var songHighscore = StringTools.replace(data[0], " ", "-");
				switch (songHighscore) {
					case 'Dad-Battle': songHighscore = 'Dadbattle';
					case 'Philly-Nice': songHighscore = 'Philly';
			}
			songHighscore = songHighscore.toLowerCase();
			if (songHighscore != 'ronald-mcdonald-slide' || songHighscore != 'jump-out') {
				if (Highscore.getScore(songHighscore, 3) > 0 && Highscore.getMissesString(songHighscore, 3) == '0') {
					myButt = true;
				} else myButt = false;

				if (Highscore.getScore(songHighscore, 3) > 0) {
					achievementsUnlocked.set('ex-normal', true);
				} else achievementsUnlocked.set('ex-normal', false);
			}
			
			if (songHighscore == 'jump-in' || songHighscore == 'swing' || songHighscore == 'split') {
				var passedDiff:Bool = false;
				for (diff in 0...2) {
					if (Highscore.getScore(songHighscore, diff) > 0) {
						passedDiff = true;
					}
				}

				if (Highscore.getScore(songHighscore, 2) > 0 && Highscore.getMissesString(songHighscore, 2) == '0' && Highscore.getScore(songHighscore, 3) > 0 && Highscore.getMissesString(songHighscore, 3) == '0') {
					achievementsUnlocked.set('bnb-perfect', true);
				} else achievementsUnlocked.set('bnb-perfect', false);

				if (Highscore.getScore(songHighscore, 3) > 0) {
					if (passedDiff) {
						achievementsUnlocked.set('bnb-normal', true);
					} else
						achievementsUnlocked.set('bnb-normal', false);
				}
			}
			if (songHighscore == 'jump-out' || songHighscore == 'ronald-mcdonald-slide' || songHighscore == 'copy-cat') {
				var passedDiff:Bool = false;
				for (diff in 0...3) {
					if (Highscore.getScore(songHighscore, diff) > 0) {
						passedDiff = true;
					}
				}
			
				if (Highscore.getScore(songHighscore, 3) > 0) {
					if (passedDiff) {
						achievementsUnlocked.set('takeover-normal', true);
					} else
						achievementsUnlocked.set('takeover-normal', false);
				}
			}
			
		}
	}
}
