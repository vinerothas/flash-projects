package classes{

	public class RandomNumberGenerator {

		private var seed:int;
		private var mw:int;
		private var mz:int;

		public function RandomNumberGenerator(seed:int) {
			if(seed==0){
				seed = 56930;
			}
			//seed = 83840765;
			this.seed = seed;
			
			mw = 1;/* must not be zero, nor 0x464fffff */
			mz = seed;/* must not be zero, nor 0x9068ffff */
		}
		
		function getRandom():Number {
			mz = 36969 * (mz & 65535) + (mz >> 16);
			mw = 18000 * (mw & 65535) + (mw >> 16);
			var r:uint = (mz << 16) + mw;/* 32-bit result */
			var r2:Number = r / 4294967295;
			return r2;
		}
		
		function getIntBetween(a:int, b:int){
			return getRandom()*(b-a+1)+a;
		}
		
		public function getSeed():Number{
			return seed;
		}
	}

}