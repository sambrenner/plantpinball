package com.plantpinball.playfield.display
{
	import flash.display.MovieClip;
	
	public class Flippers extends MovieClip
	{
		private var _leftFlipper:FlipperLeft;
		private var _rightFlipper:FlipperRight;
		
		public function Flippers()
		{
			super();
			
			_leftFlipper = new FlipperLeft();
			_leftFlipper.x = 210;
			
			_rightFlipper = new FlipperRight();
			_rightFlipper.x = 440;
			
			addChild(_leftFlipper);
			addChild(_rightFlipper);
		}
		
		public function update(angles:Vector.<Number>):void
		{
			if(angles.length < 2) return;
			_leftFlipper.setAngle(-(180-angles[0]));
			_rightFlipper.setAngle(angles[1]);
		}
	}
}