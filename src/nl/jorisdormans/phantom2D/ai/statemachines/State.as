package nl.jorisdormans.phantom2D.ai.statemachines 
{
	import nl.jorisdormans.phantom2D.core.Phantom;
	/**
	 * ...
	 * @author R. van Swieten
	 */
	public class State 
	{
		protected var stateMachine:StateMachine;
		
		public function State() 
		{
			
		}
		
		public function onAdd(stateMachine:StateMachine):void {
			this.stateMachine = stateMachine;
			
		}
		
		public function onRemove():void {
			
		}
		
		public function onActivate():void 
		{
			
		}
		
		public function onDeactivate():void 
		{
			
		}
		
		public function update(elapsedTime:Number):void {
			
		}
		
		public function handleMessage(message:String, data:Object = null):int
		{
			return Phantom.MESSAGE_NOT_HANDLED;
		}
	}

}