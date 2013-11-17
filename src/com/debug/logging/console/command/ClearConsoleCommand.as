package com.debug.logging.console.command
{
    import com.debug.logging.console.view.ConsoleViewer;

    public class ClearConsoleCommand implements IConsoleCommand
    {
		/**
		 * Reference to current console viewer.
		 * @see ConsoleViewer
		 */
        private var console:ConsoleViewer;

		/**
		 * CopyConsoleCommand. Constructor.
		 * @param console Reference to current console viewer.
		 * @see ConsoleViewer
		 */
        public function ClearConsoleCommand(console:ConsoleViewer)
        {
            this.console = console;
        }

        /**
         * @inheritDoc
         */
        public function execute(args:Array = null):void
        {
            console.clear();
        }

        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return "clear";
        }

        /**
         * @inheritDoc
         */
        public function get description():String
        {
            return "Clears the console history.";
        }
    }
}
