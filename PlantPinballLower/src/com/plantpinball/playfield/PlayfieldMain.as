package com.plantpinball.playfield
{
	import com.greensock.TweenLite;
	import com.plantpinball.events.PlantPinballEvent;
	import com.plantpinball.playfield.data.BodyType;
	import com.plantpinball.playfield.data.GameplayMode;
	import com.plantpinball.playfield.data.ObstacleType;
	import com.plantpinball.playfield.data.TargetValueObject;
	import com.plantpinball.playfield.display.Background;
	import com.plantpinball.playfield.display.Ball;
	import com.plantpinball.playfield.display.Cells;
	import com.plantpinball.playfield.display.Droplets;
	import com.plantpinball.playfield.display.Flippers;
	import com.plantpinball.playfield.display.Fungus;
	import com.plantpinball.playfield.display.ObstacleFungus;
	import com.plantpinball.playfield.display.ObstacleTrample;
	import com.plantpinball.playfield.display.Root;
	import com.plantpinball.playfield.display.SolidSurfaces;
	import com.plantpinball.playfield.display.Targets;
	import com.plantpinball.playfield.display.text.FungusInstructions;
	import com.plantpinball.playfield.display.text.FungusPopup;
	import com.plantpinball.playfield.display.text.PopupText;
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
	
	public class PlayfieldMain extends Sprite
	{
		private var _physics:PhysicsWorld;
		private var _stage:Stage;
		private var _rows:int = 0;
		private var _pausePhysics:Boolean;
		
		private var _cells:Cells;
		private var _flippers:Flippers;
		private var _ball:Ball;
		private var _targets:Targets;
		private var _root:Root;
		private var _droplets:Droplets;
		private var _fungus:Fungus;
		private var _obstacleFungus:ObstacleFungus;
		private var _obstacleTrample:ObstacleTrample;
		private var _solidSurfaces:SolidSurfaces;
		private var _popup:PopupText;
		
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
			
			_pausePhysics = false;
			
			_physics = new PhysicsWorld(new b2Vec2(0.0, 16.0), true);
			_physics.addEventListener(PlantPinballEvent.TARGET_HIT, onTargetHit);
			_physics.gameplayMode = GameplayMode.NORMAL;
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
			
			_solidSurfaces = new SolidSurfaces();
			addChild(_solidSurfaces);
			
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
		
		private function makeObstacles():void
		{
			_physics.makeObstacles();
			_physics.addEventListener(PlantPinballEvent.OBSTACLE_HIT, onObstacleHit);
			
			_obstacleFungus = new ObstacleFungus();
			_obstacleFungus.x = SizeUtil.width * (1 - LayoutUtil.OBSTACLE_X);
			_obstacleFungus.y = SizeUtil.height * LayoutUtil.FUNGUS_OBSTACLE_Y;
			
			_obstacleTrample = new ObstacleTrample();
			_obstacleTrample.x = SizeUtil.width * LayoutUtil.OBSTACLE_X;
			_obstacleTrample.y = SizeUtil.height * LayoutUtil.TRAMPLE_OBSTACLE_Y;
			
			_obstacleTrample.alpha = _obstacleFungus.alpha = 0;
			
			addChild(_obstacleFungus);
			addChild(_obstacleTrample);
			
			TweenLite.to(_obstacleFungus, .5, { alpha: 1 });
			TweenLite.to(_obstacleTrample, .5, { alpha: 1 });
		}
		
		private function update(event:Event):void
		{
			var instant:Boolean = (event == null);
			
			var targetPositions:Vector.<b2Vec2> = _physics.targetPositions;
			
			if(!_pausePhysics) _physics.update();
			
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
			
			switch(data.bodyType)
			{
				case BodyType.TARGET:
					_cells.hitCell(data.id);
					_targets.unactivate(data.id);
					break;
				case BodyType.NICHE:
					onObstacleComplete(null);
			}
			
		}
		
		private function onObstacleHit(event:PlantPinballEvent):void
		{
			var data:TargetValueObject = event.data as TargetValueObject;
			
			_pausePhysics = true;
			
			switch(data.id)
			{
				case ObstacleType.FUNGUS:
					_physics.gameplayMode = GameplayMode.OBSTACLE_FUNGUS;
					_physics.enterObstacleMode();
					
					_fungus = new Fungus();
					_fungus.x = SizeUtil.width / 2;
					_fungus.y = _cells.y + ((_cells.yMultiplier + 2.5) * LayoutUtil.CELL_Y_SPACING);
					_fungus.addEventListener(PlantPinballEvent.ANIMATION_PING, onFungusAnimationPing);
					_fungus.addEventListener(PlantPinballEvent.ANIMATION_PING, onFungusAnimationComplete);
					
					addChild(_fungus);
					_fungus.gotoAndPlay(2);
					break;
				case ObstacleType.TRAMPLE:
					_physics.gameplayMode = GameplayMode.OBSTACLE_TRAMPLE;
					//move targets up
					//replace root with sideways root
					//TBD
					break;
			}
		}
		
		private function onObstacleComplete(event:PlantPinballEvent):void
		{
			_root.showCap();
			_targets.show();
			_targets.activateAll();
			
			_physics.exitObstacleMode();
			_physics.gameplayMode = GameplayMode.NORMAL;
		}
		
		private function onFungusAnimationPing(event:PlantPinballEvent):void
		{
			_fungus.removeEventListener(PlantPinballEvent.ANIMATION_PING, onFungusAnimationPing);
			
			_obstacleFungus.hide();
			_targets.hide();
			_root.hideCap();
			_cells.rollbackRow();
		}
		
		private function onFungusAnimationComplete(event:PlantPinballEvent):void
		{
			_fungus.removeEventListener(PlantPinballEvent.ANIMATION_PING, onFungusAnimationComplete);
			
			_popup = new FungusPopup();
			_popup.x = SizeUtil.width / 2;
			_popup.y = SizeUtil.height / 2;
			_popup.addEventListener(PlantPinballEvent.TEXT_COMPLETE, onPopupTextComplete);
			addChild(_popup);
			_popup.show();
		}
		
		private function onPopupTextComplete(event:PlantPinballEvent):void
		{
			_popup.removeEventListener(PlantPinballEvent.TEXT_COMPLETE, onPopupTextComplete);
			_popup.hide();
			
			_popup = new FungusInstructions();
			_popup.x = SizeUtil.width / 2;
			_popup.y = _physics.targetPositions[0].y + (LayoutUtil.NICHE_Y_OFFSET * SizeUtil.height);
			_popup.addEventListener(PlantPinballEvent.TEXT_COMPLETE, onInstructionTextComplete);
			addChild(_popup);
			_popup.show();
		}
		
		private function onInstructionTextComplete(event:PlantPinballEvent):void
		{
			_popup.removeEventListener(PlantPinballEvent.TEXT_COMPLETE, onInstructionTextComplete);
			_popup.hide();
			
			_pausePhysics = false;
		}
		
		private function onRowCleared(e:PlantPinballEvent):void
		{
			_physics.moveTargets(_cells.y + ((_cells.yMultiplier + 2.5) * LayoutUtil.CELL_Y_SPACING));
			_targets.activateAll();
			
			_rows++;
			
			if(_rows == 3) makeObstacles();
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