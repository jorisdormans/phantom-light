package nl.jorisdormans.phantom2D.graphics 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.util.DrawUtil;
	import nl.jorisdormans.phantom2D.util.StringUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomShape
	{
		private var _data:Vector.<Number>;
		private var _commands:Vector.<int>;
		private var _processedData:Vector.<Number>;
		private var _translation:Vector3D;
		private var _scale:Vector3D;
		private var _rotation:Number;
		public var winding:String = GraphicsPathWinding.EVEN_ODD;
		
		
		public function PhantomShape(commands:Array, data:Array, winding:int) 
		{
			_commands = new Vector.<int>();
			for (var i:int = 0; i < commands.length; i++) {
				_commands.push(commands[i]);
			}
			_data = new Vector.<Number>();
			_processedData = new Vector.<Number>();
			
			for (i = 0; i < data.length; i++) {
				_data.push(data[i]);
				_processedData.push(data[i]);
			}
			
			_translation = new Vector3D();
			_scale = new Vector3D(1, 1);
			_rotation = 0;
			
			switch (winding) {
				case 0:
					this.winding = GraphicsPathWinding.EVEN_ODD;
					break;
				case 1:
					this.winding = GraphicsPathWinding.NON_ZERO;
					break;
			}
		}
		
		public function copy():PhantomShape {
			var c:PhantomShape = new PhantomShape(new Array(), new Array(), 0);
			for (var i:int = 0; i < _commands.length; i++) {
				c._commands.push(_commands[i]);
			}
			for (i = 0; i < _data.length; i++) {
				c._data.push(_data[i]);
				c._processedData.push(_data[i]);
			}
			c.winding = winding;
			return c;
		}
		
		public function draw(graphics:Graphics, x:Number, y:Number):void {
			if (_translation.x != x || _translation.y != y || _scale.x != 1 || _scale.y != 1 || _rotation != 0) {
				for (var i:int = 0; i < _data.length; i+=2) {
					_processedData[i] = _data[i] + x;
					_processedData[i + 1] = _data[i + 1] + y;
					_translation.x = x;
					_translation.y = y;
					_scale.x = 1;
					_scale.y = 1;
					_rotation = 0;
				}
			}
			
			graphics.drawPath(_commands, _processedData, winding);
		}
		
		public function drawScaled(graphics:Graphics, x:Number, y:Number, scaleX:Number, scaleY:Number):void {
			if (_translation.x != x || _translation.y != y || _scale.x != scaleX || _scale.y != scaleY || _rotation != 0) {
				for (var i:int = 0; i < _data.length; i+=2) {
					_processedData[i] = _data[i] * scaleX + x;
					_processedData[i + 1] = _data[i + 1] * scaleY + y;
					_translation.x = x;
					_translation.y = y;
					_scale.x = scaleX;
					_scale.y = scaleY;
					_rotation = 0;
				}
			}
			
			graphics.drawPath(_commands, _processedData, winding);
		}
		
		public function drawScaledRotated(graphics:Graphics, x:Number, y:Number, scaleX:Number, scaleY:Number, rotation:Number):void {
			if (_translation.x != x || _translation.y != y || _scale.x != scaleX || _scale.y != scaleY || _rotation != rotation) {
				var cos:Number = Math.cos(rotation);
				var sin:Number = Math.sin(rotation);
				var dx:Number;
				var dy:Number;
				for (var i:int = 0; i < _data.length; i += 2) {
					dx = _data[i] * scaleX;
					dy = _data[i+1] * scaleY;
					_processedData[i] = cos * dx - sin * dy + x;
					_processedData[i + 1] = cos * dy + sin * dx + y;
					_translation.x = x;
					_translation.y = y;
					_scale.x = scaleX;
					_scale.y = scaleY;
					_rotation = rotation;
				}
			}
			
			graphics.drawPath(_commands, _processedData, winding);
		}
		
		public function drawRotated(graphics:Graphics, x:Number, y:Number, rotation:Number):void {
			if (_translation.x != x || _translation.y != y || _scale.x != 1 || _scale.y != 1 || _rotation != rotation) {
				var cos:Number = Math.cos(rotation);
				var sin:Number = Math.sin(rotation);
				for (var i:int = 0; i < _data.length; i += 2) {
					_processedData[i] = cos * _data[i] - sin * _data[i+1] + x;
					_processedData[i + 1] = cos * _data[i+1] + sin * _data[i] + y;
					_translation.x = x;
					_translation.y = y;
					_scale.x = 1;
					_scale.y = 1;
					_rotation = rotation;
				}
			}
			
			graphics.drawPath(_commands, _processedData);
		}
		
		public function getPointType(index:int):int {
			if (index < _commands.length) return _commands[index];
			else return 0;
		}		
		
		public function getPoint(index:int):Vector3D {
			if (index * 4 < _data.length) {
				return new Vector3D(_data[index * 4 + 2], _data[index * 4 + 3]);
			}
			return null;
		}
		
		public function setPoint(index:int, p:Vector3D):void {
			if (index * 4 < _data.length) {
				_data[index * 4 + 2] = p.x;
				_data[index * 4 + 3] = p.y;
				_translation.x += 1;
			}
		}
		
		public function getControlPoint(index:int):Vector3D {
			if (index * 4 < _data.length) {
				return new Vector3D(_data[index * 4 + 0], _data[index * 4 + 1]);
			}
			return null;
		}
		
		public function setControlPoint(index:int, p:Vector3D):void {
			if (index * 4 < _data.length) {
				_data[index * 4 + 0] = p.x;
				_data[index * 4 + 1] = p.y;
				_translation.x += 1;
			}
		}		
		
		public function get pointCount():int {
			return _data.length * 0.25;
		}
		
		public function addPoint(index:int, type:int):void {
			var d:Vector3D = new Vector3D();
			if (index == pointCount - 1) {
				if (index == 0) {
					d.x = 20;
					d.y = 20;
				} else {
					d.x = _data[index * 4 + 2] - _data[index * 4 - 2];
					d.y = _data[index * 4 + 3] - _data[index * 4 - 1];
				}
				_data.push(0);
				_data.push(0);
				_data.push(_data[index * 4 + 2] + d.x);
				_data.push(_data[index * 4 + 3] + d.y);
				_processedData.push(0);
				_processedData.push(0);
				_processedData.push(0);
				_processedData.push(0);
				_translation.x += 1;
				_commands.push(type);
			} else {
				d.x = 0.5 * (_data[index * 4 + 2] - _data[index * 4 + 6]);
				d.y = 0.5 * (_data[index * 4 + 3] - _data[index * 4 + 7]);
				_data.splice(index * 4 + 4, 0, 0, 0, _data[index * 4 + 2] - d.x, _data[index * 4 + 3] - d.y);
				_commands.splice(index + 1, 0, type);
				_translation.x += 1;
			}
		}
		
		public function addPointToEnd(p:Vector3D, type:int):void {
			_data.push(0);
			_data.push(0);
			_data.push(p.x);
			_data.push(p.y);
			_processedData.push(0);
			_processedData.push(0);
			_processedData.push(p.x);
			_processedData.push(p.y);
			_translation.x += 1;
			_commands.push(type);
			
		}
		
		public function removePoint(index:int):void {
			if (index == 0) return;
			_data.splice(index * 4, 4);
			_processedData.splice(index * 4, 4);
			_commands.splice(index, 1);
			_translation.x += 1;
		}
		
		public function changePoint(index:int):void {
			if (index == 0) return;
			var t:int = _commands[index];
			switch (t) {
				case GraphicsPathCommand.WIDE_LINE_TO:
					t = GraphicsPathCommand.CURVE_TO;
					break;
				case GraphicsPathCommand.CURVE_TO:
					t = GraphicsPathCommand.WIDE_MOVE_TO;
					break;
				case GraphicsPathCommand.WIDE_MOVE_TO:
					t = GraphicsPathCommand.WIDE_LINE_TO;
					break;
			}
			var x:Number = (_data[index * 4 + 2] + _data[index * 4 - 2]) * 0.5; 
			var y:Number = (_data[index * 4 + 3] + _data[index * 4 - 1]) * 0.5; 
			_data[index * 4 + 0] = x;
			_data[index * 4 + 1] = y;
			_commands[index] = t;
			_translation.x += 1;
		}
		
		public function smoothPoint(index:int):void {
			if (index == 0) return;
			var p1:Vector3D = new Vector3D();
			var p2:Vector3D = new Vector3D();
			if (index > 0) {
				var t:int = _commands[index];
				switch (t) {
					case GraphicsPathCommand.WIDE_LINE_TO:
						p1.x = _data[index * 4 - 2];
						p1.y = _data[index * 4 - 1];
						break;
					case GraphicsPathCommand.CURVE_TO:
						p1.x = _data[index * 4 + 0];
						p1.y = _data[index * 4 + 1];
						break;
					}
				if (index<_commands.length-1) {
					t = _commands[index + 1];
				
					switch (t) {
						case GraphicsPathCommand.WIDE_LINE_TO:
							p2.x = _data[index * 4 + 6];
							p2.y = _data[index * 4 + 7];
							break;
						case GraphicsPathCommand.CURVE_TO:
							p2.x = _data[index * 4 + 4];
							p2.y = _data[index * 4 + 5];
							break;
						}
				} else {
					p2.x = _data[2];
					p2.y = _data[3];
				}
				_data[index * 4 + 2] = 0.5 * (p1.x + p2.x);
				_data[index * 4 + 3] = 0.5 * (p1.y + p2.y);
			}
			_commands[index] = t;
			_translation.x += 1;
		}	
		
		public function translate(dx:Number, dy:Number):void {
			for (var i:int; i < _data.length; i += 2) {
				_data[i] += dx;
				_data[i + 1] += dy;
			}
			_translation.x += 1;
		}
		
		public function scaleBy(fx:Number, fy:Number):void {
			for (var i:int; i < _data.length; i += 2) {
				_data[i] *= fx;
				_data[i + 1] *= fy;
			}
			_translation.x += 1;
		}
		
		
		
		public function createString():String {
			var start:Boolean = true;
			var c:String = "";
			var d:String = "";
			for (var i:int = 0; i < _commands.length; i++) {
				if (start) {
					start = false;
				} else {
					c += ", ";
					d += ", ";
				}
				switch (_commands[i]) {
					case GraphicsPathCommand.WIDE_MOVE_TO:
					case GraphicsPathCommand.MOVE_TO:
						c += GraphicsPathCommand.MOVE_TO.toString();
						d += _data[i * 4 + 2].toFixed(2) + ", " + _data[i * 4 + 3].toFixed(2);
						break;
					case GraphicsPathCommand.WIDE_LINE_TO:
					case GraphicsPathCommand.LINE_TO:
						c += GraphicsPathCommand.LINE_TO.toString();
						d += _data[i * 4 + 2].toFixed(2) + ", " + _data[i * 4 + 3].toFixed(2);
						break;
					case GraphicsPathCommand.CURVE_TO:
						c += GraphicsPathCommand.CURVE_TO.toString();
						d += _data[i * 4].toFixed(2) + ", " + _data[i * 4 + 1].toFixed(2) +", " + _data[i * 4 + 2].toFixed(2) + ", " + _data[i * 4 + 3].toFixed(2);
						break;
				}
			}
			
			var w:String = "";
			switch (winding) {
				case GraphicsPathWinding.EVEN_ODD:
					w = "0";
					break;
				case GraphicsPathWinding.NON_ZERO:
					w = "1";
					break;
			}
			return "new PhantomShape(new Array(" + c + "), new Array(" + d + "), "+w+");";
		}
		
		public static function emptyShape():PhantomShape {
			return new PhantomShape(new Array(GraphicsPathCommand.WIDE_MOVE_TO, GraphicsPathCommand.WIDE_LINE_TO), new Array(0, 0, 0, 0, 0, 0, 10, -10), 0);
		}
		
		public static function createFromString(s:String):PhantomShape {
			var p:int = s.indexOf("new PhantomShape(");
			if (p != 0) {
				trace("new PhantomShape( not found");
				return emptyShape();
			}
			s = s.substr(17);
			p = s.indexOf("),");
			if (p < 0) {
				trace("), not found");
				return emptyShape();
			}
			var s1:String = s.substr(0, p + 1);
			var s2:String = s.substr(p + 2);
			
			p = s2.indexOf("),");
			if (p < 0) {
				trace("), not found (2)");
				return emptyShape();
			}
			var s3:String = s2.substr(p + 2);
			s2 = s2.substr(0, p + 1);
			
			p = s3.indexOf(");");
			if (p < 0) {
				trace("); not found");
				return emptyShape();
			}
			s3 = s3.substr(0, p);
			
			
			s1 = StringUtil.trim(s1);
			s2 = StringUtil.trim(s2);
			s3 = StringUtil.trim(s3);
			
			trace(s1);
			trace(s2);
			trace(s3);
			var c:Array = StringUtil.parseCommand(s1);
			var d:Array = StringUtil.parseCommand(s2);
			var commands:Array = new Array();
			var data:Array = new Array();
			trace(c[0]);
			trace(d[0]);
			if (c[0] == "new Array" && d[0] == "new Array") {
				var i:int = 1;
				var j:int = 1;
				while (i < c.length) {
					var com:int = c[i];
					switch (com) {
						case GraphicsPathCommand.MOVE_TO: 
							commands.push(GraphicsPathCommand.WIDE_MOVE_TO);
							data.push(0, 0, d[j], d[j + 1]);
							j += 2;
							break;
						case GraphicsPathCommand.WIDE_MOVE_TO: 
							commands.push(GraphicsPathCommand.WIDE_MOVE_TO);
							data.push(d[j], d[j + 1], d[j + 2], d[j + 3]);
							j += 4;
							break;
						case GraphicsPathCommand.LINE_TO: 
							commands.push(GraphicsPathCommand.WIDE_LINE_TO);
							data.push(0, 0, d[j], d[j + 1]);
							j += 2;
							break;
						case GraphicsPathCommand.WIDE_LINE_TO: 
							commands.push(GraphicsPathCommand.WIDE_LINE_TO);
							data.push(d[j], d[j + 1], d[j + 2], d[j + 3]);
							j += 4;
							break;
						case GraphicsPathCommand.CURVE_TO: 
							commands.push(GraphicsPathCommand.CURVE_TO);
							data.push(d[j], d[j + 1], d[j + 2], d[j + 3]);
							j += 4;
							break;
					}
					i++;
				}
			}
			trace(commands);
			trace(data);
			
			return new PhantomShape(commands, data, parseInt(s3));
		}
		
	}

}