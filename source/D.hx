package;

import flixel.FlxObject;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

using StringTools;

// i made this while reallky high and i don't know it's purpose, but i'll go with it lol
class D extends FlxObject
{
	public static var efU:Bool = false;
	var exFolderName:String = 'freeplay EX';
	var exFolderDirectory:String = 'desktop/cool/agentFolder';

	public static var gfU:Bool = false;
	var goldFolderName:String = 'golden freeplay';
	var goldFolderDirectory:String = 'desktop/cool/goldFolder';

	public static var pfU:Bool = false;
	var pixelFolderName:String = 'pixel freeplay';
	var pixelFolderDirectory:String = 'desktop/cool/pixelFolder';

	public static var afU:Bool = false;
	var warmFolderName:String = 'pixel freeplay';
	var warmFolderDirectory:String = 'desktop/cool/pixelFolder';

	public static var cfN:String = 'freeplay';
	public static var cfD:String = 'desktop/folderDesktop';

	public static var cfi:Int;
	
	public function new()
	{
		super();
		updateSaves();

		if (FlxG.save.data.savedCFI != null)
			cfi = FlxG.save.data.savedCFI;
		else
			cfi = 2;

		calculateCFN();

	}
	function updateSaves()
	{
		if (FlxG.save.data.fol)
			efU = true;

		if (FlxG.save.data.sol)
			gfU = true;

		if (FlxG.save.data.pol)
			pfU = true;

		if (FlxG.save.data.aol)
			afU = true;
	}
	function calculateCFN()
	{
		switch (cfi) {
			case 0:
				cfN = exFolderName;
				cfD = exFolderDirectory;
			case 1:
				cfN = goldFolderName;
				cfD = goldFolderDirectory;
			case 2:
				cfN = 'freeplay';
				cfD = 'desktop/folderDesktop';
			case 3:
				cfN = pixelFolderName;
				cfD = pixelFolderDirectory;
		}
	}
	function calculateThing() {
		if (!gfU && cfi == 1 || !efU && cfi == 0 || !pfU && cfi == 3) {
			cfi++;

			if (cfi < 0) {
				cfi = 0;
			}
			if (cfi >= 4) {
				cfi = 0;
			}
			//if (gfU && !efU && !pfU)
			//	cfi = 1;

			calculateThing();
		} else {
			if (cfi < 0) {
				cfi = 0;
			}
			if (cfi >= 4) {
				cfi = 0;
			}
			FlxG.save.data.savedCFI = cfi;
		} 
		
	}
	override function update(elapsed:Float)
	{
		updateSaves();

		if (gfU || efU) {
			calculateThing();

			
			calculateCFN();
			
			doSomething(cfi);
		}
		super.update(elapsed);
	}

	function doSomething(cfi:Int) {
		switch (cfi) {
			case 0:
				cfN = exFolderName;
				cfD = exFolderDirectory;
			case 1:
				cfN = goldFolderName;
				cfD = goldFolderDirectory;
			case 2:
				cfN = 'freeplay';
				cfD = 'desktop/folderDesktop';
			case 3:
				cfN = pixelFolderName;
				cfD = pixelFolderDirectory;
		}
	}
}