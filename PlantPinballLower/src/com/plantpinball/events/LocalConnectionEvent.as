package com.plantpinball.events
{
	import com.plantpinball.data.LocalConnectionVO;
	
	import flash.events.Event;
	
	public class LocalConnectionEvent extends Event
	{
		public static var MESSAGE_RECEIVED:String = "message";
		
		public var data:LocalConnectionVO;
		
		public function LocalConnectionEvent(type:String, d:LocalConnectionVO = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = d;
			
			super(type, bubbles, cancelable);
		}
	}
}