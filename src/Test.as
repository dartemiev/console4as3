package
{
	import com.debug.logging.TestConsoleCommand;
	import com.debug.logging.console.Console;
	import com.debug.logging.logger.Logger;
	import com.debug.logging.logger.appender.ConsoleLogAppender;

	import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.MouseEvent;
    import flash.ui.Keyboard;

	[SWF(width="800", height="600")]
    public class Test extends Sprite
	{
		private var logger:Logger = Logger.getLogger(Test);

		public function Test()
		{
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

			logger.addAppender(new ConsoleLogAppender(this, Keyboard.A));

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