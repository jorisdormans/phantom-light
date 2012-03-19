package nl.jorisdormans.phantom2D.objects.shapes 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Shape;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class BoundingBoxOA extends BoundingBoxAA
	{
		private static var p:Vector3D = new Vector3D();
		private static var p2:Vector3D = new Vector3D();
		
		public function BoundingBoxOA(halfSize:Vector3D) 
		{
			super(halfSize);
		}
		
		override public function changeShape():void {
			createPoints();
			createProjections();
			setExtremes();
		}
		
		override public function drawShape(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			var lastPoint:int = points.length;
			MathUtil.rotateVector3D(p, points[lastPoint - 1], angle);
			p.x *= zoom;
			p.y *= zoom;
			
			var commands:Vector.<int> = new Vector.<int>();
			commands.push(GraphicsPathCommand.MOVE_TO);
			var data:Vector.<Number> = new Vector.<Number>();
			data.push(x + p.x, y + p.y);
					  
			for (var i:int = 0; i < lastPoint; i++) {
				MathUtil.rotateVector3D(p, points[i], angle);
				p.x *= zoom;
				p.y *= zoom;
				commands.push(GraphicsPathCommand.LINE_TO);
				data.push(x+p.x, y+p.y);
			}
			graphics.drawPath(commands, data);
		}
		
		override public function drawIsoShape(graphics:Graphics, x:Number, y:Number, angle:Number, isoX:Number, isoY:Number, isoZ:Number):void 
		{
			var h:Number = isoHeight * isoZ;
			var commands:Vector.<int> = new Vector.<int>();
			var data:Vector.<Number> = new Vector.<Number>();
			
			for (var i:int = 0; i < points.length; i++) {
				MathUtil.rotateVector3D(p, points[i], angle);
				MathUtil.rotateVector3D(p2, points[(i + 1) % points.length], angle);
				if (p.x - p2.x > 0) {
					commands.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO);
					data.push(x + p.x * isoX, y + p.y * isoY + h);
					data.push(x + p2.x * isoX, y + p2.y * isoY + h);
					data.push(x + p2.x * isoX, y + p2.y * isoY);
					data.push(x + p.x * isoX, y + p.y * isoY);
					data.push(x + p.x * isoX, y + p.y * isoY + h);
				}
			}			
			
			MathUtil.rotateVector3D(p, points[points.length -1], angle);
			p.x *= isoX;
			p.y *= isoY;
			
			//var commands:Vector.<int> = new Vector.<int>();
			commands.push(GraphicsPathCommand.MOVE_TO);
			//var data:Vector.<Number> = new Vector.<Number>();
			data.push(x + p.x, y + p.y+h);
					  
			for (i = 0; i < points.length; i++) {
				MathUtil.rotateVector3D(p, points[i], angle);
				p.x *= isoX;
				p.y *= isoY;
				commands.push(GraphicsPathCommand.LINE_TO);
				data.push(x+p.x, y+p.y+h);
			}
			graphics.drawPath(commands, data);
		}		
		
		override public function pointInShape(pos:Vector3D):Boolean 
		{
			p.x = pos.x - gameObject.position.x;
			p.y = pos.y - gameObject.position.y;
			MathUtil.rotateVector3D(p, p, -orientation);
			for (var i:int = 0; i < projections.length; i += 2) {
				var dot:Number = p.dotProduct(projections[i]);
				var inter1:Number = projections[i+1].y - dot;
				var inter2:Number = -(projections[i+1].x - dot);
				if (inter1 < 0 || inter2 < 0) return false;
			}
			return true;

		}
		
		override public function getRoughSize():Number 
		{
			return super.getRoughSize()*1.5;
		}
		
		private function setExtremes():void 
		{
			left = 0;
			top = 0;
			right = 0;
			bottom = 0;
			for (var i:int = 0; i < points.length; i++) {
				MathUtil.rotateVector3D(p, points[i], orientation);
				if (left > p.x) left = p.x;
				if (right < p.x) right = p.x;
				if (top > p.y) top = p.y;
				if (bottom < p.y) bottom = p.y;
			}
			
		}
		
		override public function setOrientation(a:Number):void {
			orientation = MathUtil.normalizeAngle(a);
			orientationVector.x = Math.cos(orientation);
			orientationVector.y = Math.sin(orientation);
			setExtremes();
		}		
		
	}
	
}