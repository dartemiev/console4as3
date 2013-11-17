package com.debug.logging.console.command
{
    import com.debug.Stats;
    import com.debug.logging.console.Console;
    import com.debug.logging.logger.Logger;

    import flash.display.DisplayObjectContainer;

    public class FPSConsoleCommand implements IConsoleCommand
	{
		/**
		 * View of stats.
		 * @see com.debug.Stats
		 */
		protected var stats:Stats;

		/**
		 * @inheritDoc
		 */
		public function execute(args:Array = null):void
		{
			const logger:Logger = Console.logger;
			const holder:DisplayObjectContainer = Console.stage;
			if (holder == null)
			{
				logger.warn("Placeholder for stats is not defined...");
				return;
			}

			if (stats == null)
			{
				stats = new Stats();
				holder.addChild(stats);
				logger.info("Enabled FPS display!");
			}
			else
			{
				stats.parent.removeChild(stats);
				stats = null;
				logger.info("Disabled FPS display!");
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get name():String
		{
			return "fps";
		}

		/**
		 * @inheritDoc
		 */
		public function get description():String
		{
			return "Toggle an FPS/Memory usage indicator.";
		}
	}
}
