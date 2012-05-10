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
		public static var xmlDescription:XML = <SpacePressMessage message="String"/>;
		public static var xmlDefault:XML = <SpacePressMessage message=""/>;
		
		public static function generateFromXML(xml:XML):Component {
			var comp:Component = new SpacePressMessage(xml.@message);
			comp.readXML(xml);
			return comp;
		}
		
		private var generatedMessage:String;
		
		public function SpacePressMessage(generatedMessage:String) 
		{
			this.generatedMessage = generatedMessage;
		}
		
		override public function generateXML():XML 
		{
			var xml:XML = super.generateXML();
			xml.@message = generatedMessage;
			return xml;
		}
		
		override public function readXML(xml:XML):void 
		{
			if (xml.@message.length() > 0) generatedMessage = xml.@message;
			super.readXML(xml);
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