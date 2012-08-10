package nl.jorisdormans.phantom2D.objects.misc 
{
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	import nl.jorisdormans.phantom2D.objects.ICollisionHandler;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class DestroyOnImpact extends GameObjectComponent implements ICollisionHandler
	{
		static public const E_IMPACT:String = "impact";
		
		public function DestroyOnImpact() 
		{
			
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.ICollisionHandler */
		
		public function canCollideWith(other:GameObject):Boolean 
		{
			return true;
		}
		
		public function afterCollisionWith(other:GameObject):void 
		{
			if (other.doResponse && gameObject.doResponse) {
				gameObject.handleMessage(E_IMPACT);
				gameObject.destroyed = true;
			}
		}
		
	}

}