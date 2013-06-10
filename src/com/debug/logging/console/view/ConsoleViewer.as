package com.debug.logging.console.view
{
    import com.debug.logging.console.Console;
    import com.debug.logging.console.command.CopyConsoleCommand;
    import com.debug.logging.logger.appender.ILogAppender;

    import flash.display.Bitmap;
    import flash.display.BitmapData;

    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.system.System;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
    import flash.ui.Keyboard;

    public class ConsoleViewer extends Sprite implements ILogAppender
	{
        protected var commandLine:TextField;
        /**
         * The bitmap where should write all log messages instead creation
         * new text fields with predefined settings.
         */
        protected var output:Bitmap;

        private var outputField:TextField;

		public function ConsoleViewer()
		{
			super();

            Console.registerCommand(new CopyConsoleCommand(this));
//            Console.registerCommand("clear", onClearCommand, "Clears the console history.");

            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

        /**
         * @inheritDoc
         */
		public function log(level:String, reporter:String, message:String):void
		{
            if (parent == null) return;

            var color:uint = CommandColor.getColor(level);
            // Split message by newline and add to the list.
            var messages:Array = message.split("\n");
            for each (var msg:String in messages)
            {
                const timestamp:String = new Date().toLocaleTimeString();
                const text:String = "[" + timestamp + "] " + level + ": " + reporter + " - " + msg;
                displayLine(text, color);
//                logCache.push({"color": parseInt(color.substr(1), 16), "text": text});
            }

        }

        private function displayLine(text:String, color:uint):void
        {
            outputField.appendText(text + "\n");
        }

		public function activate():void
		{
            resize();

			stage.focus = commandLine;
			commandLine.text = "";

            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
		}



		public function deactivate():void
		{
			if (stage == null) return;

            stage.focus = null;
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

        public function copy():void
        {
            // generate clipboard buffer
            var logString:String = "";
//            for(var i:int=0; i<logCache.length; i++)
//                logString += logCache[i].text + "\n";

            // copy content
            System.setClipboard(logString);
            Console.logger.info("Copied console contents to clipboard.");
        }

        protected function processCommand(command:String):void
        {
            log("CMD", ">", command);
            Console.processLine(command);
//            _consoleHistory.push(_input.text);
//            _historyIndex = _consoleHistory.length;

        }

        protected function resize():void
        {
            var width:Number = stage.stageWidth - 1;
            var height:Number = (stage.stageHeight / 3) * 2;
            // update background size
            graphics.clear();
            graphics.beginFill(0x111111, .95);
            graphics.drawRect(0, 0, width, height);
            graphics.endFill();
            // update size of command line
            commandLine.x = 5;
            commandLine.height = 18;
            commandLine.width = width - 10;
            commandLine.y = height - commandLine.height - 3;
            // update drawable bitmap
            output.x = 5;
            output.y = 0;
            output.bitmapData.dispose();
            output.bitmapData = new BitmapData(width - 10, height - 30, false, 0x0000000);

            outputField.width = width - 10;
            outputField.height = height - 28;
            outputField.x = outputField.y = 5;
        }

        protected function createInputField():TextField
        {
            var field:TextField = new TextField();
            field.condenseWhite = false;
            field.borderColor = 0xcccccc;
            field.multiline = false;
            field.wordWrap = false;
            field.border = true;
            field.type = TextFieldType.INPUT;

            var format:TextFormat = field.getTextFormat();
            format.font = "_typewriter";
            format.size = 11;
            format.color = 0xffffff;
            field.setTextFormat(format);
            field.defaultTextFormat = format;

            return field;
        }

        // -------------------------------------------------------------------
        //
        //                        COMMON HANDLERS
        //
        // -------------------------------------------------------------------

        private function onAddedToStage(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

            output = new Bitmap(new BitmapData(640, 480, false, 0x0));
            addChild(output);
            // create command line text input
            commandLine = createInputField();
            addChild(commandLine);

            outputField = createInputField();
            addChild(outputField);

            resize();

            // activate click listeners
            mouseEnabled = doubleClickEnabled = true;

//            addEventListener(Event.RESIZE, resize);
            addEventListener(MouseEvent.CLICK, onSetFocus);
            addEventListener(MouseEvent.DOUBLE_CLICK, onCopyLogToClipboard);
        }

        protected function onKeyDown(event:KeyboardEvent):void
        {
            // if "Enter" was pressed, process the command
            if (event.keyCode == Keyboard.ENTER)
            {
                // execute an entered command
                const command:String = commandLine.text;
                if (command.length == 0)
                {
                    // display a blank line
                    log("CMD", ">", command);
                    return;
                }
                // process command
                processCommand(command);
                // clear command line
                commandLine.text = "";
            }
        }

        /**
         * The handler about click somewhere on console. Set focus to input
         * field.
         * @param event Not used.
         */
        protected function onSetFocus(event:MouseEvent):void
        {
            stage.focus = commandLine;
        }

        /**
         * The handler about copy full log from condole to clipboard.
         * @param event Not used.
         */
        protected function onCopyLogToClipboard(event:MouseEvent):void
        {
            copy();
        }
	}
}

import com.debug.logging.logger.LogLevel;
import flash.utils.Dictionary;

/**
 *  Class helper to get command color by log level type.
 */
internal class CommandColor
{
    /**
     * Color map by log level type.
     */
    private static const colors:Dictionary = new Dictionary(true);
    {
        colors[LogLevel.WARNING] = 0xff6600;
        colors[LogLevel.MESSAGE] = 0xffffff;
        colors[LogLevel.ERROR] = 0xff0000;
        colors[LogLevel.DEBUG] = 0xdddddd;
        colors[LogLevel.INFO] = 0xbbbbbb;
    }

    /**
     * Get color of command line by log level type. Default color is
     * <code>0x00dd00</code>.
     * @param level Level type.
     * @return Command color by log level type.
     */
    public static function getColor(level:String):uint
    {
        return colors[level] || 0x00dd00;

    }
}