package nl.jorisdormans.phantom2D.objects
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	/**
	 * A Tile keeps track of objects that are at a particular location
	 * @author Joris Dormans
	 */
	public class Tile
	{
		/**
		 * The objects at the location
		 */
		public var objects:Vector.<GameObject>;
		/**
		 * A reference to the TiledObjectLayer
		 */
		public var layer:TiledObjectLayer;
		/**
		 * The index of the tile in the TiledObjectLayer
		 */
		public var index:int;
		/**
		 * The tile's X position in the grid of the TiledObjectLayer
		 */
		public var tileX:int;
		/**
		 * The tile's Y position in the grid of the TiledObjectLayer
		 */
		public var tileY:int;
		
		/**
		 * The tile's neighbor to the left (if any).
		 */
		public var left:Tile;
		/**
		 * The tile's neighbor to the right (if any).
		 */
		public var right:Tile;
		/**
		 * The tile's neighbor above (if any).
		 */
		public var up:Tile;
		/**
		 * The tile's neighbor below (if any).
		 */
		public var down:Tile;
		
		
		/**
		 * Creates an instance of the Tile class
		 * @param	layer	A reference to the TiledObjectLayer
		 * @param	index	The index of the tile in the TiledObjectLayer
		 */
		public function Tile(layer:TiledObjectLayer, index:int) 
		{
			this.layer = layer;
			this.index = index;
			tileX = index % layer.tilesX;
			tileY = Math.floor(index / layer.tilesX);
			objects = new Vector.<GameObject>();
		}
		
		/**
		 * Removes the tile and the list of objects it tracks. It does not dispose the objects themselves.
		 */
		public function dispose():void {
			var i:int = objects.length - 1;
			while (i >= 0) {
				objects[i].tile = null;
				i--;
			}
			layer = null;
			index = -1;
		}
		
		/**
		 * Add a GameObject to the list of objects on the tile
		 * @param	gameObject
		 */
		public function addGameObject(gameObject:GameObject):void {
			gameObject.tile = this;
			objects.push(gameObject);
		}
		
		/**
		 * Removes a GameObject from the list of objects on the tile
		 * @param	gameObject
		 */
		public function removeGameObject(gameObject:GameObject):void {
			var i:int = objects.length-1;
			while (i >= 0) {
				if (objects[i] == gameObject) {
					gameObject.tile = null;
					objects.splice(i, 1);
					return;
				} else {
					i--;
				}
			}
		}	
	}

}