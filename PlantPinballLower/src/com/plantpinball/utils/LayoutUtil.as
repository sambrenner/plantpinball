package com.plantpinball.utils
{
	import flash.geom.Point;
	
	import Box2D.Common.Math.b2Vec2;

	public class LayoutUtil
	{
		public static const NUM_TARGETS:int = 5;
		
		//percentage values
		public static const TARGET_PADDING:Number = 0.31;
		public static const TARGET_X_SPACING:Number = (1 - (2*TARGET_PADDING)) / (NUM_TARGETS - 1);
		public static const FLIPPER_Y:Number = 0.89;
		public static const LEFT_FLIPPER_X:Number = 0.34;
		public static const RIGHT_FLIPPER_X:Number = 0.57;
		public static const TRAMPLE_OBSTACLE_Y:Number = 0.17;
		public static const FUNGUS_OBSTACLE_Y:Number = 0.42;
		public static const OBSTACLE_X:Number = 0.12;
		public static const NICHE_X:Number = 0.5;
		public static const NICHE_Y_OFFSET:Number = 0.18;
		
		//pixel values
		public static const CELL_Y_SPACING:int = 66;
		public static const CELL_Y_OFFSET:int = 160;
		public static const INITIAL_BALL_POS:b2Vec2 = new b2Vec2(665,1230);
		public static const ELONGATION_CELL_POSITIONS:Vector.<Point> = new <Point>
		[
			new Point(287,-127),
			new Point(344,-87),
			new Point(402,-57),
			new Point(452,-25),
			new Point(503,13)
		];
		
		public function LayoutUtil()
		{
		}
	}
}