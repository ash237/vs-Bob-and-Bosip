package;

import flixel.FlxBasic;
import flixel.math.FlxRect;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.geom.Point;


import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxRandom;
import flixel.addons.transition.FlxTransitionableState;
import io.newgrounds.NG;
import LoadingState.LoadingsState;
import flixel.FlxState;
import lime.app.Application;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;

#if windows
import Discord.DiscordClient;
import sys.FileSystem;
#end

using StringTools;

class CoolLoadingState extends MusicBeatState
{
	public var toSwitchToState:FlxState = null;
	override function create()
	{
		var wow = new LoadingsState();
		wow.instantAlpha = true;
		openSubState(wow);
		FlxTransitionableState.skipNextTransIn = true;
		
		LoadingState.loadAndSwitchState(toSwitchToState, true,true);
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
