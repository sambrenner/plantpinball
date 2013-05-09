package com.plantpinball.video
{
	import com.plantpinball.events.VideoPlayerEvent;
	
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class VideoPlayer extends Sprite
	{
		private const BUFFER_TIME:Number = 6;
		
		private var _flvLocation:String;
		private var _netConnection:NetConnection;
		private var _netStream:NetStream;
		private var _video:Video;
		private var _muted:Boolean;
		private var _height:int;
		private var _width:int;
		
		public function VideoPlayer():void
		{
			_muted = false;
		}
		
		public function loadVideo(flvLocation:String, width:int, height:int):void
		{
			if(_netStream) _netStream.close();
			
			_flvLocation = flvLocation;
			_height = height;
			_width = width;
			
			_netConnection = new NetConnection();
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_netConnection.connect(null);
		}
		
		private function connectStream():void 
		{
			_netStream = new NetStream(_netConnection);
			_netStream.bufferTime = BUFFER_TIME;
			_netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onASyncError);
			_netStream.client = this;
			
			_video = new Video(_width, _height);
			_video.attachNetStream(_netStream);
			addChild(_video);
			
			_netStream.play(_flvLocation);
		}
		
		private function onASyncError(event:AsyncErrorEvent):void 
		{
			//trace(event.error);
		}
		
		private function onNetStatus(event:NetStatusEvent):void 
		{
			trace(event.info.code);
			
			switch (event.info.code) 
			{
				case "NetStream.Play.Start":
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_STARTED));
					break;
				case "NetConnection.Connect.Success":
					connectStream();
					break;
				case "NetStream.Play.StreamNotFound":
					//trace("Stream not found: " + _flvLocation);
					break;
				case "NetStream.Play.Stop":
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_STOPPED));
			}
		}
		
		public function onXMPData(infoObject:Object):void
		{
			//trace("XMPData");
		}
		
		public function onMetaData(infoObject:Object):void 
		{
			//trace("metadata");
		}
		
		public function onCuePoint(infoObject:Object):void 
		{
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.CUE_POINT_REACHED));
		}
		
		public function mute():void
		{
			_muted = true;
			setVolume(0);
		}
		
		public function unmute():void
		{
			_muted = false;
			setVolume(1);
		}
		
		public function show():void
		{
			this.visible = true;
		}
		
		public function hide():void
		{
			this.visible = false;
		}
		
		public function play():void
		{
			_netStream.play();
		}
		
		public function pause():void
		{
			_netStream.pause();
		}
		
		public function setVolume(volume:Number):void
		{
			var sndTransform:SoundTransform = new SoundTransform(volume);
			_netStream.soundTransform = sndTransform;
		}
		
		public function get muted():Boolean
		{
			return _muted;
		}
	}
}