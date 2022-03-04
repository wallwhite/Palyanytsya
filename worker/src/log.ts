import Colors from 'colors';

export const logError = (message: string) => {
  console.log(`${Colors.grey("[") + Colors.red("ERROR") + Colors.grey("]")}: ${message}`);
};

export const logRainbow = (message: string, code: string) => {
  console.log(`${Colors.grey("[") + Colors.rainbow(code) + Colors.grey("]")}: ${message}`);
};

export const logInfo = (message: string) => {
  console.log(`${Colors.grey("[") + Colors.blue("INFO") + Colors.grey("]")}: ${message} `);
};
