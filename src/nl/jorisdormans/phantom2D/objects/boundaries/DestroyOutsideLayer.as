package nl.jorisdormans.phantom2D.objects.boundaries
{
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	/**
	 * A Component that destroys its object when it moves outside its layer.
	 * @author Joris Dormans
	 */
	public class DestroyOutsideLayer extends GameObjectComponent
	{
		private var threshold:Number = 0;
		private var left:Boolean;
		private var right:Boolean;
		private var up:Boolean;
		private var down:Boolean;
		
		/**
		 * 
		 * @param	threshold	How many pixels the position of the object has to be outside the layer before being destroyed.
		 * @param	left
		 * @param	right
		 * @param	up
		 * @param	down
		 */
		public function DestroyOutsideLayer(threshold:Number = 0, left:Boolean = true, right:Boolean = true, up:Boolean = true, down:Boolean = true ) 
		{
			this.threshold = threshold;
			this.left = left;
			this.right = right;
			this.up = up;
			this.down = down;
			
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			var gameObject:GameObject = parent as GameObject;
			if (left && gameObject.position.x + threshold < 0) gameObject.destroyed = true;
			if (right && gameObject.position.x - threshold > gameObject.objectLayer.layerWidth) gameObject.destroyed = true;
			if (up && gameObject.position.y + threshold < 0) gameObject.destroyed = true;
			if (down && gameObject.position.y - threshold > gameObject.objectLayer.layerHeight) gameObject.destroyed = true;
		}
		
	}

}