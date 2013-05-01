package com.plantpinball.utils
{
	import Box2D.Common.Math.b2Vec2;

	public class WallUtil
	{
		private static const PPM:Number = 30;
		
		public function WallUtil()
		{
		}
		
		public static function getWall(wallId:int):Array
		{
			// box2d polygon decomposition script
			// http://www.box2d.org/forum/viewtopic.php?f=8&t=463
			
			var wall:Array = new Array();
			
			switch(wallId)
			{
				case 1:
					wall.push(new b2Vec2(627, 640), new b2Vec2(674, 622), new b2Vec2(627, 685));
					break;
				case 2:
					wall.push(new b2Vec2(674, 622), new b2Vec2(703, 587), new b2Vec2(662, 752), new b2Vec2(634, 738), new b2Vec2(627, 685));
					break;
				case 3:
					wall.push(new b2Vec2(662, 752), new b2Vec2(703, 587), new b2Vec2(681, 778));
					break;
				case 4:
					wall.push(new b2Vec2(703, 587), new b2Vec2(710, 535), new b2Vec2(691, 811.95), new b2Vec2(681, 778));
					break;
				case 5:
					wall.push(new b2Vec2(691, 811.95), new b2Vec2(710, 535), new b2Vec2(720, 1280), new b2Vec2(691, 1280));
					break;
				case 6:
					wall.push(new b2Vec2(720, 1280), new b2Vec2(710, 535), new b2Vec2(720, 0));
					break;
				case 7:
					wall.push(new b2Vec2(710, 535), new b2Vec2(697, 481), new b2Vec2(720, 0));
					break;
				case 8:
					wall.push(new b2Vec2(697, 481), new b2Vec2(671, 454), new b2Vec2(624, 329), new b2Vec2(619, 247), new b2Vec2(720, 0));
					break;
				case 9:
					wall.push(new b2Vec2(173, 1279.9), new b2Vec2(0, 1279.9), new b2Vec2(99, 1182.9));
					break;
				case 10:
					wall.push(new b2Vec2(99, 1182.9), new b2Vec2(0, 1279.9), new b2Vec2(77, 1143.9));
					break;
				case 11:
					wall.push(new b2Vec2(77, 1143.9), new b2Vec2(0, 1279.9), new b2Vec2(61, 1092.9));
					break;
				case 12:
					wall.push(new b2Vec2(61, 1092.9), new b2Vec2(0, 1279.9), new b2Vec2(48, 1011.9));
					break;
				case 13:
					wall.push(new b2Vec2(0, 1279.9), new b2Vec2(0, 0), new b2Vec2(14, 222), new b2Vec2(48, 1011.9));
					break;
				case 14:
					wall.push(new b2Vec2(110, 334.95), new b2Vec2(82, 343), new b2Vec2(107, 284), new b2Vec2(117, 306.95));
					break;
				case 15:
					wall.push(new b2Vec2(82, 343), new b2Vec2(59, 370.95), new b2Vec2(90, 289.95), new b2Vec2(107, 284));
					break;
				case 16:
					wall.push(new b2Vec2(90, 289.95), new b2Vec2(59, 370.95), new b2Vec2(58, 280));
					break;
				case 17:
					wall.push(new b2Vec2(59, 370.95), new b2Vec2(45, 408.95), new b2Vec2(58, 280));
					break;
				case 18:
					wall.push(new b2Vec2(45, 408.95), new b2Vec2(41, 434.95), new b2Vec2(23, 252), new b2Vec2(58, 280));
					break;
				case 19:
					wall.push(new b2Vec2(41, 434.95), new b2Vec2(48, 1011.9), new b2Vec2(14, 222), new b2Vec2(23, 252));
					break;
				case 20:
					wall.push(new b2Vec2(14, 222), new b2Vec2(0, 0), new b2Vec2(20, 182));
					break;
				case 21:
					wall.push(new b2Vec2(20, 182), new b2Vec2(0, 0), new b2Vec2(35, 148));
					break;
				case 22:
					wall.push(new b2Vec2(35, 148), new b2Vec2(0, 0), new b2Vec2(82, 121));
					break;
				case 23:
					wall.push(new b2Vec2(82, 121), new b2Vec2(0, 0), new b2Vec2(175, 101));
					break;
				case 24:
					wall.push(new b2Vec2(0, 0), new b2Vec2(720, 0), new b2Vec2(274, 91), new b2Vec2(175, 101));
					break;
				case 25:
					wall.push(new b2Vec2(274, 91), new b2Vec2(720, 0), new b2Vec2(365, 98));
					break;
				case 26:
					wall.push(new b2Vec2(365, 98), new b2Vec2(720, 0), new b2Vec2(505, 136));
					break;
				case 27:
					wall.push(new b2Vec2(505, 136), new b2Vec2(720, 0), new b2Vec2(577, 177));
					break;
				case 28:
					wall.push(new b2Vec2(577, 177), new b2Vec2(720, 0), new b2Vec2(619, 247));
					break;
				case 29:
					wall.push(new b2Vec2(624, 329), new b2Vec2(671, 454), new b2Vec2(633, 437), new b2Vec2(595, 413));
					break;
				case 30:
					wall.push(new b2Vec2(603, 441), new b2Vec2(595, 413), new b2Vec2(633, 437));
					break;
				case 31:
					wall.push(new b2Vec2(173, 869.95), new b2Vec2(180, 860.95), new b2Vec2(190, 860.95), new b2Vec2(194, 870.95), new b2Vec2(217, 952.95), new b2Vec2(217, 962.95), new b2Vec2(215, 972.95), new b2Vec2(207, 979.95), new b2Vec2(149, 952.95), new b2Vec2(142, 940.95), new b2Vec2(145, 925.95));
					break;
				case 32:
					wall.push(new b2Vec2(495, 861.95), new b2Vec2(500, 872.95), new b2Vec2(528, 950.95), new b2Vec2(483, 972.95), new b2Vec2(464, 975.95), new b2Vec2(453, 963.95), new b2Vec2(455, 948.95), new b2Vec2(478, 874.95), new b2Vec2(483, 862.95));
					break;
				case 33:
					wall.push(new b2Vec2(528, 950.95), new b2Vec2(500, 872.95), new b2Vec2(531, 928.95), new b2Vec2(532, 938.95));				
					break;
				case 34: 
					wall.push(new b2Vec2(128, 1068.9), new b2Vec2(141, 1053.9), new b2Vec2(215, 1131.9), new b2Vec2(202, 1150.9), new b2Vec2(127, 1086.9));
					break;
				case 35: 
					wall.push(new b2Vec2(443, 1149.9), new b2Vec2(441, 1136.9), new b2Vec2(518, 1055.9), new b2Vec2(530, 1068.9), new b2Vec2(533, 1085.9), new b2Vec2(462, 1153.9));
					break;
				case 36:
					wall.push(new b2Vec2(605, 1047.9), new b2Vec2(627, 1041.9), new b2Vec2(573, 1132.9));
					break;
				case 37:
					wall.push(new b2Vec2(573, 1132.9), new b2Vec2(627, 1041.9), new b2Vec2(658, 1041.9), new b2Vec2(658, 1279.9), new b2Vec2(540, 1204.9));
					break;
				case 38:
					wall.push(new b2Vec2(488, 1279.9), new b2Vec2(514, 1249.9), new b2Vec2(658, 1279.9));
					break;
				case 39:
					wall.push(new b2Vec2(514, 1249.9), new b2Vec2(540, 1204.9), new b2Vec2(658, 1279.9));
					break;
			}
			
			for(var i:int=0; i<wall.length; i++)
			{
				(wall[i] as b2Vec2).x /= PPM;
				(wall[i] as b2Vec2).y /= PPM;
			}
			
			return wall;
		}
	}
}