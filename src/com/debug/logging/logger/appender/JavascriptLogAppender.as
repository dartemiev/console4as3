package com.debug.logging.logger.appender
{
	import flash.external.ExternalInterface;

	/**
	 * Simple log appender to dump log events out to javascript using <code>console</code> of web browser.
	 * <p><b>NOTE:</b> it could be an expensive listener to have active.
	 */
	public class JavascriptLogAppender implements ILogAppender
	{
		public function log(level:String, reporter:String, message:String):void
		{
			if (ExternalInterface.available == true)
			{
				const timestamp:String = new Date().toLocaleTimeString();
				const log:String = "[" + timestamp + "] " + reporter + " - " + message;
				ExternalInterface.call("console." + level.toLowerCase(), log);
			}
		}
	}
}
