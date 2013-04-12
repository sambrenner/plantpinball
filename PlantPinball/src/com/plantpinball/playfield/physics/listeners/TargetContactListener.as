package com.plantpinball.playfield.physics.listeners
{
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactListener;
	
	import com.plantpinball.playfield.data.BodyType;
	import com.plantpinball.playfield.data.TargetValueObject;
		
	public class TargetContactListener extends b2ContactListener
	{		
		public function TargetContactListener()
		{
			super();
		}
		
		override public function BeginContact(contact:b2Contact):void
		{
			if(contact.GetFixtureA().GetBody().GetUserData() == BodyType.TARGET) 
			{
				(contact.GetFixtureA().GetBody().GetUserData() as TargetValueObject).hit = true;
			}
			else if(contact.GetFixtureB().GetBody().GetUserData() == BodyType.TARGET)
			{
				(contact.GetFixtureB().GetBody().GetUserData() as TargetValueObject).hit = true;
			}
		}
	}
}