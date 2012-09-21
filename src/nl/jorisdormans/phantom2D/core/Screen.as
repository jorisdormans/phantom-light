package nl.jorisdormans.phantom2D.core 
{
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	import flash.utils.getDefinitionByName;
	import nl.jorisdormans.phantom2D.cameras.Camera;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.util.StringUtil;
	
	/**
	 * Screen is the main composite class that is added to a game. A game has a stack of screens. Only the top 
	 * screen is active. Use a Screen to define menu's, and main game states. A screen has an individual camera.
	 * @author Joris Dormans
	 */
	public class Screen extends Layer
	{
		/**
		 * The screen's camera.
		 */
		public var camera:Camera;
		
		/**
		 * The width of the screen's view port.
		 */
		public var screenWidth:int;
		/**
		 * The height of the screen's view port.
		 */
		public var screenHeight:int;
		
		/**
		 * The maximum width of all the screen's layers
		 */
		public var maxWidth:int;
		/**
		 * The maximum height of all the screen's layers
		 */
		public var maxHeight:int;
		/**
		 * Indicates if the screen is currently running (don't change directly, call activate or deactivate instead).
		 */
		public var paused:Boolean;
		/**
		 * A reference to the game the screen is part of
		 */
		public var game:PhantomGame;
		
		/**
		 * Indicates if screens below should be rendered before the current game screen is.
		 */
		public var transparent:Boolean;
		/**
		 * Indicates if screens below should be updated before the current game screen is.
		 */
		public var propagateUpdate:Boolean;
		
		/**
		 * A reference to the screen below this one in the game's stack of screens. 
		 */
		public var screenBelow:Screen;
		
		
		/**
		 * Creates an instance of the GameScreen class.
		 * @param	screenWidth		Determines the width of the visible viewport.
		 * @param	screenHeight	Determines the height of the visible viewport.
		 */
		public function Screen(width:Number = 0, height:Number = 0) 
		{
			super(width, height);
			transparent = false;
			propagateUpdate = false;
			paused = true;
			screenWidth = layerWidth;
			screenHeight = layerHeight;
			maxWidth = layerWidth;
			maxHeight = layerHeight;
			camera = new Camera(this, new Vector3D(screenWidth * 0.5, screenHeight * 0.5));
		}
		
		/**
		 * Activates the screen. 
		 */
		public function activate():void {
			if (!paused) return;
			PhantomGame.log("Activating screen " + this + "...", PhantomGame.LOG_INFO, PhantomGame.LOG_TAG);
			paused = false;
		}
		
		/**
		 * Deactivates the current screen
		 */
		public function deactivate():void {
			PhantomGame.log("Deactivating screen " + this + "...", PhantomGame.LOG_INFO, PhantomGame.LOG_TAG);
			paused = true;
		}
		
		
		public function doRender():void {
			game.prof.begin("render");
			this.render(camera);
			game.prof.end("render");
		}
		
		/**
		 * The screen's main update function. Called every frame for a game's top most screen. 
		 * The update loop handles input first, it updates physics next, then it calls all other updates and finally it renders all components.
		 * @param	elapsedTime
		 */
		public function doUpdate(elapsedTime:Number):void {
			var l:int = components.length;
			//handleInput
			//input is never propagated to a screen below
			game.prof.begin("handleInput");
			if (this is IInputHandler) (this as IInputHandler).handleInput(elapsedTime, game.currentInputState, game.previousInputState);
			if (paused) return;
			game.previousInputState.copy(game.currentInputState);
			game.currentInputState.update();
			game.prof.end("handleInput");
			
			//*/
			//run physics
			game.prof.begin("physics");
			updatePhysics(elapsedTime);
			if (paused) return;
			game.prof.end("physics");
			//*/
			
			//*/
			//other updates
			game.prof.begin("other updates");
			this.update(elapsedTime);
			if (paused) return;
			game.prof.end("other update");
			//*/
			
		}
		
		
		/**
		 * Updates the physics of all the screens component. 
		 * If propagateUpdates is set to true it will update the physics of the screen below first
		 * @param	elapsedTime
		 */
		override public function updatePhysics(elapsedTime:Number):void {
			if (propagateUpdate && screenBelow) screenBelow.updatePhysics(elapsedTime);
			super.updatePhysics(elapsedTime);
		}
		
		/**
		 * Updates all the screens component. 
		 * If propagateUpdates is set to true it will update screen below first
		 * @param	elapsedTime
		 */
		override public function update(elapsedTime:Number):void {
			if (propagateUpdate && screenBelow) screenBelow.update(elapsedTime);
			super.update(elapsedTime);
			camera.update(elapsedTime);
		}
		
		
		/**
		 * Renders all screenscomponent. 
		 * If transparant flag is set to true it will render the screen below first
		 */
		override public function render(camera:Camera):void {
			if (transparent && screenBelow) screenBelow.render(screenBelow.camera);
			var l:int = components.length;
			var s:Sprite = this.sprite;
			for (var i:int = 0; i < l; i++) {
				if (components[i] is Layer) {
					(components[i] as Layer).render(camera);
					s = (components[i] as Layer).sprite;
				}
			}
			for (i = 0; i < this.renderables.length; i++) {
				this.renderables[i].render(s.graphics, camera.left, camera.top, 0, 1);
			}
		}
		
		override public function addComponent(component:Component):Component 
		{
			if (component is Layer) {
				maxWidth = Math.max((component as Layer).layerWidth, maxWidth);
				maxHeight = Math.max((component as Layer).layerHeight, maxHeight);
			}
			return super.addComponent(component);
		}
		
		override public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void 
		{
			if (this.allowInteraction) {
				currentState.localX = currentState.stageX * camera.zoom + camera.left - this.sprite.x;
				currentState.localY = currentState.stageY * camera.zoom + camera.top - this.sprite.y;
				var l:int = components.length;
				for (var i:int = 0; i < l; i++) {
					if (components[i] is IInputHandler) {
						(components[i] as IInputHandler).handleInput(elapsedTime, game.currentInputState, game.previousInputState);
					}
					if (paused) return;
				}
			}
		}
		
		override public function clear():void 
		{
			super.clear();
			for (var i:int = 0; i < components.length; i++) {
				var layer:Layer = components[i] as Layer;
				if (layer) layer.clear();
			}
		}
		
		public function openLevel(xml:XML):void 
		{
			clear();
			for (var i:int = 0; i < xml.children().length(); i++) {
				var child:XML = xml.children()[i];
				if (i<components.length) components[i].readXML(child);
			}
		}
		
		
		
		
		
	}

}