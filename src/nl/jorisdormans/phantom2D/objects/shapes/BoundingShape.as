package nl.jorisdormans.phantom2D.objects.shapes 
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.*;
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	
	/**
	 * ...
	 * @author Joris Dormans
	 * this is an class from which other shapes are derived, it should be abstract...
	 */
	public class BoundingShape extends GameObjectComponent
	{
		
		public var projections:Vector.<Vector3D>; 
		
		public var points:Vector.<Vector3D>;
		
		protected var _orientation:Number;
		
		protected var _orientationVector:Vector3D;
		
		protected var _roughSize:Number = 0;
		
		/**
		 * The shape's lowest value on the x axis. 
		 */
		protected var _left:Number;
		/**
		 * The shape's lowest value on the y axis. 
		 */
		protected var _top:Number;
		/**
		 * The shape's highest value on the x axis. 
		 */
		protected var _right:Number;
		/**
		 * The shape's highest value on the y axis. 
		 */
		protected var _bottom:Number;
		
		public function BoundingShape()
		{
			projections = new Vector.<Vector3D>();
			points = new Vector.<Vector3D>();
			_orientation = 0;
			_orientationVector = new Vector3D(1, 0, 0);
			changeShape();
		}
		
		protected function setExtremes():void {
			_left = 0;
			_right = 0;
			_top = 0;
			_bottom = 0;
			_roughSize = 0;
		}
		
		protected function changeShape():void {
			createProjections();
			createPoints();
			setExtremes();
		}
		
		/**
		 * check if a point is falls within a shape
		 * @param	p
		 * @return
		 */
		public function pointInShape(p:Vector3D):Boolean {
			return false;
		}
		
		/**
		 * draw the shape to a graphics object at a specified location
		 * @param	graphics
		 * @param	x
		 * @param	y
		 * @param	angle
		 * @param	zoom
		 */
		public function drawShape(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void {
			
		}
		
		public function get roughSize():Number {
			return _roughSize;
		}
		
		public function get orientationVector():Vector3D 
		{
			return _orientationVector;
		}
		
		public function get orientation():Number 
		{
			return _orientation;
		}
		
		public function set orientation(value:Number):void 
		{
			_orientation = MathUtil.normalizeAngle(value);
			_orientationVector.x = Math.cos(_orientation);
			_orientationVector.y = Math.sin(_orientation);
			setExtremes();
		}
		
		/**
		 * The shape's lowest value on the x axis. 
		 */
		public function get left():Number 
		{
			return _left;
		}
		
		/**
		 * The shape's lowest value on the y axis. 
		 */
		public function get top():Number 
		{
			return _top;
		}
		
		/**
		 * The shape's highest value on the x axis. 
		 */
		public function get right():Number 
		{
			return _right;
		}
		
		/**
		 * The shape's highest value on the y axis. 
		 */
		public function get bottom():Number 
		{
			return _bottom;
		}
		
		public function set bottom(value:Number):void 
		{
			_bottom = value;
		}
		
		public function projection(dst:Vector3D, unit:Vector3D, distance:Vector3D):void{
			dst.x = 0;
			dst.y = 0;
			dst.z = 0;
		}
		
		protected function createProjections():void {
			projections.splice(0, projections.length);
		}
		
		protected function createPoints():void {
			points.splice(0, points.length);
		}
		
		/**
		 * Scale the current shape with a factor.
		 * @param	factor
		 */
		public function scaleBy(factor:Number):void {
			for (var i:int = 0; i < points.length; i++) {
				points[i].scaleBy(factor);
			}
			for (i = 0; i < projections.length; i++) {
				projections[i].scaleBy(factor);
			}
			setExtremes();
		}
		
		
	}
	
}