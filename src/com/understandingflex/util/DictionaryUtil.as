/**
 * Created by IntelliJ IDEA.
 * User: shane.sizer
 * Date: 6/28/11
 * Time: 3:22 PM
 */
package com.understandingflex.util
{
	import flash.utils.Dictionary;

	public class DictionaryUtil
	{
		public static function clear(dict:Dictionary):void
		{
			for(var id:String in dict) {
				delete dict[id];
			  }
		}
		
		public function DictionaryUtil(nonInstantiationEnforcer:NonInstantiationEnforcer)
		{
		}
	}
	
}

class NonInstantiationEnforcer
{
}