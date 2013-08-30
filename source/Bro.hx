package;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * ...
 * @author Grey
 */
class Bro extends FlxSprite
{
	private var _parent:Dynamic;
	public var PLAYER_RUN_SPEED:Int = 70;
	private static inline var GRAVITY_ACCELERATION:Float = 350;
	public var JUMP_ACCELERATION:Float = 220;
	private var _jump:Float = 0;
	private var justlanded:Bool = false;
	
	public function new(_x:Int, _y:Int, parent:Dynamic) 
	{		
		super(_x, _y);
		loadGraphic("assets/media/bro.png", true, true, 8, 8);
		acceleration.y = 420;
		drag.x = PLAYER_RUN_SPEED * 3;
		_parent = parent;
		
		maxVelocity.x = PLAYER_RUN_SPEED;
		maxVelocity.y = JUMP_ACCELERATION;
		width = 7;
		
		addAnimation("s", [0]);
		addAnimation("w", [0, 1, 2, 3, 0, 4, 5, 6], 21,true);
		addAnimation("jump", [7]);
		addAnimation("fall", [8]);
	}

	override public function update():Void
	{	
		if ((FlxG.keys.pressed.LEFT))
		{
			facing = FlxObject.LEFT;
			acceleration.x = -drag.x;
		}
		else
		{
			if ((FlxG.keys.pressed.RIGHT))
			{
				facing = FlxObject.RIGHT;
				acceleration.x = drag.x;	
			}
			else
			{
				acceleration.x = 0;
			}
		}	
		
		if (_jump >= 0 && (FlxG.keys.pressed.UP))
		{				
			_jump += FlxG.elapsed;
			if (_jump > 0.25)
			{
				_jump = -1;
			}
		}
		else
		{
			_jump = -1;
		}
		
		if (_jump > 0)
		{
			if (_jump < 0.065)
			{
				velocity.y = -100;
			}
			else
			{
				velocity.y = -130;
			}
		}
		
		if (isTouching(FlxObject.FLOOR))
		{
			if (justlanded)
			{
				FlxG.sound.play("assets/media/landing.mp3", 0.2);
			}
			_jump = 0;
			justlanded = false;
		}
		
		if (velocity.x != 0 && _jump >= 0) 
		{
			play("w");
		}
		else if (velocity.x == 0 && _jump >= 0) 
		{
			play("s");
		}
		if (velocity.y < 0)
		{
		   play("jump");
		}
		if (velocity.y > 0)
		{
			justlanded = true;
		   play("fall");
		}
		
		super.update();
	}
	
}