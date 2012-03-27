package nl.jorisdormans.phantom2D.core 
{
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Composite extends Component
	{
		/**
		 * A collection of the Composite's components. Do not modify this list directly.
		 * Use AddComponent() and RemoveComponent() instead.
		 */
		public var components:Vector.<Component>;
		
		public function Composite() 
		{
			components = new Vector.<Component>();
			
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
			components[index].onRemove();
			components.splice(index, 1);
			return true;
		}
		
		/**
		 * Add a Component to the Composite. 
		 * @param	component
		 */
		public function addComponent(component:Component):Component {
			if (component) {
				component.parent = this;
				components.push(component);
				component.onAdd(this);
			}
			return component;
			
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
		override public function getProperty(property:String, componentClass:Class = null):Object {
			var r:Object;
			for (var i:int = 0; i < components.length; i++) {
				if (componentClass == null || components[i] is componentClass) {
					r = components[i].getProperty(property);
					if (r) return r;
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
		override public function sendMessage(message:String, data:Object = null, componentClass:Class = null):int {
			var result:int = Phantom.MESSAGE_NOT_HANDLED;
			var r:int = Phantom.MESSAGE_NOT_HANDLED;
			
			if (componentClass == null) {
				r = handleMessage(message, data);
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
						r = components[i].sendMessage(message, data);
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
			i = l-1;
			while (i >= 0) {
				if (components[i].destroyed) {
					removeComponentAt(i);
				}
				i--;
			}
		}		
		
	}

}