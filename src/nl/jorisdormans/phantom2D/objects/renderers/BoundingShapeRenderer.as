package nl.jorisdormans.phantom2D.objects.renderers 
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.util.StringUtil;
	/**
	 * A Component that simply renders the GameObject´s bounding shape with the specified colors and strokewidth.
	 * @author Joris Dormans
	 */
	public class BoundingShapeRenderer extends GameObjectComponent implements IRenderable
	{
		public var zoom:Number;
		/**
		 * Message you can use to change the render style. 
		 * Takes input: {[fillColor:uint][, strokeColor:uint][, strokeWidth:Number][, alpha:Number]}
		 */
		public static const M_SET_RENDER_STYLE:String = "setRenderStyle";
		
		public static var xmlDescription:XML = <BoundingShapeRenderer fillColor="Color" strokeColor="Color" strokeWidth="Number" alpha="Number" zoom="Number"/>;
		public static var xmlDefault:XML = <BoundingShapeRenderer fillColor="0xffffff" strokeColor="0xffffff" strokeWidth="-1" alpha="1" zoom="1"/>;
		
		public static function generateFromXML(xml:XML):Component {
			var comp:Component = new BoundingShapeRenderer();
			comp.readXML(xml);
			return comp;
		}
		
		public var strokeWidth:Number;
		public var strokeColor:uint;
		public var fillColor:uint;
		public var alpha:Number;
		
		public function BoundingShapeRenderer(fillColor:uint = 0xffffff, strokeColor:uint = 0xffffff, strokeWidth:Number = -1, alpha:Number = 1, zoom:Number = 1) 
		{
			this.zoom = zoom;
			this.strokeWidth = strokeWidth;
			this.strokeColor = strokeColor;
			this.fillColor = fillColor;
			this.alpha = alpha;
		}
		
		override public function generateXML():XML 
		{
			var xml:XML = super.generateXML();
			if (fillColor!=0xffffff) xml.@fillColor = StringUtil.toColorString(fillColor);
			if (strokeWidth != -1 && strokeColor != 0xffffff) xml.@strokeColor = StringUtil.toColorString(strokeColor);
			if (strokeWidth != -1) xml.@strokeWidth = strokeWidth;
			if (alpha != 1) xml.@alpha = alpha;
			if (zoom != 1) xml.@zoom = zoom;
			return xml;
		}
		
		override public function readXML(xml:XML):void 
		{
			if (xml.@fillColor.length() > 0) fillColor = StringUtil.toColor(xml.@fillColor);
			if (xml.@strokeColor.length() > 0) strokeColor = StringUtil.toColor(xml.@strokeColor);
			if (xml.@strokeWidth.length() > 0) strokeWidth = xml.@strokeWidth;
			if (xml.@alpha.length() > 0) alpha = xml.@alpha;
			if (xml.@zoom.length() > 0) zoom = xml.@zoom;
			super.readXML(xml);
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case M_SET_RENDER_STYLE:
					if (data && data.fillColor) this.fillColor = data.fillColor;
					if (data && data.strokeColor) this.strokeColor = data.strokeColor;
					if (data && data.alpha) this.alpha = data.alpha;
					if (data && data.strokeWidth) this.strokeWidth = data.strokeWidth;
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}
		
		
		/* INTERFACE phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			graphics.beginFill(fillColor, alpha);
			zoom *= this.zoom;
			angle -= gameObject.shape.orientation;
			if (strokeWidth>=0) {
				graphics.lineStyle(strokeWidth, strokeColor);
				gameObject.shape.drawShape(graphics, x, y, angle, zoom);
				graphics.lineStyle();
			} else {
				gameObject.shape.drawShape(graphics, x, y, angle, zoom);
			}
			graphics.endFill();
			
			
		}
		
	}

}