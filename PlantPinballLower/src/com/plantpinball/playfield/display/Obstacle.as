package com.plantpinball.playfield.display
{
	import com.greensock.TweenLite;

	public class Obstacle extends TargetBase
	{
		public function Obstacle()
		{
			super();
		}
		
		public function hide():void
		{
			TweenLite.to(this, .8, {alpha:0, complete:removeMyself});
		}
		
		private function removeMyself():void
		{
			this.parent.removeChild(this);
		}
	}
}