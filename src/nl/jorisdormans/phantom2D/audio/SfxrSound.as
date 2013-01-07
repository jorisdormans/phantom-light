package nl.jorisdormans.phantom2D.audio
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.core.PhantomGame;
	import nl.jorisdormans.phantom2D.thirdparty.sfxr.SfxrSynth;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	
	/**
	 * A GameObject Component that contains a SfxrSynth sound and plays it when a specific message is received.
	 * @author Joris Dormans
	 */
	public class SfxrSound extends Component
	{
		private var message:String;
		private var synth:SfxrSynth;
		
		/**
		 * Creates an instance of a Sound class
		 * @param	message		The message string that triggers the sound
		 * @param	synth		A reference to the sound effect
		 */
		public function SfxrSound(message:String, synth:SfxrSynth)
		{
			this.message = message;
			this.synth = synth;
		}
		
		override public function handleMessage(message:String, data:Object = null, componentClass:Class = null):int
		{
			if (this.message == message)
			{
				var v:Number = MathUtil.clamp(PhantomGame.volumeSoundEffects * PhantomGame.volumeMaster, 0, 1);
				if (v > 0) {
					if (v!=synth.params.masterVolume) {
						synth.params.masterVolume = v
					}
					synth.play();
				}
				return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data, componentClass);
		}
	
	}

}