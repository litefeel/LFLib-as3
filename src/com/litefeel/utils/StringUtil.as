package com.litefeel.utils
{
	
	/**
	 * 欢迎访问我的博客
	 * www.litefeel.com
	 * lite3@qq.com
	 * @author lite3
	 */
	public class StringUtil 
	{
		
		/**
		 * 删除左部空白   
		 * tab,换行,水平制表符,回车,空格, (\t,\n,\f,\r,' ')(9,10,12,13,32,160,8203,8288,12288....)
		 * 
		 * @param	input	<b>	String	</b>
		 * @return
		 */
		static public function leftTrim(input:String):String
		{
			// input 为 null | "" 时,返回自身
			if (!input) return input;
			
			// 第一个字符不是空白
			if (input.charCodeAt(0) > 32) return input;
			
			// 删除左部空白
			return input.replace(/^\s*/, "");
		}
		
		/**
		 * 删除右部空白 
		 * tab,换行,水平制表符,回车,空格, (\t,\n,\f,\r,' ')(9,10,12,13,32,160,8203,8288,12288....)
		 * 
		 * @param	input	<b>	String	</b>
		 * @return
		 */
		static public function rightTrim(input:String):String
		{
			// input 为 null | "" 时,返回自身
			if (!input) return input;
			
			// 第一个字符不是空白
			if (input.charCodeAt(input.length - 1) > 32) return input;
			
			// 删除左部空白
			return input.replace(/\s*$/, "");
		}
		
		/**
		 * 删除左部空白和右部空白
		 * tab,换行,水平制表符,回车,空格, (\t,\n,\f,\r,' ')(9,10,12,13,32,160,8203,8288,12288....)
		 * 
		 * @param	input	<b>	String	</b>
		 * @return
		 */
		static public function trim(input:String):String
		{
			return rightTrim(leftTrim(input));
		}
		
		/**
		 * 清除字符串的所有空白  
		 * tab,换行,水平制表符,回车,空格, (\t,\n,\f,\r,' ')(9,10,12,13,32,160,8203,8288,12288....)
		 * 
		 * @param	input	<b>	String	</b> 要清除空白的字符串
		 * @return
		 */
		static public function removeWhitespace(input:String):String
		{
			if(input)
				return input.replace(/\s/g, "");
			
			return input;
		}
		
		
		/**
		 * 把 input 里的所有 replace 替换为 replaceWidth
		 * 
		 * @param	input			<b>	String	</b> 源字符串
		 * @param	replaceStr		<b>	String	</b> 要替换的字符串
		 * @param	replaceWidth	<b>	String	</b> 替换后的字符串 default:""
		 * @return
		 */
		static public function replace(input:String, replace:String, replaceWith:String = ""):String
		{
			if (!input || !replace || null == replaceWith) return input;
			
			var replaceStr:String = "";
			var regChar:String = "[]\^$.|?*+()";
			var len:int = replace.length;
			var str:String;
			for (var i:int = 0; i < len; i++)
			{
				if (regChar.indexOf(str = replace.charAt(i)) != -1)
					replaceStr += "\\";
				
				replaceStr += str;
			}
			
			return input.replace(new RegExp(replaceStr, "g"), replaceWith);
		}
		
		
		/**
		 * 生成 由 count 个 input 组成的字符串
		 * 
		 * @param	input	<b>	String	</b> intput 为 null | "" 时,返回 input
		 * @param	count	<b>	int		</b> count >= 0, 如果count < 0 ,则count = 0;
		 * @return
		 */
		static public function memset(input:String, count:int):String
		{
			if (!input || count <= 0) return str;			// (null || "") 返回本身   
			
			var str:String = "";
			while (count--)
			{
				str += input;
			}
			return str;
		}
		
		
		/**
		 * 字符串分割成一个2D的数组
		 * @param	str			<b>	String	</b>	被分割字符串
		 * @param	cols		<b>	uint	</b>	分割成2D Array	的行数
		 * @param	rows		<b>	uint	</b>	分割成2D Array	的列数
		 * @param	delim		<b>	String	</b>	分割符 默认为 空字符串 ","
		 * @param	substitute	<b>	String	</b>	补充字符,当被分割字符串长度不够用
		 * @return
		 */
		static public function parseArray2D(str:String, cols:uint, rows:uint, delim:String = null, substitute:String = "1"):Array
		{
			if (!String) return null;
			var strArr:Array = str.split(delim);
			//长度不够
			if (strArr.length < cols * rows)
			{
				if (null == substitute)
				{
					return null;
				}else
				{
					strArr = strArr.concat(ArrayUtil.memset(substitute, cols * rows - strArr.length));
				}
				
			}
			
			var arr2D:Array = [];
			for (var i:int = 0; i < rows; i++)
			{
				arr2D[i] = strArr.slice(i * cols, (i + 1) * cols);
			}
			
			return arr2D;
		}
		
		static public function substitute(s:String, ...args):String 
		{
			var len:int = args.length;
			for (var i:int = 0; i < len; i++)
			{
				s = s.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
			}
			return s;
		}
		
	}
	
}