package nl.jorisdormans.phantom2D.objects 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	/**
	 * A mover gameComponents enables movement and collision response of GameObjects.
	 * @author Joris Dormans
	 */
	public class Mover extends Component
	{
		/**
		 * The GameObjects velocity (in pixels/second)
		 */
		public var velocity:Vector3D;
		/**
		 * Friction on the movement. 
		 */
		public var friction:Number;
		/**
		 * Flag indicating whether or not the GameObjects initiates collision detection with other objects.
		 */
		public var initiateCollisionCheck:Boolean;
		
		/**
		 * Factor of energy left after a bounce.
		 */
		public var bounceRestitution:Number;
		
		/**
		 * Flags if Mover is currently active
		 * default: true;
		 */
		public var applyMovement:Boolean = true;
		
		/**
		 * Creates a Mover component that is responsible to update an object's location and respond to collisions
		 * @param	velocity				The GameObjects velocity (in pixels/second).
		 * @param	friction				Friction on the movement. 
		 * @param	doResonse				Flag indicating if collision response should be handled. (When set to false collision are detected but objects do not bounce).
		 * @param	initiateCollisionCheck	Flag indicating whether or not the GameObjects initiates collision detection with other objects.
		 */
		public function Mover(velocity:Vector3D, friction:Number = 2, bounceRestitution:Number = 1, initiateCollisionCheck:Boolean = true) 
		{
			this.velocity = velocity;
			this.friction = friction;
			this.initiateCollisionCheck = initiateCollisionCheck;
			this.bounceRestitution = bounceRestitution;
		}
		
		override public function updatePhysics(elapsedTime:Number):void 
		{
			if(this.applyMovement) {
				//update position
				gameObject.position.x += elapsedTime * velocity.x;
				gameObject.position.y += elapsedTime * velocity.y;
				gameObject.position.z += elapsedTime * velocity.z;
				
				//update velocity
				velocity.scaleBy(1 - 2 * friction * friction * elapsedTime);
			}
		}
		
		/**
		 * Called when a collision is detected to respond to the collision physically (resolve interpenetration and bounce).
		 * @param	collision
		 * @param	other
		 * @param	factor
		 */
		public function respondToCollision(collision:CollisionData, other:GameObject, factor:Number):void {
			//resolve interpenetration
			gameObject.position.x -= factor * collision.normal.x * collision.interpenetration;
			gameObject.position.y -= factor * collision.normal.y * collision.interpenetration;
			gameObject.position.z -= factor * collision.normal.z * collision.interpenetration;
		}
		
		/**
		 * Specifies if this GameObject can collide with another game object.
		 * @param	other
		 * @return			Return true if the collision with the other GameObject is possible, false to ignore the collission altogether.
		 */
		public function canCollideWith(other:GameObject):Boolean {
			//Should be overriden
			return true;
		}		

		/**
		 * Is called after a collission with a particular object is detected and after the physics have responded..
		 * @param	other
		 */
		public function afterCollisionWith(other:GameObject):void {
			//Should be overriden
		}
		
		/**
		 * Bounce after a collision has been detected
		 * @param	collision
		 * @param	factor
		 */
		public function bounce(collision:CollisionData, factor:Number):void {
			var dot:Number = collision.normal.dotProduct(velocity);
			if (dot < 0) return; 
			factor *= (1 + bounceRestitution);
			factor *= dot;
			velocity.x -= factor * collision.normal.x;
			velocity.y -= factor * collision.normal.y;
			velocity.z -= factor * collision.normal.z;
		}
		
		
		private static var n:Vector3D = new Vector3D();
		/**
		 * Transfer energy between two objects
		 * @param	other
		 */
		public function transferEnergy(other:GameObject):void {
			if (!other.mover) return;
			// First, find the normalized vector n from the center of
			// circle1 to the center of circle2
			n.x = gameObject.position.x - other.position.x;
			n.y = gameObject.position.y - other.position.y;
			n.z = gameObject.position.z - other.position.z;
			n.normalize();

			// Find the length of the component of each of the movement
			// vectors along n.
			// a1 = v1 . n
			// a2 = v2 . n
			var a1:Number = velocity.dotProduct(n);
			var a2:Number = other.mover.velocity.dotProduct(n);

			// Using the optimized version,
			// optimizedP =  2(a1 - a2)
			//              -----------
			//                m1 + m2
			var optimizedP:Number = (2.0 * (a1 - a2)) / (gameObject.mass + other.mass);

			// Calculate v1', the new movement vector of circle1
			// v1' = v1 - optimizedP * m2 * n
			velocity.x -= n.x * optimizedP * other.mass;
			velocity.y -= n.y * optimizedP * other.mass;

			// Calculate v2', the new movement vector of circle1
			// v2' = v2 + optimizedP * m1 * n
			other.mover.velocity.x += n.x * optimizedP * gameObject.mass;
			other.mover.velocity.y += n.y * optimizedP * gameObject.mass;
		}		
		
	}

}