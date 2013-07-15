package com.debug.logging.console.view
{
    import com.debug.logging.console.Console;
	import com.debug.logging.console.command.ClearConsoleCommand;
	import com.debug.logging.console.command.CopyConsoleCommand;
	import com.debug.logging.console.command.IConsoleCommand;
	import com.debug.logging.logger.appender.ILogAppender;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.system.System;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	public class ConsoleViewer extends Sprite implements ILogAppender
	{
        protected static const PADDING:int = 5;

		/**
		 * Instance of console command line.
		 * @see TextField
		 */
        protected var commandLine:TextField;
		/**
		 * Instance of console output.
		 * @see TextField
		 */
        protected var outputField:TextField;
		/**
		 * Map of press handlers. Define handler by each typing key in console command line.
		 */
		private var pressHandlerMap:Dictionary;
		/**
		 * List of logged messages. It's history by logging.
		 * @see History
		 */
		protected var loggingHistory:Vector.<History>;
		/**
		 * List of using commands from console command line.
		 */
		protected var consoleHistory:Vector.<String>;
		/**
		 * Index of last used command in console history.
		 * @default -1
		 */
		private var consoleHistoryIndex:int = -1;
        /**
         * Prefix for string in auto-complete mode.
         */
		private var autoCompletePrefix:String;
		/**
		 * Flag of auto-complete mode.
		 */
		private var autoCompleteMode:Boolean;
        /**
         * Current index in list of available command in auto-complete mode.
         * @default -1
         */
		private var autoCompleteIndex:int = -1;

		/**
		 * ConsoleViewer. Constructor.
		 */
		public function ConsoleViewer()
		{
			super();
			// initialize console stuff
			loggingHistory = new <History>[];
			consoleHistory = new <String>[];
            Console.registerCommand(new CopyConsoleCommand(this));
            Console.registerCommand(new ClearConsoleCommand(this));
			// initialize key management handlers
			pressHandlerMap = new Dictionary(true);
			pressHandlerMap[Keyboard.ENTER] = onEnterPressed;
			pressHandlerMap[Keyboard.SPACE] = onSpacePressed;
			pressHandlerMap[Keyboard.DOWN] = onDownPressed;
			pressHandlerMap[Keyboard.TAB] = onTabPressed;
			pressHandlerMap[Keyboard.UP] = onUpPressed;

            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

        /**
         * @inheritDoc
         */
		public function log(level:String, reporter:String, message:String):void
		{
            if (message == null) return;
			// split message by newline and add to the history.
			const timestamp:String = new Date().toLocaleTimeString();
			const color:uint = CommandColor.getColor(level);
			const messages:Array = message.split("\n");
			for each (var line:String in messages)
			{
				line = "[" + timestamp + "] " + level + ": " + reporter + " - " + line;
				loggingHistory.push(new History(line, color));
			}
			// update view
            if (parent != null)
			{
				updateHistoryView();
			}
        }

		public function activate():void
		{
			resize();

			commandLine.text = "";
			commandLine.addEventListener(KeyboardEvent.KEY_DOWN, onKeyManagement, false, 0, true);
			stage.focus = commandLine;

			addEventListener(MouseEvent.CLICK, onSetFocus, false, 0, true);
			addEventListener(MouseEvent.DOUBLE_CLICK, onCopyLogToClipboard, false, 0, true);
			stage.addEventListener(Event.RESIZE, resize, false, 0, true);
		}

		public function deactivate():void
		{
			if (stage == null) return;

			stage.focus = null;
			commandLine.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyManagement);

			removeEventListener(MouseEvent.CLICK, onSetFocus);
			removeEventListener(MouseEvent.DOUBLE_CLICK, onCopyLogToClipboard);
			stage.removeEventListener(Event.RESIZE, resize);
		}

		/**
		 * Update console view by list of history.
		 */
		private function updateHistoryView():void
		{
			outputField.text = "";
			for each(var history:History in loggingHistory)
			{
				displayLine(history.message, history.color);
			}
		}

        private function displayLine(text:String, color:uint):void
        {
            var startIndex:int = outputField.text.length;
            var endIndex:int = startIndex + text.length;

            outputField.appendText(text + "\n");

            var format:TextFormat = outputField.getTextFormat(startIndex, endIndex);
            format.color = color;
            outputField.setTextFormat(format, startIndex, endIndex);
			outputField.scrollV = outputField.maxScrollV;
        }



		/**
		 * Copy full history list to clipboard.
		 */
        public function copy():void
        {
            // generate clipboard buffer
            var buffer:String = "";
			for each(var history:History in loggingHistory)
			{
				buffer += history.message + "\n";
			}
			// copy content
            System.setClipboard(buffer);
            Console.logger.info("Copied console contents to clipboard.");
        }

		/**
		 * Wipe the displayed console output.
		 */
		public function clear():void
		{
			loggingHistory.length = 0;
			updateHistoryView();
		}

		/**
		 * Process user command by typed name and agrs.
		 * @param command String from command line.
		 */
        protected function processCommand(command:String):void
        {
            log("CMD", ">", command);
            Console.processLine(command);
			// update console history
            consoleHistory.push(command);
            consoleHistoryIndex = consoleHistory.length;
        }

        protected function resize(event:Event = null):void
        {
            var width:Number = stage.stageWidth - 1;
            var height:Number = (stage.stageHeight / 3) * 2;
            // updateHistoryView background size
            graphics.clear();
            graphics.beginFill(0x111111, .95);
            graphics.drawRect(0, 0, width, height);
            graphics.endFill();
            // updateHistoryView size of command line
            commandLine.x = PADDING;
            commandLine.height = 18;
            commandLine.width = width - 2 * PADDING;
            commandLine.y = height - commandLine.height - PADDING;

            outputField.width = width - 10;
            outputField.height = height - commandLine.height - 3 * PADDING;
            outputField.x = outputField.y = PADDING;
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

		protected function setHistory(old:String):void
		{
			commandLine.text = old;
			commandLine.setSelection(old.length, old.length);
		}

		/**
		 * Find all commands matched by some pattern.
		 * For example, we have list of commands like a [help, clear, fps, copy] and we want to find out
		 * all commands are starting from char "c". AS result will be [clear, copy].
		 * @see IConsoleCommand
		 */
		private function findMatchCommands(pattern:String):Vector.<IConsoleCommand>
		{
			var result:Vector.<IConsoleCommand> = new <IConsoleCommand>[];
			if ((pattern == null || pattern.length == 0)) return result;

			var matcher:RegExp = new RegExp("^" + pattern + "(\\w+)", "i");
			var commands:Vector.<IConsoleCommand> = Console.getCommandList();
			for each(var command:IConsoleCommand in commands)
			{
				if (matcher.test(command.name) == false) continue;

				result.push(command);
			}
			return result;
		}

		// -------------------------------------------------------------------
		//
		//                        Key Management
		//
		// -------------------------------------------------------------------
		private function getPressHandler(keyCode:int):Function
		{
			return pressHandlerMap[keyCode] || onAnyPressed;
		}
		/**
		 * The handler about pressing buttons on keyboard when user is typing some text in
		 * command line.
		 * @param event Get key code about pressed button.
		 */
		protected function onKeyManagement(event:KeyboardEvent):void
		{
			var handler:Function = getPressHandler(event.keyCode);
			handler.apply(this, [event]);
		}
		/**
		 * The handler about pressing any key in console command line.
		 * @param event Not used.
		 */
		private function onAnyPressed(event:KeyboardEvent):void
		{
			autoCompleteIndex = -1;
			autoCompleteMode = false;
		}
		/**
		 * The handler about pressing ENTER key in console command line.
		 * @param event Not used.
		 */
		private function onEnterPressed(event:KeyboardEvent):void
		{
			var command:String = commandLine.text;
			if (command.length == 0)
			{
				// display a blank line
				log("CMD", ">", command);
			}
			else
			{
				// execute an entered command
				processCommand(command);

			}
			// clear command line
			commandLine.text = "";
		}
		/**
		 * The handler about pressing UP key in console command line. Go to previous used command.
		 * @param event Prevent event.
		 */
		private function onUpPressed(event:KeyboardEvent):void
		{
			if (consoleHistoryIndex > 0)
			{
				setHistory(consoleHistory[--consoleHistoryIndex]);
			}
			else if (consoleHistory.length > 0)
			{
				setHistory(consoleHistory[0]);
			}

			event.preventDefault();
		}
		/**
		 * The handler about pressing DOWN key in console command line. Go to next used command.
		 * @param event Prevent event.
		 */
		private function onDownPressed(event:KeyboardEvent):void
		{
			if (consoleHistoryIndex < consoleHistory.length - 1)
			{
				setHistory(consoleHistory[++consoleHistoryIndex]);
			}
			else if (consoleHistoryIndex == consoleHistory.length-1)
			{
				setHistory("");
			}

			event.preventDefault();
		}
		/**
		 * The handler about pressing TAB key in console command line. Enter in auto-complete mode.
		 * @param event Prevent event.
		 */
		private function onTabPressed(event:KeyboardEvent):void
		{
			var input:String = autoCompleteMode ? autoCompletePrefix : commandLine.text;
			var hasSpaces:Boolean = input.indexOf(" ") != -1;
			var available:Vector.<IConsoleCommand> = findMatchCommands(input);
			if ((hasSpaces == false) && (available.length != 0))
			{
				// set flag about enter in autoCompleteMode
				autoCompletePrefix = input;
                (event.shiftKey) ? autoCompleteIndex-- : autoCompleteIndex++;
				autoCompleteIndex = (autoCompleteIndex + available.length) % available.length;
				autoCompleteMode = true;
				// preset auto-complete selection
				var potential:String = available[autoCompleteIndex].name;
				commandLine.text = potential;
				commandLine.setSelection(input.length, potential.length);
				// make sure to keep focus on
				var stageFocusRect:Boolean = stage.stageFocusRect;
				stage.stageFocusRect = false;
				stage.focus = commandLine;
				stage.stageFocusRect = stageFocusRect;
			}
            event.preventDefault();
		}

		/**
		 * The handler about pressing SPACE key in console command line.
		 * @param event Prevent event.
		 */
		private function onSpacePressed(event:KeyboardEvent):void
		{
			if (autoCompleteMode == true)
			{
				var endIndex:int = commandLine.text.length;
				commandLine.setSelection(endIndex, endIndex);
			}
			// SPACE key is also typing char - process any handler
			onAnyPressed(event);
		}
		// -------------------------------------------------------------------
        //
        //                        COMMON HANDLERS
        //
        // -------------------------------------------------------------------

        private function onAddedToStage(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

            // create command line text input
            commandLine = createInputField();
            addChild(commandLine);

            outputField = createInputField();
			outputField.selectable = false;
            addChild(outputField);

            resize();

            // activate click listeners
            mouseEnabled = doubleClickEnabled = true;

			updateHistoryView();
        }

	    /**
         * The handler about click somewhere on console. Set focus to input
         * field.
         * @param event Not used.
         */
        protected function onSetFocus(event:MouseEvent):void
        {
            stage.focus = commandLine;
			event.stopImmediatePropagation();
        }

        /**
         * The handler about copy full log from condole to clipboard.
         * @param event Not used.
         */
        protected function onCopyLogToClipboard(event:MouseEvent):void
        {
            copy();
			event.stopImmediatePropagation();
        }
	}
}

import com.debug.logging.logger.LogLevel;
import flash.utils.Dictionary;

internal class History
{
	/**
	 * Message string.
	 */
	public var message:String;
	/**
	 * Color of message. Using in preview mode for history.
	 */
	public var color:uint;

	/**
	 * History. Constructor.
	 * @param message Message.
	 * @param color Message color (by default is <code>0xffffff</code>).
	 */
	public function History(message:String = null, color:uint = 0xffffff)
	{
		this.message = message;
		this.color = color;
	}

	/**
	 * @inheritDoc
	 */
	public function toString():String
	{
		return "[History(message=" + message + ", color=#" + color.toString() + ")]";
	}
}

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