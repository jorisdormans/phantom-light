package nl.jorisdormans.phantom2D.gui 
{
	import nl.jorisdormans.phantom2D.core.Camera;
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Layer;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class TransparentLayer extends Layer
	{
		private var color:uint;
		//private var alpha:Number;
		
		public function TransparentLayer(color:uint, alpha:Number) 
		{
			super();
			this.sprite.alpha = alpha;
			this.color = color;
		}
		
		override public function render(camera:Camera):void 
		{
			sprite.graphics.clear();
			sprite.graphics.beginFill(color);
			sprite.graphics.drawRect(0, 0, gameScreen.screenWidth, gameScreen.screenHeight);
			sprite.graphics.endFill();
		}
		
	}

}