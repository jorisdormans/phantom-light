package nl.jorisdormans.phantom2D.core 
{
	import flash.utils.getQualifiedClassName;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.util.StringUtil;
	
	
	/**
	 * The base class for Components of a GameObject
	 * @author Joris Dormans
	 */
	public class Component 
	{
		public static var xmlDescription:XML = <component/>;
		public static var xmlDefault:XML = <component/>;
		
		public static function generateFromXML(xml:XML):Component {
			var comp:Component = new Component();
			comp.readXML(xml);
			return comp;
		}
		
		/**
		 * A reference to the component's composite (if any)
		 */
		public var parent:Composite;
		
		
		public var destroyed:Boolean = false;
		
		/**
		 * A flag indicating the Object should be removed from a layer without disposing it
		 */
		public var removed:Boolean = false;
		
		
		public function Component() 
		{
			
		}
		
		/**
		 * Update is called once every frame (after the physics have been updated)
		 * @param	elapsedTime
		 */
		public function update(elapsedTime:Number):void {
			
		}
		
		/**
		 * Update is called every frame it can be called more than once
		 * @param	elapsedTime
		 */
		public function updatePhysics(elapsedTime:Number):void {
			
		}
		
		/**
		 * Passes a message to a component (and it subcomponents when it is a composite)
		 * @param	message				The message
		 * @param	data				Data associated with the message
		 * @param	componentClass		A specific target component class
		 * @return						An integer value that indicates its response (defined in Phantom)
		 */
		public function sendMessage(message:String, data:Object = null, componentClass:Class = null):int {
			if (componentClass != null && this is componentClass)	{
				return handleMessage(message, data);
			} else {
				return Phantom.MESSAGE_NOT_HANDLED;
			}
		}

		
		/**
		 * Handles the a message
		 * @param	message	String identifying the message
		 * @param	data	Additional message data.
		 * @return			Returns an integer indicating if and how the message was handled.
		 */
		public function handleMessage(message:String, data:Object = null):int {
			return Phantom.MESSAGE_NOT_HANDLED;
		}
		
		/**
		 * Returns a data object containing or representing the property.
		 * @param	property 	A string identifying the property to be returned
		 * @return				An object containing or representing the data.	
		 */
		public function getProperty(property:String, data:Object = null, componentClass:Class = null):Object {
			return null;
		}
		
		/**
		 * Returns a string representation of the object ("[object ClassName]")
		 * @return
		 */
		public function toString():String {
			return "[object " + getQualifiedClassName(this) + "]";
		}
		
		/**
		 * Called automatically when a component is added to a game object, should be overriden.
		 */
		public function onAdd(composite:Composite):void {
			parent = composite;
		}
		
		/**
		 * Called automatically when a component is removed to a game object, should be overriden.
		 */
		public function onRemove():void {
			parent = null;
		}
		
		/**
		 * Disposes all members, should be overriden.
		 */
		public function dispose():void {
			
		}
		
		/**
		 * Get the first parent of a particular type.
		 * @param	type 	The class indicating the type.
		 * @return			the first parent of the type (might be null)
		 */
		public function getParentByType(type:Class):Component {
			if (parent is type) return parent;
			if (parent) return parent.getParentByType(type);
			return null;
		}
		
		/**
		 * Function to generate an XML description of the component
		 * @return
		 */
		public function generateXML():XML {
			var xml:XML = new XML("<" + StringUtil.getObjectClassName(getQualifiedClassName(this)) + "/>");
			return xml;
		}
		
		/**
		 * Read and set parameters from xml
		 * @param	xml
		 */
		public function readXML(xml:XML):void {
			
		}
	}
}