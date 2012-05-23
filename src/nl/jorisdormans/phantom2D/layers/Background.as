package nl.jorisdormans.phantom2D.layers 
{
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import nl.jorisdormans.phantom2D.cameras.Camera;
	import nl.jorisdormans.phantom2D.core.Layer;
	import nl.jorisdormans.phantom2D.core.PhantomGame;
	/**
	 * Layer class that renders a gradient background
	 * @author Joris Dormans
	 */
	public class Background extends Layer
	{
		/**
		 * Adds a gradient filled background
		 * @param	colorTop
		 * @param	colorMiddle
		 * @param	colorBottom
		 * @param	middleRatio		position of the middle color (0 = top, 1255 = bottom)
		 */
		public function Background(colorTop:uint, colorMiddle:uint, colorBottom:uint, middleRatio:int = 128) 
		{
			super();
			layerWidth = PhantomGame.gameWidth;
			layerHeight = PhantomGame.gameHeight;
			var matrix:Matrix = new Matrix();
			//matrix.createGradientBox( layerWidth, layerHeight );
			matrix.createGradientBox( layerHeight, layerWidth );
			matrix.rotate( Math.PI * 0.5);
			sprite.graphics.clear();
			//var f:Number = 1;
			//if (layerHeight < layerWidth) f = layerHeight / layerWidth;
			//else f = layerWidth / layerHeight;

			sprite.graphics.beginGradientFill(GradientType.LINEAR, [colorTop, colorMiddle, colorBottom], [1.0, 1.0, 1.0], [0, middleRatio, 255], matrix);
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