package nl.jorisdormans.phantom2D.objects.shapes 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Shape;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	
	/**
	 * An object aligned bounding box
	 * @author Joris Dormans
	 */
	public class BoundingBoxOA extends BoundingBoxAA
	{
		public static var xmlDescription:XML = <BoundingBoxOA width="Number" height="Number" orientation="Number"/>;
		public static var xmlDefault:XML = <BoundingBoxOA width="20" height="20" orientation="0"/>;
		
		public static function generateFromXML(xml:XML):Component {
			var comp:Component = new BoundingBoxOA(new Vector3D(20, 20));
			comp.readXML(xml);
			return comp;
		}
		
		private static var p:Vector3D = new Vector3D();
		private static var p2:Vector3D = new Vector3D();
		
		public function BoundingBoxOA(size:Vector3D) 
		{
			super(size);
		}
		
		override protected function setExtremes():void {
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
		
		override public function drawShape(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			var lastPoint:int = points.length;
			angle += _orientation;
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
		
	}
	
}