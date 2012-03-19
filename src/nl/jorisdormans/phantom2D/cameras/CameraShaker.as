package nl.jorisdormans.phantom2D.cameras 
{
	import nl.jorisdormans.phantom2D.core.Phantom;
	/**
	 * Camera Component that shakes the camera after receiving the shake message.
	 * @author Joris Dormans
	 */
	public class CameraShaker extends CameraComponent
	{
		private var shakeSpeed:Number;
		private var shakeTime:Number;
		private var shakeAmplitude:Number;
		private var amplitude:Number;
		private var speed:Number;
		private var time:Number;
		private var timer:Number;
		private var counter:Number;
		
		/**
		 * Message to shake the camera, takes the following input {[time:Number][, amplitude:Number][, speed:Number]}
		 */
		public static const M_SHAKE:String = "shake";
		
		public function CameraShaker(time:Number = 0.4, amplitude:Number = 8, speed:Number = 30) 
		{
			this.time = time;
			this.speed = speed;
			this.amplitude = amplitude;
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case M_SHAKE:
					if (data && data.time) shakeTime = data.time;
					else shakeTime = time;
					if (data && data.amplitude) shakeAmplitude = data.amplitude;
					else shakeAmplitude = amplitude;
					if (data && data.speed) shakeSpeed = data.speed;
					else shakeSpeed = speed;
					timer = shakeTime;
					counter = Math.random() * 6;
					return Phantom.MESSAGE_CONSUMED;
			}
			return super.handleMessage(message, data);
		}
		
		override public function update(elapsedTime:Number):void 
		{
			if (timer > 0) {
				var a:Number = shakeAmplitude * timer / shakeTime;
				timer -= Math.min(elapsedTime, timer);
				var sx:Number = a * (Math.cos(counter) * 0.7 + Math.cos(counter * 3) * 0.3);
				var sy:Number = a * (Math.sin(counter * 1.3) * 0.7 + Math.cos(counter * 3.3) * 0.3);
				camera.target.x += sx;
				camera.target.y += sy;
				counter += elapsedTime * shakeSpeed;
			}
			super.update(elapsedTime);
		}
		
	}

}