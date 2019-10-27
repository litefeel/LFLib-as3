package com.litefeel.debug
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.net.LocalConnection;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
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
				s += args[i] + " ";
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
		
		public static function showObject(o:*, indent:String = "    "):String
		{
			return _showObject(o, indent || "", new Dictionary(true));
		}
		
		private static function _showObject(o:*, indent:String, dict:Dictionary):String
		{
			var s:String = "";
			var typeName:String = typeof(o);
			switch (typeName)
			{
			case "number": 
			case "string": 
			case "boolean": 
			case "undefined": 
			case "null": 
				s = ":" + typeof(o);
				s += "     " + o + "\n";
				return s;
			}
			
			if (o is Array) typeName = "Array";
			else if (o is MovieClip) typeName = "MovieClip";
			else if (o is SimpleButton) typeName = "MovieClip";
			else if (o is TextField) typeName = "MovieClip";
			
			typeName = getQualifiedClassName(o);
			if (o == null) return indent + ":" + typeName + "(null)\n";
			if (o in dict) return indent + ":" + typeName + "(this object is alreay print)\n";
			dict[o] = true;
			
			s = indent + ":" + typeName + "\n";
			
			if (typeName.indexOf("flash.") == 0) return s;
			
			indent += "     ";
			for (var k:String in o)
			{
				s += indent + k + _showObject(o[k], indent, dict);
			}
			
			var xml:XML = describeType(o);
			
			for each (var tmp:XML in xml.accessor)
			{
				if (tmp.@access == "writeonly")
					s += indent + tmp.@name + " : this is writeonly property\n";
				else
					s += indent + tmp.@name + _showObject(safeGetValue(o, tmp.@name), indent, dict);
			}
			for each (tmp in xml.variable)
			{
				s += indent + tmp.@name + _showObject(safeGetValue(o, tmp.@name), indent, dict);
			}
			return s;
		
		}
		
		private static function safeGetValue(o:*, key:String):*
		{
			try
			{
				return o[key];
			}
			catch (err:Error)
			{
				return err.message;
			}
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