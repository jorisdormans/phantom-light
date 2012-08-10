package nl.jorisdormans.phantom2D.objects.renderers 
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.ContentManager;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.graphics.PhantomShape;
	import nl.jorisdormans.phantom2D.util.StringUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomShapeRenderer extends GameObjectComponent implements IRenderable
	{
		/**
		 * Message you can use to change the render style. 
		 * Takes input: {[fillColor:uint][, alpha:Number][, size:Number][, orientation:Number][, shape:PhantomShape]}
		 */
		public static const M_SET_RENDER_STYLE:String = "setRenderStyle";
		
		public static var xmlDescription:XML = <PhantomShapeRenderer shape="PhantomShape" color="Color" scale="Number" orientation="Number" alpha="Number"/>;
		public static var xmlDefault:XML = <PhantomShapeRenderer shape="" color="0xffffff" scale="1" orientation="0" alpha="1"/>;
		
		public static function generateFromXML(xml:XML):Component {
			var comp:Component = new PhantomShapeRenderer(null, 0xffffff);
			comp.readXML(xml);
			return comp;
		}		
		
		/**
		 * A reference to a PhantomShape 
		 */
		public var shape:PhantomShape;
		/**
		 * The shape's color
		 */
		public var color:uint;
		/**
		 * The shape's orientation (relative to the objects orientation)
		 */
		public var orientation:Number;
		/**
		 * The shape's scale factor
		 */
		public var scale:Number;
		/**
		 * The shape's transparancy
		 */
		public var alpha:Number;
		
		public function PhantomShapeRenderer(shape:PhantomShape, color:uint, scale:Number = 1, orientation:Number = 0, alpha:Number = 1) 
		{
			this.shape = shape;
			this.color = color;
			this.scale = scale;
			this.alpha = alpha;
			this.orientation = orientation;
		}
		
		override public function generateXML():XML 
		{
			var xml:XML = super.generateXML();
			xml.@shape = ContentManager.getInstance().getShapeKey(shape);
			if (color!=0xffffff) xml.@color = StringUtil.toColorString(color);
			if (scale != 1) xml.@scale = scale;
			if (orientation != 0) xml.@orientation = orientation;
			if (alpha != 1) xml.@alpha = alpha;
			return xml;
		}
		
		override public function readXML(xml:XML):void 
		{
			if (xml.@shape.length() > 0) shape = ContentManager.getInstance().getShape(xml.@shape);
			if (xml.@color.length() > 0) color = StringUtil.toColor(xml.@color);
			if (xml.@scale.length() > 0) scale = xml.@scale;
			if (xml.@orientation.length() > 0) orientation = xml.@orientation;
			if (xml.@alpha.length() > 0) alpha = xml.@alpha;
			super.readXML(xml);
		}
		
		
		override public function handleMessage(message:String, data:Object = null, componentClass:Class = null):int 
		{
			switch (message) {
				case M_SET_RENDER_STYLE:
					if (data && data.fillColor) this.color = data.fillColor;
					if (data && data.orientation) this.orientation = data.orientation;
					if (data && data.alpha) this.alpha = data.alpha;
					if (data && data.scale) this.scale = data.scale;
					if (data && data.shape) this.shape = data.shape;
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}		
		
		
		
		/* INTERFACE phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			if (alpha<=0) return;
			graphics.beginFill(color, alpha);
			shape.drawScaledRotated(graphics, x, y, scale * zoom, scale * zoom, angle + this.orientation);
			//shape.draw(graphics, x, y);
			graphics.endFill();
		}
		
	}

}