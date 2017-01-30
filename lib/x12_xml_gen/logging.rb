require 'logger'
require 'pastel'

module X12XmlGen
  LOGGER = Logger.new($stderr)

  LOGGER.level = Logger.const_get(ENV.fetch('LOG_LEVEL', 'DEBUG'))

  pastel = Pastel.new
  colors = {
    'FATAL' => pastel.red.bold.detach,
    'ERROR' => pastel.red.detach,
    'WARN'  => pastel.yellow.detach,
    'INFO'  => pastel.green.detach,
    'DEBUG' => pastel.white.detach
  }

  LOGGER.formatter = lambda do |severity, datetime, progname, message|
    colorizer = $stderr.tty? ? colors[severity] : ->(s) { s }
    "#{colorizer.call(severity)}: #{message}\n"
  end
end
