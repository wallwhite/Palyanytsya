import Palyanytsya from './src/palyanytsya';

const doser = new Palyanytsya();

doser.loadTarget().then(() => {
  doser.start()
}).catch(() => {
  process.exit(1);
})
