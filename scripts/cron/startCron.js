const cron = require('node-cron');
const fetch = require('node-fetch');
const fs = require('fs')

require('dotenv').config();

const ENV_FILE = './.env.example';
const PARENT_ENV_FILE = '../../.env';
const API_URL = process.env.API_URL || 'http://localhost';
const APP_VERSION = process.env.APP_VERSION;

const API_PATHS = {
  ping: () => '/workers/ping',
  metadata: () => '/app/metadata',
  updateActivity: () => '/activity/update',
}

// PING ALIVE
cron.schedule('*/30 * * * *', () => {
  fs.readFile('../../WORKER_ID', 'utf8' , (err, data) => {
    if (err) {
      console.error(err)
      return
    }
    
    const reqBody = { id: data };
    
    fetch(`${API_URL}/workers/ping`, {
      method: 'post',
      body: JSON.stringify(reqBody),
      headers: { 'Content-Type': 'application/json' },
    })
    .then(res =>{
      console.log(res);
    })
    .catch(err =>{
      console.log(err);
    });
  });
  
  console.log('every minutes');
});

// SEND LOGS ! TODO logs in next version
// cron.schedule('* * * * *', async () => {
//   try {
//     const id = fs.readFileSync('../../WORKER_ID', { encoding:'utf8' });
//     const errorsCount = fs.readFileSync('../../logs/errorsCount', { encoding:'utf8' });
//     const requestsCount = fs.readFileSync('../../logs/requestsCount', { encoding:'utf8' });
//     const successCount = fs.readFileSync('../../logs/successCount', { encoding:'utf8' });

//     const reqBody = {
//       id,
//       errorsCount: Number(errorsCount),
//       requestsCount: Number(requestsCount),
//       successCount: Number(successCount),
//     };

//    const data = await fetch(`${API_URL}${API_PATHS.updateActivity()}`, {
//       method: 'post',
//       body: JSON.stringify(reqBody),
//       headers: { 'Content-Type': 'application/json' },
//     });

//     if(data.status===200) console.log('Logs are successfully sent');
//     else console.log('Logs sending is not successful');
//   } catch (err) {
//     console.log('send logs error');
//   }
// });

// CHECK VERSION AND RESTART WITH CLEANUP
cron.schedule('0 0 * * *', async () => {
  try {
   const data = await fetch(`${API_URL}${API_PATHS.metadata()}`, { method: 'get' });
   
   const { version } = await data.json()

   if(version && version!==APP_VERSION) {

    fs.writeFileSync(
      ENV_FILE,
      fs
        .readFileSync(ENV_FILE)
        .toString()
        .replace(APP_VERSION, version)
    );

    fs.writeFileSync(
      PARENT_ENV_FILE,
      fs
        .readFileSync(PARENT_ENV_FILE)
        .toString()
        .replace(APP_VERSION, version)
    );

    process.stdout.write('UPDATE');
    process.exit();
   }
  } catch (err) {
    console.log('error', err);
  }
});

// RESTART
cron.schedule('0 0 * * 1,3,5', async () => {
  process.stdout.write('RESTART');
  process.exit();
});
