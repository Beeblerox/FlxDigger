package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
/**
 * ...
 * @author Grey
 */
class FlxDigger extends FlxSprite
{
	
	public var Diggers:FlxTypedGroup<FlxDigger>;
	public var mat:Array<Array<Int>>;
	public var cols:Int = 0;
	public var rows:Int = 0;
	public var cntdig:Int = 0;
	public var stuck:Float = 0;
	public var oldx:Int = 0;
	public var oldy:Int = 0;
	private var szX:Int;
	private var szY:Int;
	
	public function new(matrix:Array<Array<Int>>, Digga:FlxTypedGroup<FlxDigger>, MapWidth:Int, MapHeight:Int, X:Int, Y:Int, sizeX:Int = 16, sizeY:Int = 16) 
	{
		super();
		makeGraphic(sizeX, sizeY, 0xff000000);  //let's create our digger!: a simple x*y black square.
		Diggers = Digga;						//add our friend to a FlxGroup we create in DigState
		mat = matrix;							//passing matrix data
		cols = Std.int(MapWidth / sizeX);		//calculate number of columns and rows
		rows = Std.int(MapWidth / sizeY);
		
		x = X;									//initial position
		y = Y;
		
		szX = sizeX;							//storing digger's size
		szY = sizeY;
	}
	
	override public function update():Void
	{
	//	super.update();
		if (stuck == 0)
		{
			oldx = Math.floor(x);
			oldy = Math.floor(y);
		}
		cntdig = Registry.totdiggers - Registry.ddig;  //lets count how many diggers are alive (used just to kill some of them in case of "overpopulation"
		
		stuck += FlxG.elapsed;							//stuck counter: used to see if for some reason this digger is stuck somewhere
		
		if (x- (szX * 2) <= 0)								//check if he's too near the level's border (prevents the digger from going out of the map)
		{
			kill();
		}
		if (x + (szX * 2)>= cols * szX - szX)
		{
			kill();
		}
		if (y - (szY * 2) <= 0)
		{
			kill();
		}
		if (y + (szY * 2) >= rows * szY - szY)
		{
			kill();
		}
		if (mat[Std.int(y / szY)][Std.int(x / szX)] == 1)
		{
			mat[Std.int(y / szY)][Std.int(x / szX)] = 0;
		}
		
		chooseDir();									//call the function that's used to choose a semi-random (it's "semi" 'cause diggers can't dig empty spaces so we have to check what is surrounding our bro)
		
		var f:Float = Math.random();					//yes: diggers can duplicate theirself. this is done by comparing a random generated number with a fixed value (in this case 0.91).
		if (f > 0.91)									//if conditions are satisfied, this digger will duplicate.
		{
			var d:FlxDigger = new FlxDigger(mat, Diggers, 640, 640, Std.int(x), Std.int(y), szX, szY);
			Diggers.add(d);
			Registry.totdiggers++;						//duplication is notified by incrementing this counter stored in Registry.as
		}
		
		if (Registry.totdiggers >= 300)					//reached overpopulation level? DIE!
		{
			kill();
		}
		
		if (stuck >= 1)									//stuck? DIE!
		{
			if (oldx == x || oldy == y)
			{
				Registry.ddig++;						//notifies his death by incrementing this counter
				kill();
			}
			else
			{
				stuck = 0;								//not stuck? oh, well... you can continue your job...
			}
		}
		
		super.update();
	}
	
	private function chooseDir():Void					//i don't want to explain all of this... just know that after he choose one of the available directions, 
	{													//the digger moves szX or szY steps (szX= his x size; szY= his y size)
		var f:Float = 0;
		if (mat[Std.int(y / szY)][Std.int((x - szX) / szX)] == 0)
		{
			if (mat[Std.int(y / szY)][Std.int((x + szX) / szX)] == 0)
			{
				if (mat[Std.int((y - szY) / szY)][Std.int(x / szX)] == 0)
				{
					if (mat[Std.int((y + szY) / szY)][Std.int(x / szX)] == 0)
					{
						if (cntdig > 1)
						{
							kill();
						}
					}
					else
					{
						y += szY;
					}
				}
				else
				{
					if (mat[Std.int((y + szY) / szY)][Std.int(x / szX)] == 0)
					{
						y -= szY;
					}
					else
					{
						f = Math.floor(Math.random() * 2);
						if (f == 0)
						{
							y -= szY;
						}
						else
						{
							y += szY;
						}
					}
				}
			}
			else
			{
				if (mat[Std.int((y - szY) / szY)][Std.int(x / szX)] == 0)
				{
					if (mat[Std.int((y + szY) / szY)][Std.int(x / szX)] == 0)
					{
						x += szX;
					}
					else
					{
						f = Math.floor(Math.random() * 2);
						if (f == 0)
						{
							x += szX;
						}
						else
						{
							y += szY;
						}
					}
				}
				else
				{
					if (mat[Std.int((y + szY) / szY)][Std.int(x / szX)] == 0)
					{
						f = Math.floor(Math.random() * 2);
						if (f == 0)
						{
							x += szX;
						}
						else
						{
							y -= szY;
						}
					}
					else
					{
						f = Math.floor(Math.random() * 3);
						if (f == 0)
						{
							x += szX;
						}
						if (f == 1)
						{
							y -= szY;
						}
						if (f == 2)
						{
							y += szY;
						}
					}
				}
			}
		}
		else
		{
			if (mat[Std.int(y / szY)][Std.int((x + szX) / szX)] == 0)
			{
				if (mat[Std.int((y - szY) / szY)][Std.int(x / szX)] == 0)
				{
					if (mat[Std.int((y + szY) / szY)][Std.int(x / szX)] == 0)
					{
						x -= szX;
					}
					else
					{
						f = Math.floor(Math.random() * 2);
						if (f == 0)
						{
							x -= szX;
						}
						else
						{
							y += szY;
						}
					}
				}
				else
				{
					if (mat[Std.int((y + szY) / szY)][Std.int(x / szX)] == 0)
					{
						f = Math.floor(Math.random() * 2);
						if (f == 0)
						{
							x += szX;
						}
						else
						{
							y -= szY;
						}
					}
					else
					{
						f = Math.floor(Math.random() * 3);
						if (f == 0)
						{
							x -= szX;
						}
						if (f == 1)
						{
							y -= szY;
						}
						if (f == 2)
						{
							y += szY;
						}
					}
				}
			}
			else
			{
				if (mat[Std.int((y - szY) / szY)][Std.int(x / szX)] == 0)
				{
					if (mat[Std.int((y + szY) / szY)][Std.int(x / szX)] == 0)
					{
						f = Math.floor(Math.random() * 2);
						if (f == 0)
						{
							x -= szX;
						}
						else
						{
							x += szX;
						}
					}
					else
					{
						f = Math.floor(Math.random() * 3);
						if (f == 0)
						{
							x -= szX;
						}
						if (f == 1)
						{
							x += szX;
						}
						if (f == 2)
						{
							y += szY;
						}
					}
				}
				else
				{
					f = Math.floor(Math.random() * 4);
					if (f == 0)
					{
						x += szX;
					}
					if (f == 1)
					{
						y -= szY;
					}
					if (f == 2)
					{
						x -= szX;
					}
					if (f == 3)
					{
						y += szY;
					}
				}
			}
		}
	}
	
	override public function kill():Void  //well.... you know what this does
	{
		if (!alive) return;
		velocity.x = 0;
		velocity.y = 0;
		alive = false;
		exists = false;	
		cntdig--;
	}
}