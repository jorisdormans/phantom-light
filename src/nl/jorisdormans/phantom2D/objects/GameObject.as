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
	 * GameObjects have four special components to boost performance: a shape, a mover, a handler and a renderer.
	 * It can have any number of additional generic gameComponents
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
		public var layer:ObjectLayer;
		private var tiledLayer:TiledObjectLayer;
		private var tiles:Boolean = false;
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
		 * Object type indicates how the object can be edited and is saved to xml
		 */
		public var type:int;
		public static const TYPE_NORMAL:int = 0;
		public static const TYPE_TILE:int = 1;
		public static const TYPE_CURVE:int = 2;
		
		/**
		 * The GameObject's relative mass. This value is used for collision response 
		 */
		public var mass:Number;
		
		/**
		 * An id used in scripting and message handling (probably obsolete)
		 */
		public var id:int;
		
		/**
		 * Creates an instance of the gameObject. Call the initialize() function to actually initialize it.
		 */
		public function GameObject() 
		{
			doResponse = true;
			_collisionHandlers = 0;
			_inputHandlers = 0;
			initiateCollisionCheck = false;
			type = TYPE_NORMAL;
			id = 0;
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
			if (tiles) {
				placeOnTile();
			}
		}
		
		/**
		 * Creates GameObjectComponents and adds the GameObject to the specified GameObjectLayer.
		 * @param	objectLayer	Layer to which the object is to be added.
		 * @param	position	The initial position
		 * @param	data		Additional created data
		 */
		public function initialize(objectLayer:ObjectLayer, position:Vector3D, data:Object = null):GameObject {
			this.position = position;
			if (objectLayer) {
				objectLayer.addGameObjectSorted(this);
				tiledLayer = objectLayer as TiledObjectLayer;
				if (tiledLayer) {
					tiles = true;
					placeOnTile();
				}
			}
			return this;
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
			return "[object " + getQualifiedClassName(this) + "]";
			var s:String = "[object " + getQualifiedClassName(this) + "] components (";
			var l:int = components.length;
			s += shape.toString();
			if (mover) s += ", " + mover.toString();
			//if (renderer) s += ", " + renderer.toString();
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
			if (layer.screen.camera.position.z != position.z) return false;
			var margin:Number = 0;
			if (shape) margin = shape.getRoughSize() * 0.5;
			margin *= zoom;
			if (renderX < -margin || renderY < -margin || renderX > layer.screen.screenWidth + margin || renderY > layer.screen.screenHeight + margin) return false;
			return true;
		}
		
		
		

		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number, zoom:Number):void 
		{
			var l:int = components.length;
			for (var i:int = 0; i < l; i++) {
				if (components[i] is IRenderable) {
					(components[i] as IRenderable).render(graphics, x, y, angle + shape.orientation, zoom);
				}
			}
		}
		
		public function generateXML():XML {
			var xml:XML = <object/>;
			xml.@c = StringUtil.getObjectClassName(this.toString());
			if (id > 0) xml.@id = id;
			xml.@x = Math.floor(position.x);
			xml.@y = Math.floor(position.y);
			if (position.z != 0) xml.@z = Math.floor(position.z);
			if (shape.orientation != 0) xml.@orientation = Math.floor(shape.orientation * MathUtil.TO_DEGREES);
			for (var i:int = 0; i < components.length; i++) {
				components[i].setXML(xml);
			}
			return xml;
		}
		
		override public function readXML(xml:XML):void {
			if (xml.@id.length()>0) id = xml.@id;
			position.x = xml.@x;
			position.y = xml.@y;
			if (xml.@z.length() > 0) {
				position.z = xml.@z;
			} else {
				position.z = 0;
			}
			if (xml.@orientation.length() > 0) {
				var a:Number = xml.@orientation;
				shape.setOrientation(a * MathUtil.TO_RADIANS);
			} else {
				shape.setOrientation(0);
			}
			
			for (var i:int = 0; i < components.length; i++) {
				components[i].readXML(xml);
			}
			
		}
		
		public function copySettings(other:GameObject):void {
			var xml:XML = other.generateXML();
			copySettingsXML(xml);
		}
		
		public function copySettingsXML(xml:XML):void {
			xml.@x = Math.floor(position.x);
			xml.@y = Math.floor(position.y);
			xml.@z = Math.floor(position.z);
			xml.@id = id;
			readXML(xml);
		}
		
		public function get collisionHandlers():int 
		{
			return _collisionHandlers;
		}
		
		public function get inputHandlers():int 
		{
			return _inputHandlers;
		}
		
	}

}