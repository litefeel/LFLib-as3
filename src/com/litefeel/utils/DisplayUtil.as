package com.litefeel.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * 显示扩展
	 * @author lite3
	 */
	public class DisplayUtil 
	{
		private static var bitmap:Bitmap;
		private static var bitmapData:BitmapData;
		
		/**
		 * 强制刷新渲染
		 */
		public static function renderForce():void
		{
			if (!bitmap)
			{
				bitmap = new Bitmap();
				bitmapData = new BitmapData(bitmap.width, bitmap.height);
			}
			bitmapData.draw(bitmap);
		}
		
		/**
		 * 获取可视尺寸，类似于DisplayObject.getBounds()。
		 * 如果target或其包含的显示对象使用了遮罩，请用getViewBoundsForMasker方法。
		 * @param	target
		 * @param	targetCoordinateSpace target所在的容器, null表示target自身。
		 * @return	Rectange
		 * @see	getViewBoundsForMasker()
		 */
		public static function getViewBounds(target:DisplayObject,
									coordinateSpace:DisplayObjectContainer):Rectangle 
		{
			renderForce();
			return target.getBounds(coordinateSpace);
		}
		
		/**
		 * 获取可视尺寸，类似于DisplayObject.getBounds()。
		 * 如果target及其内容没有遮罩，请使用getViewBounds()，效率更高
		 * @param	target
		 * @param	targetCoordinateSpace target所在的容器, null表示target自身。
		 * @return	Rectange
		 * @see	getViewBounds()
		 */
		public static function getViewBoundsForMasker(target:DisplayObject,
									coordinateSpace:DisplayObjectContainer):Rectangle
		{
			var bound:Rectangle = target.getBounds(null);
			var bitmapdata:BitmapData = new BitmapData(bound.width, bound.height, true, 0);
			bitmapdata.draw(target, new Matrix(1, 0, 0, 1, -bound.x, -bound.y));
			var rect:Rectangle = bitmapdata.getColorBoundsRect(0xFF000000, 0x0, false);
			bitmapdata.dispose();
			rect.x += bound.x;
			rect.y += bound.y;
			if (!coordinateSpace || target == coordinateSpace)
			{
				return rect;
			}
			
			var matrix:Matrix = target.transform.concatenatedMatrix.clone();
			var matrix2:Matrix = coordinateSpace.transform.concatenatedMatrix.clone();
			matrix2.invert();
			matrix.concat(matrix2);
			var topLeft:Point = matrix.transformPoint(rect.topLeft);
			var bottomRight:Point = matrix.transformPoint(rect.bottomRight);
			rect.topLeft = topLeft;
			rect.bottomRight = bottomRight;
			return rect;
		}
		
	}

}