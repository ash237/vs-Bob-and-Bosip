package;

import flixel.FlxState;
import flixel.FlxG;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import flixel.system.FlxSound;
import openfl.utils.Assets;
import openfl.utils.AssetType;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;

import openfl.Lib;

using StringTools;

class VideoState extends MusicBeatState
{
	public var leSource:String = "";
	public var transClass:FlxState;
	public var txt:FlxText;
	public var fuckingVolume:Float = 1;
	public var notDone:Bool = true;
	public var vidSound:FlxSound;
	public var useSound:Bool = false;
	public var soundMultiplier:Float = 1;
	public var prevSoundMultiplier:Float = 1;
	public var videoFrames:Int = 0;
	public var defaultText:String = "";
	public var doShit:Bool = false;
	public var pauseText:String = "Press P To Pause/Unpause";
	public var autoPause:Bool = false;
	public var musicPaused:Bool = false;
	var sexMode:Bool = false;
	public static var sexed:Bool = false;
	var holdTimer:Int = 0;
	var crashMoment:Int = 0;
	var itsTooLate:Bool = false;
	var skipTxt:FlxText;
	var doneSomeShit:Bool = false;
	public function new(source:String, toTrans:FlxState, frameSkipLimit:Int = -1, autopause:Bool = false)
	{
		super();
		
		autoPause = autopause;
		
		leSource = source;
		transClass = toTrans;
		
		/*if (GlobalVideo.get() != null) {
			GlobalVideo.get().hide();
			GlobalVideo.get().stop();
			
		}
		if (frameSkipLimit != -1 && GlobalVideo.isWebm && GlobalVideo.get() == null)
		{
			GlobalVideo.getWebm().webm.SKIP_STEP_LIMIT = frameSkipLimit;	
		}*/
	}
	
	override function create()
	{
		
		super.create();
		FlxG.autoPause = false;
		FlxTransitionableState.skipNextTransIn = false;
		FlxTransitionableState.skipNextTransOut = false;
		doShit = false;

		if (GlobalVideo.isWebm)
		{
		videoFrames = Std.parseInt(Assets.getText(leSource.replace(".webm", ".txt")));
		}
		
		fuckingVolume = FlxG.sound.music.volume;
		FlxG.sound.music.volume = 0;
		var isHTML:Bool = false;
		#if web
		isHTML = true;
		#end
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var html5Text:String = "You Are Not Using HTML5...\nThe Video Didnt Load!";
		if (isHTML)
		{
			html5Text = "You Are Using HTML5!";
		}
		defaultText = "If Your On HTML5\nTap Anything...\nThe Bottom Text Indicates If You\nAre Using HTML5...\n\n" + html5Text;
		txt = new FlxText(0, 0, FlxG.width,
			defaultText,
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);

		skipTxt = new FlxText(FlxG.width / 1.5, FlxG.height - 50, FlxG.width, 'hold ANY KEY to skip', 32);
		skipTxt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT);
		
		if (GlobalVideo.isWebm)
		{
			if (Assets.exists(leSource.replace(".webm", ".ogg"), MUSIC) || Assets.exists(leSource.replace(".webm", ".ogg"), SOUND))
			{
				//if (!vidSound.playing)
				useSound = true;
				vidSound = FlxG.sound.play(leSource.replace(".webm", ".ogg"));
			}
		}
		//if (doneSomeShit)
			GlobalVideo.get().source(leSource);
		GlobalVideo.get().clearPause();
		if (GlobalVideo.isWebm)
		{	
			GlobalVideo.get().updatePlayer();
		}
		GlobalVideo.get().show();
		if (GlobalVideo.isWebm)
		{
			GlobalVideo.get().restart();
			FlxG.log.add('just fucked your FATHER???');
		} else {
			//if (!vidSound.playing)
			GlobalVideo.get().play();
			FlxG.log.add('just fucked your mom');
		}
		
		/*if (useSound)
		{*/
			//vidSound = FlxG.sound.play(leSource.replace(".webm", ".ogg"));
		
			/*new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{*/
				vidSound.time = vidSound.length * soundMultiplier;
				/*new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					if (useSound)
					{
						vidSound.time = vidSound.length * soundMultiplier;
					}
				}, 0);*/
				doShit = true;
			//}, 1);
		//}
		
		if (autoPause && FlxG.sound.music != null && FlxG.sound.music.playing)
		{
			musicPaused = true;
			FlxG.sound.music.pause();
		}
	
		add(skipTxt);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (useSound)
		{
			var wasFuckingHit = GlobalVideo.get().webm.wasHitOnce;
			soundMultiplier = GlobalVideo.get().webm.renderedCount / videoFrames;
			
			if (soundMultiplier > 1)
			{
				soundMultiplier = 1;
			}
			if (soundMultiplier < 0)
			{
				soundMultiplier = 0;
			}
			if (doShit)
			{
				var compareShit:Float = 100;
				if (vidSound.time >= (vidSound.length * soundMultiplier) + compareShit || vidSound.time <= (vidSound.length * soundMultiplier) - compareShit)
					vidSound.time = vidSound.length * soundMultiplier;
			}
			if (wasFuckingHit)
			{
			if (soundMultiplier == 0)
			{
				if (prevSoundMultiplier != 0)
				{
					vidSound.pause();
					vidSound.time = 0;
				}
			} else {
				if (prevSoundMultiplier == 0)
				{
					vidSound.resume();
					vidSound.time = vidSound.length * soundMultiplier;
				}
			}
			prevSoundMultiplier = soundMultiplier;
			}
		}
		
		if (notDone)
		{
			FlxG.sound.music.volume = 0;
		}
		GlobalVideo.get().update(elapsed);

		if (controls.RESET)
		{
			GlobalVideo.get().restart();
		}
		/*if (FlxG.keys.justPressed.P)
		{
			txt.text = pauseText;
			trace("PRESSED PAUSE");
			GlobalVideo.get().togglePause();
			if (GlobalVideo.get().paused)
			{
				GlobalVideo.get().alpha();
			} else {
				GlobalVideo.get().unalpha();
				txt.text = defaultText;
				txt.visible = false;
			}
		}*/
		
		if (GlobalVideo.get().ended || GlobalVideo.get().stopped)
		{
			txt.visible = false;
			skipTxt.visible = false;
			GlobalVideo.get().hide();
			GlobalVideo.get().stop();
		}
		if (crashMoment > 0)
			crashMoment--;
		if (FlxG.keys.pressed.ANY && crashMoment <= 0 || itsTooLate && FlxG.keys.pressed.ANY) {
			holdTimer++;
			crashMoment = 16;
			itsTooLate = true;
			GlobalVideo.get().alpha();
			txt.visible = false;
			if (holdTimer > 100) {
				notDone = false;
				skipTxt.visible = false;
				FlxG.sound.music.volume = fuckingVolume;
				txt.text = pauseText;
				
				if (musicPaused)
				{
					musicPaused = false;
					FlxG.sound.music.resume();
				}
				FlxG.autoPause = true;
				GlobalVideo.get().hide();
				GlobalVideo.get().stop();
				FlxG.switchState(transClass);
			}
		} else if (!GlobalVideo.get().paused) {
			GlobalVideo.get().unalpha();
			holdTimer = 0;
			itsTooLate = false;
		}
		if (GlobalVideo.get().ended)
		{
			notDone = false;
			FlxG.sound.music.volume = fuckingVolume;
			txt.text = pauseText;
			
			if (musicPaused)
			{
				musicPaused = false;
				FlxG.sound.music.resume();
			}
			FlxG.autoPause = true;
			
			FlxG.switchState(transClass);
		}
		
		if (GlobalVideo.get().played || GlobalVideo.get().restarted)
		{
			GlobalVideo.get().show();
		}
		
		GlobalVideo.get().restarted = false;
		GlobalVideo.get().played = false;
		GlobalVideo.get().stopped = false;
		GlobalVideo.get().ended = false;
	}
}
