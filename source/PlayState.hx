package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;

/**
 * ...
 * @author Grey
 */
class PlayState extends FlxState
{
	public var map:FlxTilemap;
	private var string:String;
	private var txt:FlxText;
	public var bkg:FlxSprite;
	private var done:Bool = false;
	private var player:Bro;
	private var xb:Float = 320;
	private var yb:Float = 320;
	
	override public function create():Void 
	{
		super.create();
		bkg = new FlxSprite(0, 0, "assets/media/bg.png");
		map = new FlxTilemap();
		string = convertMatrixToStr(Registry.mapray);
		map.loadMap(string, "assets/media/liltiles.png", 8, 8, 0, 0);
		add(bkg);
		add(map);
		playercoords();
		add(player = new Bro(Std.int(xb), Std.int(yb), this));
		txt = new FlxText(FlxG.width / 4.5 - 125, FlxG.height / 1.5 + 185, 1000, "Press R to Regenerate");
		txt.size = 16;
		txt.color = 0xFFFFFF;
		txt.shadow = 0xff000000;
		txt.antialiasing = true;
		add(txt);
		FlxG.mouse.hide();
	}
	
	override public function update():Void
	{
		super.update();	
		FlxG.collide(player, map);
		if (FlxG.keys.justPressed.R && !done)
		{
			done = true;
			FlxG.cameras.fade(0xff000000, 1, onFade);
		}
	}
	
	public function convertMatrixToStr(mat:Array<Array<Int>>):String
	{
		var mapString:String = "";
		
		for (y in 0...(mat.length))
		{
			for (x in 0...(mat[y].length))
			{
				mapString += mat[y][x] + ",";
			}
			
			mapString += "\n";
		}
		
		return mapString;
	}
	
	private function onFade():Void
	{
		FlxG.switchState(new DigState());
	}
	
	private function playercoords():Void
	{
		var ok:Bool = false;
		var x:Int;
		var y:Int;
		while (!ok)
		{
			x = Std.int(xb / 8);
			y = Std.int(yb / 8);
			if (Registry.mapray[y][x] == 1)
			{
				xb = Math.floor(Math.random() * 640);
				yb = Math.floor(Math.random() * 640);
			}
			else
			{
				ok = true;
			}
		}
	}
}