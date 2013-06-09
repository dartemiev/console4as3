package com.debug.logging.logger.appender
{
	public interface ILogAppender
	{
		function log(level:String, reporter:String, message:String):void;
	}
}
