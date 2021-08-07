package;

import flixel.FlxG;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	public static var songMisses:Map<String, Int> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songMisses:Map<String, Int> = new Map<String, Int>();
	#end


	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff).toLowerCase();


		#if !switch
		NGio.postScore(score, song);
		#end

		if(!FlxG.save.data.botplay)
		{
			trace(score);
			if (songScores.exists(daSong))
			{
				trace('i fuckn got here');
				trace(songScores.get(daSong));
				if (songScores.get(daSong) < score) {
					trace(daSong);
					trace(score);
					setScore(daSong, score);
				}
			} else {
				setScore(daSong, score);
				trace(daSong);
				trace(score);
			}
		}else trace('BotPlay detected. Score saving is disabled.');
	}

	public static function saveMisses(song:String, misses:Int = 0, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff).toLowerCase();

		if(!FlxG.save.data.botplay)
		{
			if (songMisses.exists(daSong))
			{
				if (songMisses.get(daSong) > misses) {
					setMisses(daSong, misses);
				}
			} else {
				setMisses(daSong, misses);
			}
		}else trace('BotPlay detected. Score saving is disabled.');
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0):Void
	{

		#if !switch
		NGio.postScore(score, "Week " + week);
		#end

		if(!FlxG.save.data.botplay)
		{
			var daWeek:String = formatSong('week' + week, diff);

			if (songScores.exists(daWeek))
			{
				if (songScores.get(daWeek) < score)
					setScore(daWeek, score);
			}
			else
				setScore(daWeek, score);
		}else trace('BotPlay detected. Score saving is disabled.');
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	public static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		//trace(songScores.get(song));
		
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	static function setMisses(song:String, misses:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songMisses.set(song, misses);
		//trace(songScores.get(song));
		
		FlxG.save.data.songMisses = songMisses;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		var daSong:String = song;

		if (diff == 0)
			daSong += '-easy';
		else if (diff == 2)
			daSong += '-hard';
		else if (diff == 3)
			daSong += '-ex';

		return daSong;
	}

	public static function getScore(song:String, diff:Int):Int
	{
		if (!songScores.exists(formatSong(song, diff)))
			setScore(formatSong(song, diff), 0);
		//trace(formatSong(song, diff));
		//trace(songScores.get(formatSong(song, diff)));
		return songScores.get(formatSong(song, diff));
	}

	public static function getMissesString(song:String, diff:Int):String
	{
		if (!songMisses.exists(formatSong(song, diff)))
			return 'N/A';
		//trace(formatSong(song, diff));
		//trace(songScores.get(formatSong(song, diff)));
		return Std.string(songMisses.get(formatSong(song, diff)));
	}


	public static function getMisses(song:String, diff:Int):Int
	{
		if (!songMisses.exists(formatSong(song, diff)))
			return -1;
		//trace(formatSong(song, diff));
		//trace(songScores.get(formatSong(song, diff)));
		return songMisses.get(formatSong(song, diff));
	}
	
	public static function getWeekScore(week:Int, diff:Int):Int
	{
		if (!songScores.exists(formatSong('week' + week, diff)))
			setScore(formatSong('week' + week, diff), 0);

		return songScores.get(formatSong('week' + week, diff));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.songMisses != null)
		{
			songMisses = FlxG.save.data.songMisses;
		}
	}
}