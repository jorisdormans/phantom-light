package nl.jorisdormans.phantom2D.gui 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	import nl.jorisdormans.phantom2D.objects.ObjectLayer;
	
	/**
	 * ...
	 * @author Maarten
	 */
	public class MouseOver extends Component implements IInputHandler 
	{
		private var mouseLoc:Vector3D;
		private var objectLayer:ObjectLayer;
		private var oldMouseLoc:Vector3D;
		private var overObject:Component;
		private var oldOverObject:Component;
		
		public function MouseOver() 
		{
			
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IInputHandler */
		
		public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void 
		{
			var mouseX:Number = objectLayer.gameScreen.camera.left + currentState.mouseX;
			var mouseY:Number = objectLayer.gameScreen.camera.top + currentState.mouseY;
			mouseLoc = new Vector3D(mouseX, mouseY);
			
			var oldMouseX:Number = objectLayer.gameScreen.camera.left + previousState.mouseX;
			var oldMouseY:Number = objectLayer.gameScreen.camera.top + previousState.mouseY;
			oldMouseLoc = new Vector3D(oldMouseX, oldMouseY);
			
			overObject = objectLayer.getObjectAt(mouseLoc);
			
			if (overObject) {
				trace("Sending...");
				overObject.sendMessage("mouseOver");
			}
			
			oldOverObject = objectLayer.getObjectAt(oldMouseLoc);
			
			if (oldOverObject && !overObject) {
				
				oldOverObject.sendMessage("mouseOut");
				oldOverObject = null;
				overObject = null;
			}
			
			/*
			if (gameObject.shape.pointInShape(mousePoint)) {
				trace("mouse over object");
			}
			*/
		}
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			objectLayer = composite as ObjectLayer;
			if (!objectLayer) {
				throw new Error("MouseOverController added to Composite that is not an ObjectLayer");
			}
		}
	}

}