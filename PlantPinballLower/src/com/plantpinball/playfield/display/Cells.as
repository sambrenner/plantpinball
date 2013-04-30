package com.plantpinball.playfield.display
{
	import com.plantpinball.utils.SizeUtil;
	
	import flash.display.MovieClip;
	
	public class Cells extends MovieClip
	{
		private var _activeCells:Vector.<Cell>;
		
		public function Cells()
		{
			super();
			
			makeInitialTargets();
		}
		
		public function animateCell(cellId:int):void
		{
			_activeCells[cellId].animateDivision();
		}
		
		private function makeInitialTargets():void
		{
			_activeCells = new Vector.<Cell>(5);
			_activeCells[0] = new CellA();
			_activeCells[1] = new CellB();
			_activeCells[2] = new CellC();
			_activeCells[3] = new CellD();
			_activeCells[4] = new CellE();
			
			var padding:Number = 0.2;
			var spacing:Number = (1 - (2*padding)) / (_activeCells.length - 1);
			
			for(var i:int=0; i<_activeCells.length; i++)
			{
				var cell:Cell = _activeCells[i];
				
				cell.x = (i * spacing * SizeUtil.width) - (cell.width / 2);
				addChild(cell);
			}
		}
	}
}