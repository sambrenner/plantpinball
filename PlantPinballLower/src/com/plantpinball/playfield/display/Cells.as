package com.plantpinball.playfield.display
{
	import com.plantpinball.events.PlantPinballEvent;
	import com.plantpinball.utils.LayoutUtil;
	import com.plantpinball.utils.SizeUtil;
	
	import flash.display.MovieClip;
	
	public class Cells extends MovieClip
	{
		private var _cellHolder:MovieClip;
		private var _newestCells:Vector.<Cell> = new Vector.<Cell>(5);
		private var _fileIsHit:Vector.<Boolean> = new Vector.<Boolean>(5);
		private var _yMultiplier:int = 0;
		
		public function Cells()
		{
			super();
			
			_cellHolder = new MovieClip();
			addChild(_cellHolder);
			
			addEventListener(PlantPinballEvent.ANIMATION_COMPLETE, onAnimationComplete);
			
			resetFileStatus();
			makeRow(0);
			makeCellsActive();
		}
		
		public function hitCell(cellId:int):void
		{
			_fileIsHit[cellId] = true;
			_newestCells[cellId].animateDivision();
		}
		
		private function isRowComplete():Boolean
		{
			for(var i:int = 0; i<_fileIsHit.length; i++)
			{
				if(_fileIsHit[i] == false) return false;
			}
			
			return true;
		}
		
		private function progressRow():void
		{
			_yMultiplier += 1;
			
			resetFileStatus();
			resetRowAnimation();
			
			makeRow(_yMultiplier * LayoutUtil.CELL_Y_SPACING);
			makeCellsActive();
			
			dispatchEvent(new PlantPinballEvent(PlantPinballEvent.ROW_CLEARED));
		}
		
		private function resetRowAnimation():void
		{
			for(var i:int=0; i<_newestCells.length; i++)
			{
				_newestCells[i].reset();
			}
		}
		
		private function resetFileStatus():void
		{
			for(var i:int = 0; i<_fileIsHit.length; i++)
			{
				_fileIsHit[i] = false;
			}
		}
		
		private function makeRow(yPos:int):void
		{
			for(var i:int=0; i<_newestCells.length; i++)
			{
				var cell:Cell = makeCell(i);
				cell.y = yPos;
				
				_newestCells[i] = cell;
				_cellHolder.addChild(cell);
			}
		}
		
		private function makeCell(fileId:int):Cell
		{
			var newCell:Cell;
			
			switch(fileId)
			{
				case 0:
					newCell = new CellA();
					break;
				case 1:
					newCell = new CellB();
					break;
				case 2:
					newCell = new CellC();
					break;
				case 3:
					newCell = new CellD();
					break;
				case 4:
					newCell = new CellE();
					break;
			}
			
			newCell.x = (LayoutUtil.TARGET_PADDING * SizeUtil.width) + (fileId * LayoutUtil.TARGET_X_SPACING * SizeUtil.width) - (newCell.width / 2);
			newCell.fileId = fileId;
			
			return newCell;
		}
		
		private function makeCellsActive():void
		{
			for(var i:int = 0; i<_newestCells.length; i++)
			{
				_newestCells[i].active = true;
			}
		}
		
		private function onAnimationComplete(e:PlantPinballEvent):void
		{
			if(isRowComplete()) progressRow();
		}

		public function get yMultiplier():int
		{
			return _yMultiplier;
		}
	}
}