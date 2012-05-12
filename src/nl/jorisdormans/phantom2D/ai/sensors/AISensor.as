package nl.jorisdormans.phantom2D.ai.sensors 
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class AISensor extends GameObjectComponent
	{
		protected var target:AITarget;
		
		public function AISensor() 
		{
			
		}
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			target = parent.getComponentByClass(AITarget) as AITarget;
			if (!target) {
				throw new Error("AISensor cannot find AITarget component in its parent.");
			}
		}
		
		
		
	}

}