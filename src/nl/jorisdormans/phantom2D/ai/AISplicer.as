package nl.jorisdormans.phantom2D.ai 
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.core.PhantomGame;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class AISplicer extends Composite implements IRenderable
	{
		public static var splices:int = 8;
		private static var currentSplice:int = 0;
		
		public static var xmlDescription:XML = <AISplicer/>;
		public static var xmlDefault:XML = <AISplicer/>;
		
		public static function generateFromXML(xml:XML):Component {
			var comp:Component = new AISplicer();
			comp.readXML(xml);
			return comp;
		}
		
		private var allocatedSplice:int;
		private var elapsedTime:Number;
		
		public function AISplicer() 
		{
			allocatedSplice = currentSplice;
			currentSplice++;
			currentSplice %= splices;
			elapsedTime = 0;
		}
		
		override public function update(elapsedTime:Number):void 
		{
			this.elapsedTime += elapsedTime;
			if (PhantomGame.frameClock % splices == allocatedSplice) {
				super.update(this.elapsedTime);
				this.elapsedTime = 0;
			}
		}
		
		override public function updatePhysics(elapsedTime:Number):void 
		{
			//super.updatePhysics(elapsedTime);
			//no code here
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			var l:int = components.length;
			for (var i:int = 0; i < l; i++) {
				if (components[i] is IRenderable) (components[i] as IRenderable).render(graphics, x, y, angle, zoom);
			}
		}
		
		
		
		
		
		
	}

}