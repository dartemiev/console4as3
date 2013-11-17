package com.debug.logging.console.command
{
    import com.debug.logging.console.Console;
    import com.debug.logging.logger.Logger;

    public class HelpConsoleCommand implements IConsoleCommand
	{
		/**
		 * List of available command for use.
		 * @see com.debug.logging.console.command.IConsoleCommand
		 */
		protected var commands:Vector.<IConsoleCommand>;

		/**
		 * HelpConsoleCommand. Constructor.
		 * @param commands List of available command for use.
		 * @see com.debug.logging.console.command.IConsoleCommand
		 */
		public function HelpConsoleCommand(commands:Vector.<IConsoleCommand>)
		{
			this.commands = commands;
		}

		/**
		 *  @inheritDoc
		 */
		public function execute(args:Array = null):void
		{
			const logger:Logger = Console.logger;
			// display some options for use
			logger.info("Keyboard shortcuts: ");
			logger.info("[SHIFT]-TAB - Cycle through auto-completed commands.");
//			logger.info("PgUp/PgDn - Page log view up/down a page.");
			logger.info("");

			// do the sort before display commands
			commands.sort(comparator);
			// display list of available commands
			logger.info("Commands:");
			for each(var command:IConsoleCommand in commands)
			{
				var description:String = command.description;
				description = description && description.length != 0 ? description : "[no description]";
				logger.info("\t- " + command.name + " : " + description);
			}
		}

		/**
		 * @private
		 */
		private function comparator(a:IConsoleCommand, b:IConsoleCommand):int
		{
			return (a.name > b.name) ? 1 : -1;
		}

		/**
		 *  @inheritDoc
		 */
		public function get name():String
		{
			return "help";
		}

		/**
		 *  @inheritDoc
		 */
		public function get description():String
		{
			return "List known commands, optionally filtering by prefix.";
		}
	}
}