package com.plantpinball.utils.localconnection
{
	import flash.events.EventDispatcher;
	import flash.net.LocalConnection;

	public class LocalConnectionUtil extends EventDispatcher
	{
		private static var RECEIVING_FUNCTION_NAME:String = "message";
		
		private var _client:LocalConnectionClient;
		private var _receiveConnection:LocalConnection;
		private var _sendConnection:LocalConnection;
		private var _connectTo:String;
		private var _connectionName:String;
		private var _myId:String;
		
		public function LocalConnectionUtil(myId:String, connectTo:String)
		{
			_myId = myId;
			_connectionName = connectTo;
			_connectTo = "app#" + connectTo;
			
			_client = new LocalConnectionClient();
			_receiveConnection = new LocalConnection();
			_receiveConnection.client = _client;
			
			_sendConnection = new LocalConnection();
			
			trace("Connecting to " + _connectTo);
			
			try 
			{
				_receiveConnection.allowDomain("*");
				_receiveConnection.connect(_connectionName);
			}
			catch(e:Error)
			{
				//LC Error
				trace("LC Error");
			}
		}
		
		public function send(message:String):void
		{
			_sendConnection.send(_connectTo + ":" + _myId, RECEIVING_FUNCTION_NAME, message);
		}
	}
}