package com.plantpinball.utils
{
	import com.plantpinball.events.LocalConnectionEvent;
	import com.plantpinball.net.PPLocalConnection;
	
	import flash.events.EventDispatcher;

	public class LocalConnectionUtil extends EventDispatcher
	{
		private static var RECEIVING_FUNCTION_NAME:String = "message";
		
		private var _receiveConnection:PPLocalConnection;
		private var _sendConnection:PPLocalConnection;
		private var _connectTo:String;
		private var _connectionName:String;
		private var _myId:String;
		
		public function LocalConnectionUtil(myId:String, connectTo:String)
		{
			_myId = myId;
			_connectionName = connectTo;
			_connectTo = "app#" + connectTo;
			
			_receiveConnection = new PPLocalConnection();
			_receiveConnection.addEventListener(LocalConnectionEvent.MESSAGE_RECEIVED, onMessageReceived);
			
			_sendConnection = new PPLocalConnection();
			
			try 
			{
				_receiveConnection.allowDomain("*");
				_receiveConnection.connect(_connectionName);
			}
			catch(e:Error)
			{
				trace("LC Error");
			}
		}
		
		public function send(message:String):void
		{
			_sendConnection.send(_connectTo + ":" + _myId, RECEIVING_FUNCTION_NAME, message);
		}
		
		private function onMessageReceived(e:LocalConnectionEvent):void
		{
			dispatchEvent(new LocalConnectionEvent(LocalConnectionEvent.MESSAGE_RECEIVED, e.data));
		}
	}
}