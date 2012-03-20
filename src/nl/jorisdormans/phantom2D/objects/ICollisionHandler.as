package nl.jorisdormans.phantom2D.objects 
{
	import nl.jorisdormans.phantom2D.objects.GameObject;
	
	/**
	 * Implement this interface to create components that affect how a GameObject collides and make 
	 * it respond after collisions
	 * @author Joris Dormans
	 */
	public interface ICollisionHandler 
	{
		/**
		 * Return true if the component's parent can collide with the other GameObject
		 * @param	other
		 * @return
		 */
		function canCollideWith(other:GameObject):Boolean;
		
		/**
		 * Implement this function to determine behavior after a collision has been detected
		 * @param	other
		 */
		function afterCollisionWith(other:GameObject):void;
		
		
	}
	
}