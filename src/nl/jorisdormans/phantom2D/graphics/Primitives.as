package nl.jorisdormans.phantom2D.graphics 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Primitives
	{
		
		public function Primitives() 
		{
			
		}
		
		public static function drawStar(graphics:Graphics, x:Number, y:Number, size:Number, rotation:Number = 0):void {
			var commands:Vector.<int> = new Vector.<int>();
			var data:Vector.<Number> = new Vector.<Number>();
			for (var i:int = 0; i < 5; i++) {
				if (i == 0) commands.push(GraphicsPathCommand.MOVE_TO);
				else commands.push(GraphicsPathCommand.LINE_TO);
				data.push(x + size * Math.sin(rotation), y - size * Math.cos(rotation));
				rotation += (Math.PI * 4) / 5;
			}
			
			graphics.drawPath(commands, data, GraphicsPathWinding.NON_ZERO);
			
		}
		
		public static function addRegularPolygon(commands:Vector.<int>, data:Vector.<Number>, x:Number, y:Number, size:Number, sides:int, angle:Number):void {
			var step:Number = Math.PI * 2 / sides;
			commands.push(GraphicsPathCommand.MOVE_TO);
			data.push(x + Math.cos(angle) * size, y + Math.sin(angle) * size);
			angle += step;
			for (var i:int = 0; i < sides; i++) {
				commands.push(GraphicsPathCommand.LINE_TO);
				data.push(x + Math.cos(angle) * size, y + Math.sin(angle) * size);
				angle += step;
			}
		}
		
	}

}