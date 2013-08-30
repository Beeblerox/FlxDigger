package;  

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
	private var _b:FlxButton;
	private var _t1:FlxText;
	private var _t2:FlxText;
	private var t3:FlxText;
	private var clicked:Bool = false;
	
	override public function create():Void
	{
		var t3:FlxText;
		
		_t2 = new FlxText(FlxG.width / 2 - 160, FlxG.height / 3, 1000, "FlxDiggers Demo");
		_t2.size = 32;
		_t2.color = 0xFFFFFF;
		_t2.antialiasing = true;
		add(_t2);
		
		t3 = new FlxText(FlxG.width / 4.5 - 125, FlxG.height / 1.5 + 185, 1000, "by Grey Productions");
		t3.size = 8;
		t3.color = 0xFFFFFF;
		t3.antialiasing = _t2.antialiasing;
		add(t3);
		
		FlxG.mouse.show("assets/media/cursor.png");
		
		_b = new FlxButton(FlxG.width / 2 - 50, FlxG.height / 3 + 80, "DIG LIKE A PRO!", onButton);
		_b.loadGraphic("assets/media/b1.png", true, false, 104, 15);
		_b.label.color = 0x4e4e4e;
		_b.label.offset.y = 1;
		add(_b);			
	}

	private function onButton():Void
	{
		FlxG.cameras.flash(0xffc2c2c2, 0.5);
		FlxG.cameras.fade(0xff000000, 2.5, onFade);
	}
	
	private function onFade():Void
	{
		FlxG.switchState(new DigState());
	}
}