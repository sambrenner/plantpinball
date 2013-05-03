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
				case 1: //begin main piece
					wall.push(new b2Vec2(621.55, 642.1), new b2Vec2(661.45, 629.75), new b2Vec2(622.3, 688.25));
					break;
				case 2:
					wall.push(new b2Vec2(661.45, 629.75), new b2Vec2(692.75, 600), new b2Vec2(654.75, 752.15), new b2Vec2(630.7, 737.45), new b2Vec2(622.3, 688.25));
					break;
				case 3:
					wall.push(new b2Vec2(692.75, 600), new b2Vec2(704.3, 564.3), new b2Vec2(675.05, 774.1), new b2Vec2(654.75, 752.15));
					break;
				case 4:
					wall.push(new b2Vec2(675.05, 774.1), new b2Vec2(704.3, 564.3), new b2Vec2(685.45, 802.8));
					break;
				case 5:
					wall.push(new b2Vec2(685.45, 802.8), new b2Vec2(704.3, 564.3), new b2Vec2(687.15, 848.35));
					break;
				case 6:
					wall.push(new b2Vec2(687.15, 848.35), new b2Vec2(704.3, 564.3), new b2Vec2(717.15, 1284.05), new b2Vec2(687.15, 1288.35));
					break;
				case 7:
					wall.push(new b2Vec2(717.15, 1284.05), new b2Vec2(704.3, 564.3), new b2Vec2(717.15, 0));
					break;
				case 8:
					wall.push(new b2Vec2(704.3, 564.3), new b2Vec2(703.05, 510.8), new b2Vec2(717.15, 0));
					break;
				case 9:
					wall.push(new b2Vec2(703.05, 510.8), new b2Vec2(682.45, 472.6), new b2Vec2(717.15, 0));
					break;
				case 10:
					wall.push(new b2Vec2(682.45, 472.6), new b2Vec2(649.4, 448.55), new b2Vec2(610.4, 372.55), new b2Vec2(620.4, 297), new b2Vec2(717.15, 0));
					break;
				case 11:
					wall.push(new b2Vec2(187.8, 1290.25), new b2Vec2(-2.85, 1288.35), new b2Vec2(133, 1222.35));
					break;
				case 12:
					wall.push(new b2Vec2(133, 1222.35), new b2Vec2(-2.85, 1288.35), new b2Vec2(92.8, 1159.1));
					break;
				case 13:
					wall.push(new b2Vec2(92.8, 1159.1), new b2Vec2(-2.85, 1288.35), new b2Vec2(65.25, 1080.7));
					break;
				case 14:
					wall.push(new b2Vec2(178.35, 1136.65), new b2Vec2(84.85, 1080.6), new b2Vec2(58.2, 1016.55), new b2Vec2(195.9, 1115.2));
					break;
				case 15:
					wall.push(new b2Vec2(84.85, 1080.6), new b2Vec2(65.25, 1080.7), new b2Vec2(58.2, 1016.55));
					break;
				case 16:
					wall.push(new b2Vec2(65.25, 1080.7), new b2Vec2(-2.85, 1288.35), new b2Vec2(58.2, 1016.55));
					break;
				case 17:
					wall.push(new b2Vec2(-2.85, 1288.35), new b2Vec2(-2.85, 0.9), new b2Vec2(16.5, 249.4), new b2Vec2(42.7, 589), new b2Vec2(58.2, 1016.55));
					break;
				case 18:
					wall.push(new b2Vec2(110, 340.75), new b2Vec2(90.35, 347.55), new b2Vec2(118.95, 315.3));
					break;
				case 19:
					wall.push(new b2Vec2(90.35, 347.55), new b2Vec2(68.45, 365.3), new b2Vec2(109.55, 294), new b2Vec2(118.95, 315.3));
					break;
				case 20:
					wall.push(new b2Vec2(68.45, 365.3), new b2Vec2(56.5, 383.2), new b2Vec2(82.7, 293.9), new b2Vec2(109.55, 294));
					break;
				case 21:
					wall.push(new b2Vec2(56.5, 383.2), new b2Vec2(47.65, 406.15), new b2Vec2(58.75, 286.45), new b2Vec2(82.7, 293.9));
					break;
				case 22:
					wall.push(new b2Vec2(47.65, 406.15), new b2Vec2(42.35, 438.95), new b2Vec2(34.35, 270.6), new b2Vec2(58.75, 286.45));
					break;
				case 23:
					wall.push(new b2Vec2(42.35, 438.95), new b2Vec2(42.7, 589), new b2Vec2(16.5, 249.4), new b2Vec2(34.35, 270.6));
					break;
				case 24:
					wall.push(new b2Vec2(16, 229.95), new b2Vec2(16.5, 249.4), new b2Vec2(13.8, 207.8));
					break;
				case 25:
					wall.push(new b2Vec2(16.5, 249.4), new b2Vec2(-2.85, 0.9), new b2Vec2(13.8, 207.8));
					break;
				case 26:
					wall.push(new b2Vec2(13.8, 207.8), new b2Vec2(-2.85, 0.9), new b2Vec2(20.75, 184.2));
					break;
				case 27:
					wall.push(new b2Vec2(20.75, 184.2), new b2Vec2(-2.85, 0.9), new b2Vec2(29.8, 166.55));
					break;
				case 28:
					wall.push(new b2Vec2(29.8, 166.55), new b2Vec2(-2.85, 0.9), new b2Vec2(44.15, 150.3));
					break;
				case 29:
					wall.push(new b2Vec2(44.15, 150.3), new b2Vec2(-2.85, 0.9), new b2Vec2(68.1, 136.25));
					break;
				case 30:
					wall.push(new b2Vec2(68.1, 136.25), new b2Vec2(-2.85, 0.9), new b2Vec2(116.9, 120.35));
					break;
				case 31:
					wall.push(new b2Vec2(116.9, 120.35), new b2Vec2(-2.85, 0.9), new b2Vec2(181.9, 106.35));
					break;
				case 32:
					wall.push(new b2Vec2(-2.85, 0.9), new b2Vec2(717.15, 0), new b2Vec2(237.05, 101.8), new b2Vec2(181.9, 106.35));
					break;
				case 33:
					wall.push(new b2Vec2(237.05, 101.8), new b2Vec2(717.15, 0), new b2Vec2(289, 101.25));
					break;
				case 34:
					wall.push(new b2Vec2(289, 101.25), new b2Vec2(717.15, 0), new b2Vec2(341, 104.45));
					break;
				case 35:
					wall.push(new b2Vec2(341, 104.45), new b2Vec2(717.15, 0), new b2Vec2(426.65, 118.85));
					break;
				case 36:
					wall.push(new b2Vec2(426.65, 118.85), new b2Vec2(717.15, 0), new b2Vec2(503.25, 144.75));
					break;
				case 37:
					wall.push(new b2Vec2(503.25, 144.75), new b2Vec2(717.15, 0), new b2Vec2(561.3, 179.35));
					break;
				case 38:
					wall.push(new b2Vec2(561.3, 179.35), new b2Vec2(717.15, 0), new b2Vec2(607.25, 233.85));
					break;
				case 39:
					wall.push(new b2Vec2(607.25, 233.85), new b2Vec2(717.15, 0), new b2Vec2(620.4, 297));
					break;
				case 40:
					wall.push(new b2Vec2(610.4, 372.55), new b2Vec2(649.4, 448.55), new b2Vec2(619.2, 443), new b2Vec2(591, 420.85));
					break;
				case 41: //end main piece
					wall.push(new b2Vec2(597.55, 445.9), new b2Vec2(591, 420.85), new b2Vec2(619.2, 443));
					break;
				case 42: //begin bottom right piece
					wall.push(new b2Vec2(463.7, 1123), new b2Vec2(597.5, 1010.4), new b2Vec2(559.3, 1081), new b2Vec2(474.3, 1139.4));
					break;
				case 43:
					wall.push(new b2Vec2(597.5, 1010.4), new b2Vec2(623.75, 967.9), new b2Vec2(570.45, 1080.7), new b2Vec2(559.3, 1081));
					break;
				case 44:
					wall.push(new b2Vec2(570.45, 1080.7), new b2Vec2(623.75, 967.9), new b2Vec2(632.85, 1292.3), new b2Vec2(503.7, 1225.85));
					break;
				case 45:
					wall.push(new b2Vec2(448, 1292.3), new b2Vec2(503.7, 1225.85), new b2Vec2(632.85, 1292.3));
					break;
				case 46: //end bottom right piece
					wall.push(new b2Vec2(632.85, 1292.3), new b2Vec2(623.75, 967.9), new b2Vec2(633.95, 870.95));
					break;
				case 47: //left bumper holder
					wall.push(new b2Vec2(172.6, 870.65), new b2Vec2(184.05, 861.15), new b2Vec2(184.4, 917.55), new b2Vec2(147.15, 950.1), new b2Vec2(144.15, 930.9));
					break;
				case 48:
					wall.push(new b2Vec2(194.85, 974.25), new b2Vec2(147.15, 950.1), new b2Vec2(184.4, 917.55), new b2Vec2(215.3, 961.35), new b2Vec2(212.6, 972.85));
					break;
				case 49: //right bumper holder
					wall.push(new b2Vec2(526.7, 931.9), new b2Vec2(525.95, 950.55), new b2Vec2(491.85, 934.55), new b2Vec2(480.45, 861.55), new b2Vec2(488.6, 861.65));
					break;
				case 50:
					wall.push(new b2Vec2(491.85, 934.55), new b2Vec2(525.95, 950.55), new b2Vec2(475.1, 974.5), new b2Vec2(454.2, 973.4), new b2Vec2(449.35, 967.05));
					break;
				case 51: //left bumper
					wall.push(new b2Vec2(185.9, 860.6), new b2Vec2(187.8, 861.55), new b2Vec2(190.5, 864.15), new b2Vec2(195.2, 871.05), new b2Vec2(217.45, 951.8), new b2Vec2(215.9, 958.9), new b2Vec2(186, 917.15));
					break;
				case 52: //right bumper
					wall.push(new b2Vec2(473.1, 869.8), new b2Vec2(477.95, 863.15), new b2Vec2(489.95, 933.05), new b2Vec2(448.7, 964.55), new b2Vec2(448.2, 953.9));
					break;
				case 53: //ball holder
					wall.push(new b2Vec2(636.25, 1286.7), new b2Vec2(636.25, 1254.95), new b2Vec2(683.25, 1273.95), new b2Vec2(683.25, 1286.7));
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