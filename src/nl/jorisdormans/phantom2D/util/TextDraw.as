package nl.jorisdormans.phantom2D.util
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class TextDraw
	{
		
		public function TextDraw()
		{
		
		}
		
		private static var font:String = "Tahoma";
		private static var textField:TextField;
		private static var bmpd:BitmapData;
		private static var sprite:Sprite;
		
		public static function drawText(graphics:Graphics, x:Number, y:Number, width:Number, height:Number, text:String, color:uint, size:Number):void
		{
			if (text == null || text == "")
				return;
			if (textField == null)
			{
				textField = new TextField();
				bmpd = new BitmapData(width, height, false, 0x00ffffff);
				sprite = new Sprite();
				sprite.addChild(textField);
				
				textField.multiline = false;
			}
			textField.defaultTextFormat = new TextFormat(font, size, color);
			textField.text = text;
			textField.width = width;
			textField.height = height;
			bmpd = new BitmapData(width, height, true, 0xff00ff);
			
			var m:Matrix = new Matrix();
			m.translate(0, 0);
			bmpd.draw(sprite, m);
			m = new Matrix();
			m.translate(Math.floor(x), Math.floor(y - height * 0.4));
			graphics.beginBitmapFill(bmpd, m, false, true);
			graphics.drawRect(Math.floor(x), Math.floor(y - height * 0.4), width, height * 0.8);
			graphics.endFill();
		
		}
		
		public static function drawTextCentered(graphics:Graphics, x:Number, y:Number, width:Number, height:Number, text:String, color:uint, size:Number):void
		{
			if (text == null || text == "")
				return;
			if (textField == null)
			{
				textField = new TextField();
				bmpd = new BitmapData(width, height, false, 0x00ffffff);
				sprite = new Sprite();
				sprite.addChild(textField);
				
				textField.multiline = false;
			}
			textField.defaultTextFormat = new TextFormat(font, size, color);
			textField.text = text;
			textField.width = width;
			textField.height = height;
			width = textField.textWidth * 1.2;
			bmpd = new BitmapData(width, height, true, 0xff00ff);
			
			var m:Matrix = new Matrix();
			m.translate(0, 0);
			bmpd.draw(sprite, m);
			m = new Matrix();
			m.translate(Math.floor(x - width * 0.5), Math.floor(y - height * 0.4));
			graphics.beginBitmapFill(bmpd, m, false, true);
			graphics.drawRect(Math.floor(x - width * 0.5), Math.floor(y - height * 0.4), width, height * 0.8);
			graphics.endFill();
		
		}
		
		public static function drawTextRight(graphics:Graphics, x:Number, y:Number, width:Number, height:Number, text:String, color:uint, size:Number):void
		{
			if (text == null || text == "")
				return;
			if (textField == null)
			{
				textField = new TextField();
				bmpd = new BitmapData(width, height, false, 0x00ffffff);
				sprite = new Sprite();
				sprite.addChild(textField);
				
				textField.multiline = false;
			}
			textField.defaultTextFormat = new TextFormat(font, size, color);
			textField.text = text;
			textField.width = width;
			textField.height = height;
			width = textField.textWidth * 1.2;
			bmpd = new BitmapData(width, height, true, 0xff00ff);
			
			var m:Matrix = new Matrix();
			m.translate(0, 0);
			bmpd.draw(sprite, m);
			m = new Matrix();
			m.translate(Math.floor(x - width), Math.floor(y - height * 0.4));
			graphics.beginBitmapFill(bmpd, m, false, true);
			graphics.drawRect(Math.floor(x - width), Math.floor(y - height * 0.4), width, height * 0.8);
			graphics.endFill();
		
		}
	
	}

}