package nl.jorisdormans.phantom2D.objects 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import nl.jorisdormans.phantom2D.cameras.Camera;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.shapes.BoundingLine;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	import nl.jorisdormans.phantom2D.util.StringUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class TiledObjectLayer extends ObjectLayer
	{
		/**
		 * A list of tiles in this layer
		 */
		public var tiles:Vector.<Tile>;
		/**
		 * The size of the tiles
		 */
		public var tileSize:int;
		/**
		 * The width of the grid of tiles
		 */
		public var tilesX:int;
		/**
		 * The height of the grid of tiles
		 */
		public var tilesY:int;
		/**
		 * An array that contains the game objects that can be placed in this level by the editor as tiles
		 */
		public var tileList:Array;
		/**
		 * Determines the order in which tiles get checked: first the same tile, then orthogonally adjecent tiles and diagonally adjecent tiles
		 */
		private static var checkOrder:Vector.<Number>;

		
		/**
		 * 
		 * @param	tileSize				The size of the tiles
		 * @param	tilesX					The width of the grid of tiles
		 * @param	tilesY					The height of the grid of tiles
		 * @param	physicsExecutionCount	The number times the physics of the GameObjects are updated every frame. Minimum value is 1, higher values reduce performance, but increase accuracy
		 */
		public function TiledObjectLayer(tileSize:int, tilesX:int, tilesY:int, physicsExecutionCount:int = 1) {
			super(physicsExecutionCount, 0, 0);
			tiles = new Vector.<Tile>();
			this.tileSize = tileSize;
			clear();
			createTiles(tilesX, tilesY);
			tileList = new Array();
			if (!checkOrder) {
				checkOrder = new Vector.<Number>();
				checkOrder.push(0, 0, //same tile
				                0, 1, 0, -1, -1, 0, 1, 0, //orthoganally adjecent tiles
								-1, -1, 1, -1, -1, 1, 1, 1); //diagonally adjecent tiles
			}
		}
		
		override public function clear():void {
			super.clear();
			
			//clear tiles
			var i:int = tiles.length - 1;
			while (i >= 0) {
				tiles[i].layer = null;
				tiles[i].dispose();
				i--;
			}
			tiles.splice(0, tiles.length);
		}
		
		protected function createTiles(x:int, y:int):void {
			tilesX = x;
			tilesY = y;
			layerWidth = x * tileSize;
			layerHeight = y * tileSize;
			var t:int = x * y;
			while (tiles.length < t) tiles.push(new Tile(this, tiles.length));
			while (tiles.length > t) tiles[t].dispose();
			
			for (y = 0; y < tilesY; y++) {
				for (x = 0; x < tilesX; x++) {
					t = x + y * tilesX;
					if (x > 0) tiles[t].left = tiles[t - 1];
					if (x < tilesX - 1) tiles[t].right = tiles[t + 1];
					if (y > 0) tiles[t].up = tiles[t - tilesX];
					if (y < tilesY - 1) tiles[t].down = tiles[t + tilesX];
				}
			}
			
		}
		
		/**
		 * Returns the tile at a specified position
		 * @param	position
		 * @return
		 */
		public function getTile(position:Vector3D, objectSizeOffset:Number = 0):Tile {
			var x:int = Math.max(0, Math.min(tilesX - 1, Math.floor(position.x / tileSize)));
			var y:int = Math.max(0, Math.min(tilesY - 1, Math.floor(position.y / tileSize)));
			return tiles[x + y * tilesX];
		}
		
		
		
		override protected function checkCollisionsOfObject(index:int):void {
			var object:GameObject = objects[index];
			if (!object.initiateCollisionCheck && (!object.mover || !object.mover.initiateCollisionCheck)) return;
			var minX:int = Math.max(object.tile.tileX - 1, 0);
			var maxX:int = Math.min(object.tile.tileX + 2, tilesX);
			var minY:int = Math.max(object.tile.tileY - 1, 0);
			var maxY:int = Math.min(object.tile.tileY + 2, tilesY);
			for (var i:int = 0; i < 18; i += 2) {
				var x:int = object.tile.tileX +checkOrder[i];
				var y:int = object.tile.tileY +checkOrder[i + 1];
				if (x >= minX && x < maxX && y >= minY && y < maxY) {
					var tile:Tile = tiles[x + y * tilesX];
					var maxO:int = tile.objects.length;
					for (var j:int = maxO-1; j >= 0; j--) {
						checkCollisionsBetween(object, tile.objects[j]);
					}
					
				}
			}
		}
		
		/**
		 * Creates objects in a level according to the data array and the objectList
		 * @param	data		An array of integers containing the level data
		 * @param	objectList	An array of game object classes
		 */
		
		public function createObjects(data:Array, tileList:Array = null):void {
			if (tileList) {
				this.tileList = tileList;
			}
			for (var i:int = 0; i < data.length; i++) {
				var x:int = i % tilesX;
				var y:int = i / tilesX;
				var tileIndex:int = data[i] as int;
				if (y<tilesY && tileIndex >= 0 && tileIndex < this.tileList.length && this.tileList[tileIndex]!=null) {
					var gameObject:GameObject = new this.tileList[tileIndex]() as GameObject;
					var p:Vector3D = new Vector3D(x * tileSize + tileSize * 0.5, y * tileSize + tileSize * 0.5); 
					addGameObjectSorted(gameObject, p);
				}
			}
		}
		
		
		override public function getObjectAt(position:Vector3D, objectClass:Class = null):GameObject 
		{
			var tileX:int = MathUtil.clamp(position.x / tileSize, 0, tilesX - 1);
			var tileY:int = MathUtil.clamp(position.y / tileSize, 0, tilesX - 1);
			var minX:int = Math.max(tileX - 1, 0);
			var maxX:int = Math.min(tileX + 2, tilesX);
			var minY:int = Math.max(tileY - 1, 0);
			var maxY:int = Math.min(tileY + 2, tilesY);
			for (var x:int = minX; x < maxX; x++) {
				for (var y:int = minY; y < maxY; y++) {
					var tile:Tile = tiles[x + y * tilesX];
					var maxO:int = tile.objects.length;
					for (var j:int = maxO - 1; j >= 0; j--) {
						if ((objectClass == null || tile.objects[j] is objectClass) && tile.objects[j].shape && tile.objects[j].shape.pointInShape(position)) return tile.objects[j];
					}
				}
			}
			return null;
		}
	}

}