package nl.jorisdormans.phantom2D.objects.boundaries
{
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	/**
	 * Component that will cause a GameObject to wrap around a layer
	 * @author Joris Dormans
	 */
	public class WrapAround extends GameObjectComponent
	{
		private var threshold:Number;
		private var horizontal:Boolean;
		private var vertical:Boolean;
		
		public function WrapAround(threshold:Number = 0, horizontal:Boolean = true, vertical:Boolean = true) 
		{
			this.threshold = threshold;
			this.horizontal = horizontal;
			this.vertical = vertical;
		}
		
		override public function updatePhysics(elapsedTime:Number):void 
		{
			if (horizontal) {
				if (gameObject.position.x < -threshold) {
					gameObject.position.x += threshold * 2 + gameObject.objectLayer.layerWidth;
				} else if (gameObject.position.x > threshold + gameObject.objectLayer.layerWidth) {
					gameObject.position.x -= threshold * 2 + gameObject.objectLayer.layerWidth;
				}
			}
			if (vertical) {
				if (gameObject.position.y < -threshold) {
					gameObject.position.y += threshold * 2 + gameObject.objectLayer.layerHeight;
				} else if (gameObject.position.y > threshold + gameObject.objectLayer.layerHeight) {
					gameObject.position.y -= threshold * 2 + gameObject.objectLayer.layerHeight;
				}
			}
			
		}
		
	}

}