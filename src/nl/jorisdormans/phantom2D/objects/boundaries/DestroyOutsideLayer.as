package nl.jorisdormans.phantom2D.objects.boundaries
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	/**
	 * A Component that destroys its object when it moves outside its layer.
	 * @author Joris Dormans
	 */
	public class DestroyOutsideLayer extends GameObjectComponent
	{
		public static var xmlDescription:XML = <DestroyOutsideLayer threshold="Number" left="Boolean" right="Boolean" up="Boolean" down="Boolean"/>;
		public static var xmlDefault:XML = <DestroyOutsideLayer threshold="0" left="true" right="true" up="true" down="true"/>;
		
		public static function generateFromXML(xml:XML):Component {
			var comp:Component = new DestroyOutsideLayer();
			comp.readXML(xml);
			return comp;
		}
		
		private var threshold:Number = 0;
		private var left:Boolean;
		private var right:Boolean;
		private var up:Boolean;
		private var down:Boolean;
		
		/**
		 * 
		 * @param	threshold	How many pixels the position of the object has to be outside the layer before being destroyed.
		 * @param	left
		 * @param	right
		 * @param	up
		 * @param	down
		 */
		public function DestroyOutsideLayer(threshold:Number = 0, left:Boolean = true, right:Boolean = true, up:Boolean = true, down:Boolean = true ) 
		{
			this.threshold = threshold;
			this.left = left;
			this.right = right;
			this.up = up;
			this.down = down;
		}
		
		override public function generateXML():XML 
		{
			var xml:XML = super.generateXML();
			if (threshold != 0) xml.@threshold = threshold;
			if (!left) xml.@left = "false";
			if (!right) xml.@right = "false";
			if (!up) xml.@up = "false";
			if (!down) xml.@down = "false";
			return xml;
		}
		
		override public function readXML(xml:XML):void 
		{
			super.readXML(xml);
			if (xml.@threshold.length() > 0) threshold = xml.@threshold;
			if (xml.@left.length() > 0) left = xml.@left == "true";
			if (xml.@right.length() > 0) right = xml.@right == "true";
			if (xml.@up.length() > 0) up = xml.@up == "true";
			if (xml.@down.length() > 0) down = xml.@down == "true";
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			var gameObject:GameObject = parent as GameObject;
			if (left && gameObject.position.x + threshold < 0) gameObject.destroyed = true;
			if (right && gameObject.position.x - threshold > gameObject.objectLayer.layerWidth) gameObject.destroyed = true;
			if (up && gameObject.position.y + threshold < 0) gameObject.destroyed = true;
			if (down && gameObject.position.y - threshold > gameObject.objectLayer.layerHeight) gameObject.destroyed = true;
		}
		
	}

}