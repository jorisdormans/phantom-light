package nl.jorisdormans.phantom2D.util 
{
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class MathUtil
	{
		
		public function MathUtil() 
		{
			
		}
		
		public static const TO_DEGREES:Number = 180 / Math.PI;
		public static const TO_RADIANS:Number = Math.PI / 180;
		public static const TWO_PI:Number = Math.PI * 2;
		
		
		private static var v:Vector3D = new Vector3D();
		private static var p:Vector3D = new Vector3D();
		
		public static function easeCos(v:Number):Number {
			return 0.5 - Math.cos(v * Math.PI) * 0.5;
		}
		
		/**
		 * Normalizes an angle to a value between -PI and and PI
		 * @param	a
		 * @return
		 */
		public static function normalizeAngle(a:Number):Number {
			a = a % TWO_PI;
			if (a > Math.PI) a -= TWO_PI;
			if (a <= -Math.PI) a += TWO_PI;
			return a;
		}
		
		/**
		 * Returns the difference between the normalized angles target and current. 
		 * @param	target
		 * @param	current
		 * @return
		 */
		public static function angleDifference(target:Number, current:Number):Number {
			target -= current;
			return (normalizeAngle(target));
		}
		
		private static var _sin:Number = 0;
		private static var _cos:Number = 1;
		private static var _angle:Number = 0;
		
		/**
		 * Rotates the vector src by an angle over the z axis and stores the result in vector dst
		 * @param	dst
		 * @param	src
		 * @param	angle
		 */
		public static function rotateVector3D(dst:Vector3D, src:Vector3D, angle:Number):void {
			if (angle != _angle) {
				_sin = Math.sin(angle);
				_cos = Math.cos(angle);
				_angle = angle;
			}
			var x:Number = src.x; //store this value in case dst == src
			dst.x = _cos * src.x - _sin * src.y;
			dst.y = _sin * x + _cos * src.y;
			dst.z = src.z;
		}
		/**
		 * Rotates the vector src by an angle over the z axis and stores the result in vector dst.
		 * A second version of the rotateVector3D to boost performance (collision detection often needs two 'matrices' at the same time)
		 * @param	dst
		 * @param	src
		 * @param	angle
		 */
		private static var _sinb:Number = 0;
		private static var _cosb:Number = 1;
		private static var _angleb:Number = 0;
		public static function rotateVector3Db(dst:Vector3D, src:Vector3D, angle:Number):void {
			if (angle != _angleb) {
				_sinb = Math.sin(angle);
				_cosb = Math.cos(angle);
				_angleb = angle;
			}
			var x:Number = src.x; //store this value in case dst == src
			dst.x = _cosb * src.x - _sinb * src.y;
			dst.y = _sinb * x + _cosb * src.y;
			dst.z = src.z;
		}		
		
		/**
		 * Normalizes vector src and rotates it 90 degrees
		 * @param	dst
		 * @param	src
		 */
		public static function getNormal2D(dst:Vector3D, src:Vector3D):void {
			dst.x = src.x;
			dst.y = src.y;
			dst.z = src.z;
			dst.w = src.w;
			dst.normalize();
			var y:Number = dst.y;
			dst.y = -dst.x;
			dst.x = y;
		}	
		
		/**
		 * Finds the intersection of two line segments
		 * @param	line1Start		The starting point of line segment 1
		 * @param	line1Direction	The unit vector of line segment 1
		 * @param	line1Length		The length of line segment 1
		 * @param	line2Start		The starting point of line segment 2
		 * @param	line2Direction  The unit vector of line segment 2
		 * @param	line2Length		The lenght of line segment 2
		 * @return					The distance of the intersection point from the start of line segment 2
		 */
		public static function intersection(line1Start:Vector3D, line1Direction:Vector3D, line1Length:Number, line2Start:Vector3D, line2Direction:Vector3D, line2Length:Number):Number {
			var v3bx:Number = line2Start.x - line1Start.x;
			var v3by:Number = line2Start.y - line1Start.y;
			var perP1:Number = v3bx * line2Direction.y - v3by * line2Direction.x;
			var perP2:Number = line1Direction.x * line2Direction.y - line1Direction.y * line2Direction.x;
			if (perP2 == 0) return -1;
			var t:Number = perP1 / perP2;
			if (t <= 0 || t>=line1Length) return -1; //in the wrong direction
			var cx:Number = line1Start.x + line1Direction.x * t;
			var cy:Number = line1Start.y + line1Direction.y * t;
			var lx:Number = cx - line2Start.x;
			var ly:Number = cy - line2Start.y;
			var dot:Number = lx * line2Direction.x + ly * line2Direction.y;
			
			if (dot > 0 && dot < line2Length) {
				return dot;
			}
			return -1;
		}		
		
		/**
		 * Calculates the distance of the closest point on a line segment to another point
		 * @param	lineStart		The starting point of the line segment
		 * @param	lineDirection	The unit vector of the line segment
		 * @param	lineLength		The length of the line segment
		 * @param	point			
		 * @return					The distance of the closest point from the starting point.
		 */
		public static function closestPointOnLine(lineStart:Vector3D, lineDirection:Vector3D, lineLength:Number, point:Vector3D):Number {
			var v3bx:Number = point.x - lineStart.x;
			var v3by:Number = point.y - lineStart.y;
			var p:Number = v3bx * lineDirection.x + v3by * lineDirection.y;
			if (p < 0) p = 0;
			if (p > lineLength) p = lineLength;
			return p;
		}	
		
		/**
		 * Calculates the distance between the a point and its closest point on a line segment
		 * @param	lineStart		The starting point of the line segment
		 * @param	lineDirection	The unit vector of the line segment
		 * @param	lineLength		The length of the line segment
		 * @param	point			
		 * @return					The distance between the point and the closest point on the line segment.
		 */
		public static function distanceToLine(lineStart:Vector3D, lineDirection:Vector3D, lineLength:Number, point:Vector3D):Number {
			var p:Number = closestPointOnLine(lineStart, lineDirection, lineLength, point);
			v.x = lineStart.x;
			v.y = lineStart.y;
			v.z = lineStart.z;
			v.x += lineDirection.x * p;
			v.y += lineDirection.y * p;
			return Vector3D.distance(v, point);
		}
		
		/**
		 * Determines if a point is on the right hand side of a line.
		 * @param	point
		 * @param	lineStart
		 * @param	lineUnit
		 * @return
		 */
		public static function pointOnRightSide(point:Vector3D, lineStart:Vector3D, lineUnit:Vector3D):Boolean {
			v.x = lineUnit.y;
			v.y = -lineUnit.x;
			v.z = 0;
			p.x = lineStart.x - point.x;
			p.y = lineStart.y - point.y;
			p.z = 0;
			return v.dotProduct(p)>0;
		}	
		/**
		 * Sets the dst vector to a point on a square determined by the direction of vector src. The square is in position (0, 0).
		 * @param	dst
		 * @param	src
		 * @param	size	The size of the square
		 */
		public static function getSquareOutlinePoint(dst:Vector3D, src:Vector3D, size:Number):void {
			v.x = src.x;
			v.y = src.y;
			v.z = 0;
			v.normalize();
			if (Math.abs(v.x) > Math.abs(v.y)) {
				if (v.x < 0) {
					dst.x = -size;
					dst.y = -size * v.y / v.x;
					dst.z = 0;
				} else {
					dst.x = size;
					dst.y = size * v.y / v.x;
					dst.z = 0;
				}
			} else {
				if (v.y < 0) {
					dst.x = -size * v.x / v.y;
					dst.y = -size;
					dst.z = 0;
				} else {
					dst.x = size * v.x / v.y;
					dst.y = size;
					dst.z = 0;
				}
			}
		}
		
		
		public static function getRectangleOutlinePoint(dst:Vector3D, src:Vector3D, width:Number, height:Number):void {
			var f:Number = height / width;
			src.x *= f;
			getSquareOutlinePoint(dst, src, width);
			dst.y *= f;
			src.x /= f;
		}		
		
		/**
		 * Calculates the squared distance between two vectors
		 * @param	a
		 * @param	b
		 * @return
		 */
		public static function distanceSquared(a:Vector3D, b:Vector3D):Number {
			var dx:Number = a.x - b.x;
			var dy:Number = a.y - b.y;
			var dz:Number = a.z - b.z;
			return dx * dx + dy * dy + dz * dz;
		}
		
		static public function clamp(v:Number, min:Number, max:Number):Number
		{
			return Math.max(Math.min(v, max), min);
		}
		
		public static function getBezierPosition(dest:Vector3D, startX:Number, startY:Number, controlX:Number, controlY:Number, endX:Number, endY:Number, t:Number):void {
			dest.x = (1 - t) * (1 - t) * startX + 2 * (1 - t) * t * controlX + t * t * endX;
			dest.y = (1 - t) * (1 - t) * startY + 2 * (1 - t) * t * controlY + t * t * endY;
		}
		
		
		public static function getBezierNormal(dest:Vector3D, startX:Number, startY:Number, controlX:Number, controlY:Number, endX:Number, endY:Number, t:Number):void {
			v.x = (1 - t) * (1 - t) * startX + 2 * (1 - t) * t * controlX + t * t * endX;
			v.y = (1 - t) * (1 - t) * startY + 2 * (1 - t) * t * controlY + t * t * endY;
			t += 0.01;
			p.x = (1 - t) * (1 - t) * startX + 2 * (1 - t) * t * controlX + t * t * endX;
			p.y = (1 - t) * (1 - t) * startY + 2 * (1 - t) * t * controlY + t * t * endY;
			v.x -= p.x;
			v.y -= p.y;
			var ds:Number = Math.sqrt(v.x * v.x + v.y * v.y );
			if (ds == 0) {
				dest.x = 0;
				dest.y = -1;
			} else {
				dest.x = -v.y / ds;
				dest.y = v.x / ds;
			}
		}
		

		
		
		
	}

}