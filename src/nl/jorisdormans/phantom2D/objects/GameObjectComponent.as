package nl.jorisdormans.phantom2D.objects 
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	/**
	 * Base class for all components designed to be components of a GameObject.
	 * Creates a reference to is GameObject parent, throws an exception if not added to a GameObject 
	 * @author Joris Dormans
	 */
	public class GameObjectComponent extends Component
	{
		/**
		 * A reference to the component's GameObject (if any)
		 */
		public var gameObject:GameObject;
		
		public function GameObjectComponent() 
		{
			
		}
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			gameObject = getParentByType(GameObject) as GameObject;
			if (!gameObject) {
				throw new Error("GameObjectComponent (" + this + ") must be added to a GameObject.");
			}
		}
		
		override public function onRemove():void 
		{
			super.onRemove();
			gameObject = null;
		}
		
		/**
		 * Function that is called after the Component's GameObject is placed in an ObjectLayer and initialized
		 */
		public function onInitialize():void {
			
		}
		
	}

}