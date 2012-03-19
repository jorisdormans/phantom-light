package nl.jorisdormans.phantom2D.core 
{
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	import flash.utils.getDefinitionByName;
	import nl.jorisdormans.phantom2D.cameras.Camera;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.particles.Particle;
	import nl.jorisdormans.phantom2D.particles.ParticleLayer;
	import nl.jorisdormans.phantom2D.util.StringUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Screen extends Layer
	{
		/**
		 * The screen's camera.
		 */
		public var camera:Camera;
		
		public var screenWidth:int;
		public var screenHeight:int;
		
		/**
		 * The maximum width of all game screen components
		 */
		public var maxWidth:int;
		/**
		 * The maximum height of all game screen components
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
		 * Flag indicating if a screen is being edited by the editor
		 */
		public var editing:Boolean = false;
		
		/**
		 * A backup of the game level in xml format. Is used to reset a level.
		 */
		public var levelData:XML;
		
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
			trace("PHANTOM: Activating screen " + this + "...");
			paused = false;
		}
		
		/**
		 * Deactivates the current screen
		 */
		public function deactivate():void {
			trace("PHANTOM: Deactivating screen " + this + "...");
			paused = true;
		}
		
		
		/**
		 * The screen's main update function. Called every frame for a game's top most screen. 
		 * The update loop handles input first, it updates physics next, then it calls all other updates and finally it renders all components.
		 * @param	elapsedTime
		 */
		override public function update(elapsedTime:Number):void {
			var l:int = components.length;
			//handleInput
			//input is never propagated to a screen below
			game.prof.begin("handleInput");
			if (this is IInputHandler) (this as IInputHandler).handleInput(elapsedTime, game.currentInputState, game.previousInputState);
			if (paused) return;
			game.previousInputState.copy(game.currentInputState);
			game.currentInputState.update();
			game.prof.end("handleInput");
			
			//run physics
			game.prof.begin("physics");
			updatePhysics(elapsedTime);
			if (paused) return;
			game.prof.end("physics");
			
			//other updates
			game.prof.begin("other updates");
			updateOther(elapsedTime);
			if (paused) return;
			game.prof.end("other update");
			
			//draw frame
			game.prof.begin("render");
			render(camera);
			game.prof.end("render");
			game.prof.endProfiling();			
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
		public function updateOther(elapsedTime:Number):void {
			if (propagateUpdate && screenBelow) screenBelow.updateOther(elapsedTime);
			var l:int = components.length;
			for (var i:int = 0; i < l; i++) {
				components[i].update(elapsedTime);
			}
			camera.update(elapsedTime);
		}
		
		
		/**
		 * Renders all screenscomponent. 
		 * If transparant flag is set to true it will render the screen below first
		 */
		override public function render(camera:Camera):void {
			if (transparent && screenBelow) screenBelow.render(screenBelow.camera);
			var l:int = components.length;
			for (var i:int = 0; i < l; i++) {
				if (components[i] is Layer) {
					(components[i] as Layer).render(camera);
				}
			}
		}
		
		/*public function makeInvisible():void {
			var l:int = layers.length;
			for (var i:int = 0; i < l; i++) {
				layers[i].graphics.clear();
			}
			
		}*/
		
		
		/**
		 * Fast access to the addParticle function of ParticleLayers in the screen's component list
		 * @param	particle	The particle to be added
		 * @param	layer		Indicates the particleLayer, 0 = the lowest layer.
		 */
		public function addParticle(particle:Particle, layerIndex:int = 0):void {
			var l:int = components.length;
			for (var i:int = 0; i < l; i++) {
				if (components[i] is ParticleLayer) {
					if (layerIndex == 0) {
						(components[i] as ParticleLayer).addParticle(particle);
						return;
					} else {
						layerIndex--;
					}
				}
			}
		}
		
		/**
		 * Returns a ParticleLayer from the screen's component list
		 * @param	index	The index of the ParticleLayer (0 = the lowest layer)
		 * @return
		 */
		public function getParticleLayer(index:int = 0):ParticleLayer {
			var l:int = components.length;
			for (var i:int = 0; i < l; i++) {
				if (components[i] is ParticleLayer) {
					if (index == 0) {
						return (components[i] as ParticleLayer);
					} else {
						index--;
					}
				}
			}
			return null;
		}
		
		override public function generateNewXML():XML {
			var xml:XML = <screen/>;
			xml.@c = StringUtil.getObjectClassName(this.toString());
			for (var i:int = 0; i < components.length; i++) {
				if (components[i] is Layer) {
					xml.appendChild((components[i] as Layer).generateNewXML());
				}
			}
			return xml;
			
		}
		
		
		override public function generateXML():XML {
			var xml:XML = <screen/>;
			xml.@c = StringUtil.getObjectClassName(this.toString());
			for (var i:int = 0; i < components.length; i++) {
				if (components[i] is Layer) {
					xml.appendChild((components[i] as Layer).generateXML());
				}
			}
			return xml;
		}
		
		override public function readXML(xml:XML):void {
			if (levelData != xml) {
				//store a copy of the level data
				levelData = new XML(xml.toXMLString());
			}
			
			trace("PHANTOM: Reading screen data");
			if (xml.@c != StringUtil.getObjectClassName(this.toString())) {
				trace("WARNING: Data for '"+xml.@c+"' might not be compatible with screen of class", StringUtil.getObjectClassName(this.toString()) + ".");
			}
			for (var i:int = 0; i < components.length; i++) {
				if (components[i] is Layer) (components[i] as Layer).clear();
			}
			for (i = 0; i < xml.layer.length(); i++) {
				getComponentByClass(Layer, i).readXML(xml.layer[i]);
			}
		}
		
		public function reset():void {
			if (levelData) {
				readXML(levelData);
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
			var l:int = components.length;
			for (var i:int = 0; i < l; i++) {
				if (components[i] is IInputHandler) {
					(components[i] as IInputHandler).handleInput(elapsedTime, game.currentInputState, game.previousInputState);
				}
				if (paused) return;
			}

		}
		
		
		
	}

}