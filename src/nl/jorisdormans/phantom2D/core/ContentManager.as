package nl.jorisdormans.phantom2D.core 
{
	import flash.utils.Dictionary;
	import nl.jorisdormans.phantom2D.graphics.PhantomShape;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class ContentManager 
	{
		private static var instance:ContentManager;
		public var objects:Dictionary
		public var tiles:Dictionary
		public var tileKeys:Vector.<String>
		public var levels:Dictionary;
		public var shapes:Dictionary;
		public var shapeKeys:Dictionary;	
		
		
		public function ContentManager() 
		{
			if (instance) throw new Error( "ContentManager can only be accessed through ContentManager.getInstance()" ); 
			objects = new Dictionary();
			tiles = new Dictionary();
			levels = new Dictionary();
			shapes = new Dictionary();
			shapeKeys = new Dictionary();
			tileKeys = new Vector.<String>();
		}
		
		public static function getInstance():ContentManager {
			if (!instance) {
				instance = new ContentManager();
			}
			return instance;
		}
		
		public function addObjects(xml:XML):void {
			for (var i:int = 0; i < xml.GameObject.length(); i++) {
				if (xml.GameObject[i].@key.length() > 0) {
					var key:String = xml.GameObject[i].@key
					var go:XML = xml.GameObject[i];
					objects[key] = go;
				}
			}
			PhantomGame.log(xml.GameObject.length() + " object(s) added to ContentManager");
		}
		
		public function getObject(key:String):XML {
			return objects[key] as XML;
		}
		
		public function addTiles(xml:XML):void {
			for (var i:int = 0; i < xml.GameObject.length(); i++) {
				if (xml.GameObject[i].@key.length() > 0) {
					var key:String = xml.GameObject[i].@key
					var go:XML = xml.GameObject[i];
					if (!tiles[key]) {
						tileKeys.push(key);
					}
					tiles[key] = go;
				}
			}
			PhantomGame.log(xml.GameObject.length() + " tile(s) added to ContentManager");
		}
		
		public function getTile(key:String):XML {
			return tiles[key] as XML;
		}
		
		public function addLevels(xml:XML):void {
			for (var i:int = 0; i < xml.level.length(); i++) {
				if (xml.level[i].@key.length() > 0) {
					var key:String = xml.level[i].@key;
					var l:XML = xml.level[i];
					levels[key] = l;
				}
			}
			PhantomGame.log(xml.level.length() + " level(s) added to ContentManager");
			
		}
		
		public function getLevel(key:String):XML {
			return levels[key] as XML;
		}
		
		public function addShape(key:String, shape:PhantomShape):void {
			if (shapeKeys[shape]) throw new Error("Shape cannot be added twice to ContentManager.");
			if (shapes[key]) throw new Error("Key for Shape cannot be added duplicated in ContentManager.");
			shapes[key] = shape;
			shapeKeys[shape] = key;

		}
		
		public function getShape(key:String):PhantomShape {
			if (!shapes[key]) {
				trace("WARNING: Shape", key, "not found by ShapeManager");
			}
			return shapes[key] as PhantomShape;
		}
		
		public function getShapeKey(shape:PhantomShape):String {
			if (!shapeKeys[shape]) {
				trace("WARNING: Key for", shape, "not found by ShapeManager");
			}
			return shapeKeys[shape] as String;
		}

		
		
	}

}