import { hilog } from '@kit.PerformanceAnalysisKit';

// 引入hilog类进行二次封装
const LOGGER_TAG: string = 'my_log';
const LOGGER_DOMAIN: number = 0x0000;

class Logger {
  //   参数 domain：用于指定输出日志所对应的业务领域，取值范围为 0x0000~0xFFFF，开发者可以根据需要进行自定义。
  //   参数 tag：用于指定日志标识，可以为任意字符串，建议标识调用所在的类或者业务行为。
  //   参数 format：格式字符串，用于日志的格式化输出。%{public}s 字符串 %{public}d 数字
  //   参数 args：可以为 0 个或多个参数，可以为 0 个或多个参数，是格式字符串中参数类型对应的参数列表。
  domain: number;
  tag: string;
  format: string = '%{public}s, %{public}s';

  constructor(domain: number = LOGGER_DOMAIN, tag: string = LOGGER_TAG) {
    this.domain = domain
    this.tag = tag
  }

  debug(...args: string[]) {
    hilog.debug(this.domain, this.tag, this.format, args)
  }

  info(...args: string[]) {
    hilog.info(this.domain, this.tag, this.format, args)
  }

  warn(...args: string[]) {
    hilog.warn(this.domain, this.tag, this.format, args)
  }

  error(...args: string[]) {
    hilog.error(this.domain, this.tag, this.format, args)
  }
}

export const logger = new Logger(LOGGER_DOMAIN, LOGGER_TAG)