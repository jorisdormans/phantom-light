package nl.jorisdormans.phantom2D.objects 
{
	import nl.jorisdormans.phantom2D.core.InputState;
	
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public interface IInputHandler 
	{
		function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void;
	}
	
}