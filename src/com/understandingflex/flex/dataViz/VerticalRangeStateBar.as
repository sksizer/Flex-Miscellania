package
com.understandingflex.flex.dataViz{
	import com.understandingflex.as3.dataViz.RangedStateBar;

	import flash.display.Sprite;

	import mx.core.UIComponent;

	/**
	 * This is a simple visualization.
	 */
	public class VerticalRangeStateBar extends UIComponent
	{
		
		public function VerticalRangeStateBar()
		{
			super();
		}
		
		private var _background:Sprite;
		private var _rangedState:RangedStateBar;
		
	
		//--------------------------------------------------------------------------
		//
		// PUBLIC PROPERTIES
		//
		//--------------------------------------------------------------------------
		
		private var _backgroundColorChanged:Boolean = false;
		private var _backgroundColor:int = -1;
		
		public function set backgroundColor(value:int):void
		{
			if (_backgroundColor == value )
				return;
		
			_backgroundColor = value;
			_backgroundColorChanged = true;
			invalidateDisplayList();
		}
		
		
		//--------------------------------------------------------------------------
		//
		// PUBLIC METHODS
		//
		//--------------------------------------------------------------------------
		
		public function addState(stateName:String,  color:uint):void
		{
			_rangedState.addState(stateName, color);
		}
		
		public function addValue(start:Number, end:Number,  stateName:String):void
		{
			_rangedState.updateValue(start, end, stateName);
		}
		
		public function reset():void
		{
			_rangedState.reset();
		}
		
		//--------------------------------------------------------------------------
		//
		// UICOMPONENT LIFECYCLE
		//
		//--------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
		
			if (_background == null)
			{
				_background = new Sprite();
			}
			addChild(_background);
			
			
			if (_rangedState == null)
			{
				_rangedState = new RangedStateBar(true);
			}
			addChild(_rangedState);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			var widthScaleFactor:Number =  unscaledWidth / 100;
			var heightScaleFactor:Number = unscaledHeight / 1000;
			
			if (_backgroundColorChanged)
			{
				_backgroundColorChanged = false;
				drawBackground();
			}
			
			_background.scaleX = widthScaleFactor;
			_background.scaleY = heightScaleFactor;
			
			_rangedState.scaleX = widthScaleFactor;
			_rangedState.scaleY = heightScaleFactor;
		}
		
		private function drawBackground():void
		{
			_background.graphics.clear();
			
			if (_backgroundColor < 0)
				return;
			
			_background.graphics.beginFill(_backgroundColor,1);
			_background.graphics.drawRect(0,0,100,1000);
		}
	}
}
