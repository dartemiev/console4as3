package com.debug.logging.logger.appender
{
	import com.debug.logging.console.view.ConsoleViewer;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.KeyboardEvent;

    public class ConsoleLogAppender implements ILogAppender
	{
        /**
         * Link reference to stage of application.
         */
		protected var holder:DisplayObjectContainer;
        /**
         * Hot key for show/hide console.
         */
		protected var hotkey:uint;
        /**
         * Instance of console UI.
         */
		protected var consoleViewer:ConsoleViewer;

        // -------------------------------------------------------------------
        //
        //                        COMMON API
        //
        // -------------------------------------------------------------------
        /**
         * ConsoleLogAppender. Constructor.
         * @param holder The holder where console would be displayed.
         * @param hotkey The hotkey id (it's key code).
         */
		public function ConsoleLogAppender(holder:DisplayObject, hotkey:uint)
		{
			this.hotkey = hotkey;
            // create UI of console
            consoleViewer = new ConsoleViewer();
            // init or waiting for adding to stage
			if (holder.stage != null)
			{
				init(holder.stage);
			}
			else
			{
				holder.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function log(level:String, reporter:String, message:String):void
		{
			if (consoleViewer == null) return;

			consoleViewer.log(level, reporter, message);
		}

        /**
         * Initialize console appender with UI viewer of console.
         * @param stage Reference to stage.
         */
		private function init(stage:DisplayObjectContainer):void
		{
            holder = stage;
            // start listen to press hot key
			holder.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

        // -------------------------------------------------------------------
        //
        //                        COMMON HANDLERS
        //
        // -------------------------------------------------------------------

        /**
         * The handler about adding holder to stage.
         * @param event Get target.
         */
		protected function onAddedToStage(event:Event):void
		{
			var target:DisplayObject = event.currentTarget as DisplayObject;
            target.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			init(target.stage);
		}

		/**
		 * The handler about check activation state of console log viewer by hot cut.
		 * @param event Get info about pressed key.
		 */
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if ((event.ctrlKey != true) || (event.keyCode != hotkey)) return;

			if (consoleViewer.parent != null)
			{
				consoleViewer.parent.removeChild(consoleViewer);
				consoleViewer.deactivate();
			}
			else
			{
				holder.addChild(consoleViewer);
				consoleViewer.activate();
			}
		}
	}
}