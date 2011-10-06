package com.understandingflex.util
{
	import flash.utils.Dictionary;

	public class CallLater
	{
		private static var queueLength:uint = 0;
		private static var queue:Dictionary = new Dictionary();
		
		public static function callLater( frameDelay:uint , call:Function , params:Array=null ):void
		{
			if (frameDelay<1)
				throw new Error("callLater must be delayed by at least 1 frame.");
			var currentFrameCount:uint = FrameCounter.count;
			var targetFrame:uint = currentFrameCount + frameDelay;
			
			var targetFrameList:Array = queue[targetFrame] ? queue[targetFrame] as Array : [];
			queue[targetFrame] = targetFrameList;
			targetFrameList.push( [call, params ] );
			queueLength++;
			FrameCounter.addCallback(enterFrameHandler);
		}
		
		private static function enterFrameHandler():void
		{
			var currentFrameCount:uint = FrameCounter.count;
			var targetFrameList:Array = queue[currentFrameCount] ? queue[currentFrameCount] as Array : [];
			for each (var callBack:Array in targetFrameList)
			{
				var f:Function = callBack[0] as Function;
				var params:Array = callBack[1] as Array;
				f.apply(null,params);
				queueLength--;
			}
			if (queueLength < 1)
				FrameCounter.removeCallback(enterFrameHandler);
		}
		
		public function CallLater(nonInstantiatingEnforcer:NonInstantiatingEnforcer) {}
	}
}

class NonInstantiatingEnforcer {}
