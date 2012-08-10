package nl.jorisdormans.phantom2D.ai.statemachines 
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.core.PhantomGame;
	import nl.jorisdormans.phantom2D.graphics.PhantomFont;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.util.StringUtil;
	/**
	 * ...
	 * @author R. van Swieten
	 */
	public class StateMachine extends State implements IRenderable
	{
		public static var xmlDescription:XML = <StateMachine firstState="String"/>;
		public static var xmlDefault:XML = <StateMachine firstState=""/>;
		
		public static function generateFromXML(xml:XML):Component {
			var comp:Component = new StateMachine();
			comp.readXML(xml);
			return comp;
		}
		
		private var states:Vector.<State>;
		private var firstState:State;
		
		public function StateMachine(firstState:State = null) 
		{
			this.firstState = firstState;
			states = new Vector.<State>();
		}
		
		override public function generateXML():XML 
		{
			var xml:XML = super.generateXML();
			if (firstState) xml.@firstState = StringUtil.getObjectClassName(firstState.toString());
			return xml;
		}
		
		override public function readXML(xml:XML):void 
		{
			if (xml.@firstState.length() > 0) {
				firstState = StateFactory.getInstance().getState(xml.@firstState);
			}
			super.readXML(xml);
		}		
		
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			if(firstState != null) {
				addState(firstState);
			}
		}
		
		public function addState(state:State):void {
			if (states.length > 0) {
				states[states.length - 1].onDeactivate();
			}
			states.push(state);
			state.onAdd(this);
			state.onActivate();
		}
		
		public function removeState(state:State):void {
			if (states.length > 0 && states[states.length - 1] == state) {
				popState();
			}else{
				for (var i:int = states.length -1; i >= 0; i--) {
					if (states[i] == state) {
						state.onRemove();
						states.splice(i, 1);
						break;
					}
				}
			}
		}
		
		public function popState():State
		{
			var state:State = states.pop();
			state.onDeactivate();
			state.onRemove();
			if (states.length > 0) {
				states[states.length - 1].onActivate();
			}
			return state;
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			if (states.length > 0) {
				states[states.length - 1].update(elapsedTime);
			}
		}
		
		override public function updatePhysics(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			if (states.length > 0) {
				states[states.length - 1].updatePhysics(elapsedTime);
			}
		}
		
		override public function handleMessage(message:String, data:Object = null, componentClass:Class = null):int 
		{
			var r:int = Phantom.MESSAGE_NOT_HANDLED;
			if (states.length > 0) {
				r = states[states.length - 1].handleMessage(message, data, componentClass);
				if (r != Phantom.MESSAGE_CONSUMED) return r;
			}
			switch (super.handleMessage(message, data)) {
				case Phantom.MESSAGE_NOT_HANDLED:
					return r;
				case Phantom.MESSAGE_CONSUMED:
					return Phantom.MESSAGE_CONSUMED;
				default:
					return Phantom.MESSAGE_HANDLED;
			}
			
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			if (PhantomGame.debugInfo) {
				var s:String = "No State!";
				if (states.length > 0) s = StringUtil.getObjectClassName(states[states.length-1].toString());
				graphics.lineStyle(4, 0x000000);
				PhantomFont.drawText(s, graphics, x, y, 7, PhantomFont.ALIGN_CENTER);
				graphics.lineStyle(2, 0xffffff);
				PhantomFont.drawText(s, graphics, x, y, 7, PhantomFont.ALIGN_CENTER);
				graphics.lineStyle();
			}
		}
		
	}

}