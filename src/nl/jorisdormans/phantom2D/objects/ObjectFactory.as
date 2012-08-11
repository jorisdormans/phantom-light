package nl.jorisdormans.phantom2D.objects 
{
	import flash.utils.Dictionary;
	import nl.jorisdormans.phantom2D.ai.*;
	import nl.jorisdormans.phantom2D.ai.sensors.*;
	import nl.jorisdormans.phantom2D.ai.statemachines.StateMachine;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.core.PhantomGame;
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
			components["AISplicer"] = AISplicer;
			components["AIEye"] = AIEye;
			components["AISensorRadius"] = AISensorRadius;
			components["AITarget"] = AITarget;
			components["StateMachine"] = StateMachine;
			
		}
		
		public function generateFromXML(xml:XML):GameObject {
			var gameObject:GameObject = GameObject.generateFromXML(xml) as GameObject;
			/*for (var i:int = 0; i < xml.children().length(); i++) {
				var child:XML = xml.children()[i];
				addComponent(gameObject, child);
			}*/
			return gameObject;
		}
		
		public function addComponent(composite:Composite, xml:XML):void {
			var c:Class = components[xml.localName()];
			if (c) {
				var comp:Component = components[xml.localName()].generateFromXML(xml);
				if (comp) {
					composite.addComponent(comp);
				}
				var childComposite:Composite = comp as Composite;
				if (childComposite) {
					for (var i:int = 0; i < xml.children().length(); i++) {
						var child:XML = xml.children()[i];
						addComponent(childComposite, child);
					}
				}
			}
			else
			{
				PhantomGame.log("Component not found: " + xml.localName(), PhantomGame.LOG_WARNING);
			}
		}
		
		public function insertComponent(composite:Composite, xml:XML):void {
			var c:Class = components[xml.localName()];
			if (c) {
				var comp:Component = components[xml.localName()].generateFromXML(xml);
				if (comp) {
					composite.insertComponent(comp, 0);
				}
				if (comp is Composite) {
					for (var i:int = 0; i < xml.children().length(); i++) {
						var child:XML = xml.children()[i];
						addComponent(comp as Composite, child);
					}
				}
			}
		}

		
		
	}

}