package nl.jorisdormans.phantom2D.objects.misc 
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class SpacePressMessage extends Component implements IInputHandler
	{
		private var generatedMessage:String;
		
		public function SpacePressMessage(generatedMessage:String) 
		{
			this.generatedMessage = generatedMessage;
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IInputHandler */
		
		public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void 
		{
			if (currentState.keySpace && !previousState.keySpace) {
				parent.sendMessage(generatedMessage);
			}
		}
		
		
		
	}

}