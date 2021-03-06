package com.debug.logging.console.command
{
	public interface IConsoleCommand
	{
		function execute(args:Array = null):void;

		function get name():String;

		function get description():String;
	}
}
