package nl.jorisdormans.phantom2D.gui 
{
	import nl.jorisdormans.phantom2D.core.Camera;
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	import nl.jorisdormans.phantom2D.objects.ObjectLayer;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class InterfaceLayer extends ObjectLayer implements IInputHandler
	{
		private var _hoverObject:GameObject;
		private var _clickedObject:GameObject;
		private var keyboard:Boolean;
		private var mouse:Boolean;
		private var mousePosition:Vector3D;
		private var ignoreCamera:Boolean;
		
		//Is obsolete now?
		
		
		public function InterfaceLayer(width:int, height:int, keyboard:Boolean = true, mouse:Boolean = true, ignoreCamera:Boolean = true) 
		{
			super(width, height, 1);
			physicsExecutionCount = 0;
			this.keyboard = keyboard;
			this.mouse = mouse;
			this.ignoreCamera = ignoreCamera;
			mousePosition = new Vector3D();
		}
		
		override public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void
		{
			if (mouse) {
				if (currentState.mouseX != previousState.mouseX || currentState.mouseY != previousState.mouseY) {
					mousePosition.x = currentState.mouseX;
					mousePosition.y = currentState.mouseY;
					if (!ignoreCamera) {
						mousePosition.x += gameScreen.camera.left;
						mousePosition.y += gameScreen.camera.top;
					}
					hoverObject = getObjectAt(mousePosition);
				}
				if (hoverObject && currentState.mouseButton && !previousState.mouseButton) {
					hoverObject.sendMessage("press");
					_clickedObject = hoverObject;
				}
				if (hoverObject && !currentState.mouseButton && previousState.mouseButton && _hoverObject == _clickedObject) {
					hoverObject.sendMessage("release");
				}
			}
			if (keyboard) {
				if (currentState.arrowDown && !previousState.arrowDown) changeHoverObject(1);
				if (currentState.arrowUp && !previousState.arrowUp) changeHoverObject( -1);
				if (hoverObject && ((currentState.keyEnter && !previousState.keyEnter) || (currentState.keySpace && !previousState.keySpace) )) {
					hoverObject.sendMessage("press");
					_clickedObject = _hoverObject;
				}
				if (hoverObject && ((!currentState.keyEnter && previousState.keyEnter) || (!currentState.keySpace && previousState.keySpace) )) {
					if (_hoverObject == _clickedObject) {
						hoverObject.sendMessage("release");
					}
				}
				if (hoverObject && currentState.arrowRight && !previousState.arrowRight) {
					hoverObject.sendMessage("change option right");
				}
				if (hoverObject && currentState.arrowLeft && !previousState.arrowLeft) {
					hoverObject.sendMessage("change option left");
				}
			}
		}
		
		
		
		private function changeHoverObject(delta:int):void
		{
			if (!hoverObject && objects.length>0) {
				hoverObject = objects[0];
			} else {
				var i:int = getObjectNumber(hoverObject);
				if (i < 0) return;
				i += delta;
				i %= objects.length;
				if (i < 0) i = objects.length - 1;
				hoverObject = objects[i];
			}
		}
		
		override public function render(camera:Camera):void 
		{
			if (gameScreen != gameScreen.game.currentScreen) {
				sprite.graphics.clear();
				return;
			}
			if (ignoreCamera) {
				camera.setZeroFocus();
				super.render(camera);
				camera.restoreFocus();
			} else {
				super.render(camera);
			}
		}
		
		
		public function get hoverObject():GameObject { return _hoverObject; }
		
		public function set hoverObject(value:GameObject):void 
		{
			if (value == _hoverObject) return;
			if (_hoverObject) _hoverObject.sendMessage("unhighlight");
			_hoverObject = value;
			if (_hoverObject) _hoverObject.sendMessage("highlight");
		}
		
		override public function addGameObject(gameObject:GameObject):void 
		{
			super.addGameObject(gameObject);
			
			if (keyboard && !hoverObject) {
				hoverObject = gameObject;
			}
		}
		
		
		
	}

}