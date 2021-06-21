package;

import flixel.FlxBasic;
import flixel.math.FlxRect;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.geom.Point;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import io.newgrounds.NG;
import lime.app.Application;
import flixel.math.FlxMath;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var inCredits:Bool = false;
	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end
	var creditsLayer1:FlxTypedGroup<CreditIcon>;
	var creditsLayer2:FlxTypedGroup<CreditIcon>;
	var creditsLayer3:FlxTypedGroup<CreditIcon>;
	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.1" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;
	public static var prevCharacter:Int = 99;
	var character:Character;
	var targetY:Float;
	var logoBl:FlxSprite;
	var targetX:Int;
	var creditsLogo:FlxSprite;
	var logoSHIT:Int = 0;

	var yellow:FlxSprite;
	var blue:FlxSprite;
	var lock:FlxSprite;
	var actuallyInCredits:Bool = false;
	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;
		selectedSomethin = true;
		blue = new FlxSprite(-800).loadGraphic(Paths.image('mainmenu/Blue'));
		blue.scrollFactor.set();
		blue.updateHitbox();
		blue.antialiasing = true;
		add(blue);
		
		yellow = new FlxSprite(FlxG.width).loadGraphic(Paths.image('mainmenu/Yellow'));
		yellow.scrollFactor.set();
		yellow.updateHitbox();
		yellow.antialiasing = true;
		add(yellow);
		
		var line:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/Black line'));
		line.scrollFactor.set();
		line.updateHitbox();
		line.antialiasing = true;
		add(line);

		var random = FlxG.random.int(0,2);
		if (random == prevCharacter) {
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
		var pcChance = FlxG.random.int(0, 50);
		if (pcChance == 25) {
			character = new Character(-800, 300, 'pc');
			targetX = -40;
		}
		prevCharacter = random;
		character.debugMode = true;
		character.scale.set(0.8, 0.8);
		character.scrollFactor.set(0, 0);
		add(character);
		
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		logoBl = new FlxSprite(-1500, -180);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.scrollFactor.set(1, 0);
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		logoBl.scale.set(0.45, 0.45);
		add(logoBl);

		creditsLogo = new FlxSprite(-1500, 30);
		creditsLogo.frames = Paths.getSparrowAtlas('FNF_main_menu_assets');
		creditsLogo.scrollFactor.set(1, 0);
		creditsLogo.antialiasing = true;
		creditsLogo.animation.addByPrefix('bump', 'donate basic', 24, true);
		creditsLogo.animation.play('bump');
		creditsLogo.updateHitbox();
		creditsLogo.scale.set(0.6, 0.6);
		add(creditsLogo);
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		creditsLayer1 = new FlxTypedGroup<CreditIcon>();
		add(creditsLayer1);
		creditsLayer2 = new FlxTypedGroup<CreditIcon>();
		add(creditsLayer2);
		creditsLayer3 = new FlxTypedGroup<CreditIcon>();
		add(creditsLayer3);
		inCredits = true;
		FlxTween.tween(yellow, {x: 0}, 0.6, {
			ease: FlxEase.quadIn,
			startDelay:0.2
		});

		FlxTween.tween(blue, {x: 0}, 0.6, {
			ease: FlxEase.quadIn,
			startDelay: 0.2,
		});
		FlxTween.tween(character, {x: targetX}, 0.6, {
			ease: FlxEase.quadIn,
			startDelay:0.25,
			onComplete: function(twn:FlxTween) {
				if (pcChance == 25) {
					FlxG.sound.play(Paths.sound('MIRAGE_95_x2', 'shared'), 0.4);
				}
				selectedSomethin = false;
				inCredits = false;
			}
		});
		FlxTween.tween(logoBl, {x: -850}, 0.6, {
			ease: FlxEase.quadIn,
			startDelay:0.25
		});
		for (i in 0...7) {
			var credit:CreditIcon;
			switch (i) {
				case 0:
					credit = new CreditIcon("AmorAltra", 'https://www.youtube.com/channel/UCffme2uZNxvK4s51DDALlNA');
				case 1:
					credit = new CreditIcon("TheMaskedChris", 'https://twitter.com/TheMaskedChris');
				case 2:
					credit = new CreditIcon("Yoshe", 'https://twitter.com/yoshexists');
				case 3:
					credit = new CreditIcon("Mikethemagicman", 'https://www.twitch.tv/mikethemagicman88');
				case 4:
					credit = new CreditIcon("Seabo", "https://linktr.ee/Seabo");
				case 5:
					credit = new CreditIcon("Ash", 'https://twitter.com/theAshPerson_');
				case 6:
					credit = new CreditIcon("Cerbera", 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
				default:
					credit = new CreditIcon("AmorAltra");
			}
			credit.scrollFactor.set(1, 0);
			credit.x += 300;
			credit.visible = false;
			creditsLayer1.add(credit);	
		}

		for (i in 0...7) {
			var credit:CreditIcon;
			switch (i) {
				case 0:
					credit = new CreditIcon("DPZ", 'https://www.youtube.com/channel/UCeQWT9cATBr4ofogZODGmyw');
				case 1:
					credit = new CreditIcon("Hjfod", 'https://www.youtube.com/hjfod');
				case 2:
					credit = new CreditIcon("Splatterdash", 'https://splatterdash.newgrounds.com/');
				case 3:
					credit = new CreditIcon("Ardolf", "https://youtube.com/channel/UC304bqrManiYmlbXd4gklYg");
				case 4:
					credit = new CreditIcon("Vlusky", 'https://linktr.ee/VluskyHusky');
				case 5:
					credit = new CreditIcon("Sirhadoken", "https://www.youtube.com/channel/UCsnvLQHPk5qHh_JCcCKZW-A");
				case 6:
					credit = new CreditIcon("Corrupt", "https://twitter.com/c0rruptzie?s=21");
				default:
					credit = new CreditIcon("AmorAltra");
			}
			credit.scrollFactor.set(1, 0);
			credit.x += 300;
			credit.visible = false;
			creditsLayer2.add(credit);	
		}

		for (i in 0...2) {
			var credit:CreditIcon;
			switch (i) {
				case 0:
					credit = new CreditIcon("Rakurai", 'https://twitter.com/RacchusRefrain');
				case 1:
					credit = new CreditIcon("Melty", 'https://twitter.com/MeltyDraws');
				default:
					credit = new CreditIcon("AmorAltra");
			}
			credit.scrollFactor.set(1, 0);
			credit.x += 300;
			credit.visible = false;
			creditsLayer3.add(credit);	
		}
		


		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');
		Conductor.changeBPM(110);
		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.centerOrigin();
			menuItem.scrollFactor.set(1, 1);
			menuItem.ID = i;
			/*menuItem.screenCenter(X);
			menuItem.x += 50;*/
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.9));
			menuItem.updateHitbox();
			if (!FlxG.save.data.beatWeek && optionShit[i] == 'freeplay') 
				menuItem.color = FlxColor.fromHSL(menuItem.color.hue, menuItem.color.saturation, 0.2, 1);
			/*menuItem.screenCenter(X);
			menuItem.x += 2000;*/
			/*menuItem.screenCenter(X);
			menuItem.x -= 400;*/

			//i'm fuckn dumb lol sorry
			switch (i) {
				case 0:
					menuItem.x = -118.2;
				case 1:
					menuItem.x = 58.5;
				case 2:
					menuItem.x = 67.5;
				case 3:
					menuItem.x = 57.375;
			}
			menuItem.x += 2000;
			menuItems.add(menuItem);
			
			menuItem.antialiasing = true;
			finishedFunnyMove = true; 
			/*if (firstStart)
				FlxTween.tween(menuItem,{y: 60 + (i * 160)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
						finishedFunnyMove = true; 
						changeItem();
					}});
			else
				menuItem.y = 60 + (i * 160);*/
		}
		for (i in menuItems.members) {
			FlxTween.tween(i, {x: i.x - 2000}, 0.6, {
				ease: FlxEase.quadIn,
				startDelay:0.25
			});
			
		}
		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
		lock = new FlxSprite().loadGraphic(Paths.image('mainmenu/Lock'));
		lock.scrollFactor.set(1, 1);
		if (!FlxG.save.data.beatWeek)
			add(lock);
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		for (i in 0...menuItems.length){
			/*if (menuItems.members.indexOf(menuItems.members[i]) == 3) {
				menuItems.members[i].y = FlxMath.lerp(menuItems.members[i].y, (-1 * 500) + 60, 0.16);
			} else */
			var targetY = menuItems.members.indexOf(menuItems.members[i]);
			menuItems.members[i].y = FlxMath.lerp(menuItems.members[i].y, (targetY * 200) + 60, 0.16);
		}
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lock.x = menuItems.members[1].getGraphicMidpoint().x - 140;
		lock.y = menuItems.members[1].y - menuItems.members[1].height / 2;
		lock.scale.set(menuItems.members[1].scale.x, menuItems.members[1].scale.y);
		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				if (!inCredits) {
					//FlxG.switchState(new TitleState());
					doTheFuckinTransition(new TitleState());
				} 
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] != 'freeplay') {
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					/*if (FlxG.save.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);*/

					menuItems.forEach(function(spr:FlxSprite)
					{
						var daChoice:String = optionShit[curSelected];

						switch (daChoice)
						{
							case 'story mode':
								doTheFuckinTransition(new StoryMenuState());
							
								/*FlxTween.tween(yellow, {x: 50}, 0.6, {
									ease: FlxEase.quadOut,
								});
								FlxTween.tween(yellow, {x: FlxG.width}, 0.6, {
									ease: FlxEase.quadOut,
									onComplete: function(twn:FlxTween) {
										FlxTransitionableState.skipNextTransIn = true;
										FlxTransitionableState.skipNextTransOut = true;
										FlxG.switchState(new FreeplayState());
									},
									startDelay:0.6
								});
								FlxTween.tween(blue, {x: -50}, 0.6, {
									ease: FlxEase.quadOut,
								});
								FlxTween.tween(blue, {x: -800}, 0.6, {
									ease: FlxEase.quadOut,
									startDelay:0.6
								});
								inCredits = true;
								for (i in menuItems.members) {
									FlxTween.tween(i, {x: i.x + 50}, 0.6, {
										ease: FlxEase.quadOut,
									});
									FlxTween.tween(i, {x: FlxG.width}, 0.6, {
										ease: FlxEase.quadOut,
										startDelay:0.6
									});
									
								}
								FlxTween.tween(character, {x: character.x - 50}, 0.6, {ease: FlxEase.quadOut});
								FlxTween.tween(character, {x: -800}, 0.6, {
									ease: FlxEase.quadOut,
									startDelay:0.6
								});
								FlxTween.tween(logoBl, {x: logoBl.x - 50}, 0.6, {
									ease: FlxEase.quadOut,
								});
								FlxTween.tween(logoBl, {x: -1500}, 0.6, {
									ease: FlxEase.quadOut,
									startDelay:0.6
								});
								*/
							case 'options':
								doTheFuckinTransition(new OptionsMenu());
							case 'donate':
								if (!actuallyInCredits) {
									inCredits = true;
									new FlxTimer().start(0.1, function(tmr:FlxTimer)
									{
										for (i in creditsLayer1) 
											i.visible = true;
										for (i in creditsLayer2) 
											i.visible = true;
										for (i in creditsLayer3) 
											i.visible = true;
										FlxTween.tween(logoBl, {x: -1500}, 0.6, {
											ease: FlxEase.quadIn,
										});
										for (i in menuItems.members) {
											FlxTween.tween(i, {x: i.x + 1000}, 0.6, {
												ease: FlxEase.quadIn,
												startDelay: 0.1,
											});
											
										}
										new FlxTimer().start(1.1, function(tmr:FlxTimer)
										{
											FlxTween.tween(creditsLogo, {x: -660}, 0.6, {
												ease: FlxEase.quadIn,
											});
											new FlxTimer().start(0.5, function(tmr:FlxTimer)
											{
												for (i in creditsLayer1) {
													FlxTween.tween(i, {x: -650}, 0.6, {
														ease: FlxEase.quadOut,
													});
												}
											});
											new FlxTimer().start(0.6, function(tmr:FlxTimer)
											{
												for (i in creditsLayer2) {
													FlxTween.tween(i, {x: -650}, 0.6, {
														ease: FlxEase.quadOut,
													});
												}
											});
											new FlxTimer().start(0.7, function(tmr:FlxTimer)
											{
												for (i in creditsLayer3) {
													FlxTween.tween(i, {x: -650}, 0.6, {
														ease: FlxEase.quadOut,
														onComplete: function(twn:FlxTween)
														{
															FlxG.mouse.visible = true;
															actuallyInCredits = true;
														}
													});
												}
											});
										});
									});
								}
						}
					});
				} else if (FlxG.save.data.beatWeek) {
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					doTheFuckinTransition(new FreeplayState());
				}
			}
		} else if (actuallyInCredits) {
			if (controls.BACK) {
				new FlxTimer().start(0.4, function(tmr:FlxTimer)
				{
					
					new FlxTimer().start(0.6, function(tmr:FlxTimer)
					{
						for (i in menuItems.members) {
							for (i in menuItems.members) {
								FlxTween.tween(i, {x: i.x - 1000}, 0.7, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									inCredits = false;
									new FlxTimer().start(0.2, function(tmr:FlxTimer)
									{
										FlxG.mouse.visible = false;
										selectedSomethin = false;
										actuallyInCredits = false;
									});
								}
								});
							}
						}
					});
					FlxTween.tween(logoBl, {x: -850}, 0.6, {
						ease: FlxEase.quadOut,
					});
					FlxTween.tween(creditsLogo, {x: -1500}, 0.6, {
						ease: FlxEase.quadOut,
					});
					for (i in creditsLayer1) {
						FlxTween.tween(i, {x: 300}, 0.6, {
							ease: FlxEase.quadOut,
						});
					}
				});
				new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					for (i in creditsLayer2) {
						FlxTween.tween(i, {x: 300}, 0.6, {
							ease: FlxEase.quadOut,
						});
					}
				});
				new FlxTimer().start(0.2, function(tmr:FlxTimer)
				{
					for (i in creditsLayer3) {
						FlxTween.tween(i, {x: 300}, 0.6, {
							ease: FlxEase.quadOut,
						});
					}
				});
			}
		}

		super.update(elapsed);
		if (!inCredits) {
			menuItems.forEach(function(spr:FlxSprite)
			{
				spr.screenCenter(X);
				spr.x -= 400;
				trace(spr.x);
			});
		} else {
			
			for (i in creditsLayer1) {
				if (i.graphic.bitmap.hitTest(new Point(-650, (FlxG.height / 3) - 55), 0, new Point(FlxG.mouse.x, FlxG.mouse.y))) {
					i.scale.set(1.02, 1.02);
					if (FlxG.mouse.justPressed) {
						#if linux
						Sys.command('/usr/bin/xdg-open', [i.link, "&"]);
						#else
						FlxG.openURL(i.link);
						#end
					}
				} else {
					i.scale.set(1, 1);
				}
			}
			for (i in creditsLayer2) {
				if (i.graphic.bitmap.hitTest(new Point(-650, (FlxG.height / 3) - 55), 0, new Point(FlxG.mouse.x, FlxG.mouse.y))) {
					i.scale.set(1.02, 1.02);
					if (FlxG.mouse.justPressed) {
						#if linux
						Sys.command('/usr/bin/xdg-open', [i.link, "&"]);
						#else
						FlxG.openURL(i.link);
						#end
					}
				} else {
					i.scale.set(1, 1);
				}
			}
			for (i in creditsLayer3) {
				if (i.graphic.bitmap.hitTest(new Point(-650, (FlxG.height / 3) - 55), 0, new Point(FlxG.mouse.x, FlxG.mouse.y))) {
					i.scale.set(1.02, 1.02);
					if (FlxG.mouse.justPressed) {
						#if linux
						Sys.command('/usr/bin/xdg-open', [i.link, "&"]);
						#else
						FlxG.openURL(i.link);
						#end
					}
				} else {
					i.scale.set(1, 1);
				}
			}
		}
		
		if (camFollow.y != targetY) {
			camFollow.y = FlxMath.lerp(camFollow.y, targetY, 0.7);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		character.playAnim('idle', true);
		logoSHIT++;
		if (logoSHIT > 1) {
			logoSHIT = 0;
			logoBl.animation.play('bump', true);
		}
		trace(':(');
	}
	function doTheFuckinTransition(daState:Dynamic) {
		FlxTween.tween(yellow, {x: 50}, 0.6, {
			ease: FlxEase.quadOut,
		});
		FlxTween.tween(yellow, {x: FlxG.width}, 0.6, {
			ease: FlxEase.quadOut,
			onComplete: function(twn:FlxTween) {
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.switchState(daState);
			},
			startDelay:0.6
		});
		FlxTween.tween(blue, {x: -50}, 0.6, {
			ease: FlxEase.quadOut,
		});
		FlxTween.tween(blue, {x: -800}, 0.6, {
			ease: FlxEase.quadOut,
			startDelay:0.6
		});
		inCredits = true;
		for (i in menuItems.members) {
			FlxTween.tween(i, {x: i.x + 50}, 0.6, {
				ease: FlxEase.quadOut,
			});
			FlxTween.tween(i, {x: FlxG.width}, 0.6, {
				ease: FlxEase.quadOut,
				startDelay:0.6
			});
			
		}
		FlxTween.tween(character, {x: character.x - 50}, 0.6, {ease: FlxEase.quadOut});
		FlxTween.tween(character, {x: -800}, 0.6, {
			ease: FlxEase.quadOut,
			startDelay:0.6
		});
		FlxTween.tween(logoBl, {x: logoBl.x - 50}, 0.6, {
			ease: FlxEase.quadOut,
		});
		FlxTween.tween(logoBl, {x: -1500}, 0.6, {
			ease: FlxEase.quadOut,
			startDelay:0.6
		});
	}


	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				if (optionShit[menuItems.members.indexOf(spr)] != 'freeplay')
					spr.animation.play('selected');
				else if (FlxG.save.data.beatWeek) {
					spr.animation.play('selected');
				} 
					
				if (FlxG.save.data.beatWeek)
					spr.scale.set(0.9, 0.9);
				spr.updateHitbox();
				targetY = spr.getGraphicMidpoint().y;
				//camFollow.y = FlxMath.lerp(camFollow.y, spr.getGraphicMidpoint().y, 0.7);
			} else {
				spr.scale.set(0.75, 0.75);
				spr.updateHitbox();
			}

			spr.updateHitbox();
		});
	}
	
}
