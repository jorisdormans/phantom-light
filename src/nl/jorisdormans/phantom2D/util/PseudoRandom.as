package nl.jorisdormans.phantom2D.util 
{
	/**
	 * ...
	 * @author Jackson Dunstan
	 */
	public class PseudoRandom
	{
		/** Current seed value */
        private static var __seed:int = Math.random() * int.MAX_VALUE;
 
		
		public function PseudoRandom() 
		{
		}
		
        /**
        *   Get the current seed value
        *   @return The current seed value
        */
        public static function get seed(): int
        {
            return __seed;
        }
 
        /**
        *   Set the current seed value
        *   @param seed The current seed value
        */
        public static function set seed(seed:int): void
        {
            __seed = seed;
        }
 
        /**
        *   Get the next integer in the pseudo-random sequence
        *   @param n (optional) Maximum value
        *   @return The next integer in the pseudo-random sequence
        */
        public static function nextInt(n:int = int.MAX_VALUE): int
        {
            return n > 0 ? nextNumber() * n : nextNumber();
        }
 
        /**
        *   Get the next random number in the pseudo-random sequence
        *   @return The next random number in the pseudo-random sequence
        */
        public static function nextNumber(): Number
        {
            __seed = (__seed*9301+49297) % 233280;
            return __seed / 233280.0;
        }
		
        /**
        *   Get the next random number in the pseudo-random sequence
        *   @return The next random number in the pseudo-random sequence
        */
        public static function nextFloat(): Number
        {
            __seed = (__seed*9301+49297) % 233280;
            return __seed / 233280.0;
        }
		
		
		/**
		 * Set the seed using a string (setting an empty string randomizes the seed);
		 */
		public static function set seedString(value:String):void {
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
		
		
	}

}