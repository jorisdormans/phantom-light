package nl.jorisdormans.phantom2D.particles 
{
	import flash.filters.BlurFilter;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Camera;
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Layer;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	/**
	 * A ScreenObjectComponent that holds particles
	 * @author Joris Dormans
	 */
	public class ParticleLayer extends Layer
	{
		private var particles:Vector.<Particle>
		private var particleLimit:int;
		
		/**
		 * Creates an instance of the ParticleLayer class.
		 * @param	particleLimit 	The maximum number of particles that can be active at the some time in the layer.
		 */
		public function ParticleLayer(width:Number, height:Number, particleLimit:int = 128) 
		{
			this.particleLimit = particleLimit;
			particles = new Vector.<Particle>();
			super(width, height);
			
		}
		
		override public function updatePhysics(elapsedTime:Number):void 
		{
			for (var i:int = particles.length - 1; i >= 0; i--) {
				particles[i].update(elapsedTime);
				if (particles[i].life <= 0) {
					particles.splice(i, 1);
				}
			}
		}
		
		override public function render(camera:Camera):void 
		{
			sprite.graphics.clear();
			var l:int = particles.length
			for (var i:int = 0; i < l; i++) {
				var offsetX:Number = 0;
				var offsetY:Number = 0;
				var px:Number = particles[i].position.x;
				var py:Number = particles[i].position.y;
				if (renderWrappedHorizontal) {
					if (px < camera.left) {
						px += layerWidth;
						offsetX = layerWidth;
					} else if (px > camera.right) {
						px -= layerWidth;
						offsetX = -layerWidth;
					}
				}
				if (renderWrappedVertical) {
					if (py < camera.top) {
						py += layerHeight;
						offsetY = layerHeight;
					} else if (py > camera.bottom) {
						py -= layerHeight;
						offsetY = -layerHeight;
					}
				}
				if (px>camera.left-10 && px<camera.right+10 && py>camera.top-10 && py<camera.bottom+10) {
					//adjust camera for wrapping
					camera.left -= offsetX;
					camera.top -= offsetY;
					particles[i].render(sprite.graphics, camera);
					//readjust camera after wrapping
					camera.left += offsetX;
					camera.top += offsetY;
				}
			}
		}
		
		/**
		 * Adds a particle to the layer. If there are too many the oldest particles are removed to make space for new ones
		 * @param	particle	The Particle to be added
		 */
		public function addParticle(particle:Particle):void {
			if (particles.length >= particleLimit) particles.splice(0, particles.length - particleLimit + 1);
			particles.push(particle);
		}
		
		public function createExplosion(position:Vector3D, velocity:Vector3D, particleType:Class, particleCount:int, force:Number):void {
			for (var i:int = 0; i < particleCount; i++) {
				var v:Vector3D = new Vector3D();
				if (velocity) {
					v.x = velocity.x;
					v.y = velocity.y;
				}
				var a:Number = Math.random() * MathUtil.TWO_PI;
				var d:Number = (Math.random() + Math.random() + 1) * force * 0.33;
				v.x += Math.cos(a) * d;
				v.y += Math.sin(a) * d;
				var p:Vector3D = position.clone();
				p.add(v);
				var l:Number = 0.5 + (Math.random() + Math.random()) * 0.5;
				var particle:Particle = new particleType() as Particle;
				particle.initialize(l, p, v);
				addParticle(particle);
			}
		}
		
		
		override public function clear():void 
		{
			super.clear();
			particles.splice(0, particles.length);
		}
	}

}