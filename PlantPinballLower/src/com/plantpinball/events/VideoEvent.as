package com.plantpinball.events
{
	import flash.events.Event;
	
	public class VideoEvent extends Event
	{
		public static const VIDEO_STOPPED:String = "VIDEO_STOPPED";
		public static const CUE_POINT_REACHED:String = "CUE_POINT_REACHED";
		public static const VIDEO_STARTED:String = "VIDEO_STARTED";
		
		public static const BUFFERING:String = "BUFFERING";
		public static const PLAYING:String = "PLAYING";
		public static const PAUSED:String = "PAUSED";
		
		public function VideoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}