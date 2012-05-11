package nl.jorisdormans.phantom2D.objects 
{
	import nl.jorisdormans.phantom2D.core.Composite;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class GameObjectComposite extends Composite
	{
		/**
		 * A reference to the component's GameObject (if any)
		 */
		public var gameObject:GameObject;
		
		
		public function GameObjectComposite() 
		{
			
		}
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			gameObject = getParentByType(GameObject) as GameObject;
			if (!gameObject) {
				throw new Error("GameObjectComposite (" + this + ") must be added toa GameObject.");
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