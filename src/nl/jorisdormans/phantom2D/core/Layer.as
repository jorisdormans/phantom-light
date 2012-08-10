package nl.jorisdormans.phantom2D.core 
{
	import flash.display.Sprite;
	import nl.jorisdormans.phantom2D.cameras.Camera;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	import nl.jorisdormans.phantom2D.util.StringUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Layer extends Composite implements IInputHandler
	{
		/**
		 * Message to change internal flags that help when a layer needs to be draw wrapped.
		 * These are called by the cameras.WrapAroundLayer component.
		 * Expects input: {[horizontal:Boolean][,vertical:Boolean]}
		 */
		public static const M_SET_WRAPPED:String = "setWrapped";
		
		
		/**
		 * A reference to the sprite the layer uses to draw itself to.
		 */
		public var sprite:Sprite;
		
		/**
		 * A reference to its parent as a Layer.
		 */
		public var layer:Layer;
		
		/**
		 * A rerference to its parent as a Screen.
		 */
		public var screen:Screen;
		
		protected var renderWrappedHorizontal:Boolean = false;
		protected var renderWrappedVertical:Boolean = false;
		
		/**
		 * Flag that can be used to toggle whether a layer responds to inputs.
		 */
		public var allowInteraction:Boolean = true;
		
		/**
		 * The width of the ObjectLayer
		 */
		public var layerWidth:Number;
		/**
		 * The height of the ObjectLayer
		 */
		public var layerHeight:Number;		
		
		/**
		 * Contructor for the layer
		 * @param	width	The layer's width, use 0 if you want to use the game's default width.
		 * @param	height  The layer's height, use 0 if you want to use the game's default height.
		 */
		public function Layer(width:int=0, height:int=0) 
		{
			sprite = new Sprite();
			if (width>0) {
				layerWidth = width;
			} else {
				layerWidth = PhantomGame.gameWidth;
			}
			if (height>0) {
				layerHeight = height;
			} else {
				layerHeight = PhantomGame.gameHeight;
			}
		}
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			layer = composite as Layer;
			if (layer) {
				layer.sprite.addChild(sprite);
			}
			screen = composite as Screen;
		}
		
		override public function onRemove():void 
		{
			if (sprite.parent) {
				sprite.parent.removeChild(sprite);
			}
			layer = null;
			screen = null;
			super.onRemove();
		}
		
		override public function dispose():void 
		{
			sprite = null;
			layer = null;
			screen = null;
			super.dispose();
		}
		
		/**
		 * Clears the layer and all its contents
		 */
		public function clear():void {
		
		}
		
		override public function handleMessage(message:String, data:Object = null, componentClass:Class = null):int 
		{
			switch (message) {
				case M_SET_WRAPPED:
					if (data && data.horizontal) renderWrappedHorizontal = data.horizontal;
					if (data && data.vertical) renderWrappedVertical = data.vertical;
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}
		
		
		/**
		 * Called to render the objects this component controls
		 * @param	camera
		 */
		public function render(camera:Camera):void {
			sprite.graphics.clear();
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IInputHandler */
		
		public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void 
		{
			if (allowInteraction) {
				for (var i:int = 0; i < components.length; i++) {
					if (components[i] is IInputHandler) (components[i] as IInputHandler).handleInput(elapsedTime, currentState, previousState);
				}
			}
		}
		
	}

}