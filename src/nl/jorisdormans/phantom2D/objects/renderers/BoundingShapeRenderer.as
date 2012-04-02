package nl.jorisdormans.phantom2D.objects.renderers 
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	/**
	 * A Component that simply renders the GameObject´s bounding shape with the specified colors and strokewidth.
	 * @author Joris Dormans
	 */
	public class BoundingShapeRenderer extends GameObjectComponent implements IRenderable
	{
		/**
		 * Message you can use to change the render style. 
		 * Takes input: {[fillColor:uint][, strokeColor:uint][, strokeWidth:Number][, alpha:Number]}
		 */
		public static const M_SET_RENDER_STYLE:String = "setRenderStyle";
		public var strokeWidth:Number;
		public var strokeColor:uint;
		public var fillColor:uint;
		public var alpha:Number;
		
		public function BoundingShapeRenderer(fillColor:uint = 0xffffff, strokeColor:uint = 0xffffff, strokeWidth:Number = -1, alpha:Number = 1) 
		{
			this.strokeWidth = strokeWidth;
			this.strokeColor = strokeColor;
			this.fillColor = fillColor;
			this.alpha = alpha;
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case M_SET_RENDER_STYLE:
					if (data && data.fillColor) this.fillColor = data.fillColor;
					if (data && data.strokeColor) this.strokeColor = data.strokeColor;
					if (data && data.alpha) this.alpha = data.alpha;
					if (data && data.strokeWidth) this.strokeWidth = data.strokeWidth;
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}
		
		
		/* INTERFACE phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			graphics.beginFill(fillColor, alpha);
			angle -= gameObject.shape.orientation;
			if (strokeWidth>=0) {
				graphics.lineStyle(strokeWidth, strokeColor);
				gameObject.shape.drawShape(graphics, x, y, angle, zoom);
				graphics.lineStyle();
			} else {
				gameObject.shape.drawShape(graphics, x, y, angle, zoom);
			}
			graphics.endFill();
			
			
		}
		
	}

}