package nl.jorisdormans.phantom2D.objects 
{
	import flash.utils.Dictionary;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.objects.boundaries.*;
	import nl.jorisdormans.phantom2D.objects.misc.*;
	import nl.jorisdormans.phantom2D.objects.renderers.*;
	import nl.jorisdormans.phantom2D.objects.shapes.*;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class ObjectFactory 
	{
		protected static var instance:ObjectFactory;
		
		public function ObjectFactory() 
		{
			if (instance) throw new Error( "ObjectFactory can only be accessed through ObjectFactory.getInstance()" ); 
		}
		
		public static function getInstance():ObjectFactory {
			if (!instance) {
				instance = new ObjectFactory();
				instance.initialize();
			}
			return instance;
		}
		
		
		
		public var components:Dictionary;
		
		protected function initialize():void {
			components = new Dictionary();
			components["CollideWithLayerEdge"] = CollideWithLayerEdge;
			components["DestroyOutsideLayer"] = DestroyOutsideLayer;
			components["WrapAround"] = WrapAround;
			components["ArrowKeyHandler"] = ArrowKeyHandler;
			components["Gravity"] = Gravity;
			components["LimitedLife"] = LimitedLife;
			components["SpacePressMessage"] = SpacePressMessage;
			components["BoundingShapeRenderer"] = BoundingShapeRenderer;
			components["PhantomShapeRenderer"] = PhantomShapeRenderer;
			components["BoundingBoxAA"] = BoundingBoxAA;
			components["BoundingBoxOA"] = BoundingBoxOA;
			components["BoundingCircle"] = BoundingCircle;
			components["BoundingLine"] = BoundingLine;
			components["BoundingPolygon"] = BoundingPolygon;
			components["BoundingShape"] = BoundingShape;
			components["Mover"] = Mover;
			
		}
		
		public function generateFromXML(xml:XML):GameObject {
			var gameObject:GameObject = GameObject.generateFromXML(xml) as GameObject;
			return gameObject;
		}
		
		public function addComponent(composite:Composite, xml:XML):void {
			var c:Class = components[xml.localName()];
			if (c) {
				var comp:Component = components[xml.localName()].generateFromXML(xml);
				if (comp) {
					composite.addComponent(comp);
				}
			}
		}
		
		
	}

}