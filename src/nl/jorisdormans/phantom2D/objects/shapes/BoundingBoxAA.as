package nl.jorisdormans.phantom2D.objects.shapes 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Shape;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	
	/**
	 * An Axis Alligned Bounding Box
	 * @author Joris Dormans
	 */
	public class BoundingBoxAA extends BoundingShape
	{
		//A size of the box divided by 2
		private var _halfSize:Vector3D;
		
		private static var p:Vector3D = new Vector3D();
		private static var p2:Vector3D = new Vector3D();
		
		public function BoundingBoxAA(size:Vector3D) 
		{
			this._halfSize = size;
			this._halfSize.scaleBy(0.5);
			super();
		}
		
		override protected function setExtremes():void {
			super.setExtremes();
			_left = -_halfSize.x;
			_right = _halfSize.x;
			_top = -_halfSize.y;
			_bottom = _halfSize.y;
			var w:Number = Math.max( -_left, _right);
			var h:Number = Math.max( -_top, _bottom);
			_roughSize = Math.sqrt(w * w + h * h) * 2;
			
		}
		
		
		override public function pointInShape(p:Vector3D):Boolean 
		{
			return (Math.abs(p.x - gameObject.position.x) <= _halfSize.x && Math.abs(p.y-gameObject.position.y) <= _halfSize.y);
		}
		
		override public function drawShape(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			graphics.drawRect(x-_halfSize.x*zoom, y-_halfSize.y*zoom, zoom * 2 * _halfSize.x, zoom * 2 * _halfSize.y);
		}
		
		override public function projection(dst:Vector3D, unit:Vector3D, distance:Vector3D):void 
		{
			//first corner
			var x:Number = distance.x;
			var y:Number = distance.y;
			p.x = x - _halfSize.x;
			p.y = y - _halfSize.y;
			var d:Number = p.dotProduct(unit);
			dst.x = d;
			dst.y = d;
			
			//second corner
			p.x = x + _halfSize.x;
			p.y = y - _halfSize.y;
			d = p.dotProduct(unit);
			if (dst.x > d) dst.x = d;
			if (dst.y < d) dst.y = d;
			
			//third corner
			p.x = x + _halfSize.x;
			p.y = y + _halfSize.y;
			d = p.dotProduct(unit);
			if (dst.x > d) dst.x = d;
			if (dst.y < d) dst.y = d;
			
			//fourth corner
			p.x = x - _halfSize.x;
			p.y = y + _halfSize.y;
			d = p.dotProduct(unit);
			if (dst.x > d) dst.x = d;
			if (dst.y < d) dst.y = d;
		}
		
		override protected function createProjections():void 
		{
			super.createProjections();
			projections.push(new Vector3D(1, 0, 0));
			projections.push(new Vector3D( -_halfSize.x, _halfSize.x, 0));
			projections.push(new Vector3D(0, 1, 0));
			projections.push(new Vector3D( -_halfSize.y, _halfSize.y, 0));
		}
		
		override protected function createPoints():void 
		{
			super.createPoints();
			points.push(new Vector3D( -_halfSize.x, -_halfSize.y));
			points.push(new Vector3D( _halfSize.x, -_halfSize.y));
			points.push(new Vector3D( _halfSize.x, _halfSize.y));
			points.push(new Vector3D( -_halfSize.x, _halfSize.y));
		}
		
		override public function scaleBy(factor:Number):void 
		{
			_halfSize.scaleBy(factor);
			super.scaleBy(factor);
		}
		
		/**
		 * A reference to the box's size
		 */
		public function get size():Vector3D {
			return new Vector3D(_halfSize.x * 2, _halfSize.y * 2, _halfSize.z * 2);
		}
		
		public function set size(value:Vector3D):void {
			_halfSize.x = value.x * 0.5;
			_halfSize.y = value.y * 0.5;
			_halfSize.z = value.z * 0.5;
			changeShape();
		}
		
		
		/**
		 * A reference to the box's halfsize
		 */
		public function get halfSize():Vector3D 
		{
			return _halfSize;
		}
		
		override public function set orientation(value:Number):void 
		{
			if (!(this is BoundingBoxOA)) value = 0;
			super.orientation = value;
		}
		
		
		
		
	}
	
}