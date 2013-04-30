package com.plantpinball.events
{
	import flash.events.Event;
	
	public class PlantPinballEvent extends Event
	{
		public static const ANIMATION_COMPLETE:String = "animation_complete";
		public static const TARGET_HIT:String = "target_hit";
		public static const ROW_CLEARED:String = "row_cleared";
		
		public var data:Object;
		
		public function PlantPinballEvent(type:String, d:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = d;
			
			super(type, bubbles, cancelable);
		}
	}
}