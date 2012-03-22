package nl.jorisdormans.phantom2D.objects.shapes 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Shape;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	import nl.jorisdormans.phantom2D.util.PseudoRandom;
	
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class BoundingPolygon extends BoundingShape
	{
		private static var p:Vector3D = new Vector3D();
		private static var p2:Vector3D = new Vector3D();
		private static var u:Vector3D = new Vector3D();

		public function BoundingPolygon(... args) 
		{
			super();
			for (var i:int = 0; i < args.length; i++) {
				if (args[i] is Vector3D) {
					points.push(args[i]);
				}
			}
			createProjections();
			setExtremes();
		}
		
		override public function projection(dst:Vector3D, unit:Vector3D, distance:Vector3D):void
		{
			if (points.length <= 0) return;
			//first corner
			p.x = distance.x + points[0].x;
			p.y = distance.y + points[0].y;
			var d:Number = p.dotProduct(unit);
			dst.x = d;
			dst.y = d;
			
			//other corners
			for (var i:int  = 1; i < points.length; i++) {
				p.x = distance.x + points[i].x;
				p.y = distance.y + points[i].y;
				d = p.dotProduct(unit);
				if (dst.x > d) dst.x = d;
				if (dst.y < d) dst.y = d;
			}
		}
		
		
		override protected function createProjections():void 
		{
			super.createProjections();
			var c:int = 0;
			var found:Boolean;
			for (var i:int = 0; i < points.length; i++) {
				var u:Vector3D = new Vector3D();
				u.x = points[(i + 1) % points.length].x - points[i].x;
				u.y = points[(i + 1) % points.length].y - points[i].y;
				u.z = points[(i + 1) % points.length].z - points[i].z;
				MathUtil.getNormal2D(u, u);
				
				found = false;
				if (!found) {
					c++;
					var p:Vector3D = new Vector3D();
					projection(p, u, new Vector3D(0, 0, 0));
					projections.push(u);
					projections.push(p);
				}
			}
		}
		
		override public function drawShape(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			var lastPoint:int = points.length;
			if (lastPoint <= 0) return;
			angle += orientation;
			
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
		
		override public function pointInShape(pos:Vector3D):Boolean 
		{
			p.x = pos.x - gameObject.position.x;
			p.y = pos.y - gameObject.position.y;
			MathUtil.rotateVector3D(p, p, -_orientation);
			for (var i:int = 0; i < projections.length; i += 2) {
				var dot:Number = p.dotProduct(projections[i]);
				var inter1:Number = projections[i+1].y - dot;
				var inter2:Number = -(projections[i+1].x - dot);
				if (inter1 < 0 || inter2 < 0) return false;
			}
			return true;
		}
		
		public function getRandomPosition(distanceToEdge:Number):Vector3D {
			var result:Vector3D = new Vector3D();
			var s:Number = _roughSize;
			var tries:int = 100;
			var found:Boolean;
			while (tries > 0) {
				tries--;
				result.x = PseudoRandom.nextNumber() * s - s * 0.5;
				result.y = PseudoRandom.nextNumber() * s - s * 0.5;
				result.z = gameObject.position.z;
				found = true;
				for (var i:int = 0; i < projections.length; i += 2) {
					var dot:Number = result.x * projections[i].x + result.y * projections[i].y;
					if (dot < projections[i + 1].x + distanceToEdge || dot > projections[i + 1].y - distanceToEdge) {
						found = false;
						break;
					}
				}
				if (found) return result;
			}
			return null;
		}
		
		
		override protected function setExtremes():void 
		{
			super.setExtremes();
			for (var i:int = 0; i < points.length; i++) {
				MathUtil.rotateVector3D(p, points[i], _orientation);
				if (_left > p.x) _left = p.x;
				if (_right < p.x) _right = p.x;
				if (_top > p.y) _top = p.y;
				if (_bottom < p.y) _bottom = p.y;
			}
			var w:Number = Math.max( -_left, _right);
			var h:Number = Math.max( -_top, _bottom);
			_roughSize = Math.sqrt(w * w + h * h) * 2;
			
		}
		
		
	}
	
}