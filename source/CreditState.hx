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

#if windows
import Sys;
import sys.FileSystem;
#end

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class CreditState extends MusicBeatState
{
	var panelBottom:FlxSprite;
	var panelTop:FlxSprite;
	var panelMiddle:FlxSprite;
	var arrowLeft:FlxSprite;
	var arrowRight:FlxSprite;
	var creditsText:FlxSprite;

	var creditsPage1:FlxTypedGroup<CreditIcon>;
	var textPage1:FlxTypedGroup<FlxSprite>;

	var curPage:Int = 0;

	var canDoStuff:Bool = false;
	
	override function create()
	{
		super.create();
		FlxG.camera.zoom = 0.8;

		FlxG.mouse.visible = true;

		panelMiddle = new FlxSprite().loadGraphic(Paths.image("credits/panelMiddle"));
		panelMiddle.antialiasing = true;
		panelMiddle.alpha = 0;
		add(panelMiddle);

		panelBottom = new FlxSprite(0, 500).loadGraphic(Paths.image("credits/panelBottom"));
		panelBottom.antialiasing = true;
		add(panelBottom);

		panelTop = new FlxSprite(0, -500).loadGraphic(Paths.image("credits/panelTop"));
		panelTop.antialiasing = true;
		add(panelTop);

		creditsPage1 = new FlxTypedGroup<CreditIcon>();
		add(creditsPage1);

		textPage1 = new FlxTypedGroup<FlxSprite>();
		add(textPage1);

		arrowRight = new FlxSprite(1015, 1000).loadGraphic(Paths.image("credits/arrowRight"));
		arrowRight.antialiasing = true;
		arrowRight.scale.set(0.8, 0.8);
		arrowRight.updateHitbox();
		add(arrowRight);

		arrowLeft = new FlxSprite(182, 1000).loadGraphic(Paths.image("credits/arrowLeft"));
		arrowLeft.antialiasing = true;
		arrowLeft.scale.set(0.8, 0.8);
		arrowLeft.updateHitbox();
		add(arrowLeft);

		creditsText = new FlxSprite(502, 1005).loadGraphic(Paths.image("credits/creditsText"));
		creditsText.antialiasing = true;
		add(creditsText);

		for (i in 0...12) {
			var icon:CreditIcon = new CreditIcon();
			var text:FlxSprite = new FlxSprite();
			switch (i) {
				case 0:
					icon = new CreditIcon(55, 128, 'Amor', 'https://www.youtube.com/channel/UCffme2uZNxvK4s51DDALlNA');
					text = new FlxSprite(164, 141).loadGraphic(Paths.image('credits/text/creditAmor'));
				case 1:
					icon = new CreditIcon(61, 243, 'Chris', 'https://twitter.com/TheMaskedChris');
					text = new FlxSprite(169, 259).loadGraphic(Paths.image('credits/text/creditChris'));
				case 2:
					icon = new CreditIcon(52, 366, 'Cutie', 'https://twitter.com/ash__i_guess_');
					text = new FlxSprite(169, 380).loadGraphic(Paths.image('credits/text/creditAsh'));
				case 3:
					icon = new CreditIcon(67, 494, 'Cerbera', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new FlxSprite(168, 501).loadGraphic(Paths.image('credits/text/creditCerbera'));
				case 4:
					icon = new CreditIcon(455, 131, 'DPZ', 'https://www.youtube.com/channel/UCeQWT9cATBr4ofogZODGmyw');
					text = new FlxSprite(568, 143).loadGraphic(Paths.image('credits/text/creditDPZ'));
				case 5:
					icon = new CreditIcon(454, 248, 'Splatter', 'https://splatterdash.newgrounds.com/');
					text = new FlxSprite(567, 259).loadGraphic(Paths.image('credits/text/creditSplatter'));
				case 6:
					icon = new CreditIcon(437, 359, 'Ardolf', 'https://linktr.ee/ardolf');
					text = new FlxSprite(567, 390).loadGraphic(Paths.image('credits/text/creditArdolf'));
				case 7:
					icon = new CreditIcon(447, 494, 'Boom', 'https://www.youtube.com/c/BoomKitty');
					text = new FlxSprite(564, 498).loadGraphic(Paths.image('credits/text/creditBoomkitty'));
				case 8:
					icon = new CreditIcon(852, 125, 'Mike', 'https://www.twitch.tv/mikethemagicman88');
					text = new FlxSprite(961, 141).loadGraphic(Paths.image('credits/text/creditMike'));
				case 9:
					icon = new CreditIcon(847, 241, 'Seabo', 'https://linktr.ee/Seabo');
					text = new FlxSprite(965, 259).loadGraphic(Paths.image('credits/text/creditSeabo'));
				case 10:
					icon = new CreditIcon(836, 368, 'Blu', 'https://twitter.com/bluskystv');
					text = new FlxSprite(963, 391).loadGraphic(Paths.image('credits/text/creditBluskys'));
				case 11:
					icon = new CreditIcon(841, 487, 'Mini', 'https://www.youtube.com/c/minishoey');
					text = new FlxSprite(959, 500).loadGraphic(Paths.image('credits/text/creditMini'));
				
			}
			icon.x += FlxG.width * 2;
			text.x += FlxG.width * 2;
			icon.antialiasing = true;
			text.antialiasing = true;
			creditsPage1.add(icon);
			textPage1.add(text);
		}

		for (i in 0...12) {
			var icon:CreditIcon = new CreditIcon();
			var text:FlxSprite = new FlxSprite();
			switch (i) {
				case 0:
					icon = new CreditIcon(58, 111, 'Jghost', 'https://twitter.com/jghost_217?s=21');
					text = new FlxSprite(165, 137).loadGraphic(Paths.image('credits/text/creditJghost'));
				case 1:
					icon = new CreditIcon(40, 259, 'Cerberus', 'https://twitter.com/vzCerberus?s=09');
					text = new FlxSprite(166, 254).loadGraphic(Paths.image('credits/text/creditCerberus'));
				case 2:
					icon = new CreditIcon(58, 370, 'Mango', 'https://twitter.com/MangooPop');
					text = new FlxSprite(165, 385).loadGraphic(Paths.image('credits/text/creditMango'));
				case 3:
					icon = new CreditIcon(58, 490, 'Cougar', 'https://twitter.com/CougarMacDowal1?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor');
					text = new FlxSprite(162, 495).loadGraphic(Paths.image('credits/text/creditCougar'));
				case 4:
					icon = new CreditIcon(459, 113, 'Typic', 'https://www.youtube.com/c/TypicalEmerald');
					text = new FlxSprite(573, 137).loadGraphic(Paths.image('credits/text/creditTypic'));
				case 5:
					icon = new CreditIcon(455, 226, 'Scorch', 'https://twitter.com/ScorchVx');
					text = new FlxSprite(573, 254).loadGraphic(Paths.image('credits/text/creditScorch'));
				case 6:
					icon = new CreditIcon(446, 371, 'Netba', 'https://twitter.com/NetBa_Art');
					text = new FlxSprite(573, 387).loadGraphic(Paths.image('credits/text/creditNetba'));
				case 7:
					icon = new CreditIcon(446, 481, 'Jyro', 'https://jyro.carrd.co/');
					text = new FlxSprite(572, 494).loadGraphic(Paths.image('credits/text/creditJyro'));
				case 8:
					icon = new CreditIcon(824, 125, 'Kaos', 'http://www.twitter.com/KaoskurveA');
					text = new FlxSprite(963, 140).loadGraphic(Paths.image('credits/text/creditKaos'));
				case 9:
					icon = new CreditIcon(834, 225, 'Yoshe', 'https://twitter.com/yoshexists');
					text = new FlxSprite(965, 258).loadGraphic(Paths.image('credits/text/creditYoshe'));
				case 10:
					icon = new CreditIcon(836, 371, 'Phlox', 'https://twitter.com/HiPhlox');
					text = new FlxSprite(963, 390).loadGraphic(Paths.image('credits/text/creditPhlox'));
				case 11:
					icon = new CreditIcon(852, 492, 'Wildy', 'https://www.youtube.com/channel/UCrUhQeLDv7lpZifWfPr4uGQ');
					text = new FlxSprite(962, 499).loadGraphic(Paths.image('credits/text/creditWildy'));
			}
			icon.x += FlxG.width * 3;
			text.x += FlxG.width * 3;
			icon.antialiasing = true;
			text.antialiasing = true;
			creditsPage1.add(icon);
			textPage1.add(text);
		}

		for (i in 0...13) {
			var icon:CreditIcon = new CreditIcon();
			var text:FlxSprite = new FlxSprite();
			switch (i) {
				case 0:
					icon = new CreditIcon(61, 133, 'HJ', 'https://www.youtube.com/hjfod');
					text = new FlxSprite(160, 137).loadGraphic(Paths.image('credits/text/creditHJFod'));
				case 1:
					icon = new CreditIcon(64, 236, 'Hado', 'https://www.youtube.com/channel/UCsnvLQHPk5qHh_JCcCKZW-A');
					text = new FlxSprite(162, 257).loadGraphic(Paths.image('credits/text/creditHado'));
				case 2:
					icon = new CreditIcon(60, 362, 'Vlusky', 'https://vlsk.carrd.co/');
					text = new FlxSprite(163, 389).loadGraphic(Paths.image('credits/text/creditVlusky'));
				case 3:
					icon = new CreditIcon(50, 484, 'Melt', 'https://twitter.com/MeltyDraws');
					text = new FlxSprite(162, 497).loadGraphic(Paths.image('credits/text/creditMelty'));
				case 4:
					icon = new CreditIcon(458, 127, 'Raku', 'https://twitter.com/RacchusRefrain');
					text = new FlxSprite(568, 151).loadGraphic(Paths.image('credits/text/creditRakurai'));
				case 5:
					icon = new CreditIcon(460, 268, 'Juni', 'https://www.youtube.com/c/JuniperGD');
					text = new FlxSprite(568, 284).loadGraphic(Paths.image('credits/text/creditJuniper'));
				case 6:
					icon = new CreditIcon(460, 375, 'Corrupt', 'https://twitter.com/c0rruptzie?s=21');
					text = new FlxSprite(568, 380).loadGraphic(Paths.image('credits/text/creditCorrupt'));
				case 7:
					icon = new CreditIcon(806, 119, 'Dunko', 'https://www.youtube.com/user/duncangustina');
					text = new FlxSprite(962, 119).loadGraphic(Paths.image('credits/text/dunkandPizza'));
				case 8:
					icon = new CreditIcon(861, 171, 'Pizza', 'https://twitter.com/pizzapancakess_');
					text = new FlxSprite(962, 119).loadGraphic(Paths.image('credits/text/smile'));
				case 9:
					icon = new CreditIcon(848, 269, 'Rebecca', 'https://twitter.com/rebecca_doodles');
					text = new FlxSprite(958, 280).loadGraphic(Paths.image('credits/text/rebeccaName'));
				case 10:
					icon = new CreditIcon(855, 373, 'Aether', 'https://twitter.com/AetherDX');
					text = new FlxSprite(955, 376).loadGraphic(Paths.image('credits/text/aetherdxName'));
				case 11:
					icon = new CreditIcon(849, 499, 'Ohya', 'https://twitter.com/ohyaholla');
					text = new FlxSprite(955, 503).loadGraphic(Paths.image('credits/text/ohyaName'));
				case 12:
					icon = new CreditIcon(467, 479, 'Astro', 'https://www.instagram.com/_astro.squid_');
					text = new FlxSprite(581, 504).loadGraphic(Paths.image('credits/text/creditAstro'));
			}
			icon.x += FlxG.width * 4;
			text.x += FlxG.width * 4;
			icon.antialiasing = true;
			text.antialiasing = true;
			creditsPage1.add(icon);
			textPage1.add(text);
		}
		for (i in 0...5) {
			var text:FlxSprite = new FlxSprite();
			switch (i) {
				case 0:
					text = new FlxSprite(514, 139).loadGraphic(Paths.image('credits/specialThanks1'));
				case 1:
					text = new FlxSprite(284, 207).loadGraphic(Paths.image('credits/column1'));
				case 2:
					text = new FlxSprite(470, 207).loadGraphic(Paths.image('credits/column2'));
				case 3:
					text = new FlxSprite(666, 206).loadGraphic(Paths.image('credits/column3'));
				case 4:
					text = new FlxSprite(864, 207).loadGraphic(Paths.image('credits/column4'));

			}
			text.x += FlxG.width * 5;
			text.antialiasing = true;
			textPage1.add(text);
		}
		FlxTween.tween(FlxG.camera, {zoom: 1.05}, 1.2, {
			ease: FlxEase.cubeOut,
			onComplete: function (twn:FlxTween) {
				FlxTween.tween(FlxG.camera, {zoom: 1}, 0.2, {
					ease: FlxEase.quadIn
				});
			}
		});

		FlxTween.tween(arrowLeft, {y: 593}, 1, {
			ease: FlxEase.quadOut,
			startDelay: 1.2,
		});

		FlxTween.tween(creditsText, {y: 605}, 1, {
			ease: FlxEase.quadOut,
			startDelay: 1.3,
		});

		FlxTween.tween(arrowRight, {y: 593}, 1, {
			ease: FlxEase.quadOut,
			startDelay: 1.4,
		});

		FlxTween.tween(panelTop, {y: 0}, 1, {
			ease: FlxEase.quadOut,
			//startDelay: 0.6,
		});

		FlxTween.tween(panelBottom, {y: 0}, 1, {
			ease: FlxEase.quadOut,
			//startDelay: 0.6,
		});

		FlxTween.tween(panelMiddle, {alpha: 1}, 1.4, {
			ease: FlxEase.cubeOut,
			//startDelay: 0.6,
		});

		for (i in creditsPage1) {
			FlxTween.tween(i, {x: i.x - FlxG.width}, 0.6, {
				ease: FlxEase.cubeOut,
			});
		}

		for (i in textPage1) {
			FlxTween.tween(i, {x: i.x - FlxG.width}, 0.6, {
				ease: FlxEase.cubeOut,
			});
		}
		new FlxTimer().start(0.6, function(tmr:FlxTimer)
		{
			for (i in 0...4) {
				FlxTween.tween(creditsPage1.members[i], {x: creditsPage1.members[i].x - FlxG.width}, 1.4, {
					ease: FlxEase.cubeOut,
					//startDelay: 0.6,
				});
	
				FlxTween.tween(textPage1.members[i], {x: textPage1.members[i].x - FlxG.width}, 1.4, {
					ease: FlxEase.cubeOut,
					//startDelay: 0.6,
				});
			}
	
			for (i in 4...8) {
				FlxTween.tween(creditsPage1.members[i], {x: creditsPage1.members[i].x - FlxG.width}, 1.4, {
					ease: FlxEase.cubeOut,
					startDelay: 0.1,
				});
	
				FlxTween.tween(textPage1.members[i], {x: textPage1.members[i].x - FlxG.width}, 1.4, {
					ease: FlxEase.cubeOut,
					startDelay: 0.1,
				});
			}
			for (i in 8...37) {
				FlxTween.tween(creditsPage1.members[i], {x: creditsPage1.members[i].x - FlxG.width}, 1.4, {
					ease: FlxEase.cubeOut,
					startDelay: 0.2,
				});
			}
			for (i in 8...42) {
				FlxTween.tween(textPage1.members[i], {x: textPage1.members[i].x - FlxG.width}, 1.4, {
					ease: FlxEase.cubeOut,
					startDelay: 0.2,
					onComplete: function(twn:FlxTween) {
						canDoStuff = true;
					}
				});
			}
		});
		
	}

	override function update(elapsed:Float)
	{
		if (canDoStuff) {
			if (controls.LEFT_P) {
				changePage(-1);
			}
			if (controls.RIGHT_P) {
				changePage(1);
			}
			if (controls.BACK)
				outTransition();
		}

		if (controls.RIGHT)
			arrowRight.scale.set(0.92, 0.92);
		else
			arrowRight.scale.set(0.95, 0.95);

		if (controls.LEFT)
			arrowLeft.scale.set(0.92, 0.92);
		else
			arrowLeft.scale.set(0.95, 0.95);

		if (FlxG.mouse.overlaps(arrowLeft)) {
			arrowLeft.scale.set(1, 1);
			if (FlxG.mouse.pressed)
				arrowLeft.scale.set(0.92, 0.92);
			if (FlxG.mouse.justPressed && canDoStuff)
				changePage(-1);
		} else if (!controls.LEFT)
			arrowLeft.scale.set(0.95, 0.95);

		if (FlxG.mouse.overlaps(arrowRight)) {
			arrowRight.scale.set(1, 1);
			if (FlxG.mouse.pressed)
				arrowRight.scale.set(0.92, 0.92);
			if (FlxG.mouse.justPressed && canDoStuff)
				changePage(1);
		} else if (!controls.RIGHT)
			arrowRight.scale.set(0.95, 0.95);

		for (i in creditsPage1) {
			if (FlxG.mouse.overlaps(i)) {
				i.scale.set(1.1, 1.1);
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

	function changePage(change:Int = 0):Void {
		canDoStuff = false;
		var prevPage = curPage;
		curPage += change;
		if (curPage < 0) {
			curPage = 0;
			canDoStuff = true;
		} else if (curPage > 3) {
			curPage = 3;
			canDoStuff = true;
		}
		if (prevPage != curPage) {
			for (i in creditsPage1) {
				FlxTween.tween(i, {x: i.x + FlxG.width * -change}, 1, {
					ease: FlxEase.quadOut,
				});
			}
			for (i in textPage1) {
				FlxTween.tween(i, {x: i.x + FlxG.width * -change}, 1, {
					ease: FlxEase.quadOut,
					onComplete: function (twn:FlxTween) {
						canDoStuff = true;
					},
				});
			}
		}
	}

	function outTransition():Void {
		canDoStuff = false;
		FlxTween.tween(arrowLeft, {y: 973}, 1, {
			ease: FlxEase.quadOut,
		});

		FlxTween.tween(creditsText, {y: 1005}, 1, {
			ease: FlxEase.quadOut,
			startDelay: 0.1,
		});

		FlxTween.tween(arrowRight, {y: 973}, 1, {
			ease: FlxEase.quadOut,
			startDelay: 0.2,
		});

		FlxTween.tween(panelTop, {y: -500}, 1, {
			ease: FlxEase.quadOut,
			//startDelay: 0.6,
		});

		FlxTween.tween(panelBottom, {y: 500}, 1, {
			ease: FlxEase.quadOut,
			//startDelay: 0.6,
		});

		FlxTween.tween(panelMiddle, {alpha: 0}, 1, {
			ease: FlxEase.cubeOut,
			startDelay: 0.6,
			onComplete: function(twn:FlxTween) {
				FlxG.switchState(new MainMenuState());
			}
		});

		FlxTween.tween(FlxG.camera, {zoom: 0.8}, 0.6, {startDelay: 0.6});

		var imFuckingDumb:Int = 0;
		var dumb2:Int = 0;
		var dumb3:Int = 0;
		switch (curPage) {
			case 0:
				dumb3 = 24;
				imFuckingDumb = 12;
			case 1:
				dumb3 = 37;
				dumb2 = 12;
				imFuckingDumb = 24;
			case 2:
				dumb2 = 24;
				imFuckingDumb = 37;
		}
		//sorry :(
		for (i in creditsPage1)
			i.alpha = 0;
		for (i in textPage1)
			i.alpha = 0;
		if (curPage == 3) {
			for (i in 37...42) {
				textPage1.members[i].alpha = 1;

				FlxTween.tween(textPage1.members[i], {x: textPage1.members[i].x - FlxG.width * 1.5}, 1.4, {
					ease: FlxEase.cubeOut,
					startDelay: 0.4,
				});
			}
		} else {
			for (i in (4 * curPage)...imFuckingDumb) {
				creditsPage1.members[i].alpha = 1;
				textPage1.members[i].alpha = 1;
				FlxTween.tween(creditsPage1.members[i], {x: creditsPage1.members[i].x - FlxG.width * 1.5}, 1.4, {
					ease: FlxEase.cubeOut,
					startDelay: 0.4,
				});

				FlxTween.tween(textPage1.members[i], {x: textPage1.members[i].x - FlxG.width * 1.5}, 1.4, {
					ease: FlxEase.cubeOut,
					startDelay: 0.4,
				});
			}
		}
		/*if (curPage > 0) {
			for (i in (4 * (curPage - 1))...dumb2) {
				creditsPage1.members[i].visible = false;
				textPage1.members[i].visible = false;
			}
		}

		if (curPage < 2) {
			for (i in (4 * (curPage + 1))...dumb3) {
				creditsPage1.members[i].visible = false;
				textPage1.members[i].visible = false;
			}
		}*/
	}
	override function beatHit()
	{
		super.beatHit();
		
	}
}
