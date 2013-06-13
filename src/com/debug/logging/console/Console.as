package com.debug.logging.console
{
	import com.debug.logging.console.command.FPSConsoleCommand;
	import com.debug.logging.console.command.HelpConsoleCommand;
	import com.debug.logging.console.command.IConsoleCommand;
	import com.debug.logging.console.command.VersionConsoleCommand;
	import com.debug.logging.logger.Logger;

	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	public class Console
	{
		/**
		 * Reference to stage of application.
		 */
		public static var stage:DisplayObjectContainer;

		/**
		 * Instance of logger.
		 * @see Logger
		 */
		public static const logger:Logger = Logger.getLogger(Console);

		/**
		 * The map of available command.
		 */
		protected static var commands:Dictionary;
		/**
		 * Alphabetically ordered list of commands.
		 */
		protected static var commandList:Vector.<IConsoleCommand>;

		/**
		 *  Initializing
		 */
		{
			// create command list and fill it in default commands
			commands = new Dictionary(true);
			commandList = new <IConsoleCommand>[];
			registerCommand(new VersionConsoleCommand());
			registerCommand(new HelpConsoleCommand(commandList));
			registerCommand(new FPSConsoleCommand());
		}

		/**
		 * Register a command which the user can execute via the console.
		 * <p>Arguments are parsed and cast to match the arguments in the user's function. Command names must be
		 * alphanumeric plus underscore with no spaces.</p>
		 * @param command Console command.
		 * @see com.debug.logging.console.command.IConsoleCommand
		 */
		public static function registerCommand(command:IConsoleCommand):void
		{
			if (validateCommand(command) == true)
			{
				if (commands[command.name] != null)
				{
					logger.warn("Command already registered! Replacing existing command '" + command.name + "'!");
				}

				commands[command.name] = command;
				commandList.push(command);
			}
		}

		/**
		 * Take a line of console input and process it, executing any command.
		 * @param line String to parse for command.
		 */
		public static function processLine(line:String):void
		{
			// Match tokens, this allows for text to be split by spaces excluding spaces between quotes.
			// TODO Allow escaping of quotes
			var pattern:RegExp = /[^\s"']+|"[^"]*"|'[^']*'/g;
			var args:Array = [];
			var match:Object = pattern.exec(line);
			while (match)
			{
				args.push(match[0]);

				match = pattern.exec(line);
			}

			// Look up the command.
			if (args.length == 0) return;

			var commandName:String = args[0];
			var command:IConsoleCommand = commands[commandName];

			if (command == null)
			{
				logger.warn("No such command '" + commandName + "'!");
				return;
			}

			// invoke command
			try
			{
				command.execute(args[1]);
			}
			catch(ex:Error)
			{
				logger.error(ex.message);
			}
		}

		/**
		 * Command validation.
		 * @param command Checking command.
		 * @return valid/invalid status by checking command.
		 * @see IConsoleCommand
		 */
		private static function validateCommand(command:IConsoleCommand):Boolean
		{
			// sanity checks command
			if (command == null)
			{
				logger.error("Command is null!");
				return false;
			}

			// validate name
			const name:String = command.name;
			if ((name == null) || (name.length == 0))
			{
				logger.error("Command has no name!");
				return false;
			}
			// validate for spaces
			if (name.indexOf(" ") != -1)
			{
				logger.error("Command '" + name + "' has a space in it, it will not work.");
				return false;
			}
			return true;
		}

		/**
		 * Get full list of available console command.
		 * @return List of available console command.
		 * @see IConsoleCommand
		 */
		public static function getCommandList():Vector.<IConsoleCommand>
		{
			return commandList;
		}
	}
}
