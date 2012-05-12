package nl.jorisdormans.phantom2D.ai.statemachines 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class StateFactory 
	{
		
		protected static var instance:StateFactory;
		
		public function StateFactory() 
		{
			if (instance) throw new Error( "StateFactory can only be accessed through StateFactory.getInstance()" ); 
		}
		
		public static function getInstance():StateFactory {
			if (!instance) {
				instance = new StateFactory();
				instance.initialize();
			}
			return instance;
		}
		
		public var states:Dictionary;
		
		protected function initialize():void {
			states = new Dictionary();
			states["State"] = State;
		}
		
		public function getState(name:String):State {
			var type:Class = states[name];
			if (type) {
				var state:State = new type();
				return state;
			} else {
				trace("Phantom Warning: State '" + name + "' could not be found by StateFactory!");
				return null;
			}
		}
	}

}