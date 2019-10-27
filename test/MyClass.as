package 
{
	/**
	 * ...
	 * @author litefeel
	 */
	public class MyClass 
	{
		public var b:int = 6;
		private var c:int = 7;
		public var nst:NestClass = new NestClass();
		public var e:Number = 8;
		public var f:uint = 9;
		public var g:* = new NestClass;
		public var j:* = 5;
		public var i:Object = new NestClass;
		public var h:Array = [1, 3, 5];
		public function MyClass() 
		{
			
		}
		
		public  function set aaa(a:int):void{}
		public function get aaa():int 
		{
			return 5;
		}
		
	}
	
	

}

class NestClass
	{
		public var obj:Object = new Object();
	}