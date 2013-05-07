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
			mainRoot.jaggedCap.visible = false;
		}
		
		public function update(targetY:int, instant:Boolean = false):void
		{
			TweenLite.to(mainRoot, instant ? 0 : .4, { y:targetY });
		}
		
		public function hideCap():void
		{
			mainRoot.jaggedCap.visible = true;
			TweenLite.to(mainRoot.rootCap, .2, { alpha:0 });
		}
		
		public function showCap():void
		{
			mainRoot.jaggedCap.visible = false;
			TweenLite.to(mainRoot.rootCap, .2, { alpha:1 });
		}
	}
}