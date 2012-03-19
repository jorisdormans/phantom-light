package nl.jorisdormans.phantom2D.objects.shapes 
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.*;
	import nl.jorisdormans.phantom2D.objects.CollisionData;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	
	/**
	 * ...
	 * @author Joris Dormans
	 * this is an class from which other shapes are derived, it should be abstract...
	 */
	public class BoundingShape extends Component
	{
		public var projections:Vector.<Vector3D>; 
		public var points:Vector.<Vector3D>;
		public var orientation:Number;
		public var orientationVector:Vector3D;
		public var lineWidth:int = 2; 
		protected var roughSize:Number = -1;
		public var isoHeight:Number = 0;
		/**
		 * The shape's lowest value on the x axis. Do not set this value.
		 */
		public var left:Number;
		/**
		 * The shape's lowest value on the y axis. Do not set this value.
		 */
		public var top:Number;
		/**
		 * The shape's highest value on the x axis. Do not set this value.
		 */
		public var right:Number;
		/**
		 * The shape's highest value on the y axis. Do not set this value.
		 */
		public var bottom:Number;
		
		public function BoundingShape()
		{
			projections = new Vector.<Vector3D>();
			points = new Vector.<Vector3D>();
			orientation = 0;
			orientationVector = new Vector3D(1, 0, 0);
			changeShape();
		}
		
		public function changeShape():void {
			createProjections();
			createPoints();
			left = 0;
			right = 0;
			top = 0;
			bottom = 0;
		}
		
		public function pointInShape(p:Vector3D):Boolean {
			return false;
		}
		
		/*public function roughCollisionCheck(other:BoundingShape):Boolean {
			return CollisionData.roughCheck(this, other);
		}
		
		public function collisionCheck(other:BoundingShape):CollisionData {
			return CollisionData.check(this, other);
		}*/
		
		public function drawPhysics(graphics:Graphics, offsetX:Number, offsetY:Number):void {
			var dx:Number = gameObject.position.x - offsetX;
			var dy:Number = gameObject.position.y - offsetY;
			graphics.lineStyle(lineWidth, 0xff0000, 1);
			drawPositionMark(graphics, dx, dy);
			drawShape(graphics, offsetX, offsetY);
			graphics.lineStyle();
		}
		
		public function drawShape(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void {
			
		}
		
		public function drawIsoShape(graphics:Graphics, x:Number, y:Number, angle:Number, isoX:Number, isoY:Number, isoZ:Number):void {
		
		}
		
		public function drawPositionMark(graphics:Graphics, x:Number, y:Number):void {
			graphics.moveTo(x-4, y);
			graphics.lineTo(x+4, y);
			graphics.moveTo(x, y-4);
			graphics.lineTo(x, y+4);
		}
		
		public function getRoughSize():Number {
			if (roughSize < -1) roughSize = 0;
			return roughSize;
		}
		
		public function projection(dst:Vector3D, unit:Vector3D, distance:Vector3D):void{
			dst.x = 0;
			dst.y = 0;
			dst.z = 0;
		}
		
		public function createProjections():void {
			projections.splice(0, projections.length);
		}
		
		public function createPoints():void {
			points.splice(0, points.length);
		}
		
		public function scale(factor:Number):void {
			for (var i:int; i < points.length; i++) {
				points[i].scaleBy(factor);
			}
		}
		
		public function rotateBy(a:Number):void {
			setOrientation(orientation + a);
		}
		
		public function setOrientation(a:Number):void {
			orientation = MathUtil.normalizeAngle(a);
			orientationVector.x = Math.cos(orientation);
			orientationVector.y = Math.sin(orientation);
			//createProjections();
		}
		
	}
	
}