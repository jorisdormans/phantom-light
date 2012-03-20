package nl.jorisdormans.phantom2D.util 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class DrawUtil
	{
		
		public function DrawUtil() 
		{
			
		}
		
		/**
		 * Returns the illumination value of a color (0-1).
		 * @param	color
		 * @return
		 */
		public static function colorToIllumination(color:uint):Number {
			var red1:uint = (color & 0xff0000) >> 16;
			var green1:uint = (color & 0x00ff00) >> 8;
			var blue1:uint = color & 0x0000ff;
			var il:uint = red1 + (green1 << 1) + blue1;
			return (il / 1024);
		}
		
		/**
		 * Linear inerpolation between two colors
		 * @param	color1
		 * @param	color2
		 * @param	f
		 * @return
		 */
		public static function lerpColor(color1:uint, color2:uint, f:Number):uint {
			var red1:uint = (color1 & 0xff0000) >> 16;
			var green1:uint = (color1 & 0x00ff00) >> 8;
			var blue1:uint = color1 & 0x0000ff;

			var red2:uint = (color2 & 0xff0000) >> 16;
			var green2:uint = (color2 & 0x00ff00) >> 8;
			var blue2:uint = color2 & 0x0000ff;
			
			red1 += Math.round((red2 - red1) * f);
			green1 += Math.round((green2 - green1) * f);
			blue1 += Math.round((blue2 - blue1) * f);
			
			return ((red1 << 16) | (green1 << 8) | blue1);
		}	
		
		/**
		 * Draws a regular star
		 * @param	graphics
		 * @param	x
		 * @param	y
		 * @param	outerRadius
		 * @param	innerRadius
		 * @param	points
		 * @param	rotation
		 */
		public static function drawStar(graphics:Graphics, x:Number, y:Number, outerRadius:Number, innerRadius:Number, points:int = 5, rotation:Number = 0):void {
			var commands:Vector.<int> = new Vector.<int>();
			var data:Vector.<Number> = new Vector.<Number>();
			var step:Number = Math.PI / points;
			commands.push(GraphicsPathCommand.MOVE_TO);
			data.push(x + outerRadius * Math.sin(rotation), y - outerRadius * Math.cos(rotation));
			for (var i:int = 0; i < points; i++) {
				rotation += step;
				commands.push(GraphicsPathCommand.LINE_TO);
				data.push(x + innerRadius * Math.sin(rotation), y - innerRadius * Math.cos(rotation));				
				rotation += step;
				commands.push(GraphicsPathCommand.LINE_TO);
				data.push(x + outerRadius * Math.sin(rotation), y - outerRadius * Math.cos(rotation));
			}
			graphics.drawPath(commands, data, GraphicsPathWinding.NON_ZERO);
		}
		
		/**
		 * Draws a regular polygon
		 * @param	commands
		 * @param	data
		 * @param	x
		 * @param	y
		 * @param	radius
		 * @param	sides
		 * @param	orientation
		 */
		public static function drawRegularPolygon(graphics:Graphics, x:Number, y:Number, radius:Number, sides:int, orientation:Number):void {
			var commands:Vector.<int> = new Vector.<int>();
			var data:Vector.<Number> = new Vector.<Number>();
			
			addRegularPolygon(commands, data, x, y, radius, sides, orientation);
			
			graphics.drawPath(commands, data, GraphicsPathWinding.NON_ZERO);
		}
		
		/**
		 * Adds a regular polygon to command and data structure
		 * @param	commands
		 * @param	data
		 * @param	x
		 * @param	y
		 * @param	radius
		 * @param	sides
		 * @param	orientation
		 */
		public static function addRegularPolygon(commands:Vector.<int>, data:Vector.<Number>, x:Number, y:Number, radius:Number, sides:int, orientation:Number):void {
			var step:Number = Math.PI * 2 / sides;
			commands.push(GraphicsPathCommand.MOVE_TO);
			data.push(x + Math.cos(orientation) * radius, y + Math.sin(orientation) * radius);
			orientation += step;
			for (var i:int = 0; i < sides; i++) {
				commands.push(GraphicsPathCommand.LINE_TO);
				data.push(x + Math.cos(orientation) * radius, y + Math.sin(orientation) * radius);
				orientation += step;
			}
		}
		
		/**
		 * Draws two lines in a cross centered on x and y
		 * @param	graphics
		 * @param	x
		 * @param	y
		 * @param	size
		 * @param	orientation
		 */
		public static function drawCross(graphics:Graphics, x:Number, y:Number, size:Number, orientation:Number = 0):void {
			size *= 0.5;
			var cos:Number = Math.cos(orientation) * size;
			var sin:Number = Math.sin(orientation) * size;
			graphics.moveTo(x-cos, y-sin);
			graphics.lineTo(x+cos, y+sin);
			graphics.moveTo(x-sin, y-cos);
			graphics.lineTo(x+sin, y+cos);
		}		
	}

}