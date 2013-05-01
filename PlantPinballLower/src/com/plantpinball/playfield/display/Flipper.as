package com.plantpinball.playfield.display
{
	import flash.display.MovieClip;
	
	public class Flipper extends MovieClip
	{
		public var flip:MovieClip;
		
		public function Flipper()
		{
			super();
		}
		
		public function setAngle(angle:Number):void
		{
			flip.rotation = angle;
		}
	}
}