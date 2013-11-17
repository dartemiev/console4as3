package com.debug.logging.console.command
{
    import com.debug.logging.console.Console;

    public class VersionConsoleCommand implements IConsoleCommand
	{
		/**
		 * @inheritDoc
		 */
		public function execute(args:Array = null):void
		{
			Console.logger.info("Current Console version is 1.0.0");
		}

		/**
		 * @inheritDoc
		 */
		public function get name():String
		{
			return "version";
		}

		/**
		 * @inheritDoc
		 */
		public function get description():String
		{
			return "Echo Console version information.";
		}
	}
}
