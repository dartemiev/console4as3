package
{
	import com.debug.logging.TestConsoleCommand;
	import com.debug.logging.console.Console;
	import com.debug.logging.logger.Logger;
	import com.debug.logging.logger.appender.ConsoleLogAppender;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Test extends Sprite
	{
		private var logger:Logger = Logger.getLogger(Test);

		public function Test()
		{
			logger.addAppender(new ConsoleLogAppender(this, 192))

			Console.stage = this;

			Console.registerCommand(new TestConsoleCommand(this));
			Console.processLine("help");
			Console.processLine("version");
			Console.processLine("fps");
			Console.processLine("test");


			stage.addEventListener(MouseEvent.CLICK, onFps);
		}

		private function onFps(event:MouseEvent):void
		{
			Console.processLine("fps");
		}
	}
}