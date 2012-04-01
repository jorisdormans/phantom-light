package nl.jorisdormans.phantom2D.core 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	/**
	 * The InputState class keeps track of the mouse, arrow keys and up to 8 user defined keys
	 * @author Joris Dormans
	 */
	public class InputState 
	{
		/**
		 * The mouse X position on the stage
		 */
		public var stageX:int = 0;
		/**
		 * The mouse Y position on the stage
		 */
		public var stageY:int = 0;
		/**
		 * The mouse button state
		 */
		public var mouseButton:Boolean = false;
		
		/**
		 * The mouse X position relative to the active screen's camera.
		 */
		public var localX:Number = 0;
		/**
		 * The mouse Y position relative to the active screen's camera.
		 */
		public var localY:Number = 0;
		
		/**
		 * State of the up arrow key
		 */
		public var arrowUp:Boolean = false;
		/**
		 * State of the down arrow key
		 */
		public var arrowDown:Boolean = false;
		/**
		 * State of the left arrow key
		 */
		public var arrowLeft:Boolean = false;
		/**
		 * State of the right arrow key
		 */
		public var arrowRight:Boolean = false;
		
		
		public var keyEnter:Boolean = false;
		public var keySpace:Boolean = false;
		public var keyEscape:Boolean = false;
		/**
		 * State of user defined key number 1 (defined by InputState.keyCode1)
		 */
		public var key1:Boolean = false;
		/**
		 * State of user defined key number 2 (defined by InputState.keyCode2)
		 */
		public var key2:Boolean = false;
		/**
		 * State of user defined key number 3 (defined by InputState.keyCode3)
		 */
		public var key3:Boolean = false;
		/**
		 * State of user defined key number 4 (defined by InputState.keyCode4)
		 */
		public var key4:Boolean = false;
		/**
		 * State of user defined key number 5 (defined by InputState.keyCode5)
		 */
		public var key5:Boolean = false;
		/**
		 * State of user defined key number 6 (defined by InputState.keyCode6)
		 */
		public var key6:Boolean = false;
		/**
		 * State of user defined key number 7 (defined by InputState.keyCode7)
		 */
		public var key7:Boolean = false;
		/**
		 * State of user defined key number 8 (defined by InputState.keyCode8)
		 */
		public var key8:Boolean = false;
		
		private  var mouseButtonReleased:Boolean = false;
		
		private var keyEnterReleased:Boolean = false;
		private var keySpaceReleased:Boolean = false;
		private var keyEscapeReleased:Boolean = false;
		
		private var key1Released:Boolean = false;
		private var key2Released:Boolean = false;
		private var key3Released:Boolean = false;
		private var key4Released:Boolean = false;
		private var key5Released:Boolean = false;
		private var key6Released:Boolean = false;
		private var key7Released:Boolean = false;
		private var key8Released:Boolean = false;
		
		private var arrowUpReleased:Boolean = false;
		private var arrowDownReleased:Boolean = false;
		private var arrowLeftReleased:Boolean = false;
		private var arrowRightReleased:Boolean = false;
		
		/**
		 * Key code to define user defined key 1 (default is Space).
		 */
		public static var keyCode1:int = Keyboard.SHIFT;
		/**
		 * Key code to define user defined key 2 (default is Shift).
		 */
		public static var keyCode2:int = Keyboard.CONTROL;
		/**
		 * Key code to define user defined key 3 (default is none).
		 */
		public static var keyCode3:int = 0;
		/**
		 * Key code to define user defined key 4 (default is none).
		 */
		public static var keyCode4:int = 0;
		/**
		 * Key code to define user defined key 5 (default is none).
		 */
		public static var keyCode5:int = 0;
		/**
		 * Key code to define user defined key 6 (default is none).
		 */
		public static var keyCode6:int = 0;
		/**
		 * Key code to define user defined key 7 (deafult is none).
		 */
		public static var keyCode7:int = 0;
		/**
		 * Key code to define user defined key 8 (default is none).
		 */
		public static var keyCode8:int = 0;
		
		public function InputState() 
		{
			
		}
		
		/**
		 * The update function changes the state of the keys 
		 * when they have been released since the last update
		 */
		public function update():void {
			if (keyEnterReleased) {
				keyEnter = false;
				keyEnterReleased = false;
			}
			if (keySpaceReleased) {
				keySpace = false;
				keySpaceReleased = false;
			}
			if (keyEscapeReleased) {
				keyEscape = false;
				keyEscapeReleased = false;
			}
			if (key1Released) {
				key1 = false;
				key1Released = false;
			}
			if (key2Released) {
				key2 = false;
				key2Released = false;
			}
			if (key3Released) {
				key3 = false;
				key3Released = false;
			}
			if (key4Released) {
				key4 = false;
				key4Released = false;
			}
			if (key5Released) {
				key5 = false;
				key5Released = false;
			}
			if (key6Released) {
				key6 = false;
				key6Released = false;
			}
			if (key7Released) {
				key7 = false;
				key7Released = false;
			}
			if (key8Released) {
				key8 = false;
				key8Released = false;
			}
			
			if (arrowUpReleased) {
				arrowUp = false;
				arrowUpReleased = false;
			}
			if (arrowDownReleased) {
				arrowDown = false;
				arrowDownReleased = false;
			}
			if (arrowLeftReleased) {
				arrowLeft = false;
				arrowLeftReleased = false;
			}
			if (arrowRightReleased) {
				arrowRight = false;
				arrowRightReleased = false;
			}
			if (mouseButtonReleased) {
				mouseButton = false;
				mouseButtonReleased = false;
			}

		}
		
		/**
		 * Copies the state of a source InputState into this InputState
		 * @param	source
		 */
		public function copy(source:InputState):void {
			arrowUp = source.arrowUp;
			arrowDown = source.arrowDown;
			arrowLeft = source.arrowLeft;
			arrowRight = source.arrowRight;
			
			keyEnter = source.keyEnter;
			keySpace = source.keySpace;
			keyEscape = source.keyEscape;
			
			key1 = source.key1;
			key2 = source.key2;
			key3 = source.key3;
			key4 = source.key4;
			key5 = source.key5;
			key6 = source.key6;
			key7 = source.key7;
			key8 = source.key8;
			
			stageX = source.stageX;
			stageY = source.stageY;
			mouseButton = source.mouseButton;
			localX = source.localX;
			localY = source.localY;
		}
		
		/**
		 * Event handler for the mouse down event
		 * @param	e
		 */
		public function onMouseDown(e:MouseEvent):void 
		{
			mouseButton = true;
		}
		
		/**
		 * Event handler for the mouse up event, the mouseButton state is not affected until after the next update
		 * @param	e
		 */
		public function onMouseUp(e:MouseEvent):void 
		{
			mouseButtonReleased = true;
		}
		
		/**
		 * Event handler for the mouse mopve event
		 * @param	e
		 */
		public function onMouseMove(e:MouseEvent):void 
		{
			stageX = e.stageX;
			stageY = e.stageY;
		}
		
		/**
		 * Event handler for the key down event
		 * @param	e
		 */
		public function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.UP) arrowUp = true;
			if (e.keyCode == Keyboard.DOWN) arrowDown = true;
			if (e.keyCode == Keyboard.LEFT) arrowLeft = true;
			if (e.keyCode == Keyboard.RIGHT) arrowRight = true;
			
			if (e.keyCode == Keyboard.ENTER) keyEnter = true;
			if (e.keyCode == Keyboard.SPACE) keySpace = true;
			if (e.keyCode == Keyboard.ESCAPE) keyEscape = true;
			
			if (e.keyCode == keyCode1) key1 = true;
			if (e.keyCode == keyCode2) key2 = true;
			if (e.keyCode == keyCode3) key3 = true;
			if (e.keyCode == keyCode4) key4 = true;
			if (e.keyCode == keyCode5) key5 = true;
			if (e.keyCode == keyCode6) key6 = true;
			if (e.keyCode == keyCode7) key7 = true;
			if (e.keyCode == keyCode8) key8 = true;
		}
		
		/**
		 * Event handler for the key up event, key states are not affected until after the next update
		 * @param	e
		 */
		public function onKeyUp(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.UP) arrowUpReleased = true;
			if (e.keyCode == Keyboard.DOWN) arrowDownReleased = true;
			if (e.keyCode == Keyboard.LEFT) arrowLeftReleased = true;
			if (e.keyCode == Keyboard.RIGHT) arrowRightReleased = true;
			
			if (e.keyCode == Keyboard.ENTER) keyEnterReleased = true;
			if (e.keyCode == Keyboard.SPACE) keySpaceReleased = true;
			if (e.keyCode == Keyboard.ESCAPE) keyEscapeReleased = true;
	
			if (e.keyCode == keyCode1) key1Released = true;
			if (e.keyCode == keyCode2) key2Released = true;
			if (e.keyCode == keyCode3) key3Released = true;
			if (e.keyCode == keyCode4) key4Released = true;
			if (e.keyCode == keyCode5) key5Released = true;
			if (e.keyCode == keyCode6) key6Released = true;
			if (e.keyCode == keyCode7) key7Released = true;
			if (e.keyCode == keyCode8) key8Released = true;
			
		}
		
	}

}