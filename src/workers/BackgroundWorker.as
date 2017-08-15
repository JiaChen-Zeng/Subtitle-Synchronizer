package workers
{
	import moe.aoi.utils.FileReferenceUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.registerClassAlias;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	import models.FileModel;
	
	public class BackgroundWorker extends Sprite
	{
		public static const READY:String = 'ready';
		public static const SYNCHRONIZE_SUBTITLES:String = 'synchronize subtitles';
		public static const PROGRESS:String = 'progress';
		public static const COMPLETE:String = 'complete';
		public static const ERROR:String = 'error';
		
		private var mainToBackgroundChannel:MessageChannel;
		private var backgroundToMainChannel:MessageChannel;
		
		public function BackgroundWorker()
		{
			registerClassAlias('flex.messaging.io.ArrayList', ArrayList);
			registerClassAlias('models.FileModel', FileModel);
			
			backgroundToMainChannel = Worker.current.getSharedProperty('backgroundToMainChannel');
			mainToBackgroundChannel = Worker.current.getSharedProperty('mainToBackgroundChannel');
			
			mainToBackgroundChannel.addEventListener(Event.CHANNEL_MESSAGE, mainToBackgroundChannel_channelMessageHandler);
			
			backgroundToMainChannel.send(BackgroundWorker.READY);
		}
		
		protected function mainToBackgroundChannel_channelMessageHandler(event:Event):void
		{
			if (mainToBackgroundChannel.messageAvailable)
			{
				var head:String = mainToBackgroundChannel.receive();
				
				if (head === BackgroundWorker.SYNCHRONIZE_SUBTITLES)
				{
					//要等到全部接收完毕之后再同步字幕，必须 block！
					var dataProvider1:IList = mainToBackgroundChannel.receive(true);
					var dataProvider2:IList = mainToBackgroundChannel.receive(true);
					var explicitOutputDirectory:String = mainToBackgroundChannel.receive(true);
					var explicitVideoDirectory:String = mainToBackgroundChannel.receive(true);
					
//					try
//					{
						synchronizeSubtitles(dataProvider1, dataProvider2, explicitOutputDirectory, explicitVideoDirectory);
//					} 
//					catch(error:Error) 
//					{
//						backgroundToMainChannel.send(BackgroundWorker.ERROR);
//					}
				}
			}
		}
		
		public function synchronizeSubtitles(dataProvider1:IList, dataProvider2:IList, explicitOutputDirectory:String, explicitVideoDirectory:String):void
		{
			//把字幕文件移动到字幕输出文件夹内并改名
			//进度为0时
			backgroundToMainChannel.send(BackgroundWorker.PROGRESS);
			backgroundToMainChannel.send(0);
			var minLength:int = Math.min(dataProvider1.length, dataProvider2.length);
			backgroundToMainChannel.send(minLength);
			
			for (var i:int = 0; i < minLength; i++) 
			{
				//获取 FileModel
				var videoFileModel:FileModel = dataProvider1.getItemAt(i) as FileModel;
				var subtitleFileModel:FileModel = dataProvider2.getItemAt(i) as FileModel;
				
				//生成要拷贝到的 url
				var outputDirectory:File = new File(explicitOutputDirectory);
				var videoFile:File = new File(videoFileModel.url);
				
				var fileName:String = FileReferenceUtil.getBaseName(videoFile);
				var newFile:File;
				if (explicitVideoDirectory) //如果有指定视频文件夹，输出的时候会字幕输出到相应子文件夹中
				{
					var videoDirectory:File = new File(explicitVideoDirectory);
					
					var splitRelativePath:Array = videoDirectory.getRelativePath(videoFile).split('/');
					splitRelativePath.pop();
					var relativePath:String = splitRelativePath.join('/');
					
					newFile = outputDirectory.resolvePath(
						relativePath ? (relativePath + '/') : '' + fileName + '.' + subtitleFileModel.extension);//加字幕后缀名
				}
				else
				{
					newFile = outputDirectory.resolvePath(fileName + '.' + subtitleFileModel.extension);//加字幕后缀名
				}
				
				//拷贝了
				var file:File;
				file = new File(subtitleFileModel.url);
				file.copyTo(newFile, true);
				
				backgroundToMainChannel.send(BackgroundWorker.PROGRESS);
				backgroundToMainChannel.send(i + 1);
				backgroundToMainChannel.send(minLength);
			}
			
			backgroundToMainChannel.send(BackgroundWorker.COMPLETE);
		}
	}
}