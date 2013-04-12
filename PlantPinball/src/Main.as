package 
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	
	import com.plantpinball.playfield.PlayfieldMain;
	import com.plantpinball.utils.SizeUtil;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class Main extends Sprite
	{
		private var _playfield:PlayfieldMain;
		
		public function Main()
		{
			if(stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			SizeUtil.SIZE = SizeUtil.HALF_SIZE;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
					
			_playfield = new PlayfieldMain(stage);
			_playfield.init();
			addChild(_playfield);
		}
	}
}