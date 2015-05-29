package br.com.casi {
	import flash.external.ExternalInterface;
	public class Tracer  {
		public static function call(func:String, value:String, debug:Boolean=false):void {
			if (debug) trace(func, value);
			if (ExternalInterface.available) {
				ExternalInterface.call(func, value);
			}
		}
	}
}