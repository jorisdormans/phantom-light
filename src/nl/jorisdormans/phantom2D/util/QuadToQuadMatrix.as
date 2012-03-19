package nl.jorisdormans.phantom2D.util 
{
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Joris Dormans
	 * Adapted from a CS source 
	 * http://code.google.com/p/wiimotetuio/source/browse/trunk/WiimoteTUIO/Warper.cs
	 */
	public class QuadToQuadMatrix
	{
		private var warpMat:Vector.<Number>;
		
		public function QuadToQuadMatrix(src:Vector.<Vector3D>, dst:Vector.<Vector3D>) 
		{
			warpMat = new Vector.<Number>();
			computeWarp(src, dst);
		}
		
		
		public function computeWarp(src:Vector.<Vector3D>, dst:Vector.<Vector3D>):void {
                var srcMat:Vector.<Number> = computeQuadToSquare(src);
                var dstMat:Vector.<Number> = computeSquareToQuad(dst);
                warpMat = multMats(srcMat, dstMat);
        }		
		
		private function multMats(srcMat:Vector.<Number>, dstMat:Vector.<Number>):Vector.<Number> {
			var resMat:Vector.<Number> = new Vector.<Number>();
            // DSTDO/CBB: could be faster, but not called often enough to matter
            for (var r:int = 0; r < 4; r++) {
                var ri:int = r * 4;
                for (var c:int = 0; c < 4; c++) {
                    resMat[ri + c] = (srcMat[ri    ] * dstMat[c     ] +
                                      srcMat[ri + 1] * dstMat[c +  4] +
                                      srcMat[ri + 2] * dstMat[c +  8] +
                                      srcMat[ri + 3] * dstMat[c + 12]);
                }
            }
			return resMat;
        }	
		
		
		private function computeSquareToQuad(quad:Vector.<Vector3D>):Vector.<Number> {
			var mat:Vector.<Number> = new Vector.<Number>();
			var dx1:Number = quad[1].x - quad[2].x;
			var dy1:Number = quad[1].y - quad[2].y;
			var dx2:Number = quad[3].x - quad[2].x;
			var dy2:Number = quad[3].y - quad[2].y;
			var sx:Number = quad[0].x - quad[1].x + quad[2].x - quad[3].x;
			var sy:Number = quad[0].y - quad[1].y + quad[2].y - quad[3].y;
			
			var g:Number = (sx * dy2 - dx2 * sy) / (dx1 * dy2 - dx2 * dy1);
			var h:Number = (dx1 * sy - sx * dy1) / (dx1 * dy2 - dx2 * dy1);
			var a:Number = quad[1].x - quad[0].x + g * quad[1].x;
			var b:Number = quad[3].x - quad[0].x + h * quad[3].x;
			var c:Number = quad[0].x;
			var d:Number = quad[1].y - quad[0].y + g * quad[1].y;
			var e:Number = quad[3].y - quad[0].y + h * quad[3].y;
			var f:Number = quad[0].y;

			mat[ 0] = a;    mat[ 1] = d;    mat[ 2] = 0;    mat[ 3] = g;
			mat[ 4] = b;    mat[ 5] = e;    mat[ 6] = 0;    mat[ 7] = h;
			mat[ 8] = 0;    mat[ 9] = 0;    mat[10] = 1;    mat[11] = 0;
			mat[12] = c;    mat[13] = f;    mat[14] = 0;    mat[15] = 1;
			return mat;
		}	
		
		private function computeQuadToSquare(quad:Vector.<Vector3D>):Vector.<Number> {
			var mat:Vector.<Number> = computeSquareToQuad(quad);
                // invert through adjoint
                var a:Number = mat[ 0];
				var d:Number = mat[ 1];
				var g:Number = mat[ 3];
				
                var b:Number = mat[ 4];
				var e:Number = mat[ 5];
				var h:Number = mat[ 7];
				
                // ignore 3rd row 
				
				var c:Number = mat[12];
				var f:Number = mat[13];

                var A:Number =     e - f * h;
                var B:Number = c * h - b;
                var C:Number = b * f - c * e;
                var D:Number = f * g - d;
                var E:Number =     a - c * g;
                var F:Number = c * d - a * f;
                var G:Number = d * h - e * g;
                var H:Number = b * g - a * h;
                var I:Number = a * e - b * d;

                // Probably unnecessary since 'I' is also scaled by the determinant,
                //   and 'I' scales the homogeneous coordinate, which, in turn,
                //   scales the X,Y coordinates.
                // Determinant  =   a * (e - f * h) + b * (f * g - d) + c * (d * h - e * g);
                var idet:Number = 1.0 / (a * A           + b * D           + c * G);

                mat[ 0] = A * idet;     mat[ 1] = D * idet;     mat[ 2] = 0;    mat[ 3] = G * idet;
                mat[ 4] = B * idet;     mat[ 5] = E * idet;     mat[ 6] = 0;    mat[ 7] = H * idet;
                mat[ 8] = 0       ;     mat[ 9] = 0       ;     mat[10] = 1;    mat[11] = 0       ;
                mat[12] = C * idet;     mat[13] = F * idet;     mat[14] = 0;    mat[15] = I * idet;
				
				return mat;
        }	
		
		public function transfromVector(src:Vector3D):Vector3D
        {
            var result:Vector3D = new Vector3D();
            var z:Number = 0;
            result.x = (src.x * warpMat[0] + src.y * warpMat[4] + z * warpMat[8] + 1 * warpMat[12]);
            result.y = (src.x * warpMat[1] + src.y * warpMat[5] + z * warpMat[9] + 1 * warpMat[13]);
            result.z = (src.x * warpMat[2] + src.y * warpMat[6] + z * warpMat[10] + 1 * warpMat[14]);
            result.w = (src.x * warpMat[3] + src.y * warpMat[7] + z * warpMat[11] + 1 * warpMat[15]);        
			
			var r:Vector3D = new Vector3D();
            r.x = result.x/result.w;
            r.y = result.y/result.w;
            return r;
        }	
		
		public static function createQuad(point1:Vector3D, point2:Vector3D, point3:Vector3D, point4:Vector3D):Vector.<Vector3D> {
			var r:Vector.<Vector3D> = new Vector.<Vector3D>();
			r.push(point1, point2, point3, point4);
			return r;
		}		
		
	}
}

