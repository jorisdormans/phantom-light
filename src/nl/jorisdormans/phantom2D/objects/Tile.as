package nl.jorisdormans.phantom2D.objects
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.util.TextDraw;
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
		
		public var aStarDistance:Number = 0;
		public var aStarList:int = 0;
		public var aStarPrevious:int = 0;
		
		private var tileObject:GameObject;
		
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
			if (gameObject.type == GameObject.TYPE_TILE) {
				if (tileObject) {
					tileObject.type = GameObject.TYPE_NORMAL;
				}
				tileObject = gameObject;
			}
		}
		
		/**
		 * Removes a GameObject from the list of objects on the tile
		 * @param	gameObject
		 */
		public function removeGameObject(gameObject:GameObject):void {
			if (gameObject == tileObject) {
				tileObject = null;
			}
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
		
		public function getTileObject():GameObject {
			return (tileObject);
		}
		
		public function drawTile(graphics:Graphics, x:Number, y:Number, size:Number, forObject:GameObject = null):void {
			var c:uint;
			if ((tileX + tileY) % 2 == 1) {
				c = 0x007000;
			} else {
				c = 0x006600;
			}
			graphics.beginFill(c);
			graphics.drawRect(x, y, size, size);
			graphics.endFill();
			
			if (aStarList > 0) {
				TextDraw.drawTextCentered(graphics, x+size*0.5, y+size*0.5, size, size, Math.round(aStarDistance*10).toString(), 0xffffff, 12);
			}
		}
		
	}

}