package nl.jorisdormans.phantom2D.objects 
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.cameras.Camera;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.core.Layer;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.shapes.BoundingLine;
	import nl.jorisdormans.phantom2D.util.StringUtil;
	/**
	 * A ScreenComponent to handle GameObjects. For improved collision detection, use the TiledObjectLayer component
	 * @author Joris Dormans
	 */
	public class ObjectLayer extends Layer implements IInputHandler
	{
		/**
		 * The list of GameObjects inside this layer
		 */
		public var objects:Vector.<GameObject>;
		/**
		 * The number times the physics of the GameObjects are updated every frame. Minimum value is 1, higher values reduce performance, but increase accuracy
		 */
		protected var physicsExecutionCount:int;
		
		/**
		 * An array that contains the game objects that can be placed in this level by the editor
		 */
		public var objectList:Array;
		
		/**
		 * Creates an instance of the ObjectLayer class.
		 * @param	physicsExecutionCount	The number times the physics of the GameObjects are updated every frame. Minimum value is 1, higher values reduce performance, but increase accuracy
		 */
		public function ObjectLayer(physicsExecutionCount:int = 1, width:Number=0, height:Number=0) 
		{
			super (width, height);
			objects = new Vector.<GameObject>();
			this.physicsExecutionCount = Math.max(physicsExecutionCount, 4);
			objectList = new Array();
		}
		
		
		/**
		 * Removes all objects
		 */
		override public function clear():void {
			//clear objects
			var i:int;
			i = objects.length - 1;
			while (i >= 0) {
				objects[i].tile = null;
				objects[i].objectLayer = null;
				objects[i].dispose();
				i--;
			}
			objects.splice(0, objects.length);		
		}
		
		/**
		 * Add a gameObject to this layer
		 * @param	gameObject
		 */
		public function addGameObject(gameObject:GameObject):void {
			gameObject.removed = false;
			
			if (gameObject.objectLayer != null) {
				gameObject.objectLayer.removeGameObject(gameObject);
			}
			gameObject.objectLayer = this;
			objects.push(gameObject);
		}
		
		/**
		 * Add a game object to a particular position in the object list
		 * @param	gameObject
		 * @param	position
		 */
		public function addGameObjectAt(gameObject:GameObject, position:int):void {
			gameObject.removed = false;
			
			if (gameObject.objectLayer != null) {
				gameObject.objectLayer.removeGameObject(gameObject);
			}
			gameObject.objectLayer = this;
			objects.splice(position, 0, gameObject);
		}
		
		/**
		 * Inserts a gameObject at a location in the list based on the GameObject.sortOrder value.
		 * This function should only be called if the list of objects is realy sorted
		 * @param	gameObject
		 */
		public function addGameObjectSorted(gameObject:GameObject):void {
			gameObject.removed = false;
			if (gameObject.objectLayer != null) {
				gameObject.objectLayer.removeGameObject(gameObject);
			}
			gameObject.objectLayer = this;
			var l:int = objects.length;
			for (var i:int = l-1; i >= 0; i--) {
				if (compareObjects(objects[i], gameObject) < 0 ) {
					objects.splice(i+1, 0, gameObject);
					return;
				}
			}
			//add to begin
			objects.splice(0, 0, gameObject);
		}

		/**
		 * Remove a GameObject instance from the list of objects
		 * @param	gameObject
		 */
		public function removeGameObject(gameObject:GameObject):void {
			var i:int = objects.length-1;
			while (i >= 0) {
				if (objects[i] == gameObject) {
					if (gameObject.tile != null) gameObject.tile.removeGameObject(gameObject);
					gameObject.objectLayer = null;
					objects.splice(i, 1);
				}
				i--;
			}
		}		
		
		override public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void {
			if (allowInteraction) {
				super.handleInput(elapsedTime, currentState, previousState); 
				var l:int = objects.length;
				for (var i:int = 0; i < l; i++) {
					if (objects[i].inputHandlers > 0) {
						objects[i].handleInput(elapsedTime, currentState, previousState);
					}
				}
			}
		}
		
		override public function render(camera:Camera):void {
			sprite.graphics.clear();
			var i:int = 0;
			var l:int = objects.length;
			while (i < l) {
				var rx:Number = objects[i].position.x - camera.left;
				var ry:Number = objects[i].position.y - camera.top;
				
				if (renderWrappedHorizontal) {
					var dx:Number = objects[i].position.x - camera.position.x;
					var d:Number = layerWidth * 0.5;
					if (dx < -d) rx += layerWidth;
					if (dx >= d) rx -= layerWidth;
				}
				
				if (renderWrappedVertical) {
					var dy:Number = objects[i].position.y - camera.position.y;
					d = layerHeight * 0.5;
					if (dy < -d) ry += layerHeight;
					if (dy >= d) ry -= layerHeight;
				}
				
				if (objects[i].isVisible(rx, ry, camera.zoom)) {
					objects[i].render(sprite.graphics, rx, ry, camera.angle, camera.zoom);
				}
				
				i++;
			}
		}	
		
		override public function update(elapsedTime:Number):void {
			var l:int = objects.length;
			for (var i:int = l-1; i >= 0 ; i--) {
				objects[i].update(elapsedTime);
			}
			super.update(elapsedTime);
		}
		
		override public function updatePhysics(elapsedTime:Number):void {
			var i:int = 0;
			var l:int = objects.length;
			elapsedTime /= physicsExecutionCount;
			for (var t:int = 0; t < physicsExecutionCount; t++) {
				i = 0;
				while (i < l) {
					//check if the object is destroyed. If so remove it
					if (objects[i].removed) {
						if (objects[i].tile != null) objects[i].tile.removeGameObject(objects[i]);
						objects[i].objectLayer = null;
						objects[i].removed = false;
						objects.splice(i, 1);
						l--;
					} else if (objects[i].destroyed) {
						objects[i].dispose();
						if (objects[i].tile != null) objects[i].tile.removeGameObject(objects[i]);
						objects[i].objectLayer = null;
						objects.splice(i, 1);
						l--;
					} else {
						objects[i].updatePhysics(elapsedTime);
						checkCollisionsOfObject(i);
						i++;
					}
				}
			}
			super.updatePhysics(elapsedTime);
		}
		
		protected function checkCollisionsOfObject(index:int):void {
			if (!objects[index].initiateCollisionCheck  && (!objects[index].mover || !objects[index].mover.initiateCollisionCheck)) return;
			for (var j:int = 0; j < index; j++) {
				checkCollisionsBetween(objects[index], objects[j]);
			}
		}
		
		/**
		 * Checks if two objects are colliding and calls the appropriate functions when they do
		 * @param	object1
		 * @param	object2
		 */
		public function checkCollisionsBetween(object1:GameObject, object2:GameObject):void {
			if (object1 == object2 || object1.destroyed || object2.destroyed || object1.removed || object2.removed) return;
			//if (object1.shape.position.z != object2.shape.position.z) return;
			if (!object1.canCollideWith(object2) || !object2.canCollideWith(object1)) return;
			screen.game.prof.begin("collision check");
			var collision:CollisionData = CollisionData.check(object1, object2);
			if (collision.interpenetration != CollisionData.NO_INTERPENETRATION) {
				if (object1.doResponse && object2.doResponse) {
					if (object1.mover && object2.mover && ((object2.mass<object1.mass*100) && (object1.mass<object2.mass*100))) {
						object2.mover.respondToCollision(collision, object1, -0.5);
						object1.mover.respondToCollision(collision, object2, 0.5);
						object1.mover.transferEnergy(object2);
					} else if (object1.mover && (!object2.mover || object1.mass<object2.mass*100)) {
						object1.mover.respondToCollision(collision, object2, 1);
						object1.mover.bounce(collision, 1);
					} else if (object2.mover && (!object1.mover || object2.mass<object1.mass*100)) {
						object2.mover.respondToCollision(collision, object1, -1);
						object2.mover.bounce(collision, -1);
					}
				}
				object1.afterCollisionWith(object2);
				object2.afterCollisionWith(object1);
			}
			screen.game.prof.end("collision check");
		}
		
				
		/**
		 * Find a gameObject by its class
		 * @param	c		The class of the object to be found
		 * @param	index	The index of the objects of that class to be returned (0 = the first)
		 * @return
		 */
		public function findObjectByClass(c:Class, index:int = 0):GameObject {
			var l:int = objects.length;
			for (var i:int = 0; i < l; i++) {
				if (objects[i] is c) {
					if (index == 0) return objects[i];
					else index--;
				}
			}			
			return null;
		}
		
		/**
		 * Return a list of all objects of a certain class
		 * @param	objectClass
		 * @return
		 */
		public function findAllObjectsOfClass(objectClass:Class):Vector.<GameObject> {
			var r:Vector.<GameObject> = new Vector.<GameObject>();
			var l:int = objects.length;
			for (var i:int = 0; i < l; i++) {
				if (objects[i] is objectClass) {
					r.push(objects[i]);
				}
			}
			return r;
		}
		
		/**
		 * The number of objects in the layer
		 */
		public function get objectCount():int { return objects.length; }
		
		/**
		 * Returns the number of objects of a certain class
		 * @param	objectClass
		 * @return
		 */
		public function countObjectType(objectClass:Class):int {
			var r:int = 0;
			var l:int = objects.length;
			for (var i:int = 0; i < l; i++) {
				if (objects[i] is objectClass) r++;
			}			
			return r;
		}
		
		/**
		 * Sorts the objects in the layer in asending order of the GameObject.sortOrder value
		 */
		public function sortObjects():void {
			objects.sort(compareObjects);
		}
		
		protected function compareObjects(a:GameObject, b:GameObject):int {
			if (a.sortOrder > b.sortOrder) return 1;
			else if (a.sortOrder < b.sortOrder) return -1;
			else return 0;
		}	
		
		/**
		 * Looks for the first object that is located at a particular position
		 * @param	position			
		 * @param	objectClass		A class specifying the type of object (null = any class of objects).
		 * @return			
		 */
		public function getObjectAt(position:Vector3D, objectClass:Class = null): GameObject {
			for (var i:int = objects.length-1; i >= 0 ; i--) {
				if ((objectClass == null || objects[i] is objectClass) && objects[i].shape && objects[i].shape.pointInShape(position)) return objects[i];
			}
			return null;
		}
		
		/**
		 * Returns the index of a gameObject
		 * @param	gameObject
		 * @return
		 */
		public function getObjectIndex(gameObject:GameObject):int {
			for (var i:int = 0; i < objects.length; i++) {
				if (gameObject == objects[i]) return i;
			}
			return -1;
		}
		
		/**
		 * Sends a message to all objects in the layer
		 * @param	message
		 * @param	data
		 */
		public function sendMessageToObjects(message:String, data:Object):void {
			for (var i:int = 0; i < objects.length; i++) {
				objects[i].sendMessage(message, data);
			}
			
		}
		
		/**
		 * Pooled instances for the ratTracing
		 */
		private var v1:Vector3D = new Vector3D();
		private var v2:Vector3D = new Vector3D();
		private var rayObject:GameObject;
		private var ray:BoundingLine;
		
		/**
		 * Returns true if a ray can be traced from start to target object.
		 * @param	start
		 * @param	target
		 * @param	forObject	Objects must be able to collide with this object to count as blocking. When null all objects count as blocking
		 * @return
		 */
		public function rayTraceToObject(start:GameObject, target:GameObject, forObject:GameObject=null):Boolean 
		{
			if (!rayObject) {
				rayObject = new GameObject();
				rayObject.addComponent(ray = new BoundingLine(new Vector3D()));
				
			}
			v1.x = target.position.x - start.position.x;
			v1.y = target.position.y - start.position.y;
			v1.z = target.position.z - start.position.z;
			ray.setLine(v1);

			rayObject.position.x = start.position.x + v1.x * 0.5;
			rayObject.position.y = start.position.y + v1.y * 0.5;
			rayObject.position.z = 0;
			
			for (var i:int = 0; i < objects.length; i++) {
				if (objects[i] != start && objects[i] != target && (forObject == null || objects[i].canCollideWith(forObject)) && objects[i].doResponse) {
					if (CollisionData.roughCheck(rayObject, objects[i])) {
						if (CollisionData.check(rayObject, objects[i]).interpenetration != CollisionData.NO_INTERPENETRATION) {
							return false;
						}
					}
				}
			}
			return true;
		}
		
		/**
		 * Returns true if a ray can be traced from start to target point.
		 * @param	start
		 * @param	target
		 * @param	forObject	Objects must be able to collide with this object to count as blocking. When null all objects count as blocking
		 * @return
		 */
		
		public function rayTraceToPoint(start:GameObject, target:Vector3D, forObject:GameObject=null):Boolean 
		{
			v1.x = target.x - start.position.x;
			v1.y = target.y - start.position.y;
			v1.z = target.z - start.position.z;

			rayObject.position.x = start.position.x + v1.x * 0.5;
			rayObject.position.y = start.position.y + v1.y * 0.5;
			rayObject.position.z = 0;
			ray.setLine(v1);
			
			for (var i:int = 0; i < objects.length; i++) {
				if (objects[i] != start && (forObject == null || objects[i].canCollideWith(forObject)) && objects[i].doResponse) {
					if (CollisionData.roughCheck(rayObject, objects[i])) {
						if (CollisionData.check(rayObject, objects[i]).interpenetration != CollisionData.NO_INTERPENETRATION) {
							return false;
						}
					}
				}
			}
			return true;
		}
		
		
	}

}