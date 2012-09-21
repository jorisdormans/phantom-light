package nl.jorisdormans.phantom2D.gui 
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Camera;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.util.TextDraw;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class SimpleButtonRenderer extends Component implements IRenderable
	{
		private var caption:String;
		private var textSize:Number;
		private var fillColor:uint;
		private var textColor:uint;
		private var fillPressed:uint;
		private var textPressed:uint;
		private var fillHover:uint;
		private var textHover:uint;
		private var pressed:Boolean;
		private var hovering:Boolean;
		private var strokeWidth:Number;
		private var fill:uint;
		private var text:uint;
		
		public function SimpleButtonRenderer(caption:String, textSize:Number, fillColor:uint, textColor:uint, fillHover:uint, textHover:uint, fillPressed:uint, textPressed:uint, strokeWidth:Number = -1) 
		{
			this.caption = caption;
			this.textSize = textSize;
			this.fillColor = fillColor;
			this.textColor = textColor;
			this.fill = fillColor;
			this.text = textColor;
			this.fillHover = fillHover;
			this.textHover = textHover;
			this.fillPressed = fillPressed;
			this.textPressed = textPressed;
			this.strokeWidth = strokeWidth;
			pressed = false;
			hovering = false;
			super();
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case GUIKeyboardHandler.E_ONPRESS: 
					pressed = true;
					fill = fillPressed;
					text = textPressed;
					return Phantom.MESSAGE_HANDLED;
				case GUIKeyboardHandler.E_ONRELEASE:
					pressed = false;
					if (hovering) {
						fill = fillHover;
						text = textHover;
					} else {
						fill = fillColor;
						text = textColor;
					}
					return Phantom.MESSAGE_HANDLED;
				case GUIKeyboardHandler.E_ONFOCUS:
					hovering = true;
					if (!pressed) {
						fill = fillHover;
						text = textHover;
					}
					return Phantom.MESSAGE_HANDLED;
				case GUIKeyboardHandler.E_ONBLUR: 
					hovering = false;
					pressed = false;
					fill = fillColor;
					text = textColor;
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}
		
		/* INTERFACE phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			if (strokeWidth >= 0) {
				graphics.lineStyle(strokeWidth, text);
			}
			graphics.beginFill(fill);
			gameObject.shape.drawShape(graphics, x, y, angle, zoom);
			graphics.endFill();
			if (strokeWidth >= 0) {
				graphics.lineStyle();
			}
			
			var tx:Number = x;
			var ty:Number = y + textSize * 0.4 * zoom;
			TextDraw.drawTextCentered(graphics, tx, ty, 200, 40, caption, text, textSize * zoom);
		}
		
	}

}