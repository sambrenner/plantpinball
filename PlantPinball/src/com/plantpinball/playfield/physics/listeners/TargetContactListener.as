package com.plantpinball.playfield.physics.listeners
{
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactListener;
	
	import com.plantpinball.data.BodyType;
	
	public class TargetContactListener extends b2ContactListener
	{
		public function TargetContactListener()
		{
			super();
		}
		
		override public function BeginContact(contact:b2Contact):void
		{
			if(String(contact.GetFixtureA().GetBody().GetUserData()).indexOf(BodyType.TARGET) == 0 || String(contact.GetFixtureB().GetBody().GetUserData()).indexOf(BodyType.TARGET) == 0)
			{
				trace(contact.GetFixtureA().GetBody().GetUserData() + " " + contact.GetFixtureB().GetBody().GetUserData());
			}
		}
	}
}