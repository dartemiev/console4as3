package com.debug.logging.console.view
{
	import com.debug.logging.logger.appender.ILogAppender;

	import flash.display.Sprite;

	public class ConsoleViewer extends Sprite implements ILogAppender
	{
		public function ConsoleViewer()
		{
			super();
		}

		public function log(level:String, reporter:String, message:String):void
		{
		}

		public function activate():void
		{
//			layout();
//			_input.text = "";
//			addListeners();
//			stage.focus = _input;
		}

		public function deactivate():void
		{
//			removeListeners();
			stage.focus = null;
		}
	}
}
