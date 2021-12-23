package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.system.FlxSound;

class GameOverFakeSubstate extends MusicBeatSubstate
{
	var bf:Character;
	var camFollow:FlxObject;

	var stageSuffix:String = "";

	public function new(x:Float, y:Float)
	{
		var daBf:String = '';
		daBf = 'deadbf-extra';

		
		super();

		Conductor.songPosition = 0;

		bf = new Character(x, y, daBf);
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x + 90, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);
		var die = new FlxSound();
		die = new FlxSound().loadEmbedded(Paths.sound('fnf_loss_sfx' + stageSuffix, 'shared'));
		die.play();
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('idle', true);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (bf.animation.curAnim.name == 'idle' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'idle' && bf.animation.curAnim.finished)
		{
			close();
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;
}
