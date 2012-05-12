package nl.jorisdormans.phantom2D.ai.statemachines 
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.core.Phantom;
	/**
	 * ...
	 * @author R. van Swieten
	 */
	public class State extends Composite 
	{
		protected var stateMachine:StateMachine;
		
		public function State() 
		{
			
		}
		
		override public function onAdd(composite:Composite):void {
			super.onAdd(composite);
			this.stateMachine = composite as StateMachine;
			
		}
		
		override public function onRemove():void {
			
		}
		
		public function onActivate():void 
		{
			
		}
		
		public function onDeactivate():void 
		{
			
		}
		
		
	}

}