package nl.jorisdormans.phantom2D.graphics 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class ShapeManager 
	{
		private static var shapes:Dictionary = new Dictionary();
		private static var keys:Dictionary = new Dictionary();
		
		public function ShapeManager() 
		{
			throw new Error("ShapeManager should not be initialized.");
		}
		
		public static function addShape(key:String, shape:PhantomShape):void {
			if (keys[shape]) throw new Error("Shape cannot be added twice to ShapeManager.");
			if (shapes[key]) throw new Error("Key cannot be added duplicated in ShapeManager.");
			shapes[key] = shape;
			keys[shape] = key;
		}
		
		public static function getShape(key:String):PhantomShape {
			if (!shapes[key]) {
				trace("WARNING: Shape", key, "not found by ShapeManager");
			}
			return shapes[key] as PhantomShape;
		}
		
		public static function getKey(shape:PhantomShape):String {
			if (!keys[shape]) {
				trace("WARNING: Key for", shape, "not found by ShapeManager");
			}
			return keys[shape] as String;
		}
		
	}

}