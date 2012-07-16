package nl.jorisdormans.phantom2D.objects
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
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
		 * Optional informational flags, used for gameplay (ex. fog of war)
		 */
		public var flags:uint;
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
		
		/**
		 * Read only property to get the center x position of the tile in its layer.
		 */
		public function get positionX():Number {
			return (tileX + 0.5) * layer.tileSize;
		}
		
		/**
		 * Read only property to get the center y position of the tile in its layer.
		 */
		public function get positionY():Number {
			return (tileY + 0.5) * layer.tileSize;
		}
		
		/**
		 * Function to get the center position as a new vector3d of the tile in its layer.
		 */
		public function getPosition():Vector3D {
			return new Vector3D((tileX + 0.5) * layer.tileSize, (tileY + 0.5) * layer.tileSize);
		}

		
	}

}