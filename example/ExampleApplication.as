package
{
	import com.debug.logging.logger.Logger;
	import com.debug.logging.logger.appender.ConsoleLogAppender;

	import flash.display.Sprite;
	import flash.ui.Keyboard;

	public class ExampleApplication extends Sprite
	{
		public function ExampleApplication()
		{
			Logger.addAppender(new ConsoleLogAppender(this, Keyboard.F2));
		}
	}
}
