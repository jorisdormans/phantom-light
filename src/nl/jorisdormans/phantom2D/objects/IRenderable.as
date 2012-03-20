package nl.jorisdormans.phantom2D.objects 
{
	import flash.display.Graphics;
	
	/**
	 * Implement this interface to make a component renderable
	 * @author Joris Dormans
	 */
	public interface IRenderable 
	{
		/**
		 * Implement this function to make a component renderable
		 * @param	graphics
		 * @param	x
		 * @param	y
		 * @param	angle
		 * @param	zoom
		 */
		function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void;
	}
	
}