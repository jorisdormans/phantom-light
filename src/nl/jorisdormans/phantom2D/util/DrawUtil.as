package nl.jorisdormans.phantom2D.util 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class DrawUtil
	{
		
		public function DrawUtil() 
		{
			
		}
		
		public static const moveTo:int = 0;
		public static const lineTo:int = 1;
		public static const curveTo:int = 2;
		public static function drawPolygon(graphics:Graphics, x:Number, y:Number, polygon:Array, scaleX:Number=1, scaleY:Number=1):void {
			var p:int = 0;
			var t:int;
			var x1:Number;
			var x2:Number;
			var y1:Number;
			var y2:Number;
			while (p < polygon.length) {
				t = (polygon[p] as int);
				switch (t) {
					default:
					case moveTo:
						x1 = (polygon[p + 1] as Number)*scaleX;
						y1 = (polygon[p + 2] as Number)*scaleY;
						graphics.moveTo(x + x1, y + y1);
						p += 3;
						break;
					case lineTo:
						x1 = (polygon[p + 1] as Number)*scaleX;
						y1 = (polygon[p + 2] as Number)*scaleY;
						graphics.lineTo(x + x1, y + y1);
						p += 3;
						break;
					case curveTo:
						x1 = (polygon[p + 1] as Number)*scaleX;
						y1 = (polygon[p + 2] as Number)*scaleY;
						x2 = (polygon[p + 3] as Number)*scaleX;
						y2 = (polygon[p + 4] as Number)*scaleY;
						graphics.curveTo(x + x2, y + y2, x + x1, y + y1);
						p += 5;
						break;
				}
			}
		}
		
		public static function drawPolygonAngled(graphics:Graphics, x:Number, y:Number, polygon:Array, angle:Number, scaleX:Number=1, scaleY:Number=1):void {
			var p:int = 0;
			var t:int;
			var x1:Number;
			var x2:Number;
			var y1:Number;
			var y2:Number;
			angle+= Math.PI * 0.5;
			var cos:Number = Math.cos(angle);
			var sin:Number = Math.sin(angle);
			while (p < polygon.length) {
				t = (polygon[p] as int);
				switch (t) {
					default:
					case moveTo:
						x1 = (polygon[p + 1] as Number)*scaleX;
						y1 = (polygon[p + 2] as Number)*scaleY;
						graphics.moveTo(x + cos*x1-sin*y1, y + cos*y1+sin*x1);
						p += 3;
						break;
					case lineTo:
						x1 = (polygon[p + 1] as Number)*scaleX;
						y1 = (polygon[p + 2] as Number)*scaleY;
						graphics.lineTo(x + cos*x1-sin*y1, y + cos*y1+sin*x1);
						p += 3;
						break;
					case curveTo:
						x1 = (polygon[p + 1] as Number)*scaleX;
						y1 = (polygon[p + 2] as Number)*scaleY;
						x2 = (polygon[p + 3] as Number)*scaleX;
						y2 = (polygon[p + 4] as Number)*scaleY;
						graphics.curveTo(x + cos*x2-sin*y2, y + cos*y2+sin*x2, x + cos*x1-sin*y1, y + cos*y1+sin*x1);
						p += 5;
						break;
				}
			}
		}	
		
		public static function colorToIllumination(color:uint):Number {
			var red1:uint = (color & 0xff0000) >> 16;
			var green1:uint = (color & 0x00ff00) >> 8;
			var blue1:uint = color & 0x0000ff;
			var il:uint = red1 + (green1 << 1) + blue1;
			return (il / 1024);
		}
		
		
		public static function lerpColor(color1:uint, color2:uint, f:Number):uint {
			var red1:uint = (color1 & 0xff0000) >> 16;
			var green1:uint = (color1 & 0x00ff00) >> 8;
			var blue1:uint = color1 & 0x0000ff;

			var red2:uint = (color2 & 0xff0000) >> 16;
			var green2:uint = (color2 & 0x00ff00) >> 8;
			var blue2:uint = color2 & 0x0000ff;
			
			red1 += Math.round((red2 - red1) * f);
			green1 += Math.round((green2 - green1) * f);
			blue1 += Math.round((blue2 - blue1) * f);
			
			return ((red1 << 16) | (green1 << 8) | blue1);
		}	
		
		public static var strokeWidthAdjust:Number = 0.7;
		
		public static function drawCircleToSVG(x:Number, y:Number, r:Number, fill:String, stroke:String, strokeWidth:Number):XML {
			var svg:XML = <circle/>;
			svg.@cx = x.toFixed(2);
			svg.@cy = y.toFixed(2);
			svg.@r = r.toFixed(2);
			if (stroke !=null) {
				svg.@stroke = stroke;
				svg.@["stroke-width"] = (strokeWidth * strokeWidthAdjust).toFixed(1);
			}
			if (fill !=null) {
				svg.@fill = fill;
			}
			return svg;
			
		}
		
		public static function drawRectToSVG(x:Number, y:Number, w:Number, h:Number, fill:String, stroke:String, strokeWidth:Number):XML {
			var svg:XML = <rect/>;
			svg.@x = x.toFixed(2);
			svg.@y = y.toFixed(2);
			svg.@width = w.toFixed(2);
			svg.@height = h.toFixed(2);
			if (stroke !=null) {
				svg.@stroke = stroke;
				svg.@["stroke-width"] = (strokeWidth * strokeWidthAdjust).toFixed(1);
			}
			if (fill !=null) {
				svg.@fill = fill;
			}
			return svg;
		}	
		
		public static function drawRoundRectToSVG(x:Number, y:Number, w:Number, h:Number, rx:Number, ry:Number, fill:String, stroke:String, strokeWidth:Number):XML {
			var svg:XML = <rect/>;
			svg.@x = x.toFixed(2);
			svg.@y = y.toFixed(2);
			svg.@width = w.toFixed(2);
			svg.@height = h.toFixed(2);
			svg.@rx = rx.toFixed(2);
			svg.@ry = ry.toFixed(2);
			if (stroke !=null) {
				svg.@stroke = stroke;
				svg.@["stroke-width"] = (strokeWidth * strokeWidthAdjust).toFixed(1);
			}
			if (fill !=null) {
				svg.@fill = fill;
			}
			return svg;
			
		}	
		
		public static function drawPathToSVG(commands:Vector.<int>, data:Vector.<Number>, fill:String, stroke:String, strokeWidth:Number):XML {
			var d:String = "";
			var di:int = 0;
			for (var i:int = 0; i < commands.length; i++) {
				switch (commands[i]) {
					case GraphicsPathCommand.WIDE_MOVE_TO:
						d += " M " + data[di + 2].toFixed(2) + " " + data[di + 3].toFixed(2);
						di += 4;
						break;
					case GraphicsPathCommand.MOVE_TO:
						d += " M " + data[di].toFixed(2) + " " + data[di + 1].toFixed(2);
						di += 2;
						break;
					case GraphicsPathCommand.WIDE_LINE_TO:
						d += " L " + data[di + 2].toFixed(2) + " " + data[di + 3].toFixed(2);
						di += 4;
						break;
					case GraphicsPathCommand.LINE_TO:
						d += " L " + data[di].toFixed(2) + " " + data[di + 1].toFixed(2);
						di += 2;
						break;
					case GraphicsPathCommand.CURVE_TO:
					    var cx:Number = data[di];
					    var cy:Number = data[di + 1];
						if (i>0 && commands[i-1] == GraphicsPathCommand.CURVE_TO) {
							cx = data[di + 2] + (data[di + 0] - data[di + 2]) * 0.5;
							cy = data[di + 3] + (data[di + 1] - data[di + 3]) * 0.5;
						}
						d += " S " + cx.toFixed(2) + " " + cy.toFixed(2) + " " + data[di + 2].toFixed(2) + " " + data[di + 3].toFixed(2);
						di += 4;
						break;
				}
			}	
			if (d.charAt(0) == " ") d = d.substr(1);
					
			var svg:XML = <path/>;
			svg.@d = d;
			if (stroke !=null) {
				svg.@stroke = stroke;
				svg.@["stroke-width"] = (strokeWidth * strokeWidthAdjust).toFixed(1);
			}
			if (fill !=null) {
				svg.@fill = fill;
			}
			
			
			return svg;
		}
		
	}

}