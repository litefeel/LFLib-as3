package com.litefeel.utils 
{
	
	
	/**
	 * ...
	 * @author fdsaf
	 */
	public class ArrayUtil 
	{
		
		/**
		 *  创建一个含有 len 个 c的数组
		 * @param	c
		 * @param	len
		 * @return
		 */
		static public function memset(c:Object, len:uint):Array
		{
			var arr:Array = [];
			for (var i:int = 0; i < len; i++)
			{
				arr[i] = c;
			}
			return arr;
		}
		
		/**
		 * 浅复制一个数组
		 * @param	arr		<b>	Array	</b>
		 * @return	返回数组的副本,数组本身地址改变,里面元素不变
		 */
		static public function clone(arr:Array):Array
		{
			return arr.concat();
		}
		
		/**
		 * 深复制一个数组
		 * 
		 * @param	arr		<b> Array	</b>
		 * @return	返回对象副本,数组本身地址改变,所有引用的地址也改变
		 */
		static public function deepClone(arr:Array):Array
		{
			return ObjectUtil.deepClone(arr) as Array;
		}
		
		/**
		 * 
		 * @param	arr Array or Vector
		 * @param	key
		 * @param	vlaue
		 * @return -1 not find
		 */
		static public function indexOfKey(arr:*, key:String, value:*):int 
		{
			if (!arr) return -1;
			var len:int = arr.length;
			for (var i:int = 0; i < len; i++)
			{
				if (arr[i] && arr[i][key] == value)
				{
					return i;
				}
			}
			return -1;
		}
	}
	
}