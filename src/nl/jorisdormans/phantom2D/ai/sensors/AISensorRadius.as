package nl.jorisdormans.phantom2D.ai.sensors 
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
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
		
		public function AISensorRadius(radius:Number) 
		{
			this.radius = radius;
			this.radiusSquared = radius * radius;
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			if (target.gameObject) {
				var d:Number = MathUtil.distanceSquared(target.targetObject.position, gameObject.position);
				if (d < radiusSquared + target.targetObject.shape.roughSize * target.targetObject.shape.roughSize ) {
					target.detect();
				}
			}
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