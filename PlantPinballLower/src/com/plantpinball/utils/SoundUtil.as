package com.plantpinball.utils
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	public class SoundUtil extends EventDispatcher
	{
		public static const TARGET_HIT:String = "targethit.wav";
		public static const FLIPPER:String = "flipper.wav";
		public static const OBSTACLE:String = "obstacle.mp3";
		public static const WALL:String = "wall.wav";
		
		private var _basePath = "sound/";
		
		private var _targetSound:Sound = new Sound();
		private var _flipperSound:Sound = new Sound();
		private var _obstacleSound:Sound = new Sound();
		private var _wallSound:Sound = new Sound();
		
		public function SoundUtil(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function preloadSounds():void
		{
			_targetSound.load(new URLRequest(_basePath + TARGET_HIT));
			_flipperSound.load(new URLRequest(_basePath + FLIPPER));
			_obstacleSound.load(new URLRequest(_basePath + OBSTACLE));
			_wallSound.load(new URLRequest(_basePath + WALL));
		}
		
		public function playSound(soundType:String):void
		{
			switch(soundType)
			{
				case TARGET_HIT:
					_targetSound.play();
					break;
				case FLIPPER:
					_flipperSound.play();
					break;
				case OBSTACLE:
					_obstacleSound.play();
					break;
				case WALL:
					_wallSound.play();
					break;
			}
			
		}
	}
}