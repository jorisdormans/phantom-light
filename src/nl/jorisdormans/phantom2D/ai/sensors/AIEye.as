package nl.jorisdormans.phantom2D.ai.sensors 
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.PhantomGame;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.util.DrawUtil;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class AIEye extends AISensor implements IRenderable 
	{
		private var distance:Number;
		private var arc:Number;
		private var orientation:Number;
		private var distanceSquared:Number;
		
		public function AIEye(distance:Number, arc:Number, orientation:Number = 0) 
		{
			this.orientation = orientation;
			this.arc = arc * 0.5 * MathUtil.TO_RADIANS;
			this.distance = distance;
			this.distanceSquared = distance * distance;
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			if (target.gameObject) {
				var d:Number = MathUtil.distanceSquared(target.targetObject.position, gameObject.position);
				if (d < distanceSquared + target.targetObject.shape.roughSize * target.targetObject.shape.roughSize ) {
					var a:Number = Math.atan2(target.targetObject.position.y - gameObject.position.y, target.targetObject.position.x - gameObject.position.x);
					a = MathUtil.angleDifference(gameObject.shape.orientation + orientation, a);
					if (Math.abs(a)<=arc) {
						target.detect();
					}
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
			graphics.moveTo(x + Math.cos(gameObject.shape.orientation + orientation + arc) * distance, y + Math.sin(gameObject.shape.orientation + orientation + arc) * distance);
			graphics.lineTo(x, y);
			graphics.lineTo(x + Math.cos(gameObject.shape.orientation + orientation - arc) * distance, y + Math.sin(gameObject.shape.orientation + orientation - arc) * distance);
			DrawUtil.drawEllipseArc(graphics, x, y, distance, distance, gameObject.shape.orientation + orientation - arc, arc * 2);
			graphics.lineStyle();
		}
		
	}

}