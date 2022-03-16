const fs = require('fs')
import Colors from 'colors';

const REQUEST_LOG_FILE_PATH = "../../logs/requestsCount"; 

export const logError = (message: string) => {
  console.log(`${Colors.grey("[") + Colors.red("ERROR") + Colors.grey("]")}: ${message}`);
};

export const logRainbow = (message: string, code: string) => {
  console.log(`${Colors.grey("[") + Colors.rainbow(code) + Colors.grey("]")}: ${message}`);
};

export const logSuccess = (message: string) => {
  console.log(`${Colors.grey("[") + Colors.green("SUCCESS") + Colors.grey("]")}: ${message}`);
};

export const logInfo = (message: string) => {
  console.log(`${Colors.grey("[") + Colors.blue("INFO") + Colors.grey("]")}: ${message} `);
};
