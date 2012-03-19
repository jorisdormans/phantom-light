package nl.jorisdormans.phantom2D.particles 
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.cameras.Camera;
	/**
	 * The basic particle class, for light weight particles
	 * @author Joris Dormans
	 */
	public class Particle 
	{
		/**
		 * Specifies how long a particle has left to live (in seconds)
		 */
		public var life:Number;
		/**
		 * Specifies how long a particle has been living (in seconds)
		 */
		protected var living:Number;
		/**
		 * The particle's current position
		 */
		public var position:Vector3D;
		/**
		 * The particle's current velocity
		 */
		protected var velocity:Vector3D;
		/**
		 * The particle's current color
		 */
		public var color:uint;
		
		public function Particle() {
			
		}
		
		/**
		 * Creates an instance of the particle class
		 * @param	life		The number of seconds a particle will live
		 * @param	position	The starting position
		 * @param	velocity	The initial velocity
		 */
		public function initialize(life:Number, position:Vector3D, velocity:Vector3D):void
		{
			living = 0;
			this.life = life;
			this.position = position;
			this.velocity = velocity;
			this.color = 0xffffff;
		}
		
		/**
		 * Updates a particle's position and life.
		 * @param	elapsedTime
		 */
		public function update(elapsedTime:Number):void {
			life -= elapsedTime;
			living += elapsedTime;
			position.x += velocity.x * elapsedTime;
			position.y += velocity.y * elapsedTime;
		}
		
		/**
		 * Renders the partice to the screen
		 * @param	graphics	The Graphics object the particle is to be rendered on
		 * @param	camera		The screen's camera
		 */
		public function render(graphics:Graphics, camera:Camera):void {
			graphics.beginFill(color);
			graphics.drawCircle(position.x - camera.left, position.y - camera.top, Math.min(5, life * 10));
			graphics.endFill();
		}
		
	}

}