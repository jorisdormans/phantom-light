package nl.jorisdormans.phantom2D.gui 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.gui.SimpleButtonRenderer;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.ObjectLayer;
	import nl.jorisdormans.phantom2D.objects.shapes.BoundingBoxAA;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class SimpleMenuButton extends GameObject
	{
		private var command:String;
		
		public function SimpleMenuButton() 
		{
			
		}
		
		override public function initialize(objectLayer:ObjectLayer, position:Vector3D, data:Object = null):GameObject 
		{
			if (data.sortOrder) this.sortOrder = data.sortOrder;
			else this.sortOrder = position.y;
			addComponent(new BoundingBoxAA(new Vector3D(100, 20)));
			addComponent(new SimpleButtonRenderer(data.caption, 14, 0x000000, 0xffffff, 0x006600, 0xffffff, 0x00ff00, 0xffffff, 3));
			addComponent(new GUIKeyboardHandler());
			addComponent(new MouseHandler());
			this.command = data.command;
			return super.initialize(objectLayer, position, data);
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			if (message == GUIKeyboardHandler.E_ONRELEASE) {
				layer.gameScreen.sendMessage(command, null);
				//return GameObjectComponent.MESSAGE_HANDLED;
			} else if (message == MouseHandler.E_ONRELEASE) {
				layer.gameScreen.sendMessage(command, null);
			}
			return super.handleMessage(message, data);
		}
		
	}

}