package com.plantpinball.utils
{
	public class SizeUtil
	{
		public static const FULL_SIZE:String = "full";
		public static const HALF_SIZE:String = "half";
		public static var SIZE:String;
		
		public function SizeUtil()
		{
		}
		
		public static function get height():int {
			return SIZE == FULL_SIZE ? 1920 : 1280;
		}
		
		public static function get width():int {
			return SIZE == FULL_SIZE ? 1080 : 720;
		}
	}
}