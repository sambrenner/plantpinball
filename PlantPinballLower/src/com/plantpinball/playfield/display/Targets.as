package com.plantpinball.playfield.display
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	
	import Box2D.Common.Math.b2Vec2;
	
	public class Targets extends MovieClip
	{
		private var _targets:Vector.<Target>;
		
		public function Targets()
		{
			super();
			
			_targets = new Vector.<Target>(5);
			
			for(var i:int = 0; i<_targets.length; i++)
			{
				var t:Target = new Target();
				addChild(t);
				
				_targets[i] = t;
			}
		}
		
		public function update(positions:Vector.<b2Vec2>, instant:Boolean = false):void
		{
			for(var i:int = 0; i<_targets.length; i++)
			{
				TweenLite.to(_targets[i], instant ? 0 : .4, { x:positions[i].x, y:positions[i].y });
			}
		}
	}
}