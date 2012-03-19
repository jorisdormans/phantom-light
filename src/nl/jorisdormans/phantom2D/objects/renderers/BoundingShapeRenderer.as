package nl.jorisdormans.phantom2D.objects.renderers 
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Camera;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	/**
	 * A Component that simply renders the GameObject´s bounding shape with the specified colors and strokewidth
	 * @author Joris Dormans
	 */
	public class BoundingShapeRenderer extends Component implements IRenderable
	{
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
				case "changeFillColor":
					fillColor = data.color;
					return Phantom.MESSAGE_HANDLED;
				case "changeStrokeColor":
					strokeColor = data.color;
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}
		
		
		/* INTERFACE phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			graphics.beginFill(fillColor, alpha);
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