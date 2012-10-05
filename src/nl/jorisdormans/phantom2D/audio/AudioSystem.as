package nl.jorisdormans.phantom2D.audio 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	
	/**
	 * ...
	 * @author Koen
	 */
	public class AudioSystem extends Component 
	{
		/**
		 * Start to play a sound or music. 
		 * Takes input: {name:String, [times:int]}
		 */
		public static const M_PLAY:String           = "play";
		
		/**
		 * Stop a specific sound or music. 
		 * Takes input: {name:String,}
		 */
		public static const M_STOP:String           = "stop";
		
		/**
		 * Set the sound volume.
		 * Takes input: {volume:Number,}
		 */
		public static const M_SOUND_VOLUME:String   = "soundVolume";
		
		/**
		 * Set the music volume.
		 * Takes input: {volume:Number,}
		 */
		public static const M_MUSIC_VOLUME:String   = "musicVolume";
		
		/**
		 * Stop all sounds from playing.
		 * Takes input: n/a
		 */
		public static const M_STOP_ALL_SOUND:String = "stopAllSound";
		
		/**
		 * Stop all music from playing.
		 * Takes input: n/a
		 */
		public static const M_STOP_ALL_MUSIC:String = "stopAllMusic";
		
		/**
		 * Stop all audio/sound/music!
		 * Takes input: n/a
		 */
		public static const M_STOP_ALL:String       = "stopAll";
		
		/**
		 * Mute or unmute the entire audio system.
		 * Without input/data it toggles the value.
		 * Takes input: {[mute:Boolen]}
		 */
		public static const M_MUTE:String           = "mute";
		
		
		static private var instance:AudioSystem;
		private var shared:SharedObject;
		
		// Volume state vars:
		private var soundVolume:Number;
		private var musicVolume:Number;
		private var mute:Boolean;
		
		private var sounds:Dictionary;
		private var music:Dictionary;
		private var channels:Dictionary;
		private var customTransforms:Dictionary;
		
		private var soundTransform:SoundTransform;
		private var musicTransform:SoundTransform;
		
		public function AudioSystem() 
		{
			if ( AudioSystem.instance != null )
			{
				throw new Error( "[AudioSystem] An instance this system already exists." );
			}
			AudioSystem.instance = this;
			
			this.shared = SharedObject.getLocal("nl.jorisdormans.phantom2D.audio.AudioSystem");
			this.soundVolume = this.shared.data.soundVolume ? this.shared.data.soundVolume : 0.8;
			this.musicVolume = this.shared.data.musicVolume ? this.shared.data.musicVolume : 0.6;
			this.mute = this.shared.data.mute ? this.shared.data.mute : false;
			
			this.sounds = new Dictionary();
			this.music = new Dictionary();
			this.channels = new Dictionary();
			this.customTransforms = new Dictionary();
			
			this.soundTransform = new SoundTransform(this.soundVolume);
			this.musicTransform = new SoundTransform(this.musicVolume);
			if ( this.mute )
			{
				this.soundTransform.volume = 0;
				this.musicTransform.volume = 0;
			}
			
		}
		
		/**
		 * Register a sound or music clip to this system.
		 * 
		 * @param	name     The name of the sound, use it to play/stop.
		 * @param	asset    The sound
		 * @param	music    Whether it's music.
		 * @return
		 */
		public function register( name:String, asset:Sound, music:Boolean=false ):AudioSystem
		{
			if ( this.sounds[name] != null || this.music[name] != null )
			{
				return this;
			}
			if ( music )
			{
				this.music[name] = asset;
			}
			else
			{
				this.sounds[name] = asset;
			}
			return this;
		}
		
		public function play( name:String, times:int = -1, volume:Number = -1):void
		{
			if (this.sounds[name] == null && this.music[name] == null)
			{
				throw new Error("[AudioSystem] Sound `" + name + "' does not exist!");
			}
			if ( this.sounds[name] != null )
			{
				var sound:Sound = this.sounds[name];
				if ( times == -1 )
				{
					times = 1;
				}
				times = Math.min(1, times);
				
				var transf:SoundTransform = soundTransform;
				if ( volume != -1 )
				{
					if ( this.customTransforms[name] == null )
					{
						this.customTransforms[name] = new SoundTransform(this.soundVolume);
					}
					transf = this.customTransforms[name];
					transf.volume = Math.max(Math.min(0, volume), this.soundVolume);
				}
				this.channels[name] = sound.play(0, times, transf);
			} else {
				
				var music:Sound = this.music[name];
				if ( times == -1 )
				{
					times = 0;
				}
				this.channels[name] = sound.play(0, times, musicTransform);
			}
		}
		
		public function stop( name:String ):void
		{
			var chan:SoundChannel = this.channels[name];
			if ( chan )
			{
				chan.stop();
			}
		}
		
		public function stopAllSound():int
		{
			var count:int = 0;
			for ( var name:String in this.sounds )
			{
				if ( this.channels[name] )
				{
					this.stop( name );
					count += 1;
				}
			}
			return 0;
		}
		
		public function stopAllMusic():int
		{
			var count:int = 0;
			for ( var name:String in this.music )
			{
				if ( this.channels[name] )
				{
					this.stop( name );
					count += 1;
				}
			}
			return 0;
		}
		
		public function stopAll():int
		{
			return this.stopAllSound() + this.stopAllMusic();
		}
		
		override public function handleMessage(message:String, data:Object = null, componentClass:Class = null):int 
		{
			var result:int = Phantom.MESSAGE_CONSUMED;
			switch( message )
			{
				case M_PLAY:
					this.play( data.name as String, data.times );
					break;
				case M_STOP:
					this.stop( data.name as String );
					break;
				case M_SOUND_VOLUME:
					this.SoundVolume = data.volume as Number;
					break;
				case M_MUSIC_VOLUME:
					this.MusicVolume = data.volume as Number;
					break;
				case M_STOP_ALL_SOUND:
					this.stopAllSound();
					break;
				case M_STOP_ALL_MUSIC:
					this.stopAllMusic();
					break;
				case M_STOP_ALL:
					this.stopAll();
					break;
				case M_MUTE:
					var mute:Boolean = !this.mute;
					if ( data.mute != null && data.mute is Boolean )
					{
						mute = data.mute as Boolean;
					}
					this.Mute = mute;
					break;
				default:
					result = Phantom.MESSAGE_NOT_HANDLED;
			}
			return result;
		}
		
		public function get SoundVolume():Number
		{
			return this.soundVolume;
		}
		public function set SoundVolume( value:Number ):void
		{
			value = Math.max(Math.min(0, value), 1.0);
			this.soundVolume = value;
			if ( !this.mute )
			{
				this.soundTransform.volume = value;
			}
			this.shared.data.soundVolume = value;
			this.shared.flush();
		}
		
		public function get MusicVolume():Number
		{
			return this.musicVolume;
		}
		public function set MusicVolume( value:Number ):void
		{
			value = Math.max(Math.min(0, value), 1.0);
			this.musicVolume = value;
			if ( !this.mute )
			{
				this.musicTransform.volume = value;
			}
			this.shared.data.musicVolume = value;
			this.shared.flush();
		}
		
		public function get Mute():Boolean
		{
			return this.mute;
		}
		public function set Mute( value:Boolean ):void
		{
			this.mute = value;
			
			this.shared.data.mute = value;
			this.shared.flush();
			
			if ( this.mute )
			{
				this.soundTransform.volume = 0;
				this.musicTransform.volume = 0;
			}
			else
			{
				this.soundTransform.volume = this.soundVolume;
				this.musicTransform.volume = this.musicVolume;
			}
		}
		
		
		static public function getInstance():AudioSystem
		{
			if ( AudioSystem.instance == null )
			{
				AudioSystem.instance = new AudioSystem();
			}
			return AudioSystem.instance;
		}
	}

}