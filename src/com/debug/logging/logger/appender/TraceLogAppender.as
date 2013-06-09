package com.debug.logging.logger.appender
{
	public class TraceLogAppender implements ILogAppender
	{
		public function log(level:String, reporter:String, message:String):void
		{
			const timestamp:String = new Date().toLocaleTimeString();
			trace("[" + timestamp + "] " + level + ": " + reporter + " - " + message);
		}
	}
}