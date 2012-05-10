package nl.jorisdormans.phantom2D.objects.boundaries
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	/**
	 * Component that will cause a GameObject to wrap around a layer
	 * @author Joris Dormans
	 */
	public class WrapAround extends GameObjectComponent
	{
		public static var xmlDescription:XML = <WrapAround threshold="Number" horizontal="Boolean" vertical="Boolean"/>;
		public static var xmlDefault:XML = <WrapAround threshold="0" horizontal="true" vertical="true"/>;
		
		public static function generateFromXML(xml:XML):Component {
			var comp:Component = new WrapAround();
			comp.readXML(xml);
			return comp;
		}
		
		private var threshold:Number;
		private var horizontal:Boolean;
		private var vertical:Boolean;
		
		public function WrapAround(threshold:Number = 0, horizontal:Boolean = true, vertical:Boolean = true) 
		{
			this.threshold = threshold;
			this.horizontal = horizontal;
			this.vertical = vertical;
		}
		
		override public function generateXML():XML 
		{
			var xml:XML = super.generateXML();
			if (threshold!=0) xml.@threshold = threshold;
			if (!horizontal) xml.@horizontal = "false";
			if (!vertical) xml.@vertical = "false";
			return xml;
		}
		
		override public function readXML(xml:XML):void 
		{
			super.readXML(xml);
			if (xml.@threshold.length() > 0) threshold = xml.@threshold;
			if (xml.@horizontal.length() > 0) horizontal = xml.@horizontal == "true";
			if (xml.@vertical.length() > 0) vertical = xml.@vertical == "true";
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