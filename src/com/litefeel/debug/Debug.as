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
		public static var indent:String = "    ";
		
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
		
		public static function showObject(o:*, linePrefix:String = ""):String
		{
			var buffer:Vector.<String> = new Vector.<String>();
			_showObject(o, linePrefix || "", new Dictionary(true), buffer);
			return buffer.join("");
		}
		
		private static function _showObject(o:*, linePrefix:String, dict:Dictionary, buffer:Vector.<String>):void
		{
			var typeName:String = typeof(o);
			switch (typeName)
			{
			case "number": 
			case "string": 
			case "boolean": 
			case "undefined": 
			case "null": 
				buffer.push(":", typeName, indent, String(o), "\n");
				return;
			}
			
			if (o is Array) typeName = "Array";
			else if (o is MovieClip) typeName = "MovieClip";
			else if (o is SimpleButton) typeName = "MovieClip";
			else if (o is TextField) typeName = "MovieClip";
			
			typeName = getQualifiedClassName(o);
			if (o == null)
			{
				buffer.push(linePrefix, ":", typeName, "(null)\n");
				return;
			}
			if (o in dict)
			{
				buffer.push(linePrefix, ":", typeName, "(this object is alreay print)\n");
				return;
			}
			dict[o] = true;
			
			buffer.push(linePrefix, ":", typeName, "\n");
			
			if (typeName.indexOf("flash.") == 0) return;
			
			linePrefix += indent;
			for (var k:String in o)
			{
				buffer.push(linePrefix, k);
				_showObject(o[k], linePrefix, dict, buffer);
			}
			
			var xml:XML = describeType(o);
			
			for each (var tmp:XML in xml.accessor)
			{
				if (tmp.@access == "writeonly")
					buffer.push(linePrefix, tmp.@name, " : this is writeonly property\n");
				else
				{
					buffer.push(linePrefix, tmp.@name);
					_showObject(safeGetValue(o, tmp.@name), linePrefix, dict, buffer);
				}
			}
			for each (tmp in xml.variable)
			{
				buffer.push(linePrefix, tmp.@name);
				_showObject(safeGetValue(o, tmp.@name), linePrefix, dict, buffer);
			}
		
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