package
com.understandingflex.as3.dataViz{
	import com.understandingflex.util.CallLater;

	import flash.display.Sprite;

	/**
	 * 
	 */
	public class RangedStateBar extends Sprite
	{
		/**
		 * 
		 */
		private var states:States;
		
		
		private var updates:Vector.<UpdateValue>;

		private var drawWidth:Number;
		private var drawHeight:Number;
		
		public function RangedStateBar(startAtZero:Boolean = true, drawWidth:Number = 100, drawHeight:Number = 1000)
		{
			if (startAtZero)
				min = 0;
			this.drawWidth = drawWidth;
			this.drawHeight = drawHeight;
			initialize();
		}

		private function initialize():void
		{
			states = new States();
			updates = new Vector.<UpdateValue>();
		}

		//--------------------------------------------------------------------------
		//
		// Style
		//
		//--------------------------------------------------------------------------

		public function addState(stateName:String, color:uint):void
		{
			states.addState(stateName, color);
		}

		//--------------------------------------------------------------------------
		//
		// DATA
		//
		//--------------------------------------------------------------------------

		public function updateValue(start:Number, end:Number, state:String):void
		{
			updates.push(new UpdateValue(start, end, state));
			invalidateProperties();
		}

		public function updateDisplay():void
		{
			for each (var updateValue:UpdateValue in updates)
			{
				min = Math.min(updateValue.start, min);
				max = Math.max(updateValue.end, max);
			}
			
			setScaleFactor();
			
			// Draw Changes
			if (updates.length>0)
			{
				for each (var updateValue:UpdateValue in updates)
				{
					var y1:Number = getRelativeYPos(updateValue.start);
					var y2:Number = getRelativeYPos(updateValue.end);
					var color:uint = states.getStateColor(updateValue.stateName);
					
					this.graphics.beginFill(color);
					this.graphics.drawRect(0,y1, this.drawWidth,y2 - y1);
//					// Draw Separator
//					this.graphics.beginFill(0xFFFFFF);
//					this.graphics.drawRect(0,y1, this.drawWidth,1);
					
					updateValue.dispose();
				}
			}
			updates = new Vector.<UpdateValue>;
		}
		
		private function getRelativeYPos(value:Number):Number
		{
			return (value - min) * _scaleFactor;
		}

		private var _scaleFactor:Number = 1;
		
		private function setScaleFactor():void
		{
			_scaleFactor = this.drawHeight / max - min;
		}

		private var _max:Number = 1;

		internal function get max():Number
		{
			return _max;
		}

		internal function set max(value:Number):void
		{
			_max = value;
//			invalidateProperties();
		}

		private var _min:Number = 0;

		internal function get min():Number
		{
			return _min;
		}

		internal function set min(value:Number):void
		{
			_min = value;
//			invalidateProperties();
		}

		//--------------------------------------------------------------------------
		//
		// Lifecycle
		//
		//--------------------------------------------------------------------------

		private var _commitPropertiesQueued:Boolean = false;

		protected function invalidateProperties():void
		{
			if (!_commitPropertiesQueued)
			{
				_commitPropertiesQueued = true;
				CallLater.callLater(1, commitProperties)
			}

		}

		protected function commitProperties():void
		{
			_commitPropertiesQueued = false;
			updateDisplay();
		}
		
		public function reset(startAtZero:Boolean = true):void
		{
			if (startAtZero)
				min = 0;
			max = 1;
			// Empty and dispose updates
			while (updates.length>0)
			{
				updates.pop().dispose();
			}
			states.reset();
			invalidateProperties();
			
			this.graphics.clear();
		}
	}
}

import com.understandingflex.util.DictionaryUtil;

import flash.utils.Dictionary;

class States
{
	private var stateNamesToColors:Dictionary;

	public function States()
	{
		stateNamesToColors = new Dictionary();
	}

	public function addState(stateName:String, color:uint):void
	{
		stateNamesToColors[stateName] = color;
	}

	public function getStateColor(stateName:String):uint
	{
		return stateNamesToColors[stateName] as uint;
	}
	
	public function reset():void
	{
		DictionaryUtil.clear(stateNamesToColors);
	}
}

class UpdateValue
{
	internal var start:Number;
	internal var end:Number;
	internal var stateName:String;

	public function UpdateValue(start:Number, end:Number, stateName)
	{
		this.start = start;
		this.end = end;
		this.stateName = stateName;
	}
	
	public function dispose():void
	{
		start = undefined;
		end = undefined;
		stateName = undefined;
	}
}
