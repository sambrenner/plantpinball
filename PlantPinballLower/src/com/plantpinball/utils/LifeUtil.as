package com.plantpinball.utils
{
	import com.plantpinball.data.AppCommunicationMessage;
	import com.plantpinball.utils.LocalConnectionUtil;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.plantpinball.events.PlantPinballEvent;
	
	public class LifeUtil extends EventDispatcher
	{
		private var _lifeTimer:Timer;
		private var _localConnectionUtil:LocalConnectionUtil;
		private var _health:int;
		private var _maxHealth:int = 7;
		private var _minHealth:int = 1;
		
		public function LifeUtil(localConnectionUtil:LocalConnectionUtil, target:IEventDispatcher=null)
		{
			_localConnectionUtil = localConnectionUtil;
			
			super(target);
		}
		
		public function beginLifeCountdown():void
		{
			_health = _maxHealth;
			dispatchHealth();
			
			_lifeTimer = new Timer(15000,0);
			_lifeTimer.addEventListener(TimerEvent.TIMER, onTimer);
			_lifeTimer.start();
		}
		
		public function addHealthPoints(num:int):void
		{
			_health += num;
			if(_health > _maxHealth) _health = _maxHealth;
			dispatchHealth();
		}
		
		private function onTimer(e:TimerEvent):void
		{
			_health--;
			
			if(_health == 1) dispatchEvent(new PlantPinballEvent(PlantPinballEvent.DEATH));
			dispatchHealth();
		}
		
		private function dispatchHealth():void
		{
			var message:String;
			
			switch(_health)
			{
				case 1:
					message = AppCommunicationMessage.SET_LIFE_1;
					break;
				case 2:
					message = AppCommunicationMessage.SET_LIFE_2;
					break;
				case 3:
					message = AppCommunicationMessage.SET_LIFE_3;
					break;
				case 4:
					message = AppCommunicationMessage.SET_LIFE_4;
					break;
				case 5:
					message = AppCommunicationMessage.SET_LIFE_5;
					break;
				case 6:
					message = AppCommunicationMessage.SET_LIFE_6;
					break;
				case 7:
					message = AppCommunicationMessage.SET_LIFE_7;
					break;
			}
			
			trace("LIFE: " + message);
			
			//_localConnectionUtil.send(message);
		}

		public function get health():int
		{
			return _health;
		}

	}
}