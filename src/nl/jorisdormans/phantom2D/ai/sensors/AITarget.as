package nl.jorisdormans.phantom2D.ai.sensors 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class AITarget extends GameObjectComponent
	{
		/**
		 * Sets the the AISense's target object. Expects input {targetObject:GameObject}
		 */
		public static const M_SET_TARGET:String = "setTarget";
		
		/**
		 * Event generated when the target is detected. Generates data: {target:GameObject}
		 */
		public static const E_DETECT_TARGET:String = "detectTarget";
		/**
		 * Event generated when the target is detected. Generates data: {target:GameObject}
		 */
		public static const E_NO_TARGET:String = "noTarget";
		/**
		 * Event generated when the target is no longer detected.
		 */
		public static const E_LOST_TARGET:String = "lostTarget";
		
		
		/**
		 * detection state, no target locked
		 */
		public static const NO_TARGET:int = 0;
		/**
		 * detection state target detected
		 */
		public static const TARGET_DETECTED:int = 1;
		/**
		 * detection state target not seen for a while
		 */
		public static const TARGET_LOST:int = 2;
		
		public static var xmlDescription:XML = <AITarget timeOut="Number"/>;
		public static var xmlDefault:XML = <AITarget timeOut="1"/>;
		
		public static function generateFromXML(xml:XML):Component {
			var comp:Component = new AITarget(1);
			comp.readXML(xml);
			return comp;
		}
		
		
		public var targetObject:GameObject;
		public var position:Vector3D;
		private var _detected:int;
		private var timeOut:Number;
		private var timer:Number;
		private var detectedThisUpdate:int;
		
	
		
		public function AITarget(timeOut:Number = 1) 
		{
			_detected = NO_TARGET;
			targetObject = null;
			position = new Vector3D();
			this.timeOut = timeOut;
			detectedThisUpdate = 0;
		}
		
		override public function generateXML():XML 
		{
			var xml:XML = super.generateXML();
			if (timeOut != 1) xml.@timeOut = timeOut;
			return xml;
		}
		
		override public function readXML(xml:XML):void 
		{
			if (xml.@timeOut.length() > 0) timeOut = xml.@timeOut;
			super.readXML(xml);
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case M_SET_TARGET:
					targetObject = data.targetObject;
					setDetected(NO_TARGET);
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}
		
		public function detect():void {
			setDetected(TARGET_DETECTED);	
			detectedThisUpdate = 2;
		}
		
		public function get detected():int 
		{
			return _detected;
		}
		
		protected function setDetected(value:int):void 
		{
			if (_detected == value) return;
			_detected = value;
			switch (_detected) {
				case TARGET_DETECTED:
					gameObject.sendMessage(E_DETECT_TARGET, { targetObject: targetObject } );	
					break;
				case TARGET_LOST:
					gameObject.sendMessage(E_LOST_TARGET );	
					timer = timeOut;
					break;
				case NO_TARGET:
					gameObject.sendMessage(E_NO_TARGET );	
					break;
			}
		}
		
		
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			switch (_detected) {
				case TARGET_DETECTED:
					detectedThisUpdate--;
					if (detectedThisUpdate<0 || (targetObject && targetObject.destroyed)) {
						setDetected(TARGET_LOST);
					} else {
						position.x = targetObject.position.x;
						position.y = targetObject.position.y;
						position.z = targetObject.position.z;
					}
					break;
				case TARGET_LOST:
					timer -= elapsedTime;
					if (timer < 0) {
						setDetected(NO_TARGET);
					}
					break;
			}
		}
		
	}

}