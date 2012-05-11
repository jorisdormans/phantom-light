package nl.jorisdormans.phantom2D.ai.statemachines 
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.core.Phantom;
	/**
	 * ...
	 * @author R. van Swieten
	 */
	public class StateMachine extends State 
	{
		private var states:Vector.<State>;
		private var firstState:State;
		
		public function StateMachine(firstState:State = null) 
		{
			this.firstState = firstState;
			states = new Vector.<State>();
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
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			var r:int = Phantom.MESSAGE_NOT_HANDLED;
			if (states.length > 0) {
				r = states[states.length - 1].handleMessage(message, data);
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
		
	}

}