package nl.jorisdormans.phantom2D.objects.boundaries
{
	import nl.jorisdormans.phantom2D.core.Component;
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
		
		public static var xmlDescription:XML = <CollideWidthLayerEdge bounceRestitution="Number" left="Boolean" right="Boolean" up="Boolean" down="Boolean"/>;
		public static var xmlDefault:XML = <CollideWidthLayerEdge bounceRestitution="1" left="true" right="true" up="true" down="true"/>;
		
		public static function generateFromXML(xml:XML):Component {
			var comp:Component = new CollideWithLayerEdge();
			comp.readXML(xml);
			return comp;
		}
		
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
		
		override public function generateXML():XML 
		{
			var xml:XML = super.generateXML();
			if (bounceRestitution != -1) xml.@bounceRestitution = -bounceRestitution;
			if (!left) xml.@left = "false";
			if (!right) xml.@right = "false";
			if (!up) xml.@up = "false";
			if (!down) xml.@down = "false";
			return xml;
		}
		
		override public function readXML(xml:XML):void 
		{
			if (xml.@left.length() > 0) left = xml.@left == "true";
			if (xml.@right.length() > 0) right = xml.@right == "true";
			if (xml.@up.length() > 0) up = xml.@up == "true";
			if (xml.@down.length() > 0) down = xml.@down == "true";
			if (xml.@bounceRestitution.length() > 0) bounceRestitution = parseFloat(xml.@bounceRestitution) * -1;
			super.readXML(xml);
		}
		
		override public function updatePhysics(elapsedTime:Number):void 
		{
			super.updatePhysics(elapsedTime);
			if (left && gameObject.position.x + gameObject.shape.left < 0) {
				gameObject.position.x = -gameObject.shape.left;
				if (gameObject.mover.velocity.x < 0) gameObject.mover.velocity.x *= bounceRestitution;
				parent.handleMessage(E_EDGE_COLISSION, { dx: -1, dy:0 } );
			}
			if (right && gameObject.position.x + gameObject.shape.right > gameObject.objectLayer.layerWidth) {
				gameObject.position.x = gameObject.objectLayer.layerWidth - gameObject.shape.right;
				if (gameObject.mover.velocity.x > 0) gameObject.mover.velocity.x *= bounceRestitution;
				parent.handleMessage(E_EDGE_COLISSION, { dx: 1, dy:0 } );
			}
			if (up && gameObject.position.y + gameObject.shape.top < 0) {
				gameObject.position.y = -gameObject.shape.top;
				if (gameObject.mover.velocity.y < 0) gameObject.mover.velocity.y *= bounceRestitution;
				parent.handleMessage(E_EDGE_COLISSION, { dx: 0, dy:-1 } );
			}
			if (down && gameObject.position.y + gameObject.shape.bottom> gameObject.objectLayer.layerHeight) {
				gameObject.position.y = gameObject.objectLayer.layerHeight - gameObject.shape.bottom;
				if (gameObject.mover.velocity.y > 0) gameObject.mover.velocity.y *= bounceRestitution;
				parent.handleMessage(E_EDGE_COLISSION, { dx: 0, dy:1 } );
			}			
			
		}
		
	}

}