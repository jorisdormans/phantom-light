package nl.jorisdormans.phantom2D.objects.misc 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	
	/**
	 * Applies gravity to a GameObject
	 * @author R. van Swieten
	 */
	public class Gravity extends GameObjectComponent 
	{
		public static var xmlDescription:XML = <Gravity x="Number" y="Number" z="Number"/>;
		public static var xmlDefault:XML = <Gravity x="0" y="0" z="0"/>;
		
		public static function generateFromXML(xml:XML):Component {
			var comp:Component = new Gravity(new Vector3D());
			comp.readXML(xml);
			return comp;
		}
		
		private var gravity:Vector3D;
		public var applyGravity:Boolean = true;
		
		public function Gravity(gravity:Vector3D) 
		{
			this.gravity = gravity;
		}
		
		override public function generateXML():XML 
		{
			var xml:XML = super.generateXML();
			xml.@x = gravity.x;
			xml.@y = gravity.y;
			if (xml.@z != 0) xml.@z = gravity.z;
			return xml;
		}
		
		override public function readXML(xml:XML):void 
		{
			if (xml.@x.length() > 0) gravity.x = xml.@x;
			if (xml.@y.length() > 0) gravity.y = xml.@y;
			if (xml.@z.length() > 0) gravity.z = xml.@z;
			super.readXML(xml);
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