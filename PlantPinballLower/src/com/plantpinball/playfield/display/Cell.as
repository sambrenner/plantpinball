package com.plantpinball.playfield.display
{
	import flash.display.MovieClip;
	
	public class Cell extends MovieClip
	{
		public function Cell()
		{
			stop();
		}
		
		public function animateDivision():void
		{
			gotoAndPlay(2);
		}
	}
}