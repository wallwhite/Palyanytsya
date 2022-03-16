// @ts-ignore
import randomstring from 'randomstring';

export const getDefaultHeaders = (targetPath: string) => {
  return {
    "User-agent":"Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0",
    "Referer": targetPath,
    "Cache-Control": "max-age=0"
  }
};

export const getSearchParams = () => {
  const param = randomstring.generate({
    length: 6,
    charset: 'UTF-8'
  });
  const data = randomstring.generate({
      length: 64,
      charset: 'UTF-8'
  });
  
  return {
    [param]: data
  };
};