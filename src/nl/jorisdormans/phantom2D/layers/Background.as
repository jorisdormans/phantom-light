package nl.jorisdormans.phantom2D.layers 
{
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import nl.jorisdormans.phantom2D.cameras.Camera;
	import nl.jorisdormans.phantom2D.core.Layer;
	/**
	 * Layer class that renders a gradient background
	 * @author Joris Dormans
	 */
	public class Background extends Layer
	{
		
		public function Background(colorTop:uint, colorMiddle:uint, colorBottom:uint) 
		{
			super();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox( layerWidth, layerHeight );
			matrix.rotate( Math.PI * 0.5);
			sprite.graphics.clear();
			sprite.graphics.beginGradientFill(GradientType.LINEAR, [colorTop, colorMiddle, colorBottom], [1.0, 1.0, 1.0], [0, 200, 255], matrix);
			sprite.graphics.drawRect(0, 0, layerWidth, layerHeight);
			sprite.graphics.endFill();
		}
		
		override public function render(camera:Camera):void 
		{
			//nothing here, prevent the super from clearing the sprite.graphics
			//super.render(camera);
		}
		
	}

}