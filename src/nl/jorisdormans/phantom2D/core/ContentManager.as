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
		private var objectRecipes:Dictionary
		private var levels:Dictionary;
		private var shapes:Dictionary;
		private var shapeKeys:Dictionary;		
		
		public function ContentManager() 
		{
			if (instance) throw new Error( "ContentManager can only be accessed through ContentManager.getInstance()" ); 
			objectRecipes = new Dictionary();
			levels = new Dictionary();
			shapes = new Dictionary();
			shapeKeys = new Dictionary();
		}
		
		public static function getInstance():ContentManager {
			if (!instance) {
				instance = new ContentManager();
			}
			return instance;
		}
		
		public function addObjectRecipes(xml:XML):void {
			for (var i:int = 0; i < xml.GameObject.length(); i++) {
				if (xml.GameObject[i].@id.length() > 0) {
					var id:String = xml.GameObject[i].@id
					var go:XML = xml.GameObject[i];
					objectRecipes[id] = go;
				}
			}
		}
		
		public function addLevels(xml:XML):void {
			for (var i:int = 0; i < xml.level.length(); i++) {
				if (xml.level[i].@id.length() > 0) {
					var id:String = xml.level[i].@id
					var l:XML = xml.level[i];
					levels[id] = l;
				}
			}
			
		}
		
		public function getObjectRecipe(id:String):XML {
			return objectRecipes[id] as XML;
		}
		
		public function getLevel(id:String):XML {
			return levels[id] as XML;
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