package nl.jorisdormans.phantom2D.objects.shapes 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Shape;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class BoundingCircle extends BoundingShape
	{
		public var radius:Number;
		
		public function BoundingCircle(radius:Number) 
		{
			this.radius = radius;
			super();
		}
		
		override public function changeShape():void {
			left = -radius;
			right = radius;
			top = -radius;
			bottom = radius;
		}		
		
		override public function pointInShape(p:Vector3D):Boolean 
		{
			return (MathUtil.distanceSquared(p, gameObject.position) <= radius * radius);
		}
		
		override public function drawShape(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			graphics.drawCircle(x, y, radius * zoom);

			var commands:Vector.<int> = new Vector.<int>();
			commands.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO);
			var data:Vector.<Number> = new Vector.<Number>();
			data.push(x, y);
			data.push(x + zoom * radius * Math.cos(angle), y + zoom * radius * Math.sin(angle));
					  
			graphics.drawPath(commands, data);			
		}
		
		override public function drawIsoShape(graphics:Graphics, x:Number, y:Number, angle:Number, isoX:Number, isoY:Number, isoZ:Number):void {
			var rx:Number = radius * isoX;
			var ry:Number = radius * isoY;
			var h:Number = isoHeight * isoZ;
			graphics.drawEllipse(x - rx, y - ry, rx * 2, ry * 2);
			//graphics.drawRect(x - rx, y, rx * 2, h);
			graphics.drawEllipse(x - rx, y - ry + h, rx * 2, ry * 2);
			var commands:Vector.<int> = new Vector.<int>();
			commands.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO);
			var data:Vector.<Number> = new Vector.<Number>();
			data.push(x, y+h);
			data.push(x + radius * Math.cos(angle) * isoX, y + h + radius * Math.sin(angle) * isoY);
			graphics.drawPath(commands, data);			
		}

		
		override public function getRoughSize():Number 
		{
			if (roughSize < 0) roughSize = radius * 2;
			return roughSize;
		}
		
		override public function projection(dst:Vector3D, unit:Vector3D, distance:Vector3D):void 
		{
			var p:Number = distance.dotProduct(unit);
			dst.x = p - radius; 
			dst.y = p + radius;
			dst.z = 0;
		}
		
		override public function createProjections():void {
			super.createProjections();
			projections.push(new Vector3D(0, 0));
			projections.push(new Vector3D( -radius, radius));
		}
		
		override public function scale(factor:Number):void 
		{
			super.scale(factor);
			radius *= factor;
			roughSize = -1;
		}
		
		
		
	}
}