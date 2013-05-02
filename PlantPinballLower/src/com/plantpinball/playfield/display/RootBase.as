package com.plantpinball.playfield.display
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	
	public class RootBase extends MovieClip
	{
		public var mainRoot:MovieClip;		
		
		public function RootBase()
		{
			super();
		}
		
		public function update(targetY:int, instant:Boolean = false):void
		{
			TweenLite.to(mainRoot, instant ? 0 : .4, { y:targetY });
		}
	}
}