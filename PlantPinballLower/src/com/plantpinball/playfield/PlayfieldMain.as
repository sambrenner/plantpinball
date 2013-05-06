package com.plantpinball.playfield
{
	import com.plantpinball.events.PlantPinballEvent;
	import com.plantpinball.playfield.data.TargetValueObject;
	import com.plantpinball.playfield.display.Background;
	import com.plantpinball.playfield.display.Ball;
	import com.plantpinball.playfield.display.Cells;
	import com.plantpinball.playfield.display.Flippers;
	import com.plantpinball.playfield.display.Root;
	import com.plantpinball.playfield.display.Targets;
	import com.plantpinball.playfield.physics.PhysicsWorld;
	import com.plantpinball.utils.LayoutUtil;
	import com.plantpinball.utils.SizeUtil;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2DebugDraw;
	import com.plantpinball.playfield.display.Droplets;
	
	public class PlayfieldMain extends Sprite
	{
		private var _physics:PhysicsWorld;
		private var _stage:Stage;
		
		private var _cells:Cells;
		private var _flippers:Flippers;
		private var _ball:Ball;
		private var _targets:Targets;
		private var _root:Root;
		private var _droplets:Droplets;
		
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
			
			_physics = new PhysicsWorld(new b2Vec2(0.0, 16.0), true);
			_physics.addEventListener(PlantPinballEvent.TARGET_HIT, onTargetHit);
			_physics.init();
			
			makeNonPhysicsGraphics();
			makePhysicsGraphics();
			
			onRowCleared(null);
			update(null);
		}
				
		private function makeNonPhysicsGraphics():void
		{
			addChild(new Background());
			
			_root = new Root();
			_root.x = SizeUtil.width / 2;
			addChild(_root);
			
			_droplets = new Droplets();
			_droplets.y = 1100;
			addChild(_droplets);
			
			_cells = new Cells();
			_cells.y = LayoutUtil.CELL_Y_OFFSET;
			_cells.addEventListener(PlantPinballEvent.ROW_CLEARED, onRowCleared);
			addChild(_cells);
		}
				
		private function makePhysicsGraphics():void
		{
			_flippers = new Flippers();
			_flippers.y = 1138;
			addChild(_flippers);
			
			_ball = new Ball();
			addChild(_ball);
			
			_targets = new Targets();
			addChild(_targets);
			
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
			var instant:Boolean = (event == null);
			
			var targetPositions:Vector.<b2Vec2> = _physics.targetPositions;
			
			_physics.update();
			_flippers.update(_physics.flipperAngles);
			_targets.update(targetPositions, instant);
			_root.update(targetPositions[0].y + 60, instant);
			
			var ballPos:b2Vec2 = _physics.ballPosition;
			_ball.x = ballPos.x;
			_ball.y = ballPos.y;
			
			_ball.rotation = _physics.ballAngle;
		}
		
		private function onTargetHit(event:PlantPinballEvent):void
		{
			var data:TargetValueObject = event.data as TargetValueObject;
			
			_ball.gotoAndPlay(2);
			_cells.hitCell(data.id);
			_targets.unactivate(data.id);
		}
		
		private function onRowCleared(e:PlantPinballEvent):void
		{
			_physics.moveTargets(_cells.y + ((_cells.yMultiplier + 2.5) * LayoutUtil.CELL_Y_SPACING));
			_targets.activateAll();
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case 80:
					_physics.launchBall();
					break;
				case 90:
					_physics.leftFlipperOn = true;
					break;
				case 77:
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
				case 77:
					_physics.rightFlipperOn = false;
					break;
			}
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			_physics.makeBall(new b2Vec2(event.stageX, event.stageY));			
		}
	}
}