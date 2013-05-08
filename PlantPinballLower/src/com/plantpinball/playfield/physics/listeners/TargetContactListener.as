package com.plantpinball.playfield.physics.listeners
{
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactListener;
	
	import com.plantpinball.playfield.data.BodyType;
	import com.plantpinball.playfield.data.BodyValueObject;
	import com.plantpinball.playfield.data.TargetValueObject;
		
	public class TargetContactListener extends b2ContactListener
	{		
		public function TargetContactListener()
		{
			super();
		}
		
		override public function BeginContact(contact:b2Contact):void
		{
			var userDataA:BodyValueObject = contact.GetFixtureA().GetBody().GetUserData();
			var userDataB:BodyValueObject = contact.GetFixtureB().GetBody().GetUserData();
			
			if(userDataA)
			{
				if((userDataA as BodyValueObject).bodyType == BodyType.TARGET || (userDataA as BodyValueObject).bodyType == BodyType.OBSTACLE || (userDataA as BodyValueObject).bodyType == BodyType.NICHE) 
				{
					(userDataA as TargetValueObject).hit = true;
				}
			}
			
			if(userDataB)
			{
				if((userDataB as BodyValueObject).bodyType == BodyType.TARGET || (userDataB as BodyValueObject).bodyType == BodyType.OBSTACLE || (userDataB as BodyValueObject).bodyType == BodyType.NICHE)
				{
					(userDataB as TargetValueObject).hit = true;
				}	
			}
		}
	}
}