package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;

/**
 * ...
 * @author Grey
 */
class DigState extends FlxState
{
	public var diggroup:FlxTypedGroup<FlxDigger>;
	public var splscrn:FlxSprite;
	public var month:Float = 0;
	public var mindiggrs:Int = 300;
	
	override public function create():Void 
	{
		super.create();
		diggroup = new FlxTypedGroup<FlxDigger>();   																//creates a group for our lil' diggers
		
		Registry.mapray = new Array<Array<Int>>();																//initialize map's array
		Registry.mapray = genInitMatrix(Std.int(640 / 8), Std.int(640 / 8));
		
		Registry.totdiggers = 1;																	//var initialization
		Registry.ddig = 0;
		
		splscrn = new FlxSprite(0, 0, "assets/media/wt.png");															//let's put a pic over our workers: they don't like to be seen while they're digging...
		
		var d:FlxDigger = new FlxDigger(Registry.mapray, diggroup, 640, 640, 5 * 16, 7 * 16, 8, 8); //create just one digger and put it somewhere in the map
		
		diggroup.add(d);																			//adding stuff
		add(diggroup);
		add(splscrn);
		
		FlxG.mouse.show("assets/media/cursor.png");
	}
	
	override public function update():Void
	{
		super.update();	
		if (Registry.totdiggers >= mindiggrs)														//the total number of diggers alive is greater than this value? cool, let's switch to our PlayState
		{
			FlxG.cameras.fade(0xff000000, 1, go);
		}
		if (Registry.totdiggers < mindiggrs-50 && diggroup.countLiving() == 0)						//if diggers have died before reaching our goal of 300, we'll repeat all of this procedure
		{
			FlxG.switchState(new DigState());
		}
	}
	private function go():Void
	{
		FlxG.switchState(new PlayState());
	}
	
	public function genInitMatrix(rows:Int, cols:Int, negative:Bool = false):Array<Array<Int>>
	{
		// Build array of 1s
		var mat:Array<Array<Int>> = new Array<Array<Int>>();
		var y:Int = 0;
		while (y < rows)
		{
			mat.push(new Array<Int>());
			var x:Int = 0;
			while (x < cols)
			{
				if (!negative)
				{
					mat[y].push(1);
				}
				else
				{
					mat[y].push(0);
				}
				
				++x;
			}
			
			++y;
		}
		
		return mat;
	}
}