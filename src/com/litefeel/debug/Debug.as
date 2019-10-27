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
	public final class Debug
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
			var typeName:String = getQualifiedClassName(o);
			var buffer:Vector.<String> = new Vector.<String>();
			_showObject(o, typeName, linePrefix || "", new Dictionary(true), buffer);
			return buffer.join("");
		}
		
		private static function _showObject(o:*, typeName:String, linePrefix:String, dict:Dictionary, buffer:Vector.<String>):void
		{
			if (checkBaseType(o, typeName, buffer, false)) return;
			
			if (o in dict)
			{
				buffer.push(":", typeName, "(this object is alreay print)\n");
				return;
			}
			dict[o] = true;
			
			var realTypeName:String = getQualifiedClassName(o);
			if (typeName == "*" && checkBaseType(o, realTypeName, buffer, true)) return;
			
			if (typeName == realTypeName) buffer.push(":", typeName, "\n");
			else buffer.push(":", typeName, "[", realTypeName, "]\n");
			
			if (typeName.indexOf("flash.") == 0) return;
			
			linePrefix += indent;
			for (var k:String in o)
			{
				buffer.push(linePrefix, k);
				_showObject(o[k], getQualifiedClassName(o[k]), linePrefix, dict, buffer);
			}
			
			var xml:XML = describeType(o);
			
			for each (var tmp:XML in xml.accessor)
			{
				if (tmp.@access == "writeonly")
					buffer.push(linePrefix, tmp.@name, ":", tmp.@type, "(this is writeonly property)\n");
				else
				{
					buffer.push(linePrefix, tmp.@name);
					_showObject(safeGetValue(o, tmp.@name), tmp.@type, linePrefix, dict, buffer);
				}
			}
			for each (tmp in xml.variable)
			{
				buffer.push(linePrefix, tmp.@name);
				_showObject(safeGetValue(o, tmp.@name), tmp.@type, linePrefix, dict, buffer);
			}
		
		}
		
		private static function checkBaseType(o:*, typeName:String, buffer:Vector.<String>, isUntype:Boolean):Boolean
		{
			switch (typeName)
			{
			case "int": 
			case "uint": 
			case "Number": 
			case "Boolean": 
			case "String": 
			case "undefined": 
			case "null": 
				if (isUntype)
					buffer.push(":*[", typeName, "]  ", String(o), "\n");
				else
					buffer.push(":", typeName, "   ", String(o), "\n");
				return true;
			}
			if (o == null)
			{
				if (isUntype)
					buffer.push(":*[", typeName, "]  ", "null\n");
				else
					buffer.push(":", typeName, "   ", "null\n");
				return true;
			}
			
			return false;
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