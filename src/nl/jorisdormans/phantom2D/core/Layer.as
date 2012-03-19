package nl.jorisdormans.phantom2D.core 
{
	import flash.display.Sprite;
	import nl.jorisdormans.phantom2D.cameras.Camera;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.util.StringUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Layer extends Composite implements IInputHandler
	{
		public var sprite:Sprite;
		public var layer:Layer;
		public var screen:Screen;
		
		protected var renderWrappedHorizontal:Boolean = false;
		protected var renderWrappedVertical:Boolean = false;
		
		public static const M_SET_WRAPPED:String = "setWrapped";
		
		public var allowInteraction:Boolean = true;
		
		/**
		 * The width of the ObjectLayer
		 */
		public var layerWidth:Number;
		/**
		 * The height of the ObjectLayer
		 */
		public var layerHeight:Number;		
		
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
		
		public function clear():void {
		
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case M_SET_WRAPPED:
					renderWrappedHorizontal = data.horizontal;
					renderWrappedVertical = data.vertical;
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}
		
		/**
		 * Generate xml data describing a new layer, this is used to create a new, empty level
		 * @return
		 */
		public function generateNewXML():XML {
			var xml:XML = <layer/>;
			xml.@c = StringUtil.getObjectClassName(this.toString());
			return xml;
		}
		
		/**
		 * Generate xml data describing the current layer, this is used to save level data
		 * @return
		 */
		public function generateXML():XML {
			var xml:XML = <layer/>;
			xml.@c = StringUtil.getObjectClassName(this.toString());
			return xml;
		}
		
		public function executeScript(script:String, caller:GameObject):void {
			var p:int = script.indexOf(";");
			var command:String;
			if (p >= 0) {
				command = script.substr(0, p);
				script = script.substr(p + 1);
			} else {
				command = script;
				script = "";
			}
			command = StringUtil.trim(command);
			script = StringUtil.trim(script);
			trace("Executing:", command);
			var commandArray:Array = StringUtil.parseCommand(command);
			executeCommand(commandArray, caller);
			if (script.length > 0) {
				executeScript(script, caller);
			}
		}
		
		public function executeCommand(command:Array, caller:GameObject):Boolean {
			if (command[0] == "changeLight") {
				screen.sendMessage("changeLight", { target: command[1], speed:command[2] } );
				return true;
			}
			return false;
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