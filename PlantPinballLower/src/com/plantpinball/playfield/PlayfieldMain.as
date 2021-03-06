package com.plantpinball.playfield
{
	import com.greensock.TweenLite;
	import com.plantpinball.data.AppCommunicationMessage;
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
	import com.plantpinball.playfield.display.SlantedRoot;
	import com.plantpinball.playfield.display.SolidSurfaces;
	import com.plantpinball.playfield.display.Targets;
	import com.plantpinball.playfield.display.text.FungusInstructions;
	import com.plantpinball.playfield.display.text.FungusPopup;
	import com.plantpinball.playfield.display.text.LosePopup;
	import com.plantpinball.playfield.display.text.PopupText;
	import com.plantpinball.playfield.display.text.TrampleInstructions;
	import com.plantpinball.playfield.display.text.TramplePopup;
	import com.plantpinball.playfield.display.text.WinPopup;
	import com.plantpinball.playfield.physics.PhysicsWorld;
	import com.plantpinball.utils.LayoutUtil;
	import com.plantpinball.utils.LifeUtil;
	import com.plantpinball.utils.LocalConnectionUtil;
	import com.plantpinball.utils.SizeUtil;
	
	import flash.display.MovieClip;
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
		private var _localConnectionUtil:LocalConnectionUtil;
		private var _lifeUtil:LifeUtil;
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
		private var _gameplayMode:String;
		private var _slantedRoot:SlantedRoot;
		private var _rootCapCorrected:Boolean;
		
		private var _bgLayer:MovieClip;
		private var _ballLayer:MovieClip;
		private var _frameLayer:MovieClip;
		private var _rootLayer:MovieClip;
		private var _cellLayer:MovieClip;
		
		public function PlayfieldMain(stage:Stage, localConnectionUtil:LocalConnectionUtil)
		{
			_localConnectionUtil = localConnectionUtil;
			_lifeUtil = new LifeUtil(_localConnectionUtil);
			_lifeUtil.addEventListener(PlantPinballEvent.DEATH, onDeath);
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
			_physics.gameplayMode = _gameplayMode = GameplayMode.NORMAL;
			_physics.init();
			
			_lifeUtil.beginLifeCountdown();
			
			makeLayers();
			makeNonPhysicsGraphics();
			makePhysicsGraphics();
			
			onRowCleared(null);
			update(null);
		}
		
		private function makeLayers():void
		{
			_bgLayer = new MovieClip();
			_rootLayer = new MovieClip();
			_cellLayer = new MovieClip();
			_frameLayer = new MovieClip();
			_ballLayer = new MovieClip();
			
			addChild(_bgLayer);
			addChild(_rootLayer);
			addChild(_cellLayer);
			addChild(_frameLayer);
			addChild(_ballLayer);
		}
				
		private function makeNonPhysicsGraphics():void
		{
			_bgLayer.addChild(new Background());
			
			_root = new Root();
			_root.x = SizeUtil.width / 2;
			_rootLayer.addChild(_root);
			
			_slantedRoot = new SlantedRoot();
			_slantedRoot.visible = false;
			_rootLayer.addChild(_slantedRoot);
			
			_droplets = new Droplets();
			_droplets.y = 1100;
			_frameLayer.addChild(_droplets);
			
			_cells = new Cells();
			_cells.y = LayoutUtil.CELL_Y_OFFSET;
			_cells.addEventListener(PlantPinballEvent.ROW_CLEARED, onRowCleared);
			_cellLayer.addChild(_cells);
		}
				
		private function makePhysicsGraphics():void
		{
			_flippers = new Flippers();
			_flippers.y = 1138;
			_frameLayer.addChild(_flippers);
			
			_ball = new Ball();
			_ballLayer.addChild(_ball);
			
			_targets = new Targets();
			_cellLayer.addChild(_targets);
			
			_solidSurfaces = new SolidSurfaces();
			_frameLayer.addChild(_solidSurfaces);
			
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
			
			_frameLayer.addChild(_obstacleFungus);
			_frameLayer.addChild(_obstacleTrample);
			
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
					
					if(_gameplayMode == GameplayMode.OBSTACLE_TRAMPLE && !_rootCapCorrected) correctRootCap();
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
					_physics.gameplayMode = _gameplayMode = GameplayMode.OBSTACLE_FUNGUS;
					
					_fungus = new Fungus();
					_fungus.x = SizeUtil.width / 2;
					_fungus.y = _cells.y + ((_cells.yMultiplier + 2.5) * LayoutUtil.CELL_Y_SPACING);
					_fungus.addEventListener(PlantPinballEvent.ANIMATION_PING, onFungusAnimationPing);
					_fungus.addEventListener(PlantPinballEvent.ANIMATION_PING, onFungusAnimationComplete);
					
					addChild(_fungus);
					_fungus.gotoAndPlay(2);
					break;
				case ObstacleType.TRAMPLE:
					_physics.gameplayMode = _gameplayMode = GameplayMode.OBSTACLE_TRAMPLE;
					_localConnectionUtil.send(AppCommunicationMessage.PLAY_TRAMPLE);
					
					TweenLite.delayedCall(2, initTrampleMode);
					break;
			}
			
			_physics.enterObstacleMode();
		}
		
		private function initTrampleMode():void
		{
			_slantedRoot.x = _root.x;
			_slantedRoot.y = _root.targetY;
			_slantedRoot.visible = true;
			
			_root.hideUpperRoot();
			_root.rotateRootCap();
			
			_rootCapCorrected = false;
			
			_slantedRoot.gotoAndPlay(2);
			
			_targets.activateAll();
			
			var cellY:int = _cells.y;
			var cellMultiplier:int = _cells.yMultiplier;
			_cellLayer.removeChild(_cells);
			_cells = new Cells(true, cellMultiplier);
			_cells.addEventListener(PlantPinballEvent.ROW_CLEARED, onRowCleared);			
			_cells.y = cellY;
			_cellLayer.addChild(_cells);
			
			_obstacleFungus.hide(false);
			_obstacleTrample.hide(true);
			
			TweenLite.delayedCall(2,showTramplePopups);
		}
		
		private function showTramplePopups():void
		{
			_popup = new TramplePopup();
			_popup.x = SizeUtil.width / 2;
			_popup.y = SizeUtil.height / 2;
			_popup.addEventListener(PlantPinballEvent.TEXT_COMPLETE, onPopupTextComplete);
			addChild(_popup);
			_popup.show();
		}
		
		private function correctRootCap():void
		{
			_rootCapCorrected = true;
			
			_root.unrotateRootCap();
			_slantedRoot.gotoAndPlay(25);
		}
		
		private function onObstacleComplete(event:PlantPinballEvent):void
		{
			if(_gameplayMode == GameplayMode.OBSTACLE_TRAMPLE)
			{
				_root.showUpperRoot();
				
				var maskSprite:Sprite = new Sprite();
				maskSprite.graphics.beginFill(0);
				maskSprite.graphics.drawRect(0, _slantedRoot.y - 20, SizeUtil.width, SizeUtil.height);
				_rootLayer.addChild(maskSprite);
				_root.mask = maskSprite;
			}
			
			_root.showCap();
			_targets.show();
			_targets.activateAll();
			
			_physics.exitObstacleMode();
			_physics.gameplayMode = _gameplayMode = GameplayMode.NORMAL;
		}
		
		private function onFungusAnimationPing(event:PlantPinballEvent):void
		{
			_fungus.removeEventListener(PlantPinballEvent.ANIMATION_PING, onFungusAnimationPing);
			
			_obstacleFungus.hide(true);
			_obstacleTrample.hide(false);
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
			
			switch(_gameplayMode)
			{
				case GameplayMode.OBSTACLE_FUNGUS:
					_popup = new FungusInstructions();
					_popup.y = _physics.targetPositions[0].y + (LayoutUtil.NICHE_Y_OFFSET * SizeUtil.height);
					break;
				case GameplayMode.OBSTACLE_TRAMPLE:
					_popup = new TrampleInstructions();
					_popup.y = _physics.targetPositions[0].y;
			}
			
			_popup.x = SizeUtil.width / 2;
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
			if(_gameplayMode == GameplayMode.OBSTACLE_TRAMPLE) 
			{
				onObstacleComplete(null);
			}
			
			_physics.moveTargets(_cells.y + ((_cells.yMultiplier + 2.5) * LayoutUtil.CELL_Y_SPACING));
			_targets.activateAll();
			_lifeUtil.addHealthPoints(2);
			
			_rows++;
			
			if(_rows == 3) makeObstacles();
			if(_rows == 6) gameWon();
		}
		
		private function gameWon():void
		{
			_pausePhysics = true;
			
			_localConnectionUtil.send(AppCommunicationMessage.WON_GAME);
			trace("WINNER");
			
			TweenLite.delayedCall(1, _droplets.gotoAndPlay, [2]);
			
			var popupText:WinPopup = new WinPopup();
			popupText.x = SizeUtil.width / 2;
			popupText.y = SizeUtil.height / 2;
			popupText.addEventListener(PlantPinballEvent.TEXT_COMPLETE, onGameOverTextComplete);
			addChild(popupText);
			TweenLite.delayedCall(2, popupText.show);
		}
		
		private function onDeath(e:PlantPinballEvent):void
		{
			_pausePhysics = true;
			
			_localConnectionUtil.send(AppCommunicationMessage.LOST_GAME);
			trace("LOSER");
			
			var popupText:LosePopup = new LosePopup();
			popupText.x = SizeUtil.width / 2;
			popupText.y = SizeUtil.height / 2;
			popupText.addEventListener(PlantPinballEvent.TEXT_COMPLETE, onGameOverTextComplete);
			addChild(popupText);
			popupText.show();
		}
		
		private function onGameOverTextComplete(e:PlantPinballEvent):void
		{
			var text:PopupText = e.target as PopupText;
			text.hide();
			
			dispatchEvent(new PlantPinballEvent(PlantPinballEvent.GAME_OVER));
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