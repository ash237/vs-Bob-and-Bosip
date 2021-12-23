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
import flixel.FlxSubState;

class MusicBeatSubstate extends FlxSubState
{
	public function new()
	{
		super();
	}

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	var camAchievement:FlxCamera;
	var achievementArray:Array<String> = [];
	var showingAchievement:Bool = false;


	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		curBeat = Math.floor(curStep / 4);

		if (oldStep != curStep && curStep > 0)
			stepHit();


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
			var redFormat = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.fromString('FF0000'), true, true), '&');
			achievementName.applyMarkup(leText, [redFormat]);
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

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition > Conductor.bpmChangeMap[i].songTime)
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
}
