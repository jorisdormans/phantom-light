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
	public class BoundingBoxAA extends BoundingShape
	{
		public var halfSize:Vector3D;
		
		private static var p:Vector3D = new Vector3D();
		private static var p2:Vector3D = new Vector3D();
		
		public function BoundingBoxAA(halfSize:Vector3D) 
		{
			this.halfSize = halfSize.clone();
			super();
		}
		
		override public function changeShape():void {
			createPoints();
			createProjections();
			left = -halfSize.x;
			right = halfSize.x;
			top = -halfSize.y;
			bottom = halfSize.y;
		}
		
		
		override public function pointInShape(p:Vector3D):Boolean 
		{
			return (Math.abs(p.x - gameObject.position.x) <= halfSize.x && Math.abs(p.y-gameObject.position.y) <= halfSize.y);
		}
		
		override public function drawShape(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			graphics.drawRect(x-halfSize.x*zoom, y-halfSize.y*zoom, zoom * 2 * halfSize.x, zoom * 2 * halfSize.y);
		}
		
		override public function drawIsoShape(graphics:Graphics, x:Number, y:Number, angle:Number, isoX:Number, isoY:Number, isoZ:Number):void 
		{
			var h:Number = isoHeight * isoZ;
			var commands:Vector.<int> = new Vector.<int>();
			var data:Vector.<Number> = new Vector.<Number>();
			
			p.x = -halfSize.x;
			p.y = -halfSize.y;
			MathUtil.rotateVector3D(p, p, angle);
			p2.x = halfSize.x;
			p2.y = -halfSize.y;
			MathUtil.rotateVector3D(p2, p2, angle);
			if (p.x - p2.x > 0) {
				commands.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO);
				data.push(x + p.x * isoX, y + p.y * isoY + h);
				data.push(x + p2.x * isoX, y + p2.y * isoY + h);
				data.push(x + p2.x * isoX, y + p2.y * isoY);
				data.push(x + p.x * isoX, y + p.y * isoY);
				data.push(x + p.x * isoX, y + p.y * isoY + h);
			}
			
			p.x = halfSize.x;
			p.y = -halfSize.y;
			MathUtil.rotateVector3D(p, p, angle);
			p2.x = halfSize.x;
			p2.y = halfSize.y;
			MathUtil.rotateVector3D(p2, p2, angle);
			if (p.x - p2.x > 0) {
				commands.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO);
				data.push(x + p.x * isoX, y + p.y * isoY + h);
				data.push(x + p2.x * isoX, y + p2.y * isoY + h);
				data.push(x + p2.x * isoX, y + p2.y * isoY);
				data.push(x + p.x * isoX, y + p.y * isoY);
				data.push(x + p.x * isoX, y + p.y * isoY + h);
			}
			
			p.x = halfSize.x;
			p.y = halfSize.y;
			MathUtil.rotateVector3D(p, p, angle);
			p2.x = -halfSize.x;
			p2.y = halfSize.y;
			MathUtil.rotateVector3D(p2, p2, angle);
			if (p.x - p2.x > 0) {
				commands.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO);
				data.push(x + p.x * isoX, y + p.y * isoY + h);
				data.push(x + p2.x * isoX, y + p2.y * isoY + h);
				data.push(x + p2.x * isoX, y + p2.y * isoY);
				data.push(x + p.x * isoX, y + p.y * isoY);
				data.push(x + p.x * isoX, y + p.y * isoY + h);
			}
			
			p.x = -halfSize.x;
			p.y = halfSize.y;
			MathUtil.rotateVector3D(p, p, angle);
			p2.x = -halfSize.x;
			p2.y = -halfSize.y;
			MathUtil.rotateVector3D(p2, p2, angle);
			if (p.x - p2.x > 0) {
				commands.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO);
				data.push(x + p.x * isoX, y + p.y * isoY + h);
				data.push(x + p2.x * isoX, y + p2.y * isoY + h);
				data.push(x + p2.x * isoX, y + p2.y * isoY);
				data.push(x + p.x * isoX, y + p.y * isoY);
				data.push(x + p.x * isoX, y + p.y * isoY + h);
			}			
			
			
			p.x = -halfSize.x;
			p.y = -halfSize.y;
			MathUtil.rotateVector3D(p, p, angle);
			p.x *= isoX;
			p.y *= isoY;
			
			//var commands:Vector.<int> = new Vector.<int>();
			commands.push(GraphicsPathCommand.MOVE_TO);
			//var data:Vector.<Number> = new Vector.<Number>();
			data.push(x + p.x, y + p.y+h);
					  
			p.x = halfSize.x;
			p.y = -halfSize.y;
			MathUtil.rotateVector3D(p, p, angle);
			p.x *= isoX;
			p.y *= isoY;
			commands.push(GraphicsPathCommand.LINE_TO);
			data.push(x + p.x, y + p.y + h);
			
			p.x = halfSize.x;
			p.y = halfSize.y;
			MathUtil.rotateVector3D(p, p, angle);
			p.x *= isoX;
			p.y *= isoY;
			commands.push(GraphicsPathCommand.LINE_TO);
			data.push(x + p.x, y + p.y + h);
			
			p.x = -halfSize.x;
			p.y = halfSize.y;
			MathUtil.rotateVector3D(p, p, angle);
			p.x *= isoX;
			p.y *= isoY;
			commands.push(GraphicsPathCommand.LINE_TO);
			data.push(x + p.x, y + p.y + h);

			p.x = -halfSize.x;
			p.y = -halfSize.y;
			MathUtil.rotateVector3D(p, p, angle);
			p.x *= isoX;
			p.y *= isoY;
			commands.push(GraphicsPathCommand.LINE_TO);
			data.push(x + p.x, y + p.y + h);
			
			graphics.drawPath(commands, data);
		}			
		
		override public function getRoughSize():Number 
		{
			if (roughSize<0) {
				if (halfSize.x > halfSize.y) roughSize = halfSize.x * 2;
				else roughSize = halfSize.y * 2;
			}
			return roughSize;
		}
		
		override public function projection(dst:Vector3D, unit:Vector3D, distance:Vector3D):void 
		{
			//first corner
			var x:Number = distance.x;
			var y:Number = distance.y;
			p.x = x - halfSize.x;
			p.y = y - halfSize.y;
			var d:Number = p.dotProduct(unit);
			dst.x = d;
			dst.y = d;
			
			//second corner
			p.x = x + halfSize.x;
			p.y = y - halfSize.y;
			d = p.dotProduct(unit);
			if (dst.x > d) dst.x = d;
			if (dst.y < d) dst.y = d;
			
			//third corner
			p.x = x + halfSize.x;
			p.y = y + halfSize.y;
			d = p.dotProduct(unit);
			if (dst.x > d) dst.x = d;
			if (dst.y < d) dst.y = d;
			
			//fourth corner
			p.x = x - halfSize.x;
			p.y = y + halfSize.y;
			d = p.dotProduct(unit);
			if (dst.x > d) dst.x = d;
			if (dst.y < d) dst.y = d;
		}
		
		override public function createProjections():void 
		{
			super.createProjections();
			projections.push(new Vector3D(1, 0, 0));
			projections.push(new Vector3D( -halfSize.x, halfSize.x, 0));
			projections.push(new Vector3D(0, 1, 0));
			projections.push(new Vector3D( -halfSize.y, halfSize.y, 0));
		}
		
		override public function createPoints():void 
		{
			super.createPoints();
			points.push(new Vector3D( -halfSize.x, -halfSize.y));
			points.push(new Vector3D( halfSize.x, -halfSize.y));
			points.push(new Vector3D( halfSize.x, halfSize.y));
			points.push(new Vector3D( -halfSize.x, halfSize.y));
		}
		
		override public function scale(factor:Number):void 
		{
			super.scale(factor);
			halfSize.scaleBy(factor);
		}
		
		public function get size():Vector3D {
			return new Vector3D(halfSize.x * 2, halfSize.y * 2, halfSize.z * 2);
		}
		
		public function setSize(s:Vector3D):void {
			halfSize.x = s.x*0.5;
			halfSize.y = s.y*0.5;
			halfSize.z = s.z*0.5;
			createPoints();
			createProjections();
		}
		
		override public function setOrientation(a:Number):void 
		{
			orientation = 0;
			
		}
		
		
	}
	
}