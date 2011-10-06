package com.understandingflex.util
{
	import com.understandingflex.patterns.IDisposable;

	import flash.utils.Dictionary;

	public class DisposeUtil
	{
		/**
		 * Calls dispose on any disposable items within the dictionary, and then deletes the key.
		 * @param dict
		 */
		public static function disposeDictionary(dict:Dictionary):void
		{
			for(var id:String in dict) {
				var disposable:IDisposable = dict[id] as IDisposable;
				if (disposable)
				delete dict[id];
			  }
		}
		
		public function DisposeUtil(nonInstantiationEnforcer:NonInstantiationEnforcer)
		{
		}
	}
}

class NonInstantiationEnforcer
{
}