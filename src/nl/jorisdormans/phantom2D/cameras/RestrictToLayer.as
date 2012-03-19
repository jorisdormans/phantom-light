package nl.jorisdormans.phantom2D.cameras 
{
	import nl.jorisdormans.phantom2D.core.Layer;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	/**
	 * Restricts camera movement to a specified layer
	 * @author Joris Dormans
	 */
	public class RestrictToLayer extends CameraComponent
	{
		private var layer:Layer;
		private var horizontal:Boolean;
		private var vertical:Boolean;
		
		/**
		 * 
		 * @param	layer		The layer to which camera movement is restricted
		 * @param	horizontal	Set to true if you want to restrict movent in the horizontal direction.
		 * @param	vertical    Set to true if you want to restrict movent in the vertical direction.
		 */
		public function RestrictToLayer(layer:Layer, horizontal:Boolean = true, vertical:Boolean = true) 
		{
			this.layer = layer;
			this.horizontal = horizontal;
			this.vertical = vertical;
		}
		
		override public function onRemove():void 
		{
			layer = null;
			super.onRemove();
		}
		
		override public function update(elapsedTime:Number):void 
		{
			if (horizontal) {
				var dx:Number = camera.screen.screenWidth * 0.5;
				camera.target.x = MathUtil.clamp(camera.target.x, dx, Math.max(dx, layer.layerWidth - dx));
			}
			
			if (vertical) {
				var dy:Number = camera.screen.screenHeight * 0.5;
				camera.target.y = MathUtil.clamp(camera.target.y, dy, Math.max(dy, layer.layerHeight - dy));
			}
			
			super.update(elapsedTime);
		}
		
	}

}