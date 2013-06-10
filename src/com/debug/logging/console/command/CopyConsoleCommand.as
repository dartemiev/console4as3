package com.debug.logging.console.command
{
    import com.debug.logging.console.view.ConsoleViewer;

    public class CopyConsoleCommand implements IConsoleCommand
    {
        private var console:ConsoleViewer;

        public function CopyConsoleCommand(console:ConsoleViewer)
        {
            this.console = console;
        }

        /**
         * @inheritDoc
         */
        public function execute(...args):void
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
