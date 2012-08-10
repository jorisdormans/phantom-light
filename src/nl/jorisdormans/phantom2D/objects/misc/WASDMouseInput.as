package nl.jorisdormans.phantom2D.objects.misc 
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	import layers.Hud;
	import layers.IHudRenderable;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.core.PhantomGame;
	import nl.jorisdormans.phantom2D.objects.GameObjectComponent;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	import nl.jorisdormans.phantom2D.objects.ObjectLayer;
	import nl.jorisdormans.phantom2D.particles.Particle;
	import nl.jorisdormans.phantom2D.particles.ParticleEmiter;
	import nl.jorisdormans.phantom2D.particles.ParticleLayer;
	import nl.jorisdormans.phantom2D.util.DrawUtil;
	
	/**
	 * ...
	 * @author Koen
	 */
	public class WASDMouseInput extends GameObjectComponent implements IInputHandler
	{
		/**
		 * Event generated when the direction changes. Passes data: {dx:Number, dy:Number} where dx and dy are the direction vector
		 */
		public static const E_CHANGE_DIRECTION:String = "changeDirection";
		/**
		 * Message to signal start of the primary attack.
		 */
		public static const E_ATTACK1_START:String = "startAttack1";
		/**
		 * Message to signal end of the primary attack.
		 */
		public static const E_ATTACK1_END:String = "endAttack1";
		/**
		 * Message to signal start of the secondary attack.
		 */
		public static const E_ATTACK2_START:String = "startAttack2";
		/**
		 * Message to signal end of the secondary attack.
		 */
		public static const E_ATTACK2_END:String = "endAttack2";
		
		private var acceleration:Number;
		private var lastX:Number;
		private var lastY:Number;
		private var localmouse:Vector3D;
		private var stagemouse:Vector3D;
		private var particleLayer:ParticleLayer;
		private var particleClass:Class;
		private var particleDelay:Number;
		private var layer:ObjectLayer;
		
		public function WASDMouseInput( acceleration:Number=1000, particleClass:Class=null ) 
		{
			this.acceleration = acceleration;
			this.particleClass = particleClass;
			this.lastX = 1;
			this.lastY = 0;
			
			InputState.keyCode1 = 87; // W
			InputState.keyCode2 = 65; // A
			InputState.keyCode3 = 83; // S
			InputState.keyCode4 = 68; // D
		}
		
		override public function onInitialize():void 
		{
			super.onInitialize();
			this.particleDelay = 0;
			this.particleLayer = this.gameObject.objectLayer.screen.getComponentByClass(ParticleLayer) as ParticleLayer;
			this.layer = this.gameObject.objectLayer as ObjectLayer;
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			if ( this.particleClass && this.particleLayer && (particleDelay-=elapsedTime) <= 0)
			{
				var particle:Particle = new this.particleClass();
				particle.initialize(.3, this.localmouse, new Vector3D(0, 0));
				this.particleLayer.addParticle(particle);
				particleDelay += .05;
			}
		}
		
		public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void 
		{
			if ( this.gameObject.mover != null )
			{
				// Handle movement:
				var dx:Number = 0;
				var dy:Number = 0;
				if (currentState.key2) dx -= 1;
				if (currentState.key4) dx += 1;
				if (currentState.key1) dy -= 1;
				if (currentState.key3) dy += 1;
				if (dx != 0 && dy != 0) {
					dx *= Math.SQRT1_2;
					dy *= Math.SQRT1_2;
				}
				elapsedTime *= acceleration;
				gameObject.mover.velocity.x += dx * elapsedTime;
				gameObject.mover.velocity.y += dy * elapsedTime;
				if ((lastX!=dx || lastY!=dy) && (dx!=0 || dy!=0)) {
					lastX = dx;
					lastY = dy;
					parent.handleMessage(E_CHANGE_DIRECTION, { dx: dx, dy: dy } );
					
				}
			}
			
			// Handle mouse actions:
			stagemouse = new Vector3D(currentState.stageX, currentState.stageY);
			localmouse = new Vector3D(currentState.localX, currentState.localY);
			
			var msg:String = null;
			if (currentState.mouseButton && !previousState.mouseButton)
				msg = E_ATTACK1_START;
			if (!currentState.mouseButton && previousState.mouseButton)
				msg = E_ATTACK1_END;
			if (currentState.keySpace && !previousState.keySpace)
 				msg = E_ATTACK2_START;
			if (!currentState.keySpace && previousState.keySpace)
				msg = E_ATTACK2_END;
			
			if ( msg != null && layer.sprite.hitTestPoint(stagemouse.x, stagemouse.y) )
			{
				var pos:Vector3D = this.gameObject.position.clone();
				
				var a:Number = Math.atan2(localmouse.y - pos.y, localmouse.x - pos.x);
				var dir:Vector3D = new Vector3D( Math.sin(a), Math.cos(a) );
				
				var data:Object = { target: localmouse, origin: pos, angle: a, direction:dir };
				this.parent.handleMessage(msg, data);
			}
			
		}
		
	}

}