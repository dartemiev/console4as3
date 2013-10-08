package com.debug.logging.logger
{
	import com.debug.logging.logger.appender.ILogAppender;
	import com.debug.logging.logger.appender.TraceLogAppender;

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class Logger
	{
		/**
		 *  List of log appender.
		 *  @see com.debug.logging.appender.ILogAppender
		 */
		private static var appenders:Vector.<ILogAppender>;

		/**
		 *  Cache of already used qualified class names by class-reporter.
		 */
		private static var classNameCache:Dictionary;

		/**
		 *  Initialize.
		 */
		{
			classNameCache = new Dictionary(true);

			// add default log appender as flash trace
			appenders = new <ILogAppender>[];
			addAppender(new TraceLogAppender());
		}

		/**
		 * Create a logger for defined class-reporter. All invokes of API goes through the static.
		 * @param reporter Class-reporter.
		 * @return Instance of logger.
		 */
		public static function getLogger(reporter:Class):Logger
		{
			return new Logger(reporter);
		}

		/**
		 *  Register a new ILogAppender to be called back whenever log messages occur.
		 */
		public static function addAppender(appender:ILogAppender):void
		{
			appenders.push(appender);
		}

		/**
		 * Utility function to get the current call stack. Only works in debug build.
		 * Useful for noting who called what. Empty when in release build.
		 */
		public static function getCallStack(print:Boolean = false):String
		{
			var stack:String;
			try
			{
				stack = new Error().getStackTrace();
			}
			catch(ex:Error)
			{
				stack = "[no call stack available]"
			}
			finally
			{
				print && debug(null, stack);
			}

			return stack;
		}

		/**
		 * Prints an info message to the log.
		 * @param reporter The object that reported the info message.
		 * @param message The info message to print to the log.
		 */
		public static function info(reporter:*, message:String):void
		{
			process(new LogEntity(reporter, message), LogLevel.INFO);
		}

		/**
		 * Prints a debug message to the log.
		 * @param reporter The object that reported the debug message.
		 * @param message The debug message to print to the log.
		 */
		public static function debug(reporter:*, message:String):void
		{
			process(new LogEntity(reporter, message), LogLevel.DEBUG);
		}

		/**
		 * Prints a warning to the log.
		 * @param reporter The object that reported the warning.
		 * @param message The warning to print to the log.
		 */
		public static function warn(reporter:*, message:String):void
		{
			process(new LogEntity(reporter, message), LogLevel.WARNING);
		}

		/**
		 * Prints a error message to the log.
		 * @param reporter The object that reported the error message.
		 * @param message The error message to print to the log.
		 */
		public static function error(reporter:*, message:String):void
		{
			process(new LogEntity(reporter, message), LogLevel.ERROR);
		}

		/**
		 * Process log entity to print log message to the log.
		 * @param entity Log descriptor.
		 * @param type Level type of message (info, error, debug, etc.).
		 * @see com.debug.logging.logger.LogEntity
		 */
		private static function process(entity:LogEntity, type:String):void
		{
			// TODO : check log level before output
			// let list of appender to process log entities
			for each(var appender:ILogAppender in appenders)
			{
                var className:String = getQualifiedClassName(entity.reporter);
                var parts:Array = className.split("::");
				appender.log(type, parts[parts.length - 1], entity.message);
			}
		}

		/**
		 * Get qualified class name. If some classes are already used, get them qualified class name from cache.
		 * @param reporter Class provider to get qualified class name.
		 * @return Qualified class name.
		 */
		private static function getReporterClassName(reporter:Object):String
		{
			if (classNameCache[reporter] == null)
			{
				classNameCache[reporter] = getQualifiedClassName(reporter)
			}
			return classNameCache[reporter];
		}

		/**
		 *  Pre-defined class-reporter when somewhere <code>Logger.getLogger()</code> is used
		 */
		protected var owner:Class;

		/**
		 * com.debug.logging.logger.Logger. Constructor.
		 * @param owner Pre-defined class-reporter.
		 */
		public function Logger(owner:Class)
		{
			this.owner = owner;
		}

		/**
		 * Wrapper method for <code>Logger#debug</code>
		 * @see com.debug.logging.logger.Logger#debug
		 */
		public function debug(message:String):void
		{
			Logger.debug(owner, message);
		}
		/**
		 * Wrapper method for <code>Logger#info</code>
		 * @see com.debug.logging.logger.Logger#info
		 */
		public function info(message:String):void
		{
			Logger.info(owner, message);
		}
		/**
		 * Wrapper method for <code>Logger#warn</code>
		 * @see com.debug.logging.logger.Logger#warn
		 */
		public function warn(message:String):void
		{
			Logger.warn(owner, message);
		}
		/**
		 * Wrapper method for <code>Logger#error</code>
		 * @see com.debug.logging.logger.Logger#error
		 */
		public function error(message:String):void
		{
			Logger.error(owner, message);
		}
		/**
		 * Wrapper method for <code>Logger#addAppender</code>
		 * @see com.debug.logging.logger.Logger#addAppender
		 */
		public function addAppender(appender:ILogAppender):void
		{
			Logger.addAppender(appender);
		}
	}
}