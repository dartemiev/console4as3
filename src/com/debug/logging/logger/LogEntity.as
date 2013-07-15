package com.debug.logging.logger
{
	internal class LogEntity
	{
		/**
		 *  The object that printed the message to the log.
		 */
		public var reporter:Object;

		/**
		 *  The message that was printed.
		 */
		public var message:String = "";

		/**
		 * LogEntity. Constructor.
		 */
		public function LogEntity(reporter:Object = null, message:String = null)
		{
			this.reporter = reporter;
			this.message = message;
		}
	}
}