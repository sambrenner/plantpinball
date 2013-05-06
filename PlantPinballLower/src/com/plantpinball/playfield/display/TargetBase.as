package com.plantpinball.playfield.display
{
	import flash.display.MovieClip;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class TargetBase extends MovieClip
	{
		public var targ:MovieClip;
		
		private var _timeout:int;
		
		public function TargetBase()
		{
			super();
		}
		
		public function activate():void
		{
			targ.gotoAndStop(2);
			_timeout = setTimeout(function():void { targ.play(); }, Math.random() * 4000);
		}
		
		public function unactivate():void
		{
			clearTimeout(_timeout);	
			targ.gotoAndStop(1);
		}
	}
}