package nl.jorisdormans.phantom2D.objects.boundaries
{
	import nl.jorisdormans.phantom2D.core.Component;
	/**
	 * A GameObjectComponent that destroys its object when it moves outside its layer.
	 * @author Joris Dormans
	 */
	public class DestroyOutsideWorld extends Component
	{
		private var threshold:Number = 0;
		private var left:Boolean;
		private var right:Boolean;
		private var up:Boolean;
		private var down:Boolean;
		
		public function DestroyOutsideWorld(threshold:Number = 0, left:Boolean = true, right:Boolean = true, up:Boolean = true, down:Boolean = true ) 
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
			if (left && gameObject.position.x + threshold < 0) gameObject.destroyed = true;
			if (right && gameObject.position.x - threshold > gameObject.layer.layerWidth) gameObject.destroyed = true;
			if (up && gameObject.position.y + threshold < 0) gameObject.destroyed = true;
			if (down && gameObject.position.y - threshold > gameObject.layer.layerHeight) gameObject.destroyed = true;
		}
		
	}

}