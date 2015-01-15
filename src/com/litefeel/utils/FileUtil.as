package com.litefeel.utils 
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	/**
	 * 文件
	 * @author lite3
	 */
	public class FileUtil 
	{
		/**
		 * 复制目录
		 * @param	sourceDir 源目录
		 * @param	destDir 目标目录
		 * @param	overrideExistFiles (default = false) — 如果为 false，则跳过目标目录中已存在的同名文件。
		 * 												如果为 true，则覆盖目标目录中已存在的同名文件。
		 * @param	deleteFilesNotInSource (default = false) — 如果为 false，则保留目标目录中不在源目录中文件和目录。
		 * 													如果为 true，则删除目标目录中不在源目录中文件和目录。
		 */
		public static function copyDir(sourceDir:File, destDir:File, overrideExistFiles:Boolean = false, deleteFilesNotInSource:Boolean = false):void
		{
			if(!sourceDir.exists || !sourceDir.isDirectory) return;
			if(destDir.exists && sourceDir.url == destDir.url) return;
			
			if(overrideExistFiles && deleteFilesNotInSource)
			{
				sourceDir.copyTo(destDir, true);
				return;
			}
			
			if(overrideExistFiles && destDir.exists && !destDir.isDirectory)
			{
				destDir.deleteFile();
			}
			if(!destDir.exists) destDir.createDirectory();
			
			const destMap:Object = { };
			if(deleteFilesNotInSource)
			{
				for each(var file:File in destDir.getDirectoryListing())
				{
					destMap[file.name] = file;
				}
			}
			
			for each(file in sourceDir.getDirectoryListing())
			{
				destMap[file.name] &&= null;
				var newFile:File = destDir.resolvePath(file.name);
				// 复制目录
				if(file.isDirectory)
				{
					copyDir(file, newFile, overrideExistFiles, deleteFilesNotInSource);
				}
				// 复制文件
				else if(overrideExistFiles || !newFile.exists)
				{
					file.copyTo(newFile, true);
				}
			}
			
			if(deleteFilesNotInSource)
			{
				for each(file in destMap)
				{
					if(!file) continue;
					if(file.isDirectory) file.deleteDirectory(true);
					else file.deleteFile();
				}
			}
		}
		
		/**
		 * 遍历目录中的所有文件
		 * @param	func function(curFile, rootDir);
		 * @param	dir 要遍历的目录
		 * @param	ignoreList 
		 */
		public static function mapDir(func:Function, dir:File, ignoreList:Array = null):void
		{
			if (!dir.exists || !dir.isDirectory) return;
			
			_mapDir(func, dir, dir, ignoreList);
		}
		
		private static function _mapDir(func:Function, file:File, root:File, ignoreList:Array):void
		{
			if (ignoreList != null)
			{
				var resolvePath:String = root.getRelativePath(file);
				if (ignoreList.indexOf(resolvePath) >= 0)
				{
					return;
				}
			}
			if (file.isDirectory)
			{
				var list:Array = file.getDirectoryListing();
				for each(var f:File in list)
				{
					_mapDir(func, f, root, ignoreList);
				}
			}else
			{
				func(file, root);
			}
		}
		
		
		public static function readString(path:String, charset:String = "utf-8"):String
		{
			var file:File = new File(path);
			if (!file.exists) return null;
			
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var data:String = stream.readMultiByte(stream.bytesAvailable, charset);
			// check bom
			if (charset == "utf-8" && data.charCodeAt(0) == 0xFEFF)
			{
				data = data.substr(1);
			}
			stream.close();
			return data;
		}
		
		public static function writeString(data:String, path:String, charset:String = "utf-8"):void
		{
			var file:File = new File(path);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeMultiByte(data, charset);
			stream.close();
		}
		
		public static function getFileName(path:String):String
		{
			var arr:Array = path.split("/");
			return arr[arr.length - 1];
		}
	}

}