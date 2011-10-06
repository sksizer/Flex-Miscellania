package com.understandingflex.util
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import mx.core.FlexGlobals;

	/**
	 * Provides a running count of frames for the application and also provides 
	 * a single point to hook in and listen to frame events.
	 */
	public class FrameCounter
	{
		private static var _running:Boolean = false;
		private static var _count:uint = 0;
		private static var _callbacks:Dictionary = new Dictionary();
		
		public static function get count():uint
		{
			checkIsInitialized();
			return(_count);
		}
		
		private static function checkIsInitialized():void
		{
			if (!_running)
				initialize();
		}
		
		private static function initialize():void
		{
			IEventDispatcher(FlexGlobals.topLevelApplication).addEventListener(Event.ENTER_FRAME,enterFrameHandler,false,int.MAX_VALUE);
		}
		
		private static function enterFrameHandler(event:Event):void
		{
			_count++;
			notifyCallbacks();
		}
		
		public static function addCallback( f:Function ):void
		{
			checkIsInitialized();
			_callbacks[f] = f;
		}
		
		public static function removeCallback( f:Function ):void
		{
			delete _callbacks[f];
		}
		
		private static function notifyCallbacks():void
		{
			var clonedCallbacks:Dictionary = new Dictionary(true);
			for each (var f:Function in _callbacks)
			{
				clonedCallbacks[f] = f;
			}
			
			// Need to switch to iterator to avoid state error and complicated removeCallback call
			for each (var f:Function in clonedCallbacks)
			{
				f.apply(null,[]);
			}
		}

		/**
		 * @private
		 */
		public function FrameCounter(n:NonInstantiatingEnforcer) {}
	}
}

class NonInstantiatingEnforcer {}
