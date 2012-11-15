package nl.jorisdormans.phantom2D.util 
{
	/**
	 * ...
	 * @author Jackson Dunstan
	 */
	public class PseudoRandom
	{
		/** Current seed value */
        private var __seed:int = Math.random() * int.MAX_VALUE;
		
		private static var aRandom:PseudoRandom = new PseudoRandom();
 
		
		public function PseudoRandom() 
		{
			
		}
		
        /**
        *   Get the current seed value
        *   @return The current seed value
        */
        public function get seed(): int
        {
            return __seed;
        }
		
		public static function get seed(): int {
			return aRandom.seed;
		}
 
        /**
        *   Set the current seed value
        *   @param seed The current seed value
        */
        public function set seed(seed:int): void
        {
            __seed = seed;
        }
		
        public static function set seed(seed:int): void
        {
            aRandom.seed = seed;
        }

 
        /**
        *   Get the next integer in the pseudo-random sequence
        *   @param n (optional) Maximum value
        *   @return The next integer in the pseudo-random sequence
        */
        public function nextInt(n:int = int.MAX_VALUE): int
        {
            return n > 0 ? nextNumber() * n : nextNumber();
        }
		
        public static function nextInt(n:int = int.MAX_VALUE): int
        {
            return aRandom.nextInt(n);
        }
		
 
        /**
        *   Get the next random number in the pseudo-random sequence
        *   @return The next random number in the pseudo-random sequence
        */
        public function nextNumber(): Number
        {
            __seed = (__seed*9301+49297) % 233280;
            return __seed / 233280.0;
        }
        public static function nextNumber(): Number
        {
			return aRandom.nextNumber();
		}
		
        /**
        *   Get the next random number in the pseudo-random sequence
        *   @return The next random number in the pseudo-random sequence
        */
        public function nextFloat(): Number
        {
            __seed = (__seed*9301+49297) % 233280;
            return __seed / 233280.0;
        }
		public static function nextFloat(): Number
        {
			return aRandom.nextFloat();
		}
		
		public function nextJFloat(amplitude:Number):Number {
			__seed = (__seed*9301+49297) % 233280;
			var r:Number = (__seed / 233280.0);
			__seed = (__seed * 9301 + 49297) % 233280;
			r -= (__seed / 233280.0);
			return (r * amplitude);
		}
		
		
		/**
		 * Set the seed using a string (setting an empty string randomizes the seed);
		 */
		public function set seedString(value:String):void {
			if (value == "") {
				__seed = Math.random() * int.MAX_VALUE;
			} else {
				var s:int = 0;
				for (var i:int = 0; i < value.length; i++) {
					s += value.charCodeAt(i);
				}
				__seed = s;
			}
		}
		
		public static function set seedString(value:String):void {
			aRandom.seedString = value;
		}
		
		
	}

}