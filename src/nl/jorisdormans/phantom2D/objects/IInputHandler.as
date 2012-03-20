package nl.jorisdormans.phantom2D.objects 
{
	import nl.jorisdormans.phantom2D.core.InputState;
	
	/**
	 * Implement this interface to respond to input state changes.
	 * @author Joris Dormans
	 */
	public interface IInputHandler 
	{
		/**
		 * Implement this function to respond to input state changes.
		 * @param	elapsedTime
		 * @param	currentState
		 * @param	previousState
		 */
		function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void;
	}
	
}