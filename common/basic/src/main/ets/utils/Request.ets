import axios, {
  AxiosError,
  AxiosHeaders,
  AxiosResponse,
  InternalAxiosRequestConfig,
  Method,
  RawAxiosRequestHeaders
} from '@ohos/axios'
import { Log } from '@abner/log'
import { router } from '@kit.ArkUI';

import { RouterConfig } from '../constants';
import { UserStore } from '.';

interface RequestConfig<P> {
  url?: string;
  method?: Method;
  headers?: RawAxiosRequestHeaders | AxiosHeaders
  params?: P
  data?: P
  context?: null
}

// 创建实例
const instance = axios.create({
  baseURL: 'https://zhyl-harmony.itheima.net',
  timeout: 5 * 1000,
});

// 请求拦截器
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  // 测试Authorization
  config.headers.Authorization = UserStore.getUser().token
  Log.info(`【${config.method!}】${config.url}
    ${JSON.stringify(config.params || config.data)}`)

  return config;
}, (error: AxiosError) => {
  return Promise.reject(error);
});


// 响应拦截器
instance.interceptors.response.use((response: AxiosResponse) => {
  Log.warn(response.data?.data)
  return response.data?.data;
}, (error: AxiosError) => {
  Log.info(error)
  if (error.response?.status === 401) {
    UserStore.delUser()
    router.replaceUrl({ url: RouterConfig.LOGIN_URL })
  }
  return Promise.reject(error);
});

export class Request {
  static get<D = null, P = null>(url: string, config: RequestConfig<P> = {}): Promise<D> {
    config.url = url
    config.method = 'GET'
    return instance<null, D>(config)
  }

  static post<D = null, P = null>(url: string, config: RequestConfig<P> = {}): Promise<D> {
    config.url = url
    config.method = 'POST'
    return instance<null, D>(config)
  }

  static delete<D = null, P = null>(url: string, config: RequestConfig<P> = {}): Promise<D> {
    config.url = url
    config.method = 'DELETE'
    return instance<null, D>(config)
  }

  static put<D = null, P = null>(url: string, config: RequestConfig<P> = {}): Promise<D> {
    config.url = url
    config.method = 'PUT'
    return instance<null, D>(config)
  }

  static other<D = null, P = null>(url: string, config: RequestConfig<P> = {}): Promise<D> {
    config.url = url
    config.method = config.method || 'GET'
    return instance<null, D>(config)
  }
}