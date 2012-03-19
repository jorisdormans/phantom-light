package nl.jorisdormans.phantom2D.objects 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Camera;
	import nl.jorisdormans.phantom2D.objects.shapes.*;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class CollisionData 
	{
		/**
		 * The distance (in pixels) of overlap between two objects
		 */
		public var interpenetration:Number;
		/**
		 * The normal of the collision
		 */
		public var normal:Vector3D;
		/**
		 * The approximate position of the collision
		 */
		public var position:Vector3D;
		/**
		 * The interpenetration value that indicates no collision 
		 */
		public static const NO_INTERPENETRATION:Number = 1000;
		/**
		 * This constant determines how quickly multiple points are found
		 */
		public static const COLLISION_POINT_DISTANCE:int = 2; 
		
		/**
		 * A static pooled instance of the collisionData class.
		 */
		public static var data:CollisionData = new CollisionData();
		
		/**
		 * Static vectors to speed up calculation (and prevents creating too many instances)
		 */
		private static var distance:Vector3D = new Vector3D();
		private static var distance2:Vector3D = new Vector3D();
		private static var u:Vector3D = new Vector3D();
		private static var p:Vector3D = new Vector3D();
		
		public static var doIsometric:Boolean = false;
		
		
		
		public function CollisionData() 
		{
			interpenetration = NO_INTERPENETRATION;
			normal = new Vector3D(0, 0, 0);
			position = new Vector3D(0, 0, 0);
		}
		
		/**
		 * Clears the collission data
		 */
		public function clear():void {
			interpenetration = NO_INTERPENETRATION;
			normal.x = 0;
			normal.y = 0;
			normal.z = 0;
			normal.w = 0;
			position.x = 0;
			position.y = 0;
			position.z = 0;
			position.w = 0;
		}
		
		/**
		 * Inverts the collission data
		 */
		public function invert():void {
			normal.scaleBy( -1);
		}
		
		/**
		 * A quick check if two shapes might overlap
		 * @param	shape1
		 * @param	shape2
		 * @return
		 */
		public static function roughCheck(object1:GameObject, object2:GameObject):Boolean
		{
			if (!object1.shape || !object2.shape) return false;
			var r:Number = (object1.shape.getRoughSize() + object2.shape.getRoughSize()) / 2;
			distance.x = object1.position.x - object2.position.x;
			distance.y = object1.position.y - object2.position.y;
			distance.z = object1.position.z - object2.position.z;
			return (r > Math.abs(distance.x) || r > Math.abs(distance.y));
		}
		
		/**
		 * The accurate check for a collission between two shapes
		 * @param	shape1
		 * @param	shape2
		 * @return
		 */
		public static function check(object1:GameObject, object2:GameObject):CollisionData
		{
			data.clear();
			if (!object1.shape || !object2.shape) return data;
			//var distance:Vector3D = shape1.position.subtract(shape2.position);
			distance.x = object1.position.x - object2.position.x;
			distance.y = object1.position.y - object2.position.y;
			distance.z = object1.position.z - object2.position.z;
			
			//check iso
			if (doIsometric) {
				var i:Number = (object1.position.z + object1.shape.isoHeight - object2.position.z);
				if (i>=0) {
					data.interpenetration = i;
					data.normal.x = 0;
					data.normal.y = 0;
					data.normal.z = 1;
				} else {
					data.clear();
					return data;
				}
				i = (object2.position.z + object2.shape.isoHeight - object1.position.z);
				if (i>=0 && i<data.interpenetration) {
					data.interpenetration = i;
					data.normal.x = 0;
					data.normal.y = 0;
					data.normal.z = -1;
				} else if (i<0) {
					data.clear();
					return data;
				}
			}
			
			if (object1.shape is BoundingCircle && object2.shape is BoundingCircle) return checkCircleCircle(object1, object2, distance);
			else if (object1.shape is BoundingCircle) return checkCircleOther(object1, object2, distance, false);
			else if (object2.shape is BoundingCircle) return checkCircleOther(object2, object1, distance, true);
			else return checkOtherOther(object1, object2, distance);
		}
		
		/**
		 * The real check of two shapes that are not circles
		 * @param	shape1
		 * @param	shape2
		 * @param	distance
		 * @return
		 */
		protected static function checkOtherOther(object1:GameObject, object2:GameObject, distance:Vector3D):CollisionData
		{
			var shape1:BoundingShape = object1.shape;
			var shape2:BoundingShape = object2.shape;
			//feedback = new Vector.<Vector3D>();
			var i:int;
			var inter1:Number;
			var inter2:Number;
			//var p:Vector3D;
			//var p:Vector3D;
			//var u:Vector3D;
			var lookingAt:GameObject = object1;

			//project shape2 onto shape1
			distance2.x = -distance.x;
			distance2.y = -distance.y;
			distance2.z = -distance.z;
			MathUtil.rotateVector3D(distance2, distance2, -shape2.orientation);
			for (i = 0; i < shape1.projections.length; i += 2) {
				MathUtil.rotateVector3D(u, shape1.projections[i], shape1.orientation - shape2.orientation);
				shape2.projection(p, u, distance2);
				inter1 = shape1.projections[i + 1].y - p.x;
				inter2 = -(shape1.projections[i + 1].x - p.y);
				
				//no interpenetration thus no collision
				if (inter1 <= 0 || inter2 <= 0) {
					data.clear();
					return data;
				}

				MathUtil.rotateVector3D(u, shape1.projections[i], shape1.orientation);
				//feedback.push(new Vector3D(shape1.position.x + u.x * shape1.projections[i + 1].x, shape1.position.y + u.y * shape1.projections[i + 1].x));
				//feedback.push(new Vector3D(shape1.position.x + u.x * shape1.projections[i + 1].y, shape1.position.y + u.y * shape1.projections[i + 1].y));
				//feedback.push(new Vector3D(shape1.position.x + u.x*p.x, shape1.position.y + u.y*p.x, 0));
				//feedback.push(new Vector3D(shape1.position.x + u.x*p.y, shape1.position.y + u.y*p.y, 0));
				
				if (shape2.gameObject && shape2.gameObject.mover) {
					//Only use the interpenetration in the directions of object1 if object2 is a moving object
					if (inter1 < inter2 && inter1 < data.interpenetration) {
						data.interpenetration = inter1;
						data.normal.x = u.x;
						data.normal.y = u.y;
						data.normal.z = 0;
						lookingAt = object2;
					} else if (inter2 < data.interpenetration) {
						data.interpenetration = inter2;
						data.normal.x = -u.x;
						data.normal.y = -u.y;
						data.normal.z = 0;
						lookingAt = object2;
					}
				}
				
			}
			
			//project shape1 onto shape2
			MathUtil.rotateVector3D(distance2, distance, -shape1.orientation);
			for (i = 0; i < shape2.projections.length; i += 2) {
				MathUtil.rotateVector3D(u, shape2.projections[i], shape2.orientation - shape1.orientation);
				shape1.projection(p, u, distance2);
				inter1 = shape2.projections[i + 1].y - p.x;
				inter2 = -(shape2.projections[i + 1].x - p.y);
				
				MathUtil.rotateVector3D(u, shape2.projections[i], shape2.orientation);
				
				//feedback.push(new Vector3D(shape2.position.x + u.x * shape2.projections[i + 1].x, shape2.position.y + u.y * shape2.projections[i + 1].x));
				//feedback.push(new Vector3D(shape2.position.x + u.x * shape2.projections[i + 1].y, shape2.position.y + u.y * shape2.projections[i + 1].y));
				//feedback.push(new Vector3D(shape2.position.x + u.x*p.x, shape2.position.y + u.y*p.x, 0));
				//feedback.push(new Vector3D(shape2.position.x + u.x*p.y, shape2.position.y + u.y*p.y, 0));

				//no interpenetration thus no collision
				if (inter1 <= 0 || inter2 <= 0) {
					data.clear();
					return data;
				}
				
				if (inter1 < inter2 && inter1 < data.interpenetration) {
					data.interpenetration = inter1;
					data.normal.x = -u.x;
					data.normal.y = -u.y;
					data.normal.z = 0;
					lookingAt = object1;
				} else if (inter2 < data.interpenetration) {
					data.interpenetration = inter2;
					data.normal.x = u.x;
					data.normal.y = u.y;
					data.normal.z = 0;
					lookingAt = object1;
				}
			}
			
			if (shape1 is BoundingLine && (shape1 as BoundingLine).oneWay>0) {
				if (data.normal.dotProduct((shape1 as BoundingLine).normal) < 0 || data.interpenetration>(shape1 as BoundingLine).oneWay) {
					data.clear();
					return data;
				}
			}
			
			if (shape2 is BoundingLine && (shape2 as BoundingLine).oneWay>0) {
				if (data.normal.dotProduct((shape2 as BoundingLine).normal) > 0 || data.interpenetration>(shape2 as BoundingLine).oneWay) {
					data.clear();
					return data;
				}
			}
			//determine the point of collision
			data.position.x = lookingAt.position.x;
			data.position.y = lookingAt.position.y;
			var f:int = (lookingAt == object1)? -1: 1;
			//f = 1;
			var d:Number;
			var l:Number = 0;
			
			p.x = 0;
			p.y = 0;
			p.z = 0;
			
			//vector u will hold the correct point
			u.x = 0;
			u.y = 0;
			u.z = 0;
			
			for (i = 0; i < lookingAt.shape.points.length; i++) {
				//p = m.transformVector(lookingAt.points[i]);
				MathUtil.rotateVector3D(p, lookingAt.shape.points[i], lookingAt.shape.orientation);
				d = p.dotProduct(data.normal) * f;
				if (d < l + COLLISION_POINT_DISTANCE) {
					l = d;
					u.x = p.x;
					u.y = p.y;
					u.z = p.z;
				} else if (d < l - COLLISION_POINT_DISTANCE) {
					l = d;
					u.incrementBy(p);
					u.scaleBy(0.5);
				}
			}
			
			data.position.incrementBy(u);
			
			//feedback.push(new Vector3D(data.position.x, data.position.y));
			//feedback.push(new Vector3D(data.position.x + data.normal.x*data.interpenetration, data.position.y + data.normal.y*data.interpenetration));
			//feedback.push(new Vector3D(data.position.x + data.normal.y*5, data.position.y - data.normal.x*5));
			//feedback.push(new Vector3D(data.position.x - data.normal.y*5, data.position.y + data.normal.x*5));

			return data;
		}
		
		/**
		 * Real check between two cirlces
		 * @param	circle1
		 * @param	circle2
		 * @param	distance
		 * @return
		 */

		protected static function checkCircleCircle(object1:GameObject, object2:GameObject, distance:Vector3D):CollisionData {
			var circle1:BoundingCircle = object1.shape as BoundingCircle;
			var circle2:BoundingCircle = object2.shape as BoundingCircle;
			distance.z = 0;
			var r:Number = (circle1.radius + circle2.radius) - distance.length;
			
			if (r < 0) {
				data.clear();
				return data;
			} else if (r<data.interpenetration) {
				//calculate interpenetration
				data.normal.x = distance.x;
				data.normal.y = distance.y;
				data.normal.z = 0;
				data.normal.normalize();
				data.normal.scaleBy( -1);
				data.interpenetration = r;
				data.position.x = object1.position.x;
				data.position.y = object1.position.y;
				data.position.x += (-circle1.radius + data.interpenetration * 0.5)* data.normal.x;
				data.position.y += (-circle1.radius + data.interpenetration * 0.5)* data.normal.y;
			}
			return data;
		}
		
		/**
		 * The real collision check between a circle and a non-circle
		 * @param	circle
		 * @param	other
		 * @param	distance
		 * @param	reversed
		 * @return
		 */
		
		protected static function checkCircleOther(object1:GameObject, object2:GameObject, distance:Vector3D, reversed:Boolean = false):CollisionData
		{
			var circle:BoundingCircle = object1.shape as BoundingCircle;
			var other:BoundingShape = object2.shape;
			
			//feedback = new Vector.<Vector3D>();
			var i:int;
			var inter1:Number;
			var inter2:Number;
			
			if (reversed) distance.scaleBy( -1);
			
			for (i = 0; i < other.projections.length; i += 2) {
				MathUtil.rotateVector3D(u, other.projections[i], other.orientation);
				circle.projection(p, u, distance);
				//feedback.push(new Vector3D(other.position.x+u.x*p.x, other.position.y+u.y*p.x));
				//feedback.push(new Vector3D(other.position.x+u.x*p.y, other.position.y+u.y*p.y));
				
				inter1 = other.projections[i + 1].y - p.x;
				inter2 = p.y - other.projections[i + 1].x;
				
				//no interpenetration thus no collision
				if (inter1 <= 0 || inter2 <= 0) {
					data.clear();
					return data;
				}
				
				if (inter1 < inter2 && inter1 < data.interpenetration) {
					data.interpenetration = inter1;
					if (reversed) {
						data.normal.x = u.x;
						data.normal.y = u.y;
						data.normal.z = 0;
					} else {
						data.normal.x = -u.x;
						data.normal.y = -u.y;
						data.normal.z = 0;
					}					
				} else if (inter2 < data.interpenetration) {
					data.interpenetration = inter2;
					if (reversed) {
						data.normal.x = -u.x;
						data.normal.y = -u.y;
						data.normal.z = 0;
					} else {
						data.normal.x = u.x;
						data.normal.y = u.y;
						data.normal.z = 0;
					}					
				}				
			}
			
			MathUtil.rotateVector3D(distance2, distance, -other.orientation);
			
			//check collision on projection from other points to the center of the circle
			for (i = 0; i < other.points.length; i++) {
				MathUtil.rotateVector3D(u, other.points[i], -other.orientation);
				u.incrementBy(distance2);
				u.normalize();
				//for some reason I had this earlier with certain shapes, do not know why...
				//MathUtil.getNormal2D(u, u);
				
				other.projection(p, u, distance2);
				
				//feedback.push(new Vector3D(other.position.x+u.x*p.x, other.position.y+u.y*p.x));
				//feedback.push(new Vector3D(other.position.x + u.x * p.y, other.position.y + u.y * p.y));
				
				inter1 = circle.radius - p.x;
				inter2 = p.y + circle.radius;

				//no interpenetration thus no collision
				if (inter1 <= 0 || inter2 <= 0) {
					data.clear();
					return data;
				}
				
				if (inter1 < inter2 && inter1 < data.interpenetration) {
					data.interpenetration = inter1;
					
					if (reversed) {
						data.normal.x = u.x;
						data.normal.y = u.y;
					} else {
						data.normal.x = -u.x;
						data.normal.y = -u.y;
					}					
					
				} else if (inter2 < data.interpenetration) {
					data.interpenetration = inter2;
					if (reversed) {
						data.normal.x = -u.x;
						data.normal.y = -u.y;
					} else {
						data.normal.x = u.x;
						data.normal.y = u.y;
					}					
				}
			}
		
			data.position.x = object1.position.x;
			data.position.y = object1.position.y;
			if (reversed) {
				data.position.x += ( -circle.radius + data.interpenetration * 0.5)* data.normal.x;
				data.position.y += ( -circle.radius + data.interpenetration * 0.5)* data.normal.y;
			} else {
				data.position.x -= ( -circle.radius + data.interpenetration * 0.5)* data.normal.x;
				data.position.y -= ( -circle.radius + data.interpenetration * 0.5)* data.normal.y;
			}			
			
			//feedback.push(new Vector3D(data.position.x, data.position.y));
			//feedback.push(new Vector3D(data.position.x + data.normal.x*data.interpenetration, data.position.y + data.normal.y*data.interpenetration));
			
			//feedback.push(new Vector3D(data.position.x + data.normal.y*5, data.position.y - data.normal.x*5));
			//feedback.push(new Vector3D(data.position.x - data.normal.y*5, data.position.y + data.normal.x*5));
			
			return data;
		}
		
		
		/**
		 * A vector with drawing instructions to visualize collission data
		 */
		/*
		public static var feedback:Vector.<Vector3D>;
		public static function drawFeedback(graphics:Graphics, camera:Camera):void {
			if (feedback == null || feedback.length == 0) return;
			for (var i:int = 0; i < feedback.length; i += 2) {
				if (i % 4 == 0) graphics.lineStyle(2, 0xffff00);
				else graphics.lineStyle(2, 0x00ff00);
				graphics.moveTo(feedback[i].x - camera.left, feedback[i].y - camera.top); 
				graphics.lineTo(feedback[i+1].x - camera.left, feedback[i+1].y - camera.top); 
				graphics.lineStyle();
			}
		}
		//*/
	}
	
}