package nl.jorisdormans.phantom2D.cameras 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.cameras.FollowObject;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.core.Screen;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Camera extends Composite
	{
		/**
		 * Message that makes the camera jump to a specified location. Takes input: {target:Vector3} or {x:Number, y:Number}.
		 */
		public static const M_JUMP_TO:String = "jumpTo";
		/**
		 * Message sets the target of camera to a specified location. Takes input: {target:Vector3} or {x:Number, y:Number}.
		 */
		public static const M_MOVE_TO:String = "moveTo";
		
		/**
		 * A reference to the screen the camera is a component of
		 */
		public var screen:Screen;
		
		/**
		 * The current camera position.
		 */
		public var position:Vector3D;
		
		/**
		 * The current camera target, it will move to or towards this position on the next update.
		 */
		public var target:Vector3D;
		private var setTarget:Vector3D;
		
		/**
		 * Current camera angle.
		 */
		public var angle:Number = 0;
		
		/**
		 * Current camera zoom.
		 */
		public var zoom:Number = 1;
		
		/**
		 * The left corner of the screens visible area.
		 */
		public var left:Number = 0;
		/**
		 * The top corner of the screens visible area.
		 */
		public var top:Number = 0;
		/**
		 * The right corner of the screens visible area.
		 */
		public var right:Number = 0;
		/**
		 * The bottom corner of the screens visible area.
		 */
		public var bottom:Number = 0;
		
		
		/**
		 * Camera class handle what area of a screen is visible.   
		 * @param	screen     The Screen the camera is focused on
		 * @param	position   The initial camera position
		 */
		public function Camera(screen:Screen, position:Vector3D) 
		{
			super();
			this.screen = screen;
			this.position = position;
			this.target = position.clone();
			this.setTarget = position.clone();
			
			
		}
		
		override public function update(elapsedTime:Number):void 
		{
			target.x = setTarget.x;
			target.y = setTarget.y;
			super.update(elapsedTime);
			position.x = target.x;
			position.y = target.y;
			left = position.x - screen.screenWidth * 0.5;
			top = position.y - screen.screenHeight * 0.5;
			right = position.x + screen.screenWidth * 0.5;
			bottom = position.y + screen.screenHeight * 0.5;
		}
		
		override public function handleMessage(message:String, data:Object = null, componentClass:Class = null):int 
		{
			switch (message) {
				case M_JUMP_TO:
					if (data && data.target) {
						target = data.target;
					}
					if (data && data.x) {
						target.x = data.x;
					}
					if (data && data.y) {
						target.y = data.y;
					}
					position.x = setTarget.x = target.x;
					position.y = setTarget.y = target.y;
					position.z = setTarget.z = target.z;
					handleMessage(FollowObject.M_STOP_FOLLOWING);
					break;
				case M_MOVE_TO:
					if (data && data.target) {
						target = data.target;
					}
					if (data && data.x) {
						target.x = data.x;
					}
					if (data && data.y) {
						target.y = data.y;
					}
					target = data.target;
					setTarget.x = target.x;
					setTarget.y = target.y;
					setTarget.z = target.z;
					handleMessage(FollowObject.M_STOP_FOLLOWING);
					break;
			}
			return super.handleMessage(message, data);
		}
	}
}