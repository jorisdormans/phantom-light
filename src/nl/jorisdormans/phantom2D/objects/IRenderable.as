package nl.jorisdormans.phantom2D.objects 
{
	import flash.display.Graphics;
	
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public interface IRenderable 
	{
		function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void;
	}
	
}