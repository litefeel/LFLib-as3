package com.litefeel.utils 
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class DisplayObjectUtil
	{
		
		public static var GRAY_MATRIX:Array = [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0];
		
		/**
		 * 设置显示对象是否可用, 不可用变灰
		 * 限制: ColorMatrixFilter 滤镜 将被取消
		 * @param	display
		 * @param	enabled
		 */
		public static function setEnabled(display:DisplayObject, enabled:Boolean):void
		{
			if(display is InteractiveObject)
			{
				display["mouseEnabled"] = enabled;
			}
			if (display.hasOwnProperty("enabled"))
			{
				display["enabled"] = enabled;
			}
			
			var arr:Array = display.filters;
			if (!arr) arr = [];
			var len:Number = arr.length;
			
			// 去掉之前的 ColorMatrixFilter 滤镜
			for (var i:Number = 0; i < len; i++)
			{
				if (arr[i] is ColorMatrixFilter)
				{
					arr.splice(i, 1);
					i--;
				}
			}
			
			// 设置不可用
			if (!enabled)
			{
				arr.push(new ColorMatrixFilter(GRAY_MATRIX));
			}
			
			display.filters = arr;
		}
		
		/**
		 * 清除一个滤镜
		 * @param	filteClass
		 */
		public static function clearFilter(dispaly:DisplayObject, filterClass:Class):void
		{
			var list:Array = dispaly.filters;
			if (!list || 0 == list.length) return;
			
			for (var i:Number = list.length - 1; i >= 0; i--)
			{
				if (list[i] is filterClass)
				{
					list.splice(i, 1);
				}
			}
			dispaly.filters = list;
		}
		
		/**
		 * 返回一个矩形，该矩形定义相对于 targetCoordinateSpace 对象坐标系的显示对象区域
		 * @param	mc
		 * @param	targetCoordinateSpace	目标坐标系的影片剪辑
		 * @return
		 */
		/*public static function getViewBounds(mc:MovieClip, targetCoordinateSpace:MovieClip):Rectangle
		{
			if (!mc || ! targetCoordinateSpace) return null;
			
			var bounds:Object = mc.getBounds(targetCoordinateSpace);
			var w:Number = bounds.xMax - bounds.xMin;
			var h:Number = bounds.yMax - bounds.yMin;
			
			var bitmap:BitmapData = new BitmapData(w, h, true, 0x0);
			var matrix:Matrix = mc.transform.matrix;
			matrix.tx = -bounds.xMin;
			matrix.ty = -bounds.yMin;
			bitmap.draw(mc, matrix);
			bitmap.threshold(bitmap, bitmap.rectangle, new Point(0, 0), ">", 0xFF000000, 0xFF000000, 0xFFFFFFFF, false);
			var viewRect:Rectangle = bitmap.getColorBoundsRect(0xFFFFFFFF, 0xFF000000, true);
			viewRect.x += bounds.xMin;
			viewRect.y += bounds.yMin;
			bitmap.dispose();
			return viewRect;
		}*/
		
		/**
		 * 复制一个显示对象
		 * 
		 * 局限性 :	1. 仅重建了一个显示对象, 内部的没有新建
		 * 			2. 用绘图 API 画的不能显示
		 * 
		 * @param	display
		 * @return
		 */
		/*static public function duplicate(display:DisplayObject):DisplayObject
		{
			var classDefinition:Class = Object(display).constructor as Class;
			
			var newDisplay:DisplayObject = new classDefinition() as DisplayObject;
			
			newDisplay.transform = display.transform;
			newDisplay.filters = display.filters;
			newDisplay.cacheAsBitmap = display.cacheAsBitmap;
			newDisplay.opaqueBackground = display.opaqueBackground;
			
			if (display.scale9Grid)
			{
				var scale9Grid:Rectangle = display.scale9Grid;
				trace(scale9Grid)
				scale9Grid.x /= 20;
				scale9Grid.y /= 20;
				scale9Grid.width /= 20;
				scale9Grid.height /= 20;
				//newDisplay.scale9Grid = scale9Grid;
			}
			
			return newDisplay;
		}*/
		
	}
	
}