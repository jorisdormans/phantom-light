package nl.jorisdormans.phantom2D.objects 
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Vector3D;
	import flash.utils.getQualifiedClassName;
	import nl.jorisdormans.phantom2D.core.*;
	import nl.jorisdormans.phantom2D.cameras.Camera;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.objects.shapes.BoundingShape;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	import nl.jorisdormans.phantom2D.util.StringUtil;
	/**
	 * A GameObject is used to represent entities in the game. Its components determine its behavior and appearance.
	 * GameObjects can have one shape and one mover. Both will have a special reference. 
	 * It can have any number of additional components
	 * @author Joris Dormans
	 */
	public class GameObject extends Composite
	{
		/**
		 * The object's position on the objectLayer
		 */
		public var position:Vector3D;
		/**
		 * A direct reference to the BoundingShape component that determines the GameObjects location and shape in the GameScreen
		 */
		public var shape:BoundingShape;
		/**
		 * A direct reference to the Mover component that determines how a object moves
		 */
		public var mover:Mover;
		/**
		 * A reference to the ObjectLayer (a GameScreen component) that holds the GameObject. 
		 */
		public var objectLayer:ObjectLayer;
		private var tiledLayer:TiledObjectLayer;
		private var inTiledLayer:Boolean = false;
		/**
		 * A reference to the Tile in a TiledObjectLayer (a GameScreen component) that holds the GameObject. 
		 */
		public var tile:Tile;
		/**
		 * A number that can be used to sort GameObjects in a GameObject layer. Sort order determines the drawing order within the same layer
		 */
		public var sortOrder:Number = 0;
		/**
		 * Flag indicating if collision response should be handled. (When set to false collision are detected but objects do not bounce).
		 */
		public var doResponse:Boolean;
		
		/**
		 * A count of the number of components that implement the IHandler interface.
		 */
		private var _collisionHandlers:int;
		/**
		 * A count of the number of components that implement the IInputHandler interface.
		 */
		private var _inputHandlers:int;
		
		/**
		 * A flag if the object should initiate a collision check even when it has no mover component.
		 */
		public var initiateCollisionCheck:Boolean;
		
		/**
		 * The GameObject's relative mass. This value is used for collision response 
		 */
		public var mass:Number;
		
		/**
		 * Creates an instance of the gameObject. Call the initialize() function to actually initialize it.
		 */
		public function GameObject() 
		{
			doResponse = true;
			_collisionHandlers = 0;
			_inputHandlers = 0;
			initiateCollisionCheck = false;
			mass = 1;
			position = new Vector3D();
		}
		
		
		override public function removeComponentAt(index:int):Boolean 
		{
			if (index<0 || index>=components.length) return false;
			if (components[index] is ICollisionHandler) _collisionHandlers--;
			if (components[index] is IInputHandler) _inputHandlers--;
				
			if (components[index] == shape) {
				shape == null;
			} 
			if (components[index] == mover) {
				mover == null;
			} 
			
			return super.removeComponentAt(index);
		}
		
		
		/**
		 * Add a generic GameComponent to the object. 
		 * @param	component
		 */
		override public function addComponent(component:Component):Component {
			super.addComponent(component);
			if (component) {
				if (component is ICollisionHandler) _collisionHandlers++;
				if (component is IInputHandler) _inputHandlers++;
			}
			
			if (component is BoundingShape) {
				if (this.shape) {
					trace("PHANTOM: Removed old shape from", this);
					removeComponent(this.shape);
				}
				this.shape = component as BoundingShape;
			}
			
			if (component is Mover) {
				if (this.mover) {
					trace("PHANTOM: Removed old mover from", this);
					removeComponent(this.mover);
				}
				this.mover = component as Mover;
			}
			return component;
		}
		
		override public function updatePhysics(elapsedTime:Number):void 
		{
			super.updatePhysics(elapsedTime);
			if (inTiledLayer) {
				placeOnTile();
			}
		}
		
		/**
		 * Called after a component is initialized. Calls the onInitialize of all its GameObjectComponents
		 */
		public function initialize():void {
			if (objectLayer) {
				tiledLayer = objectLayer as TiledObjectLayer;
				if (tiledLayer) {
					inTiledLayer = true;
					placeOnTile();
				}
			}
			var l:int = components.length;
			for (var i:int = 0; i < l; i++) {
				if (components[i] is GameObjectComponent) {
					(components[i] as GameObjectComponent).onInitialize();
				}
			}
		}
		
		/**
		 * Checks if the object is in a TiledObjectLayer and updates tile data according to its current location
		 * This needs to be implemented smarter!
		 */
		private function placeOnTile():void {
			//get the current tile
			var t:Tile = tiledLayer.getTile(position);
			//update tile information if the object is in a different tile
			if (t != tile) {
				if (tile!=null) tile.removeGameObject(this);
				t.addGameObject(this);
			}
		}
		
		
		/**
		 * Handles input for the GameObject automatically called by the ObjectLayer if the GameObject contains handlers
		 * @param	elapsedTime
		 * @param	currentInputState
		 * @param	previousInputState
		 */
		public function handleInput(elapsedTime:Number, currentInputState:InputState, previousInputState:InputState):void 
		{
			if (_inputHandlers>0) {
				var l:int = components.length;
				for (var i:int = 0; i < l; i++) {
					if (components[i] is IInputHandler) {
						(components[i] as IInputHandler).handleInput(elapsedTime, currentInputState, previousInputState);
					}
				}
			}
		}

		
		/**
		 * Function to determine possible collissions.  
		 * @param	other	
		 * @return			Return true if the collision with the other GameObject is possible, false to ignore the collission altogether.
		 */
		public function canCollideWith(other:GameObject):Boolean {
			if (collisionHandlers>0) {
				var l:int = components.length;
				for (var i:int = 0; i < l; i++) {
					if (components[i] is ICollisionHandler && !(components[i] as ICollisionHandler).canCollideWith(other)) {
						return false;
					}
				}
			}
			return true;
		}
		
		/**
		 * Is called after a collission with a particular object is detected and after the physics have responded..
		 * @param	other
		 */
		public function afterCollisionWith(other:GameObject):void {
			if (collisionHandlers>0) {
				var l:int = components.length;
				for (var i:int = 0; i < l; i++) {
					if (components[i] is ICollisionHandler) {
						(components[i] as ICollisionHandler).afterCollisionWith(other);
					}
				}
			}
		}
		
		/**
		 * Creates string representing the object and its components
		 * @return
		 */
		override public function toString():String {
			//return "[object " + getQualifiedClassName(this) + "]";
			var s:String = "[object " + getQualifiedClassName(this) + "] components (";
			var l:int = components.length;
			for (var i:int = 0; i < l; i++) {
				s += ", "+components[0].toString();
			}
			s += ")";
			return s;
		}
		
		/**
		 * Checks if the GameObject is in the visible portion of the GameScreen.
		 * @param	margin	Number of pixels margin (high numbers will return true more often).
		 * @return			True when it is visible, false when it is not.
		 */
		public function isVisible(renderX:Number, renderY:Number, zoom:Number):Boolean {
			if (objectLayer.screen.camera.position.z != position.z) return false;
			var margin:Number = 0;
			if (shape) margin = shape.roughSize * 0.5;
			margin *= zoom;
			if (renderX < -margin || renderY < -margin || renderX > objectLayer.screen.screenWidth + margin || renderY > objectLayer.screen.screenHeight + margin) return false;
			return true;
		}
		
		/**
		 * Function that rendersa gamObject and its components to a certain location
		 * @param	graphics
		 * @param	x
		 * @param	y
		 * @param	angle
		 * @param	zoom
		 */
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number, zoom:Number):void 
		{
			var l:int = components.length;
			for (var i:int = 0; i < l; i++) {
				if (components[i] is IRenderable) {
					var a:Number = angle;
					if (shape) a += shape.orientation;
					(components[i] as IRenderable).render(graphics, x, y, a, zoom);
				}
			}
		}
		
		/**
		 * Current count of collisionHandlers
		 */
		public function get collisionHandlers():int 
		{
			return _collisionHandlers;
		}
		
		/**
		 * Current count of inputHandlers
		 */
		public function get inputHandlers():int 
		{
			return _inputHandlers;
		}
		
	}

}