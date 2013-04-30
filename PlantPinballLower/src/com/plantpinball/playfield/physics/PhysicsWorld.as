package com.plantpinball.playfield.physics
{
	import com.plantpinball.events.PlantPinballEvent;
	import com.plantpinball.playfield.data.BodyType;
	import com.plantpinball.playfield.data.BodyValueObject;
	import com.plantpinball.playfield.data.TargetValueObject;
	import com.plantpinball.playfield.physics.listeners.TargetContactListener;
	import com.plantpinball.utils.SizeUtil;
	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	
	public class PhysicsWorld extends b2World
	{
		private static const TIMESTEP:Number = 1.0 / 30.0;
		private static const ITERATIONS:uint = 10;
		private static const PPM:Number = 30;
		
		private var _leftFlipperOn:Boolean = false;
		private var _rightFlipperOn:Boolean = false;
		private var _leftFlipperBody:b2Body;
		private var _rightFlipperBody:b2Body;
		private var _ball:b2Body;
		private var _targets:Vector.<b2Body> = new Vector.<b2Body>(5, true);
		
		private var _targetPadding:Number = 0.2;
		private var _targetSpacing:Number = (1 - (2*_targetPadding)) / (_targets.length - 1);
			
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
			makeBall(SizeUtil.width / 3, SizeUtil.height / 2);
			addContactListeners();
		}
		
		public function update():void
		{
			this.Step(TIMESTEP, ITERATIONS, ITERATIONS);
			this.ClearForces();
			this.DrawDebugData();
			
			checkInput();
			checkTargetHit();
		}
		
		private function checkTargetHit():void
		{
			for(var i:int = 0; i<_targets.length; i++) 
			{
				var t:b2Body = _targets[i];
				var tVO:TargetValueObject = t.GetUserData() as TargetValueObject;
				
				if(tVO.hit)
				{
					trace("Target " + tVO.id + " has been hit!");
					this.dispatchEvent(new PlantPinballEvent(PlantPinballEvent.TARGET_HIT, tVO));
					tVO.hit = false;
				}
			}
		}
		
		private function checkInput():void
		{
			if (_leftFlipperOn) {  
				_leftFlipperBody.ApplyTorque(-25000);  
			} else {  
				if (_leftFlipperBody.IsAwake()) {  
					_leftFlipperBody.ApplyTorque(5000);  
				}  
			} 
			
			if (_rightFlipperOn) {  
				_rightFlipperBody.ApplyTorque(25000);  
			} else {  
				if (_rightFlipperBody.IsAwake()) {  
					_rightFlipperBody.ApplyTorque(-5000);  
				}  
			} 
		}
		
		private function makeWalls():void
		{
			var wall:b2PolygonShape = new b2PolygonShape();
			var wallBd:b2BodyDef = new b2BodyDef();
			var wallB:b2Body;
			
			var barPosOffset:Number = 94.0;
			var barWidth:Number = 100.0 / PPM;
			var centerX:Number = SizeUtil.width / PPM / 2;
			var centerY:Number = SizeUtil.height / PPM / 2;
			
			wallBd.position.Set(-barPosOffset / PPM, centerY);
			wall.SetAsBox(barWidth, centerY);
			wallB = this.CreateBody(wallBd);
			wallB.CreateFixture2(wall, 1.0);
			
			wallBd.position.Set((SizeUtil.width + barPosOffset) / PPM, centerY);
			wallB = this.CreateBody(wallBd);
			wallB.CreateFixture2(wall, 1.0);
			
			wallBd.position.Set(centerX, -barPosOffset / PPM);
			wall.SetAsBox(centerX, barWidth);
			wallB = this.CreateBody(wallBd);
			wallB.CreateFixture2(wall, 1.0);
			
			wallBd.position.Set(centerX, (SizeUtil.height + barPosOffset) / PPM);
			wallB = this.CreateBody(wallBd);
			wallB.CreateFixture2(wall, 1.0);
		}
		
		private function makeFlippers():void
		{
			var flipperWidth:int = 90;
			var flipperHeight:int = 15;
			var flipperOffset:int = 70;
			var flipperUpperAngle:Number = .6;
			var flipperLowerAngle:Number = -.6;
			var flipperTorque:Number = 30.0;
			var flipperMotorSpeed:Number = 0.0;
			var flipperDensity:Number = 2.0;
			var flipperFriction:Number = 0.0;
			var flipperX:Number = 0.3;
			var flipperY:Number = 0.75;
			
			var flipperDef:b2BodyDef = new b2BodyDef();
			flipperDef.type = b2Body.b2_dynamicBody;
			flipperDef.position.Set((SizeUtil.width * flipperX) / PPM, (SizeUtil.height * flipperY) / PPM);
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
			
			flipperDef.position.Set((SizeUtil.width * (1-flipperX)) / PPM, (SizeUtil.height * flipperY) / PPM);	
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
			var y:Number = 0.2;
			
			for(var i:int = 0; i < _targets.length; i++)
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
				fd.restitution = 0.3;
				bodyDefC.position.Set(((SizeUtil.width * _targetPadding) + (i * _targetSpacing * SizeUtil.width)) / PPM, (SizeUtil.height * y) / PPM);
				body = this.CreateBody(bodyDefC);
				body.SetType(b2Body.b2_staticBody);
				body.CreateFixture(fd);
				
				_targets[i] = body;
			}
		}
		
		public function moveTargets(yPosition:Number):void
		{
			yPosition /= SizeUtil.height;
			
			for(var i:int = 0; i<_targets.length; i++)
			{
				_targets[i].SetPosition(new b2Vec2(((SizeUtil.width * _targetPadding) + (i * _targetSpacing * SizeUtil.width)) / PPM, (SizeUtil.height * yPosition) / PPM));
			}
		}
		
		public function makeBall(x:int, y:int):void 
		{
			var fd:b2FixtureDef;
			var bodyDefC:b2BodyDef = new b2BodyDef();
			bodyDefC.type = b2Body.b2_dynamicBody;
			var circDef:b2CircleShape= new b2CircleShape(18 / PPM);
			fd = new b2FixtureDef();
			fd.shape = circDef;
			fd.density = 2.0;
			fd.friction = 0;
			fd.restitution = 0.1;
			bodyDefC.position.Set(x / PPM, y / PPM);
			_ball = this.CreateBody(bodyDefC);
			_ball.SetBullet(true);
			_ball.CreateFixture(fd);
		}
		
		private function addContactListeners():void
		{
			var targetContactListener:TargetContactListener = new TargetContactListener();
			this.SetContactListener(targetContactListener);
						
			var ballVO:BodyValueObject = new BodyValueObject;
			ballVO.bodyType = BodyType.BALL;
			
			_ball.SetUserData(ballVO);
			
			for (var i:int = 0; i < _targets.length; i++) 
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
	}
}