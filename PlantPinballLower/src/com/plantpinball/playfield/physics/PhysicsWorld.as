package com.plantpinball.playfield.physics
{
	import com.plantpinball.events.PlantPinballEvent;
	import com.plantpinball.playfield.data.BodyType;
	import com.plantpinball.playfield.data.BodyValueObject;
	import com.plantpinball.playfield.data.TargetValueObject;
	import com.plantpinball.playfield.physics.listeners.TargetContactListener;
	import com.plantpinball.utils.LayoutUtil;
	import com.plantpinball.utils.SizeUtil;
	import com.plantpinball.utils.WallUtil;
	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Common.Math.b2Math;
	
	public class PhysicsWorld extends b2World
	{
		private static const TIMESTEP:Number = 1.0 / 30.0;
		private static const ITERATIONS:uint = 10;
		private static const PPM:Number = 30;
		private static const RAD_TO_DEG:Number = 57.296;
		
		private var _leftFlipperOn:Boolean = false;
		private var _rightFlipperOn:Boolean = false;
		private var _leftFlipperBody:b2Body;
		private var _rightFlipperBody:b2Body;
		private var _ball:b2Body;
		private var _ballLostYBound:Number = (SizeUtil.height + 100) / PPM;
		private var _waitingForPlunger:Boolean;
		private var _previousBallPosition:b2Vec2;
		private var _numTargets:int = LayoutUtil.NUM_TARGETS;
		private var _targets:Vector.<b2Body> = new Vector.<b2Body>(_numTargets, true);
		private var _trampleObstacle:b2Body;
		private var _fungusObstacle:b2Body;
			
		public function PhysicsWorld(gravity:b2Vec2, doSleep:Boolean)
		{
			super(gravity, doSleep);
		}
		
		public function init():void 
		{
			this.SetWarmStarting(true);
			makeWalls();
			makeFlippers();
			makeTargets();
			resetBall();
			addContactListeners();
		}
		
		public function update():void
		{
			this.Step(TIMESTEP, ITERATIONS, ITERATIONS);
			this.ClearForces();
			//this.DrawDebugData();
			
			var ballPos:b2Vec2 = _ball.GetPosition();
			
			checkInput();
			checkTargetHit();
			checkBallLost(ballPos);
			checkBallStuck(ballPos);
		}
		
		public function makeObstacles():void
		{
			var fd:b2FixtureDef;
			var bodyDefC:b2BodyDef = new b2BodyDef();
			bodyDefC.type = b2Body.b2_dynamicBody;
			var circDef:b2CircleShape= new b2CircleShape(25 / PPM);
			fd = new b2FixtureDef();
			fd.shape = circDef;
			fd.density = 2.0;
			fd.friction = 0;
			fd.restitution = 0.5;
			bodyDefC.position.Set(LayoutUtil.OBSTACLE_X * SizeUtil.width / PPM, LayoutUtil.TRAMPLE_OBSTACLE_Y * SizeUtil.height / PPM);
			_trampleObstacle = this.CreateBody(bodyDefC);
			_trampleObstacle.SetType(b2Body.b2_staticBody);
			_trampleObstacle.CreateFixture(fd);
			
			bodyDefC.position.Set((1-LayoutUtil.OBSTACLE_X) * SizeUtil.width / PPM, LayoutUtil.FUNGUS_OBSTACLE_Y * SizeUtil.height / PPM);
			_fungusObstacle = this.CreateBody(bodyDefC);
			_fungusObstacle.SetType(b2Body.b2_staticBody);
			_fungusObstacle.CreateFixture(fd);
		}
		
		private function checkTargetHit():void
		{
			for(var i:int = 0; i<_numTargets; i++) 
			{
				var t:b2Body = _targets[i];
				var tVO:TargetValueObject = t.GetUserData() as TargetValueObject;
				
				if(tVO.hit)
				{
					this.dispatchEvent(new PlantPinballEvent(PlantPinballEvent.TARGET_HIT, tVO));
					tVO.hit = false;
				}
			}
		}
		
		private function checkInput():void
		{
			if (_leftFlipperOn) {  
				_leftFlipperBody.ApplyTorque(-5000);  
			} else {  
				if (_leftFlipperBody.IsAwake()) {  
					_leftFlipperBody.ApplyTorque(1000);  
				}  
			} 
			
			if (_rightFlipperOn) {  
				_rightFlipperBody.ApplyTorque(5000);  
			} else {  
				if (_rightFlipperBody.IsAwake()) {  
					_rightFlipperBody.ApplyTorque(-1000);  
				}  
			} 
		}
		
		private function makeWalls():void
		{
			var body:b2Body;
			var bodyDef:b2BodyDef = new b2BodyDef();
			var bodyPoly:b2PolygonShape = new b2PolygonShape();
			var bodyFix:b2FixtureDef = new b2FixtureDef();
			
			for(var i:int = 1; i<=53; i++)
			{
				var vertexArray:Array = WallUtil.getWall(i);
				
				bodyDef.type = b2Body.b2_staticBody;
				bodyPoly.SetAsArray(vertexArray, vertexArray.length);
				bodyFix.shape = bodyPoly;
				bodyFix.density = 1.0;
				bodyFix.friction = 1.0;
				bodyFix.restitution = (i == 51 || i == 52) ? 2.0 : 0.3; //give bumpers more elasticity
				body = this.CreateBody(bodyDef);
				body.CreateFixture(bodyFix);
			}
		}
		
		private function makeFlippers():void
		{
			var flipperWidth:int = 42;
			var flipperHeight:int = 8;
			var flipperOffset:int = 36;
			var flipperUpperAngle:Number = .6;
			var flipperLowerAngle:Number = -.6;
			var flipperTorque:Number = 30.0;
			var flipperMotorSpeed:Number = 0.0;
			var flipperDensity:Number = 2.0;
			var flipperFriction:Number = 0.0;
			
			//left
			var flipperDef:b2BodyDef = new b2BodyDef();
			flipperDef.type = b2Body.b2_dynamicBody;
			flipperDef.position.Set((SizeUtil.width * LayoutUtil.LEFT_FLIPPER_X) / PPM, (SizeUtil.height * LayoutUtil.FLIPPER_Y) / PPM);
			_leftFlipperBody = this.CreateBody(flipperDef);
			
			var flipperBox:b2PolygonShape = new b2PolygonShape();
			flipperBox.SetAsBox(flipperWidth / PPM, flipperHeight / PPM);
			
			var flipperFixtureDef:b2FixtureDef = new b2FixtureDef();
			flipperFixtureDef.shape = flipperBox;
			flipperFixtureDef.density = flipperDensity;
			flipperFixtureDef.friction = flipperFriction;
			_leftFlipperBody.CreateFixture(flipperFixtureDef);
			
			var localCenter:b2Vec2 = _leftFlipperBody.GetWorldCenter();
			localCenter.Add(new b2Vec2(-flipperOffset/PPM, 0));
			
			var revoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();  
			revoluteJointDef.Initialize(_leftFlipperBody, this.GetGroundBody(), localCenter);  
			revoluteJointDef.upperAngle = flipperUpperAngle;  
			revoluteJointDef.lowerAngle = flipperLowerAngle;  
			revoluteJointDef.enableLimit = true;  
			revoluteJointDef.maxMotorTorque = flipperTorque;  
			revoluteJointDef.motorSpeed = flipperMotorSpeed;  
			revoluteJointDef.enableMotor = true;  
			this.CreateJoint(revoluteJointDef);
			
			//right
			flipperDef.position.Set((SizeUtil.width * LayoutUtil.RIGHT_FLIPPER_X) / PPM, (SizeUtil.height * LayoutUtil.FLIPPER_Y) / PPM);	
			_rightFlipperBody = this.CreateBody(flipperDef);
			_rightFlipperBody.CreateFixture(flipperFixtureDef);
			localCenter = _rightFlipperBody.GetWorldCenter();
			localCenter.Add(new b2Vec2(flipperOffset/PPM,0));
			revoluteJointDef.Initialize(_rightFlipperBody, this.GetGroundBody(), localCenter);
			revoluteJointDef.upperAngle = flipperUpperAngle;  
			revoluteJointDef.lowerAngle = flipperLowerAngle;   
			revoluteJointDef.enableLimit = true;  
			revoluteJointDef.maxMotorTorque = flipperTorque;  
			revoluteJointDef.motorSpeed = flipperMotorSpeed;  
			revoluteJointDef.enableMotor = true;  
			this.CreateJoint(revoluteJointDef);
		}
		
		private function makeTargets():void
		{
			for(var i:int = 0; i < _numTargets; i++)
			{
				var body:b2Body;
				var fd:b2FixtureDef;
				var bodyDefC:b2BodyDef = new b2BodyDef();
				bodyDefC.type = b2Body.b2_dynamicBody;
				var circDef:b2CircleShape= new b2CircleShape(25 / PPM);
				fd = new b2FixtureDef();
				fd.shape = circDef;
				fd.density = 2.0;
				fd.friction = 0;
				fd.restitution = 0.5;
				bodyDefC.position.Set(0,0);
				body = this.CreateBody(bodyDefC);
				body.SetType(b2Body.b2_staticBody);
				body.CreateFixture(fd);
				
				_targets[i] = body;
			}
		}
		
		public function moveTargets(yPosition:Number):void
		{
			yPosition /= SizeUtil.height;
			
			for(var i:int = 0; i<_numTargets; i++)
			{
				_targets[i].SetPosition(new b2Vec2(((SizeUtil.width * LayoutUtil.TARGET_PADDING) + (i * LayoutUtil.TARGET_X_SPACING * SizeUtil.width)) / PPM, (SizeUtil.height * yPosition) / PPM));
			}
		}
		
		public function makeBall(point:b2Vec2):void 
		{	
			if(_ball) this.DestroyBody(_ball);
			
			var fd:b2FixtureDef;
			var bodyDefC:b2BodyDef = new b2BodyDef();
			bodyDefC.type = b2Body.b2_dynamicBody;
			var circDef:b2CircleShape= new b2CircleShape(18 / PPM);
			fd = new b2FixtureDef();
			fd.shape = circDef;
			fd.density = 1.0;
			fd.friction = 1.0;
			fd.restitution = 0.2;
			bodyDefC.position.Set(point.x / PPM, point.y / PPM);
			_ball = this.CreateBody(bodyDefC);
			_ball.SetBullet(true);
			_ball.CreateFixture(fd);
		}
		
		public function launchBall():void
		{
			if(!_waitingForPlunger) return;
			
			_waitingForPlunger = false;
			
			var currentPos:b2Vec2 = _ball.GetPosition();
			_ball.ApplyImpulse(new b2Vec2(currentPos.x, currentPos.y - 200) ,currentPos)
		}
		
		public function resetBall():void
		{
			_waitingForPlunger = true;
			makeBall(LayoutUtil.INITIAL_BALL_POS);
		}
		
		private function checkBallLost(currentBallPosition:b2Vec2):void
		{
			if(currentBallPosition.y > _ballLostYBound)
			{
				resetBall();
			}
		}
		
		private function checkBallStuck(currentBallPosition:b2Vec2):void
		{
			if(_previousBallPosition)
			{
				if(b2Math.Distance(_previousBallPosition, currentBallPosition) == 0 && !_waitingForPlunger)
				{
					_waitingForPlunger = true;
				}
			}
			
			_previousBallPosition = currentBallPosition.Copy();
		}
		
		private function addContactListeners():void
		{
			var targetContactListener:TargetContactListener = new TargetContactListener();
			this.SetContactListener(targetContactListener);
						
			var ballVO:BodyValueObject = new BodyValueObject;
			ballVO.bodyType = BodyType.BALL;
			
			_ball.SetUserData(ballVO);
			
			for (var i:int = 0; i < _numTargets; i++) 
			{
				var targetVO:TargetValueObject = new TargetValueObject();
				targetVO.bodyType = BodyType.TARGET;
				targetVO.hit = false;
				targetVO.id = i;
				
				_targets[i].SetUserData(targetVO);
			}
		}
		
		public function set rightFlipperOn(value:Boolean):void
		{
			_rightFlipperOn = value;
		}
		
		public function set leftFlipperOn(value:Boolean):void
		{
			_leftFlipperOn = value;
		}
		
		public function get flipperAngles():Vector.<Number>
		{
			return new <Number>[_leftFlipperBody.GetAngle() * RAD_TO_DEG, _rightFlipperBody.GetAngle() * RAD_TO_DEG];
		}
		
		public function get ballPosition():b2Vec2
		{
			var bp:b2Vec2 = _ball.GetPosition().Copy();
			bp.Multiply(PPM);
			return bp;
		}
		
		public function get ballAngle():Number
		{
			return _ball.GetAngle() * RAD_TO_DEG % 360;
		}
		
		public function get targetPositions():Vector.<b2Vec2>
		{
			var positions:Vector.<b2Vec2> = new Vector.<b2Vec2>(_numTargets);
			
			for(var i:int = 0; i<_numTargets; i++)
			{
				var p:b2Vec2 = _targets[i].GetPosition().Copy();
				p.Multiply(PPM);
				positions[i] = p;
			}
			
			return positions;
		}
	}
}