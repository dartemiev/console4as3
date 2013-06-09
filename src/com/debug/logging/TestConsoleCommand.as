package com.debug.logging
{
	import com.debug.logging.console.command.IConsoleCommand;

	import flash.display.DisplayObject;

	public class TestConsoleCommand implements IConsoleCommand
	{
		public function TestConsoleCommand(holder:DisplayObject)
		{
		}

		public function execute(...args):void
		{
			trace("Do smth!!!");
		}

		public function get name():String
		{
			return "test";
		}

		public function get description():String
		{
			return "";
		}
	}
}
