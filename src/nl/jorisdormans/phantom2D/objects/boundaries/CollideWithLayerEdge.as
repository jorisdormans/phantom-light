package nl.jorisdormans.phantom2D.objects.boundaries
{
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	/**
	 * A GameObjectComponent that causes the game object to bounce off the edges of its layer
	 * @author Joris Dormans
	 */
	public class CollideWithLayerEdge extends GameObjectComponent
	{
		/**
		 * Event generated after colliding against layer boundaries, data ({dx:int, dy:int}) specifies which edge
		 */
		public static const E_EDGE_COLISSION:String = "edgeCollision";
		
		private var bounceRestitution:Number;
		private var left:Boolean;
		private var right:Boolean;
		private var up:Boolean;
		private var down:Boolean;
		
		/**
		 * 
		 * @param	bounceRestitution	Energy after the reflection;
		 * @param	left				Can bounce with the layer's left 
		 * @param	right
		 * @param	up
		 * @param	down
		 */
		public function CollideWithLayerEdge(bounceRestitution:Number = 1, left:Boolean = true, right:Boolean = true, up:Boolean = true, down:Boolean = true) 
		{
			this.bounceRestitution = -bounceRestitution;
			this.left = left;
			this.right = right;
			this.up = up;
			this.down = down;
		}
		
		override public function updatePhysics(elapsedTime:Number):void 
		{
			super.updatePhysics(elapsedTime);
			if (left && gameObject.position.x + gameObject.shape.left < 0) {
				gameObject.position.x = -gameObject.shape.left;
				if (gameObject.mover.velocity.x < 0) gameObject.mover.velocity.x *= bounceRestitution;
				parent.sendMessage(E_EDGE_COLISSION, { dx: -1, dy:0 } );
			}
			if (right && gameObject.position.x + gameObject.shape.right > gameObject.objectLayer.layerWidth) {
				gameObject.position.x = gameObject.objectLayer.layerWidth - gameObject.shape.right;
				if (gameObject.mover.velocity.x > 0) gameObject.mover.velocity.x *= bounceRestitution;
				parent.sendMessage(E_EDGE_COLISSION, { dx: 1, dy:0 } );
			}
			if (up && gameObject.position.y + gameObject.shape.top < 0) {
				gameObject.position.y = -gameObject.shape.top;
				if (gameObject.mover.velocity.y < 0) gameObject.mover.velocity.y *= bounceRestitution;
				parent.sendMessage(E_EDGE_COLISSION, { dx: 0, dy:-1 } );
			}
			if (down && gameObject.position.y + gameObject.shape.bottom> gameObject.objectLayer.layerHeight) {
				gameObject.position.y = gameObject.objectLayer.layerHeight - gameObject.shape.bottom;
				if (gameObject.mover.velocity.y > 0) gameObject.mover.velocity.y *= bounceRestitution;
				parent.sendMessage(E_EDGE_COLISSION, { dx: 0, dy:1 } );
			}			
			
		}
		
	}

}