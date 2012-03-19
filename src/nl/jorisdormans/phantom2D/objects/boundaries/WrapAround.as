package nl.jorisdormans.phantom2D.objects.boundaries
{
	import nl.jorisdormans.phantom2D.core.Component;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class WrapAround extends Component
	{
		private var threshold:Number;
		private var horizontal:Boolean;
		private var vertical:Boolean;
		
		public function WrapAround(horizontal:Boolean = true, vertical:Boolean = true, threshold:Number = 0) 
		{
			this.threshold = threshold;
			this.horizontal = horizontal;
			this.vertical = vertical;
		}
		
		override public function updatePhysics(elapsedTime:Number):void 
		{
			if (horizontal) {
				if (gameObject.position.x < -threshold) {
					gameObject.position.x += threshold * 2 + gameObject.layer.layerWidth;
				} else if (gameObject.position.x > threshold + gameObject.layer.layerWidth) {
					gameObject.position.x -= threshold * 2 + gameObject.layer.layerWidth;
				}
			}
			if (vertical) {
				if (gameObject.position.y < -threshold) {
					gameObject.position.y += threshold * 2 + gameObject.layer.layerHeight;
				} else if (gameObject.position.y > threshold + gameObject.layer.layerHeight) {
					gameObject.position.y -= threshold * 2 + gameObject.layer.layerHeight;
				}
			}
			
		}
		
	}

}