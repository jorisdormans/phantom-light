package nl.jorisdormans.phantom2D.util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	/*
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	//*/
	
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class FileIO 
	{
		
		public var fileName:String = "";
		public var data:XML;
		public var textData:String;
		public var onLoadComplete:Function = null;
		public var onSaveComplete:Function = null;
		private var _loader:URLLoader;
		public var file:FileReference = new FileReference();
		
		public function FileIO() 
		{
			
		}
		
		public function openFileDialog(caption:String, filter:String = "xml files: (*.xml)|*.xml"):void {
			file.addEventListener(Event.SELECT, fileSelectedLoad);
			trace("START SELECT");
			var fileFilter:FileFilter;
			var p:int = filter.indexOf("|");
			if (p >= 0) {
				fileFilter = new FileFilter(filter.substr(0, p), filter.substr(p + 1));
				file.browse([fileFilter]);
			} else {
				file.browse();
			}
			
		}
		
		private function fileSelectedLoad(e:Event = null):void {
			trace("SELECTED");
			file.removeEventListener(Event.SELECT, fileSelectedLoad);
			fileName = file.name;
			openFile2();
		}		
		
		public function saveFileDialog(caption:String):void {
			saveFile("");
		}
		
		private function openFile2():void {
			this.fileName = fileName;
			trace("LOADING", file.name, onLoadComplete);
			file.addEventListener(IOErrorEvent.IO_ERROR, onFileError);
			file.addEventListener(Event.COMPLETE, loadFileComplete);
			file.load();
		}
		
		private function onFileError(e:IOErrorEvent):void 
		{
			trace("ERROR LOADING FILE");
			trace(e.text);
			file.removeEventListener(IOErrorEvent.IO_ERROR, onFileError);
			file.removeEventListener(Event.COMPLETE, loadFileComplete);
		}
		
		private function loadFileComplete(e:Event):void 
		{
			trace("LOAD COMPLETE", onLoadComplete);
			file.removeEventListener(IOErrorEvent.IO_ERROR, onFileError);
			file.removeEventListener(Event.COMPLETE, loadFileComplete);
			//trace(file.data);
			data = XML(file.data);
			//trace(data.toXMLString());
			if (onLoadComplete!=null) onLoadComplete();
		}			
		
		
		public function openFile(fileName:String):void {
			this.fileName = fileName;
			trace("LOADING FILE", fileName, onLoadComplete);
			var url:URLRequest = new URLRequest( fileName );
			url.contentType = "text/xml";
			_loader = new URLLoader();
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.addEventListener(Event.COMPLETE, loadComplete);
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			_loader.load(url);
		}
		
		
		private function onError(e:IOErrorEvent):void 
		{
			trace("OH OH");
			trace(e.text);
		}			
		
		private function loadComplete(e:Event):void 
		{
			trace("LOAD COMPLETE", onLoadComplete);
			data = XML(_loader.data);
			if (onLoadComplete!=null) onLoadComplete();
		}		
		
		
		public function saveFile(fileName:String):void {
			this.fileName = fileName;
		
			if (file == null) file = new FileReference();
			if (data != null) file.save(data, fileName);
			else if (textData != null) file.save(textData, fileName);
			else {
				throw new Error("No data specified");
			}
			file.addEventListener(Event.COMPLETE, saveComplete);
		}
		
		private function saveComplete(e:Event):void 
		{
			fileName = file.name;
			file.removeEventListener(Event.COMPLETE, saveComplete);
			trace("FILE SAVED");
			if (onSaveComplete != null) onSaveComplete();
			textData = null;
			data = null;
		}
		
		/*
		private var file:File;
		
		public function openFileDialog(caption:String):void {
			if (file == null) file = new File();
			file.addEventListener(Event.SELECT, fileSelectedForOpen);
			file.browseForOpen(caption);
		}
		
		private function fileSelectedForOpen(e:Event=null):void {
			file.removeEventListener(Event.SELECT, fileSelectedForOpen);
			openFile(file.nativePath);
		}
		
		public function openFile(fileName:String):void {
			this.fileName = fileName;
			
			if (fileName.indexOf(":")>=0) file = new File(fileName);
			else file = new File(File.applicationDirectory.nativePath+"\\"+fileName);
		
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			data = stream.readUTFBytes(stream.bytesAvailable);
			
			trace("FILE LOADED:", fileName);
			if (onLoadComplete != null) onLoadComplete();
		}
		
		public function saveFileDialog(caption:String):void {
			file = new File(File.applicationDirectory.nativePath + "\\" + fileName);
			file.addEventListener(Event.SELECT, fileSelectedForSave);
			file.browseForSave(caption);
		}
		
		public function fileSelectedForSave(e:Event=null):void {
			file.removeEventListener(Event.SELECT, fileSelectedForSave);
			saveFile(file.nativePath);
		}
		
		public function saveFile(fileName:String):void {
			this.fileName = fileName;
			trace(fileName);
			if (fileName.indexOf(":")) file = new File(fileName);
			else file = new File(File.applicationDirectory.nativePath + "\\" + fileName);
			
			var stream:FileStream = new FileStream()
			stream.open(file, FileMode.WRITE);
			var str:String  = data.replace(/\r/g, File.lineEnding);
			stream.writeUTFBytes(str);
			stream.close();
			trace("FILE SAVED");
			if (onSaveComplete != null) onSaveComplete();
			
		}
		
		//*/		
		
	}
	
}