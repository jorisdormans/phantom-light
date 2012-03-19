package nl.jorisdormans.phantom2D.objects 
{
	import nl.jorisdormans.phantom2D.objects.GameObject;
	
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public interface ICollisionHandler 
	{
		function canCollideWith(other:GameObject):Boolean;
		
		function afterCollisionWith(other:GameObject):void;
		
		
	}
	
}