package nl.jorisdormans.phantom2D.objects.shapes 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Shape;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	
	/**
	 * A bouncing circle class
	 * @author Joris Dormans
	 */
	public class BoundingCircle extends BoundingShape
	{
		public static var xmlDescription:XML = <BoundingShape radius="Number" orientation="Number"/>;
		public static var xmlDefault:XML = <BoundingShape radius="10" orientation="0"/>;
		
		public static function generateFromXML(xml:XML):Component {
			var comp:Component = new BoundingBoxAA(new Vector3D(20, 20));
			comp.readXML(xml);
			return comp;
		}		
		/**
		 * The circle's radius
		 */
		private var _radius:Number;
		
		public function BoundingCircle(radius:Number) 
		{
			this._radius = radius;
			super();
		}
		
		override public function generateXML():XML 
		{
			var xml:XML = super.generateXML();
			xml.@radius = _radius;
			return xml;
		}
		
		override public function readXML(xml:XML):void 
		{
			super.readXML(xml);
			if (xml.@radius.length() > 0) radius = xml.@radius;
			
		}
		
		override protected function setExtremes():void {
			super.setExtremes();
			_left = -_radius;
			_right = _radius;
			_top = -_radius;
			_bottom = _radius;
			_roughSize = radius * 2;
		}		
		
		override public function pointInShape(p:Vector3D):Boolean 
		{
			return (MathUtil.distanceSquared(p, gameObject.position) <= _radius * _radius);
		}
		
		override public function drawShape(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			graphics.drawCircle(x, y, _radius * zoom);

			var commands:Vector.<int> = new Vector.<int>();
			commands.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO);
			var data:Vector.<Number> = new Vector.<Number>();
			data.push(x, y);
			data.push(x + zoom * _radius * Math.cos(angle), y + zoom * _radius * Math.sin(angle));
					  
			graphics.drawPath(commands, data);			
		}
		
		override public function projection(dst:Vector3D, unit:Vector3D, distance:Vector3D):void 
		{
			var p:Number = distance.dotProduct(unit);
			dst.x = p - _radius; 
			dst.y = p + _radius;
			dst.z = 0;
		}
		
		override protected function createProjections():void {
			super.createProjections();
			projections.push(new Vector3D(0, 0));
			projections.push(new Vector3D( -_radius, _radius));
		}
		
		override public function scaleBy(factor:Number):void 
		{
			_radius *= factor;
			_roughSize *= factor;
			super.scaleBy(factor);
		}
		
		public function get radius():Number 
		{
			return _radius;
		}
		
		public function set radius(value:Number):void 
		{
			_radius = value;
			changeShape();
		}
		
		
		
	}
}