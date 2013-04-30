package com.plantpinball.playfield.display
{
	import com.plantpinball.events.PlantPinballEvent;
	import com.plantpinball.utils.SizeUtil;
	
	import flash.display.MovieClip;
	
	public class Cells extends MovieClip
	{
		private var _cellHolder:MovieClip;
		private var _newestCells:Vector.<Cell> = new Vector.<Cell>(5);
		private var _fileIsHit:Vector.<Boolean> = new Vector.<Boolean>(5);
		private var _padding:Number = 0.2;
		private var _spacing:Number = (1 - (2*_padding)) / (_newestCells.length - 1);
		private var _yMultiplier:int = 1;
		private var _yOffset:int = 66;
		
		public function Cells()
		{
			super();
			
			_cellHolder = new MovieClip();
			addChild(_cellHolder);
			
			addEventListener(PlantPinballEvent.ANIMATION_COMPLETE, onAnimationComplete);
			
			resetFileStatus();
			makeInitialTargets();
			makeCellsActive();
		}
		
		public function hitCell(cellId:int):void
		{
			_fileIsHit[cellId] = true;
			_newestCells[cellId].animateDivision();
			
			if(isRowComplete()) progressRow();
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
			resetFileStatus();
			makeCellsActive();
			
			dispatchEvent(new PlantPinballEvent(PlantPinballEvent.ROW_CLEARED));
			_yMultiplier += 1;
		}
		
		private function resetFileStatus():void
		{
			for(var i:int = 0; i<_fileIsHit.length; i++)
			{
				_fileIsHit[i] = false;
			}
		}
		
		private function makeInitialTargets():void
		{
			for(var i:int=0; i<_newestCells.length; i++)
			{
				var cell:Cell = makeCell(i);
								
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
			
			newCell.x = (fileId * _spacing * SizeUtil.width) - (newCell.width / 2);
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
			var target:Cell = e.target as Cell;
			var fileId:int = target.fileId;
			
			var newCell:Cell = makeCell(fileId);
			
			newCell.active = false;
			newCell.y = target.y + _yOffset; //possible bug on 2nd row clearing?
			
			_newestCells[fileId].reset();
			_newestCells[fileId] = newCell;
			
			_cellHolder.addChild(newCell);
		}
	}
}