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
	 * @author R. van Swieten
	 */
	public class DragController extends Component implements IInputHandler
	{
		private var objectLayer:ObjectLayer;
		private var draggedObject:GameObject;
		private var mouseDownLoc:Vector3D;
		private var mouseOffSetX:Number;
		private var mouseOffSetY:Number;
		
		public function DragController() 
		{
			
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IInputHandler */
		
		public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void 
		{
			var mouseX:Number = this.objectLayer.screen.camera.left + currentState.stageX;
			var mouseY:Number = this.objectLayer.screen.camera.top + currentState.stageY;
			
			if (currentState.mouseButton && !previousState.mouseButton) {
				mouseDownLoc = new Vector3D(mouseX, mouseY);
				draggedObject = objectLayer.getObjectAt(mouseDownLoc);
				
				
				
				if(draggedObject) {
					draggedObject.handleMessage("startDrag");
				
					mouseOffSetX = draggedObject.position.x - mouseX;
					mouseOffSetY = draggedObject.position.y - mouseY;
				}
			}
			
			if (!currentState.mouseButton && previousState.mouseButton && draggedObject) {
				draggedObject.handleMessage("stopDrag");
				draggedObject = null;
			}
			
			if (draggedObject) {
				draggedObject.handleMessage("dragTo", { x: mouseX + mouseOffSetX, y: mouseY + mouseOffSetY, elapsedTime: elapsedTime } );
			}
		}
		
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			objectLayer = composite as ObjectLayer;
			if (!objectLayer) {
				throw new Error("DragController added to Composite that is not an ObjectLayer");
			}
		}
	}

}