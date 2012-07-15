package nl.jorisdormans.phantom2D.core 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import nl.jorisdormans.phantom2D.layers.FPSDisplay;
	import nl.jorisdormans.phantom2D.thirdparty.profiler.Profiler;
	import nl.jorisdormans.phantom2D.thirdparty.profiler.ProfilerConfig;

	
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomGame extends Sprite
	{
		/**
		 * Flag indicating debugInfo should be rendered
		 */
		static public var debugInfo:Boolean = false;
		/**
		 * Flag indicating fps counter should be rendered
		 */
		static public var displayFPS:Boolean = false;
		/**
		 * Volume for sound effects (0-1)
		 */
		static public var volumeSoundEffects:Number = 1;
		/**
		 * Volume for music (0-1)
		 */
		static public var volumeMusic:Number = 1;
		/**
		 * Master volume (0-1)
		 */
		static public var volumeMaster:Number = 1;
		
		/**
		 * Holds the current InputState. Compare to previousInputState to see respond to key presses and releases.
		 */
		public var currentInputState:InputState;
		/**
		 * Holds the InputState from last frame.
		 */
		public var previousInputState:InputState;
		
		/**
		 * Timer to measer elapsedTime between frames
		 */
		private var frameTimer:uint;
		/**
		 * Maximu elapsed time (in seconds) to be used between for updates
		 */
		protected var maxElapsedTime:Number = 0.1;
		
		private var frameCounter:uint;
		private var frameCountTimer:Number;
		
		/**
		 * The game's current framerate, is updated every second
		 */
		public static var fps:uint = 0;
		
		public static var frameClock:uint = 0;
		
		
		
		
		/**
		 * Sprite to contain the masking shape
		 */
		private var _maskShape:Sprite;
		
		/**
		 * Reference to an instance of the profiler
		 */
		public var prof:Profiler;
		
		/**
		 * Contains a stack of active screens
		 */
		private var screens:Vector.<Screen>;
		
		/**
		 * The width of the game in pixels
		 */
		public static var gameWidth:Number;
		/**
		 * The height of the game in pixels
		 */
		public static var gameHeight:Number;
		
		private var fpsLayer:FPSDisplay;
		
		private static var activeGame:PhantomGame;
		private var gametimer:Timer;
		
		public static const LOG_DEBUG : String = "Debug";
		public static const LOG_ERROR : String = "Error";
		public static const LOG_EVENT : String = "Event";
		public static const LOG_FATAL : String = "Fatal";
		public static const LOG_HOORAY : String = "Hooray";
		public static const LOG_INFO : String = "Info";
		public static const LOG_SYSTEM : String = "System";
		public static const LOG_TRACE : String = "Trace";
		public static const LOG_USER : String = "User";
		public static const LOG_WARNING : String = "Warning";		
		
		public static const LOG_TAG : String = "Phantom";		

		
		public static function log(message:String, type:String = "Info", tag:String = ""):void {
			if (activeGame) activeGame.log(message, type, tag);
		}
		
		/**
		 * Creates a Phantom Game instance
		 * @param	width		Game width in pixels
		 * @param	height		Game height in pixels
		 * @param	startScreen	Instance to the starting game screen
		 */
		public function PhantomGame(width:Number, height:Number) 
		{
			screens = new Vector.<Screen>();
			currentInputState = new InputState();
			previousInputState = new InputState();
			gameWidth = width;
			gameHeight = height;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			fpsLayer = new FPSDisplay();
			activeGame = this;
		}
		
		/**
		 * Log function that traces its output to the console. 
		 */
		public function log(message:String, type:String = "Info", tag:String = ""):void {
			if (type != "Info") {
				if (tag != "") tag += " ";
				tag += "(" + type + ")";
			}
			if (tag != "") {
				trace(tag + ": " + message);
			} else {
				trace(message);
			}
		}
		
		
		/**
		 * Called by the constructor or after the game is added to the stage. Initiate your game here
		 * @param	e
		 */
		protected function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			//create vector to contain screens
			
			//contain current and previous input states
			
			//create a profilier
			prof = new Profiler(10);
			//ProfilerConfig.Width = 200;
			ProfilerConfig.ShowMinMax = true;
			ProfilerConfig.Width = 800;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.frameRate = 60;
		
			//add event listeners
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, currentInputState.onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, currentInputState.onKeyUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, currentInputState.onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, currentInputState.onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, currentInputState.onMouseMove);
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			//create and add a mask
			_maskShape = new Sprite();
			_maskShape.graphics.beginFill(0xffffff);
			_maskShape.graphics.drawRect(0, 0, gameWidth, gameHeight);
			_maskShape.graphics.endFill();
			stage.addChild(_maskShape);
			mask = _maskShape;
			
			this.focusRect = null;
			
			//get timer
			frameTimer = getTimer();
			
			frameCounter = 0;
			frameCountTimer = 0;
			prof.beginProfiling();
			prof.begin("idle");
		}		
		
		/**
		 * Key down event listener to show or hide the profiler
		 * @param	e
		 */
		/*
		private function onKeyDown(e:KeyboardEvent):void 
		{
			//trace("Key down", e.keyCode);
			if (e.keyCode == 80) {
				if (prof.parent) {
					prof.parent.removeChild(prof);
				} else {
					addChild(prof);
				}
			}
		}*/
		
		
		public function showDebugInfo():void {
			PhantomGame.debugInfo = true;
		}
		
		public function hideDebugInfo():void {
			PhantomGame.debugInfo = false;
		}
		
		public function showFPS():void {
			PhantomGame.displayFPS = true;
			if (fpsLayer.parent) fpsLayer.parent.removeComponent(fpsLayer);
			currentScreen.addComponent(fpsLayer);
		}
		
		public function hideFPS():void {
			PhantomGame.displayFPS = false;
			if (fpsLayer.parent) fpsLayer.parent.removeComponent(fpsLayer);
		}
		
		public function showProfiler():void {
			if (prof.parent) {
				prof.parent.removeChild(prof);
			}
			addChild(prof);
		}
		
		public function hideProfiler():void {
			if (prof.parent) {
				prof.parent.removeChild(prof);
			}
		}
		
		/**
		 * Handles the game loop
		 * @param	e
		 */
		private function onEnterFrame(e:Event):void 
		{
			
			//Get the elapsed time and calculate fps
			var time:uint = getTimer();
			var elapsedTime:Number = (time-frameTimer) / 1000;
			frameCountTimer += elapsedTime;
			elapsedTime = Math.min(maxElapsedTime, elapsedTime);
			frameTimer = time;
			
			//fps
			frameCounter++;
			if (frameCountTimer >= 1) {
				frameCountTimer -= 1;
				fps = frameCounter;
				frameCounter = 0;
			}
			
			frameClock++;
			
			prof.end("idle");
			prof.endProfiling();
			prof.beginProfiling();
			prof.begin("game");
			//update the current screen
			if (currentScreen) currentScreen.update(elapsedTime);
			prof.end("game");
			prof.begin("idle");
		}		
		
		/**
		 * Add a screen to the top of the screens stack and activate it
		 * @param	screen
		 */
		public function addScreen(screen:Screen):void {
			log("Adding screen "+screen+"...", LOG_INFO, LOG_TAG);
			if (currentScreen) {
				currentScreen.deactivate();
				screen.screenBelow = currentScreen;
			}
			//remove all children before adding a nontransparent screen
			if (!screen.transparent) {
				for (var i:int = 0; i < screens.length; i++) {
					if (screens[i].sprite.parent) {
						screens[i].sprite.parent.removeChild(screens[i].sprite.parent);
					}
				}
			}
			screens.push(screen);
			screen.game = this;
			addChild(screen.sprite);
			screen.activate();
			previousInputState.copy(currentInputState);
			if (fpsLayer.parent) fpsLayer.removeComponent(fpsLayer);
			if (displayFPS) currentScreen.addComponent(fpsLayer);
			
		}
		
		/**
		 * Removes and disposes any screen from the stack. If it is the top most screen, the screen below is activated.
		 * @param	screen
		 */
		public function removeScreen(screen:Screen):void {
			if (screen == currentScreen) {
				removeCurrentScreen();
			} else {
				log("Removing screen "+screen+"...", LOG_INFO, LOG_TAG);
				if (screen.game != this) return;
				screen.deactivate();
				removeChild(screen.sprite);
				//find and remove all instances
				for (var i:int = screens.length - 2; i >= 0; i--) {
					if (screens[i] == screen) {
						screens[i].dispose();
						if (i>0 && i == screens.length - 1) {
							//removed the top
							screens[i - 1].activate();
							if (displayFPS) {
								if (fpsLayer.parent) fpsLayer.removeComponent(fpsLayer);
								currentScreen.addComponent(fpsLayer);
							}

						} else {
							//removed in the middle
							if (i > 0) {
								screens[i + 1].screenBelow = screens[i - 1];
							} else {
								screens[i + 1].screenBelow = null;
							}
						}
						screens.splice(i, 1);
					}
				}
			}
		}
		
		/**
		 * Retrieves an instance of the screen on top of the screens stack.
		 */
		public function get currentScreen():Screen {
			if (screens.length > 0) {
				return screens[screens.length - 1];
			} else {
				return null;
			}
		}
		
		/**
		 * Removes and disposes the top most screen from the screens stack. Activates the screen below.
		 */
		public function removeCurrentScreen():void {
			if (currentScreen) {
				log("Removing current screen " + currentScreen + "...", LOG_INFO, LOG_TAG);
				currentScreen.deactivate();
				removeChild(currentScreen.sprite);
				currentScreen.dispose();
				screens.splice(screens.length - 1, 1);
			}
			if (currentScreen) {
				if (!currentScreen.sprite.parent) {
					//add the current screen back to the display list
					addChildAt(currentScreen.sprite, 0);
					var s:Screen = currentScreen;
					while (s.screenBelow && s.transparent) {
						s = s.screenBelow;
						addChildAt(s.sprite, 0);
					}
				}
				currentScreen.activate();
			}
			previousInputState.copy(currentInputState);
		}
	}

}