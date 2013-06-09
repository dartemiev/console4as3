package com.debug.logging.logger
{
	import com.pool.IDispose;

	internal class LogEntity implements IDispose
	{
		/**
		 *  The object that printed the message to the log.
		 */
		public var reporter:Class;

		/**
		 *  The message that was printed.
		 */
		public var message:String = "";

		public static function newInstance(reporter:Class, message:String):LogEntity
		{
			// TODO : create pool for log entities
			var instance:LogEntity = new LogEntity();
			instance.reporter = reporter;
			instance.message = message;
			return instance;
		}

		/**
		 * com.debug.logging.logger.LogEntity. Constructor.
		 */
		public function LogEntity(reporter:Class = null, message:String = null)
		{
			this.reporter = reporter;
			this.message = message;
		}

		public function dispose():void
		{
		}
	}
}