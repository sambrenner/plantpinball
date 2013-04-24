package com.plantpinball.playfield
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2DebugDraw;
	
	import com.plantpinball.playfield.physics.PhysicsWorld;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class PlayfieldMain extends Sprite
	{
		private var _physics:PhysicsWorld;
		private var _stage:Stage;
		
		public function PlayfieldMain(stage:Stage)
		{
			_stage = stage;
			
			super();
		}
		
		public function init():void
		{
			this.addEventListener(Event.ENTER_FRAME, update);
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			_physics = new PhysicsWorld(new b2Vec2(0.0, 10.0), true);
			_physics.init();
			
			makeDebugDraw();
		}
				
		private function makeDebugDraw():void
		{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(30.0);
			debugDraw.SetFillAlpha(0.3);
			debugDraw.SetLineThickness(1.0);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			
			_physics.SetDebugDraw(debugDraw);
		}
		
		private function update(event:Event):void
		{
			_physics.update();
		}		
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case 90:
					_physics.leftFlipperOn = true;
					break;
				case 191:
					_physics.rightFlipperOn = true;
					break;
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case 90:
					_physics.leftFlipperOn = false;
					break;
				case 191:
					_physics.rightFlipperOn = false;
					break;
			}
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			_physics.makeBall(event.stageX, event.stageY);			
		}
	}
}