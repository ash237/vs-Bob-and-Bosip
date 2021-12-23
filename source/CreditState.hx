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
	var panelLeft:FlxSprite;
	var arrowLeft:FlxSprite;
	var arrowRight:FlxSprite;
	var creditsText:FlxSprite;
	var pointer:FlxSprite;

	var creditsPage1:FlxTypedGroup<CreditIcon>;
	var textPage1:FlxTypedGroup<FlxSprite>;

	var creditsDevs:FlxTypedGroup<CreditIcon>;
	var textDevs:FlxTypedGroup<CreditText>;

	var creditsArtists:FlxTypedGroup<CreditIcon>;
	var textArtists:FlxTypedGroup<CreditText>;

	var creditsMusicians:FlxTypedGroup<CreditIcon>;
	var textMusicians:FlxTypedGroup<CreditText>;

	var creditsVAs:FlxTypedGroup<CreditIcon>;
	var textVAs:FlxTypedGroup<CreditText>;

	var creditsMisc:FlxTypedGroup<CreditIcon>;
	var textMisc:FlxTypedGroup<CreditText>;

	var curCat:Int = 0;
	var curPage:Int = 0;
	var canDoStuff:Bool = false;

	var devTexts:FlxTypedGroup<FlxSprite>;
	
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


		
		

		creditsDevs = new FlxTypedGroup<CreditIcon>();
		add(creditsDevs);

		textDevs = new FlxTypedGroup<CreditText>();
		add(textDevs);

		creditsArtists = new FlxTypedGroup<CreditIcon>();
		add(creditsArtists);

		textArtists = new FlxTypedGroup<CreditText>();
		add(textArtists);

		creditsMusicians = new FlxTypedGroup<CreditIcon>();
		add(creditsMusicians);

		textMusicians = new FlxTypedGroup<CreditText>();
		add(textMusicians);

		creditsVAs = new FlxTypedGroup<CreditIcon>();
		add(creditsVAs);

		textVAs = new FlxTypedGroup<CreditText>();
		add(textVAs);

		creditsMisc = new FlxTypedGroup<CreditIcon>();
		add(creditsMisc);

		textMisc = new FlxTypedGroup<CreditText>();
		add(textMisc);

		panelLeft = new FlxSprite(-800, 0).loadGraphic(Paths.image("credits/leftPanel"));
		panelLeft.antialiasing = true;
		add(panelLeft);

		devTexts = new FlxTypedGroup<FlxSprite>();
		add(devTexts);

		creditsPage1 = new FlxTypedGroup<CreditIcon>();
		//add(creditsPage1);

		textPage1 = new FlxTypedGroup<FlxSprite>();
		//add(textPage1);

		arrowRight = new FlxSprite(939, 1000).loadGraphic(Paths.image("credits/arrowRight"));
		arrowRight.antialiasing = true;
		arrowRight.scale.set(0.8, 0.8);
		arrowRight.updateHitbox();
		add(arrowRight);

		arrowLeft = new FlxSprite(674, 1000).loadGraphic(Paths.image("credits/arrowLeft"));
		arrowLeft.antialiasing = true;
		arrowLeft.scale.set(0.8, 0.8);
		arrowLeft.updateHitbox();
		add(arrowLeft);

		creditsText = new FlxSprite(37, 1005).loadGraphic(Paths.image("credits/textCredits"));
		creditsText.antialiasing = true;
		add(creditsText);
		
		pointer = new FlxSprite(-100, -100).loadGraphic(Paths.image("credits/tinyArrow"));
		pointer.antialiasing = true;
		add(pointer);
		
		for (i in 0...5) {
			var sprName:String = '';
			switch (i) {
				case 0:
					sprName = 'textDevs';
				case 1:
					sprName = 'textArtists';
				case 2:
					sprName = 'textMusicians';
				case 3:
					sprName = 'textVoiceactors';
				case 4:
					sprName = 'textMiscellaneous';
			}
			var spr = new FlxSprite(26, 148 + (86 * i)).loadGraphic(Paths.image("credits/" + sprName));
			spr.antialiasing = true;
			//spr.scale.set(0.8, 0.8);
			spr.updateHitbox();
			spr.x -= 600;
			spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 0.7, 1);
			FlxTween.tween(spr, {x: spr.x + 600}, 1, {
				ease: FlxEase.quadOut,
				startDelay: 0.85 + (0.09 * -(i - 4)),
				onComplete: function (twn:FlxTween) {
					
				}
			});
			devTexts.add(spr);
			
			
		}
		for (i in 0...4) {
			var icon:CreditIcon = new CreditIcon();
			var text:CreditText = new CreditText();
			switch (i) {
				case 0:
					icon = new CreditIcon(339, 129, 'Amor', 'https://www.youtube.com/channel/UCffme2uZNxvK4s51DDALlNA');
					text = new CreditText(449, 141);
					text.loadGraphic(Paths.image('credits/text/creditAmor'));
				case 1:
					icon = new CreditIcon(382, 254, 'Cutie', 'https://twitter.com/ash__i_guess_');
					text = new CreditText(497, 267);
					text.loadGraphic(Paths.image('credits/text/creditAsh'));
				case 2:
					icon = new CreditIcon(447, 381, 'Cerbera', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(546, 386);
					text.loadGraphic(Paths.image('credits/text/creditCerbera'));
				case 3:
					icon = new CreditIcon(503, 486, 'Taeyai', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(608, 517);
					text.loadGraphic(Paths.image('credits/text/creditTaeyai'));
				
			}
			icon.antialiasing = true;
			text.antialiasing = true;
			text.x = -700;
			icon.x = -700;
			creditsDevs.add(icon);
			textDevs.add(text);
		}

		for (i in 0...14) {
			var icon:CreditIcon = new CreditIcon();
			var text:CreditText = new CreditText();
			switch (i) {
				case 0:
					icon = new CreditIcon(323, 124, 'Blu', 'https://www.youtube.com/channel/UCffme2uZNxvK4s51DDALlNA');
					text = new CreditText(439, 146);
					text.loadGraphic(Paths.image('credits/text/creditBluskys'));
				case 1:
					icon = new CreditIcon(375, 261, 'OhSoVanilla', 'https://twitter.com/ash__i_guess_');
					text = new CreditText(489, 265);
					text.loadGraphic(Paths.image('credits/text/creditOhSoVanilla'));
				case 2:
					icon = new CreditIcon(432, 368, 'Chris', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(542, 383);
					text.loadGraphic(Paths.image('credits/text/creditChris'));
				case 3:
					icon = new CreditIcon(470, 490, 'Fore', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(601, 504);
					text.loadGraphic(Paths.image('credits/text/creditFore'));
				case 4:
					icon = new CreditIcon(727, 119, 'LiterallyNick', 'https://www.youtube.com/channel/UCffme2uZNxvK4s51DDALlNA');
					text = new CreditText(841, 140);
					text.loadGraphic(Paths.image('credits/text/creditLiterallyNick'));
				case 5:
					icon = new CreditIcon(768, 238, 'Fran', 'https://twitter.com/ash__i_guess_');
					text = new CreditText(894, 260);
					text.loadGraphic(Paths.image('credits/text/creditFran'));
				case 6:
					icon = new CreditIcon(827, 358, 'Typic', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(941, 382);
					text.loadGraphic(Paths.image('credits/text/creditTypic'));
				case 7:
					icon = new CreditIcon(886, 480, 'Scorch', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(1005, 508);
					text.loadGraphic(Paths.image('credits/text/creditScorch'));
				case 8:
					icon = new CreditIcon(322, 122, 'Kaos', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(460, 136);
					text.loadGraphic(Paths.image('credits/text/creditKaos'));
				case 9:
					icon = new CreditIcon(375, 258, 'Ohya', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(490, 263);
					text.loadGraphic(Paths.image('credits/text/ohyaName'));
				case 10:
					icon = new CreditIcon(419, 355, 'Justified', 'https://www.youtube.com/channel/UCffme2uZNxvK4s51DDALlNA');
					text = new CreditText(541, 383);
					text.loadGraphic(Paths.image('credits/text/creditJustified'));
				case 11:
					icon = new CreditIcon(731, 126, 'Rebecca', 'https://twitter.com/ash__i_guess_');
					text = new CreditText(841, 137);
					text.loadGraphic(Paths.image('credits/text/creditRebecca'));
				case 12:
					icon = new CreditIcon(770, 241, 'Jyro', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(895, 245);
					text.loadGraphic(Paths.image('credits/text/creditJyro'));
				case 13:
					icon = new CreditIcon(814, 348, 'SugarRatio', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(944, 382);
					text.loadGraphic(Paths.image('credits/text/creditSugarRatio'));
				
			}
			icon.antialiasing = true;
			text.antialiasing = true;
			text.x = -700;
			icon.x = -700;
			if (i >= 8) {
				text.xPos += FlxG.width;
				icon.xPos += FlxG.width;
			}
			creditsArtists.add(icon);
			textArtists.add(text);
		}

		for (i in 0...8) {
			var icon:CreditIcon = new CreditIcon();
			var text:CreditText = new CreditText();
			switch (i) {
				case 0:
					icon = new CreditIcon(340, 127, 'Mike', 'https://www.youtube.com/channel/UCffme2uZNxvK4s51DDALlNA');
					text = new CreditText(440, 143);
					text.loadGraphic(Paths.image('credits/text/creditMike'));
				case 1:
					icon = new CreditIcon(382, 244, 'Jghost', 'https://twitter.com/ash__i_guess_');
					text = new CreditText(489, 265);
					text.loadGraphic(Paths.image('credits/text/creditJghost'));
				case 2:
					icon = new CreditIcon(422, 373, 'Mango', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(528, 379);
					text.loadGraphic(Paths.image('credits/text/creditMango'));
				case 3:
					icon = new CreditIcon(494, 479, 'Astro', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(593, 504);
					text.loadGraphic(Paths.image('credits/text/creditAstro'));
				case 4:
					icon = new CreditIcon(737, 125, 'Seabo', 'https://www.youtube.com/channel/UCffme2uZNxvK4s51DDALlNA');
					text = new CreditText(846, 142);
					text.loadGraphic(Paths.image('credits/text/creditSeabo'));
				case 5:
					icon = new CreditIcon(771, 268, 'Cerberus', 'https://twitter.com/ash__i_guess_');
					text = new CreditText(896, 264);
					text.loadGraphic(Paths.image('credits/text/creditCerberus'));
				case 6:
					icon = new CreditIcon(833, 375, 'Cougar', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(931, 387);
					text.loadGraphic(Paths.image('credits/text/creditCougar'));
				case 7:
					icon = new CreditIcon(888, 487, 'Mini', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(1006, 498);
					text.loadGraphic(Paths.image('credits/text/creditMini'));
				
			}
			icon.antialiasing = true;
			text.antialiasing = true;
			text.x = -700;
			icon.x = -700;
			creditsVAs.add(icon);
			textVAs.add(text);
		}
		
		for (i in 0...8) {
			var icon:CreditIcon = new CreditIcon();
			var text:CreditText = new CreditText();
			switch (i) {
				case 0:
					icon = new CreditIcon(333, 127, 'DPZ', 'https://www.youtube.com/channel/UCffme2uZNxvK4s51DDALlNA');
					text = new CreditText(447, 140);
					text.loadGraphic(Paths.image('credits/text/creditDPZ'));
				case 1:
					icon = new CreditIcon(358, 248, 'Ardolf', 'https://twitter.com/ash__i_guess_');
					text = new CreditText(487, 279);
					text.loadGraphic(Paths.image('credits/text/creditArdolf'));
				case 2:
					icon = new CreditIcon(426, 374, 'Vlusky', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(528, 401);
					text.loadGraphic(Paths.image('credits/text/creditVlusky'));
				case 3:
					icon = new CreditIcon(491, 512, 'Boom', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(601, 524);
					text.loadGraphic(Paths.image('credits/text/creditBoomkitty'));
				case 4:
					icon = new CreditIcon(722, 129, 'Splatter', 'https://www.youtube.com/channel/UCffme2uZNxvK4s51DDALlNA');
					text = new CreditText(834, 140);
					text.loadGraphic(Paths.image('credits/text/creditSplatter'));
				case 5:
					icon = new CreditIcon(749, 253, 'Hado', 'https://twitter.com/ash__i_guess_');
					text = new CreditText(846, 274);
					text.loadGraphic(Paths.image('credits/text/creditHado'));
				case 6:
					icon = new CreditIcon(837, 397, 'HJ', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(936, 402);
					text.loadGraphic(Paths.image('credits/text/creditHJFod'));
				case 7:
					icon = new CreditIcon(888, 511, 'LiterallyNoOne', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(995, 524);
					text.loadGraphic(Paths.image('credits/text/creditLiterallyNoOne'));
				
			}
			icon.antialiasing = true;
			text.antialiasing = true;
			text.x = -700;
			icon.x = -700;
			creditsMusicians.add(icon);
			textMusicians.add(text);
		}
		
		
		for (i in 0...8) {
			var icon:CreditIcon = new CreditIcon();
			var text:CreditText = new CreditText();
			switch (i) {
				case 0:
					icon = new CreditIcon(307, 119, 'Both', 'https://www.youtube.com/channel/UCffme2uZNxvK4s51DDALlNA');
					text = new CreditText(464, 120);
					text.loadGraphic(Paths.image('credits/text/dunkandPizza'));
				case 1:
					icon = new CreditIcon(385, 259, 'Raku', 'https://twitter.com/ash__i_guess_');
					text = new CreditText(496, 282);
					text.loadGraphic(Paths.image('credits/text/creditRakurai'));
				case 2:
					icon = new CreditIcon(453, 377, 'Corrupt', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(560, 380);
					text.loadGraphic(Paths.image('credits/text/creditCorrupt'));
				case 3:
					icon = new CreditIcon(505, 494, 'Wildy', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(615, 501);
					text.loadGraphic(Paths.image('credits/text/creditWildy'));
				case 4:
					icon = new CreditIcon(747, 115, 'Yoshe', 'https://www.youtube.com/channel/UCffme2uZNxvK4s51DDALlNA');
					text = new CreditText(879, 150);
					text.loadGraphic(Paths.image('credits/text/creditYoshe'));
				case 5:
					icon = new CreditIcon(797, 271, 'Juni', 'https://twitter.com/ash__i_guess_');
					text = new CreditText(905, 283);
					text.loadGraphic(Paths.image('credits/text/creditJuniper'));
				case 6:
					icon = new CreditIcon(829, 375, 'Phlox', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(954, 393);
					text.loadGraphic(Paths.image('credits/text/creditPhlox'));
				case 7:
					icon = new CreditIcon(865, 480, 'Bon', 'https://www.youtube.com/channel/UCgfJjMiNGlI7uZu1cVag5NA');
					text = new CreditText(984, 502);
					text.loadGraphic(Paths.image('credits/text/creditBon'));
				case 8:
					text = new CreditText(622, 20);
					text.loadGraphic(Paths.image('credits/text/specialThanks'));
				case 9:
					text = new CreditText(273, 129);
					text.loadGraphic(Paths.image('credits/text/specialThanksRow1'));
				case 10:
					text = new CreditText(492, 129);
					text.loadGraphic(Paths.image('credits/text/specialThanksRow2'));
				case 11:
					text = new CreditText(741, 129);
					text.loadGraphic(Paths.image('credits/text/specialThanksRow3'));
				
			}
			icon.antialiasing = true;
			text.antialiasing = true;
			text.x = -700;
			icon.x = -700;
			if (i >= 8) {
				text.xPos += FlxG.width;
			} else
				creditsMisc.add(icon);
			textMisc.add(text);
		}
		FlxTween.tween(FlxG.camera, {zoom: 1.05}, 1.2, {
			ease: FlxEase.cubeOut,
			onComplete: function (twn:FlxTween) {
				FlxTween.tween(FlxG.camera, {zoom: 1}, 0.2, {
					ease: FlxEase.quadIn
				});
			}
		});

		FlxTween.tween(arrowLeft, {y: 611}, 1, {
			ease: FlxEase.quadOut,
			startDelay: 1.2,
		});
		

		FlxTween.tween(creditsText, {y: 618}, 1, {
			ease: FlxEase.quadOut,
			startDelay: 1.3,
		});

		FlxTween.tween(arrowRight, {y: 611}, 1, {
			ease: FlxEase.quadOut,
			startDelay: 1.4,
		});

		FlxTween.tween(panelTop, {y: 0}, 1, {
			ease: FlxEase.quadOut,
			//startDelay: 0.6,
		});

		FlxTween.tween(panelLeft, {x: 0}, 1, {
			ease: FlxEase.quadOut,
			startDelay: 0.6,
		});

		FlxTween.tween(panelBottom, {y: 0}, 1, {
			ease: FlxEase.quadOut,
			//startDelay: 0.6,
		});

		FlxTween.tween(panelMiddle, {alpha: 1}, 1.4, {
			ease: FlxEase.cubeOut,
			//startDelay: 0.6,
		});

	
		new FlxTimer().start(2.2, function(tmr:FlxTimer)
		{
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				canDoStuff = true;
			});
			curCat = 0;
			changeCat(0, true, true);
		});
		

	}

	function changeDev() {

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
			if (controls.UP_P) {
				changeCat(-1);
			}
			if (controls.DOWN_P) {
				changeCat(1);
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

		for (i in 0...devTexts.length) {
			if (FlxG.mouse.overlaps(devTexts.members[i]) && FlxG.mouse.justPressed && canDoStuff) {
				changeCat(i, true);
			}
		}
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

	function checkPage(cat:Int, ?text:Bool = false):FlxTypedGroup<Dynamic> {
		switch (cat) {
			case 0:
				if (text) 
					return textDevs;
				else
					return creditsDevs;
			case 1:
				if (text)
					return textArtists;
				else
					return creditsArtists;
			case 2:
				if (text)
					return textMusicians;
				else
					return creditsMusicians;
			case 3:
				if (text)
					return textVAs;
				else
					return creditsVAs;
			case 4:
				if (text)
					return textMisc;
				else
					return creditsMisc;
			default:
				if (text) 
					return textDevs;
				else
					return creditsDevs;
		}
	}
	function changePage(change:Int = 0, ?instant:Bool = false):Void {
		canDoStuff = false;
		var prevPage = curPage;
		var max:Int = 0;
		var lol = checkPage(curCat);
		if (curCat == 1 || curCat == 4) {
			max = 1;
			trace('worked');
		}
		curPage += change;
		if (instant)
			curPage = change;
		if (curPage < 0) {
			curPage = 0;
			canDoStuff = true;
		} else if (curPage > max) {
			curPage = max;
			canDoStuff = true;
		}
		if (prevPage != curPage) {
			trace('worked 2');
			for (i in checkPage(curCat)) {
				i.theTween = FlxTween.tween(i, {x: i.x - FlxG.width * change}, 0.6, {ease: FlxEase.cubeOut});
			}
			for (i in checkPage(curCat, true)) {
				i.theTween = FlxTween.tween(i, {x: i.x - FlxG.width * change}, 0.6, {ease: FlxEase.cubeOut});
			}
			new FlxTimer().start(0.4, function(tmr:FlxTimer)
			{
				canDoStuff = true;	
			});
		}
	}
	function changeCat(change:Int = 0, ?instant:Bool = false, ?force:Bool = false):Void {
		canDoStuff = false;
		var prevPage = curPage;
		var prevCat = curCat;
		curCat += change;
		if (instant)
			curCat = change;
		if (!force) {
			if (curCat < 0) {
				curCat = 0;
				canDoStuff = true;
			} else if (curCat > 4) {
				curCat = 4;
				canDoStuff = true;
			}
		}
		if (prevCat != curCat || force) {
			curPage = 0;

			new FlxTimer().start(0.6, function(tmr:FlxTimer)
			{
				canDoStuff = true;	
			});
				
			for (i in 0...devTexts.length) {
				var spr = devTexts.members[i];
				if (i == curCat) {
					spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 1, 1);
					pointer.setPosition(spr.x + spr.width + 8, spr.y + 4);
				} else {
					spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 0.7, 1);
				}
			}
			var woootween:FlxTween;

			for (i in checkPage(prevCat)) {
				i.theTween = FlxTween.tween(i, {x: -730}, 0.5, {ease: FlxEase.cubeIn});
			}
			for (i in checkPage(prevCat, true)) {
				i.theTween = FlxTween.tween(i, {x: -730}, 0.5, {ease: FlxEase.cubeIn});
			}
			
			for (i in checkPage(curCat)) {
				i.theTween.cancel();
				FlxTween.tween(i, {x: i.xPos}, 0.6, {
					ease: FlxEase.quadOut,
					onComplete: function (twn:FlxTween) {
						
					}
				});
			}
			for (i in checkPage(curCat, true)) {
				i.theTween.cancel();
				FlxTween.tween(i, {x: i.xPos}, 0.6, {
					ease: FlxEase.quadOut,
				});
			}

			
			var funnyListlol:Array<Dynamic> = [creditsArtists, textArtists, textMisc];
			for (grp in funnyListlol) {
				for (i in 0...grp.length) {
					var wee = grp.members[i];
					
					if (i >= 8 && prevPage == 0) {
						wee.theTween.cancel();
						wee.setPosition(wee.xPos, wee.yPos);
					}
				}
			}
			/*for (i in creditsPage1) {
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
			}*/
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
				
			}
		});

		FlxTween.tween(FlxG.camera, {zoom: 0.8}, 0.6, {startDelay: 0.6});
		for (i in checkPage(curCat)) {
			i.theTween = FlxTween.tween(i, {x: -730}, 0.5, {ease: FlxEase.cubeIn});
		}
		for (i in checkPage(curCat, true)) {
			i.theTween = FlxTween.tween(i, {x: -730}, 0.5, {ease: FlxEase.cubeIn});
		}
		
		var funnyListlol:Array<Dynamic> = [creditsArtists, textArtists, textMisc];
		for (grp in funnyListlol) {
			for (i in 0...grp.length) {
				var wee = grp.members[i];
				
				if (i >= 8 && curCat == 0) {
					wee.theTween.cancel();
					wee.setPosition(wee.xPos, wee.yPos);
				}
			}
		}

		FlxTween.tween(panelLeft, {x: panelLeft.x - 900}, 0.8, {
			ease: FlxEase.cubeOut,
			startDelay: 0.4,
			onComplete: function(twn:FlxTween) {
				FlxG.switchState(new MainMenuState());
			}
		});

		for (i in devTexts) {
			FlxTween.tween(i, {x: i.x - 900}, 0.8, {
				ease: FlxEase.cubeOut,
				startDelay: 0.44,
			});
		}

		FlxTween.tween(pointer, {x: pointer.x - 900}, 0.8, {
			ease: FlxEase.cubeOut,
			startDelay: 0.44,
		});

	}
	override function beatHit()
	{
		super.beatHit();
		
	}
}

class CreditText extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var xPos:Float;
	public var yPos:Float;
	public var theTween:FlxTween;
	public function new(xPos:Float = 0, yPos:Float = 0)
	{
		this.xPos = xPos;
		this.yPos = yPos;
		super(xPos, yPos);
		theTween = FlxTween.tween(this, {x: x}, 0, {});
	}
}