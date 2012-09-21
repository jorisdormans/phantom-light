package nl.jorisdormans.phantom2D.gui 
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	import nl.jorisdormans.phantom2D.objects.ObjectLayer;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class GUIKeyboardControler extends Component implements IInputHandler
	{
		public static const M_FOCUS:String = "focus";
		public static const UP_DOWN:String = "up-down";
		public static const LEFT_RIGHT:String = "left-right";
		private var objectLayer:ObjectLayer;
		private var focusedObject:int;
		public var orientation:String;
		
		public function GUIKeyboardControler(orientation:String = UP_DOWN) 
		{
			focusedObject = -1;
			this.orientation = orientation;
		}
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			objectLayer = composite as ObjectLayer;
			selectFirst();
		}
		
		public function selectFirst():void {
			focusedObject = -1;
			changeFocus(1);
		}
		
		private function changeFocus(delta:int):void {
			var o:int = focusedObject;
			var i:int = 0;
			while (true) {
				//change the object to focus on
				o += delta;
				if (o < 0) o = objectLayer.objects.length - 1;
				if (o >= objectLayer.objects.length) o = 0;
				
				i++;
				//did I go full circle? than break
				if (i>=objectLayer.objects.length) {
					break;
				}
				
				//can I focus on this object, than change focus
				if (objectLayer.objects[o].handleMessage(GUIKeyboardHandler.M_FOCUS) == Phantom.MESSAGE_CONSUMED) {
					break;
				}
			}
		}
		
		private function setFocus(gameObject:GameObject):void {
			for (var i:int = 0; i < objectLayer.objects.length; i++) {
				if (objectLayer.objects[i] == gameObject) {
					if (i != focusedObject && focusedObject>=0) {
						objectLayer.objects[focusedObject].handleMessage(GUIKeyboardHandler.M_BLUR);
						
					}
					break;
				}
			}
			focusedObject = i;
		}
		
		override public function handleMessage(message:String, data:Object = null, componentClass:Class = null):int 
		{
			switch (message) {
				case M_FOCUS:
					setFocus(data.focus);
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data, componentClass);
		}
		
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IInputHandler */
		
		public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void 
		{
			switch (orientation) {
				case UP_DOWN:
					if (currentState.arrowDown && !previousState.arrowDown) {
						changeFocus(1);
					}
					if (currentState.arrowUp && !previousState.arrowUp) {
						changeFocus(-1);
					}
					break;
				case LEFT_RIGHT:
					if (currentState.arrowRight && !previousState.arrowRight) {
						changeFocus(1);
					}
					if (currentState.arrowLeft && !previousState.arrowLeft) {
						changeFocus(-1);
					}
					break;
			}
		}
		
	}

}