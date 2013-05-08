package com.plantpinball.playfield.display
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.MovieClip;
	
	public class RootBase extends MovieClip
	{
		public var mainRoot:MovieClip;	
		
		private var _originalCapAlpha:Number;
		private var _rootCapSections:Vector.<MovieClip>;
		private var _targetY:Number;
		
		public function RootBase()
		{
			super();
			mainRoot.jaggedCap.visible = false;
			mainRoot.niche.alpha = 0;
			
			_originalCapAlpha = mainRoot.rootCap.alpha;
			
			_rootCapSections = new <MovieClip>[mainRoot.rootCap.sectionA,mainRoot.rootCap.sectionB,mainRoot.rootCap.sectionC,mainRoot.rootCap.sectionD,mainRoot.rootCap.sectionE];
		}
		
		public function update(targetY:int, instant:Boolean = false):void
		{
			_targetY = targetY;
			TweenLite.to(mainRoot, instant ? 0 : .4, { y:targetY });
		}
		
		public function rotateRootCap():void
		{
			TweenLite.to(mainRoot.rootCap, 1, {rotation:32, y:-83, easing:Linear.easeNone});
		}
		
		public function unrotateRootCap():void
		{
			TweenLite.to(mainRoot.rootCap, 1, {rotation:0, y:0, easing:Linear.easeNone});
		}
		
		public function hideUpperRoot():void
		{
			mainRoot.rootUpper.visible = false;
		}
		
		public function showUpperRoot():void
		{
			mainRoot.rootUpper.visible = true;
		}
		
		public function hideCap():void
		{
			mainRoot.jaggedCap.visible = true;
			TweenLite.to(mainRoot.niche, .2, { alpha:1 });
			
			for(var i:int = 0; i<_rootCapSections.length; i++)
			{
				TweenLite.to(_rootCapSections[i], .4, {alpha:0});
			}
		}
		
		public function showCap():void
		{
			mainRoot.jaggedCap.visible = false;
			TweenLite.to(mainRoot.niche, .2, { alpha:0 });
			
			for(var i:int = 0; i<_rootCapSections.length; i++)
			{
				TweenLite.to(_rootCapSections[i], .4, {alpha:1, delay:.3 * i});
			}
		}

		public function get targetY():Number
		{
			return _targetY;
		}
	}
}