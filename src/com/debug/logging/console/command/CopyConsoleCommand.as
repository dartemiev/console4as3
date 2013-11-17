package com.debug.logging.console.command
{
    import com.debug.logging.console.view.ConsoleViewer;

    public class CopyConsoleCommand implements IConsoleCommand
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
        public function CopyConsoleCommand(console:ConsoleViewer)
        {
            this.console = console;
        }

        /**
         * @inheritDoc
         */
        public function execute(args:Array = null):void
        {
            console.copy();
        }

        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return "copy";
        }

        /**
         * @inheritDoc
         */
        public function get description():String
        {
            return "Copy the console to the clipboard.";
        }
    }
}
