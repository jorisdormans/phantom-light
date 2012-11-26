package nl.jorisdormans.phantom2D.core 
{
	import flash.utils.getQualifiedClassName;
	import nl.jorisdormans.phantom2D.objects.GameObjectComposite;
	import nl.jorisdormans.phantom2D.objects.ICollisionHandler;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.objects.ObjectFactory;
	import nl.jorisdormans.phantom2D.util.StringUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Composite extends Component
	{
		public static var xmlDescription:XML = <composite/>;
		public static var xmlDefault:XML = <composite/>;
		
		public static function generateFromXML(xml:XML):Component {
			var comp:Component = new Composite();
			comp.readXML(xml);
			return comp;
		}
		
		
		/**
		 * A collection of the Composite's components. Do not modify this list directly.
		 * Use AddComponent() and RemoveComponent() instead.
		 */
		public var components:Vector.<Component>;
		protected var collisionHandlers:Vector.<ICollisionHandler>;
		protected var renderables:Vector.<IRenderable>;
		protected var inputHandlers:Vector.<IInputHandler>;
		
		public function Composite() 
		{
			components = new Vector.<Component>();
			collisionHandlers = new Vector.<ICollisionHandler>();
			renderables = new Vector.<IRenderable>();
			inputHandlers = new Vector.<IInputHandler>();
			
		}
		
		/**
		 * Remove a GameObjectComponent, including the current, shape, mover, handler or renderer.
		 * @param	component
		 */
		public function removeComponent(component:Component):Boolean {
			if (component.parent != this) return false;
			
			for (var i:int = components.length-1; i >= 0; i--) {
				if (components[i] == component) {
					return removeComponentAt(i);
				}
			}
			return false;
		}
		
		/**
		 * Remove a specific component based on its index in the component list.
		 * @param	index
		 * @return
		 */
		public function removeComponentAt(index:int):Boolean {
			if (index<0 || index>=components.length) return false;
			var c:Component = components[index];
			c.onRemove();
			if (c is ICollisionHandler) {
				for (var i:int = collisionHandlers.length - 1; i >= 0; i--) {
					if (collisionHandlers[i] == c) {
						collisionHandlers.splice(i, 1);
						break;
					}
				}
			}
			if (c is IRenderable) {
				for (i = renderables.length - 1; i >= 0; i--) {
					if (renderables[i] == c) {
						renderables.splice(i, 1);
						break;
					}
				}
			}
			if (c is IInputHandler) {
				for (i = inputHandlers.length - 1; i >= 0; i--) {
					if (inputHandlers[i] == c) {
						inputHandlers.splice(i, 1);
						break;
					}
				}
			}
			components.splice(index, 1);
			return true;
		}
		
		/**
		 * Add a Component to the Composite. 
		 * @param	component
		 */
		public function addComponent(component:Component):Component {
			if (component) {
				if (component.parent) component.parent.removeComponent(component);
				component.parent = this;
				components.push(component);
				
				if (component is IInputHandler) inputHandlers.push(component as IInputHandler);
				if (component is ICollisionHandler) collisionHandlers.push(component as ICollisionHandler);
				if (component is IRenderable) renderables.push(component as IRenderable);
				
				component.onAdd(this);
				
			}
			return component;
		}	
		
		/**
		 * Insert a component to the Component at a specified index.
		 * @param	component
		 * @param	index
		 */
		public function insertComponent(component:Component, index:int):void {
			if (index > components.length - 1) {
				addComponent(component);
			} else {
				if (component.parent) component.parent.removeComponent(component);
				component.parent = this;
				components.splice(index, 0, component);
				if (component is IInputHandler) inputHandlers.push(component as IInputHandler);
				if (component is ICollisionHandler) collisionHandlers.push(component as ICollisionHandler);
				if (component is IRenderable) renderables.push(component as IRenderable);
				component.onAdd(this);
			}
		}

		/**
		 * Insert a component to the Component before the specified child.
		 * @param	component
		 * @param	before
		 */
		public function insertBefore(component:Component, before:Component):void {
			for (var i:int = 0; i < components.length; i++) {
				if (components[i] == before) {
					insertComponent(component, i);
					return;
				}
			}
			
			addComponent(component);
		}
		
		/**
		 * Disposes all components
		 */
		override public function dispose():void {
			destroyed = true;
			removed = false;
			while (components.length > 0) {
				removeComponent(components[components.length - 1]);
			}
		}
		
		
		/**
		 * Returns a data object containing or representing the property from the first component that returns an appropriate property.
		 * @param	property		A string identifying the property to be returned
		 * @param	componentClass	A specific target component class for this message (can be null)
		 * @return					An object containing or representing the data.	
		 */
		override public function getProperty(property:String, data:Object = null, componentClass:Class = null):Object {
			var r:Object;
			for (var i:int = 0; i < components.length; i++) {
				if (componentClass == null || components[i] is componentClass) {
					r = components[i].getProperty(property, data);
					if (r != null) return r;
				}
			}
			
			return null;
		
		}
		
		
		/**
		 * Finds a component in the component list by class
		 * @param	componentClass	The class of the component to be found
		 * @param	index			The index of the component to be returned (0 = first component found)
		 * @return
		 */
		public function getComponentByClass(componentClass:Class, nth:int = 0):Component {
			var l:int = components.length;
			for (var i:int = 0; i < l; i++) {
				if (components[i] is componentClass) {
					if (nth == 0) return components[i];
					else nth--;
				}
			}			
			return null;
		}		
		
		/**
		 * Pass an arbitrary messages to the GameObject's components. 
		 * This function is the preferred way of communicating between game components. Although the shape, mover, renderer and handler components can be referenced directly.
		 * @param	message	String containing the message
		 * @param	data	Additional data.
		 * @param	componentClass		specify a specific target component class for this message
		 * @return			Returns an integer indicating if and how the message was handled.
		 */
		override public function handleMessage(message:String, data:Object = null, componentClass:Class = null):int {
			var result:int = Phantom.MESSAGE_NOT_HANDLED;
			var r:int = Phantom.MESSAGE_NOT_HANDLED;
			
			if (componentClass == null) {
				r = super.handleMessage(message, data, componentClass);
				if (r == Phantom.MESSAGE_HANDLED) 
					result = r;
				else if (r == Phantom.MESSAGE_CONSUMED) 
					return r;
			}
			
			//Check other components
			for (var i:int = 0; i < components.length; i++) {
				if (componentClass == null || components[i] is componentClass) {
					if (components[i] is Composite) {
						//composites should pass messages to their components
						r = components[i].handleMessage(message, data);
					} else {
						r = components[i].handleMessage(message, data);
					}					
					switch (r) {
						case Phantom.MESSAGE_HANDLED:
							result = r;
							break;
						case Phantom.MESSAGE_CONSUMED:
							//message was handled exclusively so return from the function
							return r;
					}
				}
			}
			return result;
		}
		
		public function hasComponent(componentClass:Class):Boolean {
			for (var i:int = 0; i < components.length; i++) {
				if (components[i] is componentClass) return true;
				if (components[i] is GameObjectComposite && (components[i] as Composite).hasComponent(componentClass)) return true;
			}
			return false;
		}
		
		
		/**
		 * Takes care of the physics update (which might run more than once every frame) 
		 * @param	elapsedTime
		 */
		override public function updatePhysics(elapsedTime:Number):void {
			for (var i:int = 0; i < components.length; i++) {
				components[i].updatePhysics(elapsedTime);
			}
		}
		
		/**
		 * Generic updates that run once every frame
		 * @param	elapsedTime
		 */
		override public function update(elapsedTime:Number):void {
			var l:int = components.length;
			for (var i:int = 0; i < l; i++) {
				components[i].update(elapsedTime);
			}
			
			//check if anything needs to be removed
			i = components.length-1;
			while (i >= 0) {
				if (components[i].destroyed) {
					removeComponentAt(i);
				}
				i--;
			}
		}
		
		override public function generateXML():XML 
		{
			var xml:XML = super.generateXML();
			for (var i:int = 0; i < components.length; i++) {
				var child:XML = components[i].generateXML();
				if (child) xml.appendChild(child);
			}
			return xml;
		}
		
		override public function readXML(xml:XML):void 
		{
			super.readXML(xml);
			while (components.length > 0) {
				components.pop().dispose();
			}
			
			for (var i:int = 0; i < xml.children().length(); i++) {
				var child:XML = xml.children()[i];
				ObjectFactory.getInstance().addComponent(this, child);
			}
		}
		
		
		/**
		 * Creates string representing the object and its components
		 * @return
		 */
		override public function toString():String {
			//return "[object " + getQualifiedClassName(this) + "]";
			var s:String = StringUtil.getObjectClassName(getQualifiedClassName(this));
			var l:int = components.length;
			if (l>0) {
				s +=" [";
				for (var i:int = 0; i < l; i++) {
					if (i>0) s += ", ";
					s += components[i].toString();
				}
				s += "]";
			}
			return s;
		}
		
		override public function reset():void 
		{
			super.reset();
			for (var i:int = 0; i < components.length; i++) {
				components[i].reset();
			}
		}
		
	}

}