package com.plantpinball.net
{
	import com.plantpinball.data.LocalConnectionVO;
	import com.plantpinball.events.LocalConnectionEvent;
	
	import flash.net.LocalConnection;
	
	public class PPLocalConnection extends LocalConnection
	{
		public function PPLocalConnection()
		{
			super();
		}
		
		public function message(value:String):void
		{
			var vo:LocalConnectionVO = new LocalConnectionVO();
			vo.message = value;
			
			dispatchEvent(new LocalConnectionEvent(LocalConnectionEvent.MESSAGE_RECEIVED, vo)); 
		}
	}
}