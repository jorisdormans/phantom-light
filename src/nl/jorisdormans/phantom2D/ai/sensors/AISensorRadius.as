package nl.jorisdormans.phantom2D.ai.sensors 
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.PhantomGame;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class AISensorRadius extends AISensor implements IRenderable
	{
		private var radiusSquared:Number;
		private var radius:Number;
		
		public static var xmlDescription:XML = <AISensorRadius radius="Number"/>;
		public static var xmlDefault:XML = <AISensorRadius radius="40"/>;
		
		public static function generateFromXML(xml:XML):Component {
			var comp:Component = new AISensorRadius(40);
			comp.readXML(xml);
			return comp;
		}
		
		
		public function AISensorRadius(radius:Number) 
		{
			this.radius = radius;
			this.radiusSquared = radius * radius;
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			if (target.gameObject && target.targetObject.position) {
				var d:Number = MathUtil.distanceSquared(target.targetObject.position, gameObject.position);
				if (d < radiusSquared + target.targetObject.shape.roughSize * target.targetObject.shape.roughSize ) {
					target.detect();
				}
			}
		}
		
		override public function generateXML():XML 
		{
			var xml:XML = super.generateXML();
			xml.@radius = radius;
			return xml;
		}
		
		override public function readXML(xml:XML):void 
		{
			if (xml.@radius.length() > 0) radius = xml.@radius;
			this.radiusSquared = radius * radius;
			super.readXML(xml);
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			if (!PhantomGame.debugInfo) return;
			var c:uint;
			switch (target.detected) {
				case AITarget.TARGET_DETECTED:
					c = 0xff0000;
					break;
				case AITarget.TARGET_LOST:
					c = 0xffff00;
					break;
				case AITarget.NO_TARGET:
					c = 0xffffff;
					break;
			}
			graphics.lineStyle(2, c);
			graphics.drawCircle(x, y, radius);
			graphics.lineStyle();
		}
		
	}

}