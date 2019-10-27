package com.litefeel.utils
{
	import com.litefeel.utils.StringUtil;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	/**
	 * UInt64 64位无符号整形
	 * @author lite3
	 */
	public final class UInt64 
	{
		public var high:uint;
		public var low:uint;
		
		public function UInt64(high:uint = 0, low:uint = 0) 
		{
			this.high = high;
			this.low = low;
		}
		public function isEmpty():Boolean
		{
			return 0 == high && 0 == low;
		}
		
		public function isEqual(v:UInt64):Boolean
		{
			return v ? (v.high == high && v.low == low) : false;
		}
		
		public function isEqualHL(high:uint, low:uint):Boolean
		{
			return this.high == high && this.low == low;
		}
		
		public function readFrom(data:IDataInput):void
		{
			high = data.readUnsignedInt();
			low  = data.readUnsignedInt();
		}
		
		public function writeTo(data:IDataOutput):void
		{
			data.writeUnsignedInt(high);
			data.writeUnsignedInt(low);
		}
		
		public function toString():String
		{
			return toNumber() + "";
		}
		
		public function toHex():String
		{
			var s:String = low.toString(16);
			if (high > 0)
			{
				if (s.length < 8)
					s = StringUtil.memset("0", 8 - s.length) + s;
				s = high.toString(16) +s;
			}
			return s;
		}
		
		/**
		 * 返回相对应的Number值,注意有精度达不到UInt64的精度,只保证Number的15位精度
		 * @return
		 */
		public function toNumber():Number
		{
			var masker:uint = uint(1 << 31);
			var result:Number = high * masker * 2;
			result += low;
			return result;
		}
	}

}