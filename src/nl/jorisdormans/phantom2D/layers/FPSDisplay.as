package nl.jorisdormans.phantom2D.layers 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import nl.jorisdormans.phantom2D.cameras.Camera;
	import nl.jorisdormans.phantom2D.core.Layer;
	import nl.jorisdormans.phantom2D.core.PhantomGame;
	/**
	 * Displays the current framerate.
	 * @author Joris Dormans
	 */
	public class FPSDisplay extends Layer
	{
		private var textField:TextField;
		private var background:uint;
		
		public function FPSDisplay(color:uint=0xffffff, font:String = "Arial", size:int = 12, background:uint = 0x000000) 
		{
			super();
			textField = new TextField();
			textField.defaultTextFormat = new TextFormat(font, size, color);
			textField.text = "fps";
			textField.width = size * 4;
			textField.height = size * 1.5;
			textField.x = layerWidth - textField.width;
			this.background = background;
			
			sprite.addChild(textField);
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			textField.text = "fps: " + PhantomGame.fps;
		}
		
		override public function render(camera:Camera):void 
		{
			super.render(camera);
			sprite.graphics.beginFill(background, 0.5);
			sprite.graphics.drawRect(layerWidth-textField.width, 0, textField.width, textField.height);
			sprite.graphics.endFill();
		}
		
	}

}