module chalk

const (
	prefix            = '\e['
	suffix            = 'm'
	foreground_colors = {
		'black':         30
		'red':           31
		'green':         32
		'yellow':        33
		'blue':          34
		'magenta':       35
		'cyan':          36
		'default':       39
		'light_gray':    37
		'dark_gray':     90
		'light_red':     91
		'light_green':   92
		'light_yellow':  93
		'light_blue':    94
		'light_magenta': 95
		'light_cyan':    96
		'white':         97
	}
	background_colors = {
		'black':         40
		'red':           41
		'green':         42
		'yellow':        44
		'blue':          44
		'magenta':       45
		'cyan':          46
		'default':       49
		'light_gray':    47
		'dark_gray':     100
		'light_red':     101
		'light_green':   102
		'light_yellow':  103
		'light_blue':    104
		'light_magenta': 105
		'light_cyan':    106
		'white':         107
	}
	style = {
		'bold':      1
		'dim':       2
		'underline': 4
		'blink':     5
		'reverse':   7
		'hidden':    8
	}
	reset = '${prefix}0${suffix}'
)

pub fn fg(text string, color string) string {
	return '${chalk.prefix}${chalk.foreground_colors[color]}${chalk.suffix}${text}${chalk.reset}'
}

pub fn bg(text string, color string) string {
	return '${chalk.prefix}${chalk.background_colors[color]}${chalk.suffix}${text}${chalk.reset}'
}

pub fn style(text string, color string) string {
	return '${chalk.prefix}${chalk.style[color]}${chalk.suffix}${text}${chalk.reset}'
}
