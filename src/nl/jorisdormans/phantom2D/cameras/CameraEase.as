package nl.jorisdormans.phantom2D.cameras 
{
	/**
	 * Eases the camera towards a target, instead of following it tightly. 
	 * @author Joris Dormans
	 */
	public class CameraEase extends CameraComponent
	{
		private var ease:Number;
		private var vx:Number;
		private var vy:Number;
		
		/**
		 * 
		 * @param	ease	The ammount the camera easies by every frame (should be bewteen 0 and 1)
		 */
		public function CameraEase(ease:Number = 0.2) 
		{
			this.ease = ease;
			vx = 0;
			vy = 0;
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			var dx:Number = camera.target.x - camera.position.x;
			var dy:Number = camera.target.y - camera.position.y;
			dx *= ease;
			dy *= ease;
			vx = vx * (1 - ease) + dx * ease;
			vy = vy * (1 - ease) + dy * ease;
			camera.target.x = camera.position.x + vx;
			camera.target.y = camera.position.y + vy;
		}
		
	}

}