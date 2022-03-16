import Palyanytsya from './src/palyanytsya';

const doser = new Palyanytsya();

doser.loadTarget().then(() => {
  doser.start();
  console.log('Started');
}).catch(() => {
  console.log('Something went wrong');
  process.exit(1);
})
