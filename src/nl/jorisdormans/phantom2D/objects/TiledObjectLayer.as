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
	import nl.jorisdormans.phantom2D.core.Camera;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.shapes.BoundingLine;
	import nl.jorisdormans.phantom2D.util.DrawUtil;
	import nl.jorisdormans.phantom2D.thirdparty.profiler.Profiler;
	import nl.jorisdormans.phantom2D.thirdparty.profiler.ProfilerConfig;
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
			while (tiles.length>t) tiles[t].dispose();
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
		
		
		private static var checkOrder:Array = new Array(0, 0, 0, 1, 0, -1, -1, 0, 1, 0, -1, -1, 1, -1, -1, 1, 1, 1);
		
		override protected function checkCollisionsOfObject(index:int):void {
			var object:GameObject = objects[index];
			if (!object.initiateCollisionCheck && (!object.mover || !object.mover.initiateCollisionCheck)) return;
			var minX:int = Math.max(object.tile.tileX - 1, 0);
			var maxX:int = Math.min(object.tile.tileX + 2, tilesX);
			var minY:int = Math.max(object.tile.tileY - 1, 0);
			var maxY:int = Math.min(object.tile.tileY + 2, tilesY);
			/*
			for (var x:int = minX; x < maxX; x++) {
				for (var y:int = minY; y < maxY; y++) {
					var tile:Tile = _tiles[x + y * tilesX];
					var maxO:int = tile.objects.length;
					for (var i:int = 0; i < maxO; i++) {
						checkCollisionsBetween(object, tile.objects[i]);
					}
				}
			}
			//*/
			//*
			for (var i:int = 0; i < 18; i += 2) {
				var x:int = object.tile.tileX +checkOrder[i] as int;
				var y:int = object.tile.tileY +checkOrder[i + 1] as int;
				if (x >= minX && x < maxX && y >= minY && y < maxY) {
					var tile:Tile = tiles[x + y * tilesX];
					var maxO:int = tile.objects.length;
					for (var j:int = maxO-1; j >= 0; j--) {
						checkCollisionsBetween(object, tile.objects[j]);
					}
					
				}
			}
			//*/
		}
		
		/*override public function getObjectAt(position:Vector3D, objectClass:Class = null, ignoreTileObject:Boolean = false):GameObject 
		{
			var minX:int = Math.max(Math.floor(position.x/tileSize) - 1, 0);
			var maxX:int = Math.min(Math.floor(position.x/tileSize) + 2, tilesX);
			var minY:int = Math.max(Math.floor(position.y/tileSize) - 1, 0);
			var maxY:int = Math.min(Math.floor(position.y/tileSize) + 2, tilesY);
			for (var x:int = minX; x < maxX; x++) {
				for (var y:int = minY; y < maxY; y++) {
					var tile:Tile = _tiles[x + y * tilesX];
					var maxO:int = tile.objects.length;
					for (var i:int = 0; i < maxO; i++) {
						if ((objectClass == null || tile.objects[i] is objectClass) && !(ignoreTileObject && _objects[i].tileObject) && tile.objects[i].shape.pointInShape(position)) return tile.objects[i];
					}
				}
			}
			
			return null;
		}*/
		
		public function getTileObjectAt(x:Number, y:Number):GameObject 
		{
			var tx:int = Math.min(Math.max(Math.floor(x/tileSize), 0), tilesX-1);
			var ty:int = Math.min(Math.max(Math.floor(y/tileSize), 0), tilesY-1);
			var tile:Tile = tiles[tx + ty * tilesX];
			var maxO:int = tile.objects.length;
			for (var i:int = 0; i < maxO; i++) {
				if (tile.objects[i].type == GameObject.TYPE_TILE) return tile.objects[i];
			}
			return null;
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
					gameObject.initialize(this, p, {index:tileIndex});
					gameObject.type = GameObject.TYPE_TILE;
				}
			}
		}
		
		override public function render(camera:Camera):void 
		{
			super.render(camera);
			return;
			sprite.graphics.clear();
			var tx:int = (camera.left / tileSize) - 1;
			var ty:int = (camera.top / tileSize) - 1;
			var drawWidth:int = Math.ceil(screen.screenWidth * camera.zoom / tileSize) + 2;
			var drawHeight:int = Math.ceil(screen.screenHeight * camera.zoom / tileSize) + 2;
			
			/*
			//Code to draw tiles and blocking info
			for (var y:int = ty; y < ty + drawWidth; y++) {
				for (var x:int = tx; x < tx + drawWidth; x++) {
					var t:int = ((x+tilesX) % tilesX) + ((y+tilesY) % tilesY) * tilesX;
					var dx:Number = x * tileSize - camera.left;
					var dy:Number = y * tileSize - camera.top;
					tiles[t].drawTile(graphics, dx, dy, tileSize * camera.zoom);
				}
			}
			//*/
			
			var l:int = objects.length;
			for (var i:int = 0; i < l; i++) {
				var ox:int = objects[i].tile.tileX;
				var oy:int = objects[i].tile.tileY;
				var offsetX:Number = 0;
				var offsetY:Number = 0;
				if (renderWrappedHorizontal) {
					if (ox < tx) {
						ox += tilesX;
						offsetX = layerWidth;
					} else if (ox > tx + drawWidth) {
						ox -= tilesX;
						offsetX = -layerWidth;
					}
				}
				if (renderWrappedVertical) {
					if (oy < ty) {
						oy += tilesY;
						offsetY = layerHeight;
					} else if (oy > ty + drawWidth + 2) {
						oy -= tilesY;
						offsetY = -layerHeight;
					}
				}
				if (ox >= tx && ox < tx + drawWidth && oy >= ty && oy < ty + drawHeight) {
					objects[i].render(sprite.graphics, camera.left-offsetX, camera.top-offsetY, camera.angle, camera.zoom);
					
				}
			}
		}
		
		override public function generateNewXML():XML 
		{
			var xml:XML = super.generateNewXML();
			xml.@tileSize = tileSize;
			xml.@tilesX = tilesX;
			xml.@tilesY = tilesY;
			return xml;
		}
		
		override public function generateXML():XML 
		{
			var xml:XML = super.generateXML();
			xml.@tileSize = tileSize;
			xml.@tilesX = tilesX;
			xml.@tilesY = tilesY;
			if (tileList.length>0) {
				for (var y:int = 0; y < tilesY; y++) {
					var row:XML = <row/>;
					xml.appendChild(row);
					var s:String = "";
					for (var x:int = 0; x < tilesX; x++) {
						var tile:GameObject = tiles[x + y * tilesX].getTileObject();
						for (var i:int = 0; i < tileList.length; i++) {
							if ((tile == null && tileList[i] == null) || (tile && tileList[i] && StringUtil.getObjectClassName(tile.toString()) == StringUtil.getClassName(tileList[i].toString()))) {
								s += StringUtil.intToStringFixed(i, 2, 16)+" ";
							}
						}
						xml.row[y] = s;
					}
				}
			}
			
			return xml;
		}
		
		override public function readXML(xml:XML):void 
		{
			tileSize = xml.@tileSize;
			tilesX = xml.@tilesX;
			tilesY = xml.@tilesY;
			createTiles(tilesX, tilesY);
			
			for (var y:int = 0; y < xml.row.length(); y++) {
				var s:String = xml.row[y];
				var x:int = 0;
				while (x<tilesX) {
					var p:int = s.indexOf(" ");
					if (p < 0) break;
					var t:String = s.substr(0, p);
					s = s.substr(p + 1);
					var i:int = parseInt(t);
					if (i >= 0 && i < tileList.length && tileList[i]) {
						var go:GameObject = new tileList[i];
						go.type = GameObject.TYPE_TILE;
						var pos:Vector3D = new Vector3D();
						pos.x = (x + 0.5) * tileSize;
						pos.y = (y + 0.5) * tileSize;
						go.initialize(this, pos);
					}
					x++;
				}
			}
			
			super.readXML(xml);
		}
		
		
		
		
		
		
		
		
	}

}