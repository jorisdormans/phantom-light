package nl.jorisdormans.phantom2D.objects.misc 
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	/**
	 * A component that destroys 
	 * @author Joris Dormans
	 */
	public class LimitedLife extends GameObjectComponent
	{
		/**
		 * Event that is generated when the effect ends.
		 */
		public static const E_DIED:String = "died";
		
		public static var xmlDescription:XML = <LimitedLife life="Number"/>;
		public static var xmlDefault:XML = <LimitedLife life="1"/>;
		
		public static function generateFromXML(xml:XML):Component {
			var comp:Component = new LimitedLife(1);
			comp.readXML(xml);
			return comp;
		}
		
		private var life:Number;
		
		public function LimitedLife(life:Number) 
		{
			this.life = life;
		}
		
		override public function generateXML():XML 
		{
			var xml:XML = super.generateXML();
			xml.@life = life;
			return xml;
		}
		
		override public function readXML(xml:XML):void 
		{
			if (xml.@life.length() > 0) life = xml.@life;
			super.readXML(xml);
		}		
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			life-= elapsedTime;
			if (life <= 0) {
				gameObject.handleMessage(E_DIED);
				gameObject.destroyed = true;
			}
		}
		
	}

}