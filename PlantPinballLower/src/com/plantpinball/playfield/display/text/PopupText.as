package com.plantpinball.playfield.display.text
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.plantpinball.events.PlantPinballEvent;
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class PopupText extends MovieClip
	{
		public var textHolder:MovieClip;
		
		private var _timer:Timer;
		
		public function PopupText()
		{
			super();
			
			textHolder.alpha = 0;
			textHolder.scaleX = textHolder.scaleY = .7;
			
			_timer = new Timer(5000);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		public function show():void
		{
			TweenLite.to(textHolder, .8, {scaleX:1, scaleY:1, ease:Bounce.easeOut});
			TweenLite.to(textHolder, .8, {alpha:1, overwrite:false});
			
			_timer.reset();
			_timer.start();
		}
		
		public function hide():void
		{
			TweenLite.to(textHolder, .4, {alpha:0, complete:removeMyself});
			
			_timer.stop();
			_timer.reset();
		}
		
		private function onTimer(e:TimerEvent):void
		{
			dispatchEvent(new PlantPinballEvent(PlantPinballEvent.TEXT_COMPLETE));
		}
		
		private function removeMyself():void
		{
			this.parent.removeChild(this);
		}
	}
}