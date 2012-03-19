package nl.jorisdormans.phantom2D.objects.renderers 
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.graphics.PhantomShape;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomShapeRenderer extends Component implements IRenderable
	{
		public var shape:PhantomShape;
		public var color:uint;
		public var size:Number;
		public var visible:Boolean;
		
		public function PhantomShapeRenderer(color:uint, shape:PhantomShape, size:Number = 1, visible:Boolean = true) 
		{
			this.shape = shape;
			this.color = color;
			this.size = size;
			this.visible = visible;
		}
		
		/* INTERFACE phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			if (!visible) return;
			graphics.beginFill(color);
			shape.drawScaledRotated(graphics, x, y, size * zoom, size * zoom, angle);
			//shape.draw(graphics, x, y);
			graphics.endFill();
		}
		
	}

}