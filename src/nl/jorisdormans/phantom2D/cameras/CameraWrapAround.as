package nl.jorisdormans.phantom2D.cameras 
{
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.core.Layer;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	/**
	 * Camponent that allows the camera to wrap around a layer. Use this 
	 * component to follow objects that wrap around layers.
	 * @author Joris Dormans
	 */
	public class CameraWrapAround extends CameraComponent
	{
		private var layer:Layer;
		private var horizontal:Boolean;
		private var vertical:Boolean;
		
		public function CameraWrapAround(layer:Layer, horizontal:Boolean = true, vertical:Boolean = true) 
		{
			this.layer = layer;
			this.horizontal = horizontal;
			this.vertical = vertical;
		}
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			camera.screen.sendMessage(Layer.M_SET_WRAPPED, { horizontal:horizontal, vertical:vertical } );
		}
		
		override public function onRemove():void 
		{
			camera.screen.sendMessage(Layer.M_SET_WRAPPED, { horizontal:false, vertical:false } );
			layer = null;
			super.onRemove();
		}
		
		override public function update(elapsedTime:Number):void 
		{
			if (horizontal) {
				if (camera.position.x < 0) camera.position.x += layer.layerWidth;
				if (camera.position.x >= layer.layerWidth) camera.position.x -= layer.layerWidth;
				var dx:Number = camera.target.x - camera.position.x;
				var d:Number = layer.layerWidth * 0.5;
				//trace(d);
				if (dx > d) camera.target.x -= layer.layerWidth;
				if (dx < -d) camera.target.x += layer.layerWidth;
			}
			
			if (vertical) {
				if (camera.position.y < 0) camera.position.y += layer.layerHeight;
				if (camera.position.y >= layer.layerHeight) camera.position.y -= layer.layerHeight;
				var dy:Number = camera.target.y - camera.position.y;
				d = layer.layerHeight * 0.5;
				if (dy > d) camera.target.y -= layer.layerHeight;
				if (dy < -d) camera.target.y += layer.layerHeight;
			}
			
			super.update(elapsedTime);
		}
		
	}

}