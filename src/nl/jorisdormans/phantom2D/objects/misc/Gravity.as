package nl.jorisdormans.phantom2D.objects.misc 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	
	/**
	 * Applies gravity to a GameObject
	 * @author R. van Swieten
	 */
	public class Gravity extends GameObjectComponent 
	{
		private var gravity:Vector3D;
		public var applyGravity:Boolean = true;
		
		public function Gravity(gravity:Vector3D) 
		{
			this.gravity = gravity;
		}
		
		override public function updatePhysics(elapsedTime:Number):void 
		{
			super.updatePhysics(elapsedTime);
			if (this.gameObject.mover && this.gameObject.mover.applyMovement && this.applyGravity) {
				this.gameObject.mover.velocity.x += gravity.x * elapsedTime;
				this.gameObject.mover.velocity.y += gravity.y * elapsedTime;
			}
		}
		
	}

}