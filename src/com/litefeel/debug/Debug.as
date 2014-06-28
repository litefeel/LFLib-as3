package com.litefeel.debug
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.net.LocalConnection;
	import flash.text.TextField;
	import flash.utils.describeType;
	/**
	 * ...
	 * @author lite3
	 */
	public class Debug
	{
		public static var loggerEnabled:Boolean = true;
		public static var traceEnabled:Boolean = true;
		
		private static var client:LocalConnection;
		/**
		 * AS3的trace
		 */
		public static function show(... args):void
		{
			var s:String = "";
			var len:Number = args.length;
			for (var i:Number = 0; i < len; i++)
			{
				s += args[i] +" ";
			}
			_trace(s);
		}
		
		/**
		 * 显示一个对象
		 * @param	o   要显示的对象, 任意类型
		 * @param	name	追加的变量名,一个字符串
		 */
		public static function showObjectProps(o:*, name:String):void
		{
			if (null == name) name = "";
			var s:String = name + showObject(o, "");
			_trace(s);
		}
		private static function showObject(o:*, lineLeft:String):String
		{
			if (null == lineLeft) lineLeft = "";
			var s:String = "";
			var typeName:String = typeof(o);
			switch(typeName)
			{
				case "number" :
				case "string" :
				case "boolean" :
				case "undefined" :
				case "null" :
					s = ":" + typeof(o);
					s += "     " + o + "\n";
					return s;
			}
			
			if (o is Array) typeName = "Array";
			else if (o is MovieClip) typeName = "MovieClip";
			else if (o is SimpleButton) typeName = "MovieClip";
			else if (o is TextField) typeName = "MovieClip";
			
			s = lineLeft + ":"+typeName+"\n";
			lineLeft += "     ";
			for (var k:String in o)
			{
				s += lineLeft + k + showObject(o[k], lineLeft);
			}
			
			var xml:XML = describeType(o);
			for each(var tmp:XML in xml.accessor)
			{
				s += lineLeft + tmp.@name + showObject(o[tmp.@name], lineLeft);
			}
			for each(tmp in xml.variable)
			{
				s += lineLeft + tmp.@name + showObject(o[tmp.@name], lineLeft);
			}
			return s;
			
		}
		
		static private function _trace(s:String):void
		{
			if (traceEnabled) trace(s);
			if (loggerEnabled)
			{
				//if (!client) client = new LocalConnection();
				//client.send("_lite3Loger", "DebugTrace", s);
			}
		}
	}
}