package nl.jorisdormans.phantom2D.objects.misc 
{
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class ArrowKeyHandler extends GameObjectComponent implements IInputHandler
	{
		/**
		 * Event generated when the direction changes. Passes data: {dx:Number, dy:Number} where dx and dy are the direction vector
		 */
		public static const E_CHANGE_DIRECTION:String = "changeDirection";
		
		private var acceleration:Number;
		private var lastX:Number;
		private var lastY:Number;
		
		
		public function ArrowKeyHandler(acceleration:Number = 1000) 
		{
			this.acceleration = acceleration;
			lastX = 1;
			lastY = 0;
		}
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			if (!gameObject.mover) {
				throw new Error("ArrowKeyHandler requires that is GameObject has a Mover component.");
			}
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IInputHandler */
		
		public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void 
		{
			var dx:Number = 0;
			var dy:Number = 0;
			if (currentState.arrowLeft) dx -= 1;
			if (currentState.arrowRight) dx += 1;
			if (currentState.arrowUp) dy -= 1;
			if (currentState.arrowDown) dy += 1;
			if (dx != 0 && dy != 0) {
				dx *= Math.SQRT1_2;
				dy *= Math.SQRT1_2;
			}
			elapsedTime *= acceleration;
			gameObject.mover.velocity.x += dx * elapsedTime;
			gameObject.mover.velocity.y += dy * elapsedTime;
			if ((lastX!=dx || lastY!=dy) && (dx!=0 || dy!=0)) {
				lastX = dx;
				lastY = dy;
				parent.sendMessage(E_CHANGE_DIRECTION, { dx: dx, dy: dy } );
				
			}
			
		}
		
		
		
	}

}