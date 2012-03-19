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
	public class BoundingLine extends BoundingShape
	{
		public var line:Vector3D;
		//public var originalLine:Vector3D;
		public var normal:Vector3D;
		public var unit:Vector3D;
		public var length:Number;
		public var oneWay:int;

		
		public static var p:Vector3D = new Vector3D();
		
		public function BoundingLine(line:Vector3D, oneWay:int = 0) 
		{
			this.line = line;
			normal = new Vector3D();			
			unit = line.clone();
			length = unit.normalize();
			super();

			setNormal();
			this.oneWay = oneWay;
			points.push(line.clone());
			points.push(line.clone());
			points[0].scaleBy( -0.5);
			points[1].scaleBy( 0.5);
			setExtremes();
		}
		
		public function setLine(line:Vector3D):void {
			this.line = line;
			unit = line.clone();
			length = unit.normalize();
			setNormal();
			this.oneWay = oneWay;
			points.push(line.clone());
			points.push(line.clone());
			points[0].scaleBy( -0.5);
			points[1].scaleBy( 0.5);
			setExtremes();
		}
		
		public function setNormal():void {
			MathUtil.getNormal2D(normal, line);
		}
		
		override public function getRoughSize():Number 
		{
			if (roughSize<0) {
				if (Math.abs(line.x) > Math.abs(line.y)) roughSize = Math.abs(line.x);
				else roughSize = Math.abs(line.y);
			}
			return roughSize;
		}
		
		override public function drawPhysics(graphics:Graphics, offsetX:Number, offsetY:Number):void 
		{
			var dx:Number = gameObject.position.x - offsetX;
			var dy:Number = gameObject.position.y - offsetY;
			
			graphics.lineStyle(lineWidth, 0xff0000, 1);

			graphics.moveTo(dx + line.x * -0.5, dy + line.y * -0.5);
			graphics.lineTo(dx + line.x * 0.5, dy + line.y * 0.5);
			
			graphics.moveTo(dx, dy);
			graphics.lineTo(dx + normal.x * 5, dy + normal.y * 5);
			graphics.lineStyle();
		}
		
		override public function drawShape(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			
			var commands:Vector.<int> = new Vector.<int>();
			commands.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO);
			var data:Vector.<Number> = new Vector.<Number>();
			MathUtil.rotateVector3D(p, line, angle);
			data.push(x + p.x * -0.5 * zoom, y + p.y * -0.5 * zoom);
			data.push(x + p.x * 0.5 * zoom, y + p.y * 0.5 * zoom);
					  
			graphics.drawPath(commands, data);			
		}
		
		override public function projection(dst:Vector3D, unit:Vector3D, distance:Vector3D):void 
		{
			//first point
			p.x = distance.x - line.x * 0.5;
			p.y = distance.y - line.y * 0.5;
			var d:Number = p.dotProduct(unit);
			dst.x = d;
			dst.y = d;
			
			//second point
			p.x = distance.x +line.x * 0.5;
			p.y = distance.y +line.y * 0.5;
			d = p.dotProduct(unit);
			if (dst.x > d) dst.x = d;
			if (dst.y < d) dst.y = d;
		}
		
		override public function createProjections():void 
		{
			super.createProjections();
			var n:Vector3D = new Vector3D();
			MathUtil.getNormal2D(n, line);
			projections.push(n);
			projections.push(new Vector3D(0, 0, 0));
			
		}
		
		override public function createPoints():void 
		{
			super.createPoints();
			var v:Vector3D = line.clone();
			v.scaleBy(0.5);
			points.push(v);
			v = line.clone();
			v.scaleBy( -0.5);
			points.push(v);
		}
		
		/*override public function setOrientation(a:Number):void 
		{
			super.setOrientation(a);
			MathUtil.rotateVector3D(line, originalLine, orientation);
			setNormal();
		}*/
		
		override public function scale(factor:Number):void 
		{
			super.scale(factor);
			//originalLine.scaleBy(factor);
			line.scaleBy(factor);
		}
		
		override public function setOrientation(a:Number):void 
		{
			super.setOrientation(a);
			setExtremes();
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
		
		override public function pointInShape(pos:Vector3D):Boolean 
		{
			p.x = pos.x - gameObject.position.x;
			p.y = pos.y - gameObject.position.y;
			MathUtil.rotateVector3D(p, p, -orientation);
			var d:Number = MathUtil.distanceToLine(points[0], unit, length, p);
			return (d < 4);
		}
			
		
	}
	
}