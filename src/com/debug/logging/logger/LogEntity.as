package com.debug.logging.logger
{
	internal class LogEntity
	{
		/**
		 *  The object that printed the message to the log.
		 */
		public var reporter:Class;

		/**
		 *  The message that was printed.
		 */
		public var message:String = "";

		/**
		 * LogEntity. Constructor.
		 */
		public function LogEntity(reporter:Class = null, message:String = null)
		{
			this.reporter = reporter;
			this.message = message;
		}
	}
}