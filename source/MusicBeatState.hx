package;

#if windows
import Discord.DiscordClient;
#end
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import openfl.Lib;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
import flixel.text.FlxText;

class MusicBeatState extends FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	var camAchievement:FlxCamera;
	var achievementArray:Array<String> = [];

	override function create()
	{
		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

		if (transIn != null)
			trace('reg ' + transIn.region);

		super.create();

		//camAchievement = new FlxCamera();
		//camAchievement.bgColor.alpha = 0;
		//FlxG.cameras.add(camAchievement);
	}


	var array:Array<FlxColor> = [
		FlxColor.fromRGB(148, 0, 211),
		FlxColor.fromRGB(75, 0, 130),
		FlxColor.fromRGB(0, 0, 255),
		FlxColor.fromRGB(0, 255, 0),
		FlxColor.fromRGB(255, 255, 0),
		FlxColor.fromRGB(255, 127, 0),
		FlxColor.fromRGB(255, 0 , 0)
	];

	var skippedFrames = 0;

	var showingAchievement:Bool = false;

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		if (FlxG.save.data.fpsRain && skippedFrames >= 6)
			{
				if (currentColor >= array.length)
					currentColor = 0;
				(cast (Lib.current.getChildAt(0), Main)).changeFPSColor(array[currentColor]);
				currentColor++;
				skippedFrames = 0;
			}
			else
				skippedFrames++;

		if ((cast (Lib.current.getChildAt(0), Main)).getFPSCap != FlxG.save.data.fpsCap && FlxG.save.data.fpsCap <= 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

		super.update(elapsed);
		if (!showingAchievement && achievementArray.length > 0) {

			var leText:String = achievementArray[0];
			achievementArray.splice(0, 1);
			showingAchievement = true;
			var achievementBox:FlxSprite = new FlxSprite(0, FlxG.height ).loadGraphic(Paths.image('achieve'));
			//achievementBox.cameras = [camAchievement];
			achievementBox.alpha = 0;
			add(achievementBox);
			achievementBox.y -= achievementBox.height;
			var achievementName = new FlxText(113, (FlxG.height - achievementBox.height) + 14, 283, leText, 16);
			achievementName.setFormat(Paths.font("PUSAB.otf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			achievementName.alpha = 0;
			//achievementName.cameras = [camAchievement];
			//achievementName.scrollFactor.set();
			add(achievementName);
			FlxTween.tween(achievementName, {alpha:1}, 0.2, {
				onComplete: function(twn:FlxTween)
				{
					FlxTween.tween(achievementName, {alpha: 0}, 1, {
						startDelay: 4,
					});
				},
				ease: FlxEase.quadOut
			});
			FlxTween.tween(achievementBox, {alpha: 1}, 0.2, {
				onComplete: function(twn:FlxTween)
				{
					FlxTween.tween(achievementBox, {alpha: 0}, 1, {
						onComplete: function(twn:FlxTween)
						{
							new FlxTimer().start(0.3, function(tmr:FlxTimer)
							{
								remove(achievementName);
								showingAchievement = false;
								remove(achievementBox);
							});
							
						},
						startDelay: 4,
					});
				},
				ease: FlxEase.quadOut
			});
		}
	}

	private function updateBeat():Void
	{
		lastBeat = curStep;
		curBeat = Math.floor(curStep / 4);
	}

	public static var currentColor = 0;

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{

		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
	
	public function fancyOpenURL(schmancy:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [schmancy, "&"]);
		#else
		FlxG.openURL(schmancy);
		#end
	}
}
