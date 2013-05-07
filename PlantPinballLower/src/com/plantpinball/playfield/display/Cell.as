package com.plantpinball.playfield.display
{
	import flash.display.MovieClip;
	
	public class Cell extends MovieClip
	{
		private var _active:Boolean;
		private var _fileId:int;
		
		public function Cell()
		{
			_active = false;
			stop();
		}
		
		public function animateDivision():void
		{
			if(_active)
			{
				_active = false;
				gotoAndPlay(2);
			}
		}
		
		public function reset():void
		{
			gotoAndStop(1);
		}
		
		public function showEnd():void
		{
			gotoAndStop(14);
		}
		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function set active(value:Boolean):void
		{
			_active = value;
		}

		public function get fileId():int
		{
			return _fileId;
		}

		public function set fileId(value:int):void
		{
			_fileId = value;
		}


	}
}