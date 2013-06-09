package com.debug.logging.logger.appender
{
	import com.debug.logging.console.view.ConsoleViewer;

	import flash.display.DisplayObject;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	public class ConsoleLogAppender implements ILogAppender
	{
		protected var holder:DisplayObjectContainer;

		protected var hotkey:uint;

		protected var consoleViewer:ConsoleViewer;

		public function ConsoleLogAppender(holder:DisplayObjectContainer, hotkey:uint)
		{
			this.hotkey = hotkey;

			if (holder.stage != null)
			{
				init(holder.stage);
			}
			else
			{
				holder.addEventListener(Event.ADDED_TO_STAGE, init);
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

		private function init(stage:DisplayObjectContainer):void
		{
			holder = stage;

			consoleViewer = new ConsoleViewer();
			consoleViewer.visible = false;
			holder.addChild(consoleViewer);

			holder.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}


		protected function onAddedToStage(event:Event):void
		{
			var target:DisplayObject = event.currentTarget as DisplayObject;
			init(target.stage);
		}

		/**
		 * The handler about check activation state of console log viewer by hot cut.
		 * @param event Get info about pressed key.
		 */
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode != hotkey) return;

			if (consoleViewer.parent != null)
			{
				consoleViewer.parent.removeChild(consoleViewer);
				consoleViewer.deactivate();
			}
			else
			{
				holder.stage.addChild(consoleViewer);
				consoleViewer.activate();
			}
		}
	}
}
