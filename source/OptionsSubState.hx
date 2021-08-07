package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import Options;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.math.FlxPoint;

class OptionsSubState extends MusicBeatSubstate
{
	public static var instance:OptionsSubState;

	var selector:FlxText;
	var curSelected:Int = 0;
	
	var curPage:Int = 0;
	var pageMax:Int = 0;

	var rightArrow:FlxSprite;
	var leftArrow:FlxSprite;

	var quickAccess:FlxSprite;
	var quickAppearance:FlxSprite;
	var quickGameplay:FlxSprite;
	var quickMisc:FlxSprite;
	public static var inDesktop:Bool = false;
	public var closeFunction:Void->Void = null;

	var options:Array<OptionCategory> = [
		new OptionCategory("Appearance", [
			#if desktop
			new DistractionsAndEffectsOption("Toggle stage distractions that can hinder your gameplay."),
			new RainbowFPSOption("Make the FPS Counter Rainbow"),
			new AccuracyOption("Display accuracy information."),
			new NPSDisplayOption("Shows your current Notes Per Second."),
			new SongPositionOption("Show the songs current position (as a bar)"),
			#else
			new DistractionsAndEffectsOption("Toggle stage distractions that can hinder your gameplay.")
			#end
		]),
		new OptionCategory("Gameplay", [
			new DFJKOption(controls),
			new DownscrollOption("Change the layout of the strumline."),
			new GhostTapOption("Ghost Tapping is when you tap a direction and it doesn't give you a miss."),
			new Judgement("Customize your Hit Timings (LEFT or RIGHT)"),
			#if desktop
			new FPSCapOption("Cap your FPS"),
			#end
			new ScrollSpeedOption("Change your scroll speed (1 = Chart dependent)"),
			new AccuracyDOption("Change how accuracy is calculated. (Accurate = Simple, Complex = Milisecond Based)"),
			new ResetButtonOption("Toggle pressing R to gameover."),
			// new OffsetMenu("Get a note offset based off of your inputs!"),
			new CustomizeGameplay("Drag'n'Drop Gameplay Modules around to your preference")
		]),
		
		
		new OptionCategory("Misc", [
			#if desktop
			new FPSOption("Toggle the FPS Counter"),
			new ReplayOption("View replays"),
			#end
			new FlashingLightsOption("Toggle flashing lights that can cause epileptic seizures and strain."),
			new WatermarkOption("Enable and disable all watermarks from the engine."),
			new BotPlay("Showcase your charts and mods with autoplay."),
			new EraseSaveData("Erase ALL your save data. WARNING: this will close your game.")
		])
		
	];

	public var acceptInput:Bool = true;

	private var currentDescription:String = "";
	private var grpControls:FlxTypedGroup<FlxSprite>;
	private var grpBars:FlxTypedGroup<FlxSprite>;
	private var grpCoolIcons:FlxTypedGroup<FlxSprite>;
	public static var versionShit:FlxText;

	var currentSelectedCat:OptionCategory;
	var blackBorder:FlxSprite;
	var border:FlxSprite;
	var menuBG:FlxSprite;

	var isCat:Bool = false;

	var exitButton:FlxSprite;

	var exitPos:FlxPoint;
	public function new(pos:FlxPoint)
	{
		super();
		FlxG.mouse.visible = true;
		acceptInput = false;
		var zoom:FlxSprite = new FlxSprite(pos.x, pos.y).loadGraphic(Paths.image('desktop/settings/settingsZoom'));
		zoom.origin.set(0, 0);
		zoom.scale.set(0.1, 0.1);
		zoom.alpha = 0;
		add(zoom);
		FlxTween.tween(zoom.scale, {x: 1, y: 1}, 0.3, {ease: FlxEase.cubeOut});
		FlxTween.tween(zoom, {x: 0, y: 0, alpha: 1}, 0.3, {ease: FlxEase.cubeOut, onComplete: function(twn:FlxTween) {
			exitPos = pos;
			remove(zoom);
			instance = this;
			acceptInput = true;
	
			menuBG = new FlxSprite().loadGraphic(Paths.image("desktop/settings/settingsFolder"));
	
			//menuBG.color = 0xFFea71fd;
			//menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
			menuBG.updateHitbox();
			menuBG.screenCenter();
			menuBG.antialiasing = true;
			add(menuBG);
	
			grpBars = new FlxTypedGroup<FlxSprite>();
			add(grpBars);
			grpCoolIcons = new FlxTypedGroup<FlxSprite>();
			add(grpCoolIcons);
			grpControls = new FlxTypedGroup<FlxSprite>();
			add(grpControls);
	
			for (i in 0...options.length)
			{
				var controlLabel:FlxSprite = new FlxSprite();
				var controlBar:FlxSprite = new FlxSprite();
				var coolIcon:FlxSprite = new FlxSprite();
				switch (i) {
					case 0:
						controlLabel = new FlxSprite(209, 486).loadGraphic(Paths.image('desktop/settings/appearanceText'));
						controlBar = new FlxSprite(170, 97).makeGraphic(429, 609, FlxColor.BLACK);
						coolIcon = new FlxSprite(221, 225).loadGraphic(Paths.image('desktop/settings/appearanceLogo'));
					case 1:
						controlLabel = new FlxSprite(628, 486).loadGraphic(Paths.image('desktop/settings/gameplayText'));
						controlBar = new FlxSprite(599, 97).makeGraphic(352, 609, FlxColor.BLACK);
						coolIcon = new FlxSprite(649, 229).loadGraphic(Paths.image('desktop/settings/gameplayLogo'));
					case 2:
						controlLabel = new FlxSprite(1034, 486).loadGraphic(Paths.image('desktop/settings/miscText'));
						controlBar = new FlxSprite(951, 97).makeGraphic(314, 609, FlxColor.BLACK);
						coolIcon = new FlxSprite(1002, 222).loadGraphic(Paths.image('desktop/settings/miscLogo'));
				}
				controlBar.alpha = 0;
				grpBars.add(controlBar);
				grpCoolIcons.add(coolIcon);
				grpControls.add(controlLabel);
			}
	
			currentDescription = "none";
	
			versionShit = new FlxText(5, FlxG.height + 40, 0, "Offset (Left, Right, Shift for slow): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription, 12);
			versionShit.scrollFactor.set();
			versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			
			border = new FlxSprite().loadGraphic(Paths.image('desktop/settings/settingsBorder'));
			add(border);
	
			quickAccess = new FlxSprite(16, 138).loadGraphic(Paths.image('desktop/settings/quickaccessText'));
			add(quickAccess);
	
			quickAppearance = new FlxSprite(16, 178).loadGraphic(Paths.image('desktop/settings/appearanceQuickaccess'));
			add(quickAppearance);
	
			quickGameplay = new FlxSprite(16, 206).loadGraphic(Paths.image('desktop/settings/gameplayQuickaccess'));
			add(quickGameplay);
	
			quickMisc = new FlxSprite(16, 233).loadGraphic(Paths.image('desktop/settings/miscQuickaccess'));
			add(quickMisc);
	
			exitButton = new FlxSprite(16, 12).loadGraphic(Paths.image('desktop/gallery/xText'));
			add(exitButton);
	
			blackBorder = new FlxSprite(-30,FlxG.height + 40).makeGraphic((Std.int(versionShit.width + 900)),Std.int(versionShit.height + 600),FlxColor.BLACK);
			blackBorder.alpha = 0.5;
			add(blackBorder);
			
			add(versionShit);
	
			FlxTween.tween(versionShit,{y: FlxG.height - 18},1,{ease: FlxEase.elasticInOut});
			FlxTween.tween(blackBorder,{y: FlxG.height - 18},1, {ease: FlxEase.elasticInOut});
		},});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (acceptInput)
		{
			if (isCat)
				currentDescription = currentSelectedCat.getOptions()[curSelected].getDescription();
			else
				versionShit.text = "Please select a category";

			if (FlxG.mouse.overlaps(exitButton)) {
				exitButton.color = FlxColor.fromHSL(exitButton.color.hue, exitButton.color.saturation, 1, 1);
			} else {
				exitButton.color = FlxColor.fromHSL(exitButton.color.hue, exitButton.color.saturation, 0.7, 1);
			}
			if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(exitButton)) {
				if (isCat)
					leaveCat();
				else
					leaveOptions();
			}

			if (FlxG.mouse.overlaps(quickAppearance)) {
				quickAppearance.color = FlxColor.fromHSL(quickAppearance.color.hue, quickAppearance.color.saturation, 1, 1);
			} else {
				quickAppearance.color = FlxColor.fromHSL(quickAppearance.color.hue, quickAppearance.color.saturation, 0.7, 1);
			}
			if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(quickAppearance)) {
				resetText(0);
			}

			if (FlxG.mouse.overlaps(quickGameplay)) {
				quickGameplay.color = FlxColor.fromHSL(quickGameplay.color.hue, quickGameplay.color.saturation, 1, 1);
			} else {
				quickGameplay.color = FlxColor.fromHSL(quickGameplay.color.hue, quickGameplay.color.saturation, 0.7, 1);
			}
			if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(quickGameplay)) {
				resetText(1);
			}

			if (FlxG.mouse.overlaps(quickMisc)) {
				quickMisc.color = FlxColor.fromHSL(quickMisc.color.hue, quickMisc.color.saturation, 1, 1);
			} else {
				quickMisc.color = FlxColor.fromHSL(quickMisc.color.hue, quickMisc.color.saturation, 0.7, 1);
			}
			if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(quickMisc)) {
				resetText(2);
			}


			for (i in 0...grpBars.members.length) {
				if (FlxG.mouse.overlaps(grpBars.members[i])) {
					grpBars.members[i].alpha = 0.2;
					grpControls.members[i].color = FlxColor.fromHSL(grpControls.members[i].color.hue, grpControls.members[i].color.saturation, 1, 1);
					if (!isCat)
						grpCoolIcons.members[i].color = FlxColor.fromHSL(grpCoolIcons.members[i].color.hue, grpCoolIcons.members[i].color.saturation, 1, 1);
					curSelected = i;
				} else {
					grpBars.members[i].alpha = 0;
					grpControls.members[i].color = FlxColor.fromHSL(grpControls.members[i].color.hue, grpControls.members[i].color.saturation, 0.7, 1);
					if (!isCat)
						grpCoolIcons.members[i].color = FlxColor.fromHSL(grpCoolIcons.members[i].color.hue, grpCoolIcons.members[i].color.saturation, 0.7, 1);
				}
			}
			if (controls.BACK && !isCat) {
				leaveOptions();
			}	
			else if (controls.BACK)
			{
				leaveCat();
			}
			/*if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);*/
			
			if (isCat)
			{
				
				if (currentSelectedCat.getOptions()[curSelected].getAccept())
				{
					if (FlxG.keys.pressed.SHIFT)
						{
							if (FlxG.keys.pressed.RIGHT)
								currentSelectedCat.getOptions()[curSelected].right();
							if (FlxG.keys.pressed.LEFT)
								currentSelectedCat.getOptions()[curSelected].left();
						}
					else
					{
						if (FlxG.keys.justPressed.RIGHT)
							currentSelectedCat.getOptions()[curSelected].right();
						if (FlxG.keys.justPressed.LEFT)
							currentSelectedCat.getOptions()[curSelected].left();
					}
				}
				else
				{

					if (FlxG.keys.pressed.SHIFT)
					{
						if (FlxG.keys.justPressed.RIGHT)
							FlxG.save.data.offset += 0.1;
						else if (FlxG.keys.justPressed.LEFT)
							FlxG.save.data.offset -= 0.1;
					}
					else if (FlxG.keys.pressed.RIGHT)
						FlxG.save.data.offset += 0.1;
					else if (FlxG.keys.pressed.LEFT)
						FlxG.save.data.offset -= 0.1;
					
				
				}
				if (currentSelectedCat.getOptions()[curSelected].getAccept())
					versionShit.text =  currentSelectedCat.getOptions()[curSelected].getValue() + " - Description - " + currentDescription;
				else
					versionShit.text = "Offset (Left, Right, Shift for slow): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;

				//sorrey :(
				if (FlxG.mouse.overlaps(rightArrow)) {
					rightArrow.color = FlxColor.fromHSL(rightArrow.color.hue, rightArrow.color.saturation, 1, 1);
				} else {
					rightArrow.color = FlxColor.fromHSL(rightArrow.color.hue, rightArrow.color.saturation, 0.7, 1);
				}
				if (FlxG.mouse.overlaps(leftArrow)) {
					leftArrow.color = FlxColor.fromHSL(leftArrow.color.hue, leftArrow.color.saturation, 1, 1);
				} else {
					leftArrow.color = FlxColor.fromHSL(leftArrow.color.hue, leftArrow.color.saturation, 0.7, 1);
				}
				if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(rightArrow)) {
					changePage(1);
				}
				if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(leftArrow)) {
					changePage(-1);
				}
				if (FlxG.mouse.pressed && FlxG.mouse.overlaps(rightArrow)) {
					rightArrow.scale.set(0.95, 0.95);
				} else {
					rightArrow.scale.set(1, 1);
				}
				if (FlxG.mouse.pressed && FlxG.mouse.overlaps(leftArrow)) {
					leftArrow.scale.set(0.95, 0.95);
				} else {
					leftArrow.scale.set(1, 1);
				}
			}
			else
			{
				if (FlxG.keys.pressed.SHIFT)
					{
						if (FlxG.keys.justPressed.RIGHT)
							FlxG.save.data.offset += 0.1;
						else if (FlxG.keys.justPressed.LEFT)
							FlxG.save.data.offset -= 0.1;
					}
					else if (FlxG.keys.pressed.RIGHT)
						FlxG.save.data.offset += 0.1;
					else if (FlxG.keys.pressed.LEFT)
						FlxG.save.data.offset -= 0.1;
			}
		

			if (controls.RESET)
					FlxG.save.data.offset = 0;

			if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(grpBars))
			{
				if (isCat) {
					currentSelectedCat.getOptions()[curSelected].press();
					grpControls.remove(grpControls.members[curSelected]);
					var controlLabel = new FlxSprite(170, 97 + (102 * (curSelected % 5))).loadGraphic(Paths.image('desktop/settings/text/' + currentSelectedCat.getOptions()[curSelected].getDisplay()));
					grpControls.add(controlLabel);
				} else
					resetText(curSelected);
			}
		}
		FlxG.save.flush();
	}

	
	var isSettingControl:Bool = false;

	function leaveCat() {
		isCat = false;
		grpControls.clear();
		grpBars.clear();
		remove(rightArrow);
		remove(leftArrow);
		remove(exitButton);
		exitButton = new FlxSprite(16, 12).loadGraphic(Paths.image('desktop/gallery/xText'));
		add(exitButton);
		for (i in 0...options.length)
		{
			var controlLabel:FlxSprite = new FlxSprite();
			var controlBar:FlxSprite = new FlxSprite();
			var coolIcon:FlxSprite = new FlxSprite();
			switch (i) {
				case 0:
					controlLabel = new FlxSprite(209, 486).loadGraphic(Paths.image('desktop/settings/appearanceText'));
					controlBar = new FlxSprite(170, 97).makeGraphic(429, 609, FlxColor.BLACK);
					coolIcon = new FlxSprite(221, 225).loadGraphic(Paths.image('desktop/settings/appearanceLogo'));
				case 1:
					controlLabel = new FlxSprite(628, 486).loadGraphic(Paths.image('desktop/settings/gameplayText'));
					controlBar = new FlxSprite(599, 97).makeGraphic(352, 609, FlxColor.BLACK);
					coolIcon = new FlxSprite(649, 229).loadGraphic(Paths.image('desktop/settings/gameplayLogo'));
				case 2:
					controlLabel = new FlxSprite(1034, 486).loadGraphic(Paths.image('desktop/settings/miscText'));
					controlBar = new FlxSprite(951, 97).makeGraphic(314, 609, FlxColor.BLACK);
					coolIcon = new FlxSprite(1002, 222).loadGraphic(Paths.image('desktop/settings/miscLogo'));
			}
			controlBar.alpha = 0;
			grpBars.add(controlBar);
			grpCoolIcons.add(coolIcon);
			grpControls.add(controlLabel);
		}
	}
	function resetText(cat:Int) {
		currentSelectedCat = options[cat];
		grpControls.clear();
		grpBars.clear();
		if (!isCat) {
			grpCoolIcons.clear();
			remove(exitButton);
			exitButton = new FlxSprite(16, 12).loadGraphic(Paths.image('desktop/gallery/backText'));
			add(exitButton);
		}

		for (i in 0...currentSelectedCat.getOptions().length)
		{
			var controlBar = new FlxSprite(170 + (FlxG.width * (Math.floor(i / 5))), 97 + (102 * (i % 5))).makeGraphic(900, 100, FlxColor.BLACK);
			controlBar.alpha = 0;
			grpBars.add(controlBar);

			var controlLabel = new FlxSprite(170 + (FlxG.width * (Math.floor(i / 5))), 97 + (102 * (i % 5))).loadGraphic(Paths.image('desktop/settings/text/' + currentSelectedCat.getOptions()[i].getDisplay()));
			grpControls.add(controlLabel);

			
			pageMax = Math.floor(i / 5);
		}

		curPage = 0;

		if (!isCat) {
			rightArrow = new FlxSprite(1126, 613).loadGraphic(Paths.image('desktop/settings/exitButton'));
			rightArrow.flipX = true;
			add(rightArrow);

			leftArrow = new FlxSprite(176, 613).loadGraphic(Paths.image('desktop/settings/exitButton'));
			add(leftArrow);
		}
		isCat = true;
		curSelected = 0;
	}
	function changePage(change:Int = 0) 
	{
		acceptInput = false;
		var prevPage = curPage; 
		curPage += change;
		if (curPage < 0) {
			curPage = 0;
			acceptInput = true;
		} else if (curPage > pageMax) {
			curPage = pageMax;
			acceptInput = true;
		}
		if (prevPage != curPage) {
			for (i in grpControls) {
				FlxTween.tween(i, {x: i.x + FlxG.width * -change}, 1, {
					ease: FlxEase.quadOut,
				});
				FlxTween.tween(grpBars.members[grpControls.members.indexOf(i)], {x: i.x + FlxG.width * -change}, 1, {
					ease: FlxEase.quadOut,
					onComplete: function (twn:FlxTween) {
						acceptInput = true;
					}
				});
			}
		}
	}

	function leaveOptions()
	{
		acceptInput = false;

		
		border.visible = false;

		quickAccess.visible = false;

		quickAppearance.visible = false;

		quickGameplay.visible = false;

		quickMisc.visible = false;

		exitButton.visible = false;

		blackBorder.visible = false;

		versionShit.visible = false;
	
		for (i in grpControls)
			i.visible = false;
		
		for (i in grpBars)
			i.visible = false;

		for (i in grpCoolIcons)
			i.visible = false;

		menuBG.visible = false;

		var zoom:FlxSprite = new FlxSprite().loadGraphic(Paths.image('desktop/settings/settingsZoom'));
		add(zoom);
		zoom.origin.set(0, 0);
		FlxTween.tween(zoom.scale, {x: 0.1, y: 0.1}, 0.3, {ease: FlxEase.cubeOut});
		FlxTween.tween(zoom, {x: exitPos.x, y: exitPos.y, alpha: 0}, 0.3, {ease: FlxEase.cubeOut, onComplete: function(twn:FlxTween) {
			close();
			if (closeFunction != null)
				closeFunction();
		},});
	}
	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent("Fresh");
		#end
		
		FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		if (isCat)
			currentDescription = currentSelectedCat.getOptions()[curSelected].getDescription();
		else
			currentDescription = "Please select a category";
		if (isCat)
		{
			if (currentSelectedCat.getOptions()[curSelected].getAccept())
				versionShit.text =  currentSelectedCat.getOptions()[curSelected].getValue() + " - Description - " + currentDescription;
			else
				versionShit.text = "Offset (Left, Right, Shift for slow): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
		}
		else
			versionShit.text = "Offset (Left, Right, Shift for slow): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
		// selector.y = (70 * curSelected) + 30;
	}
}
