import axios, {
  AxiosError,
  AxiosHeaders,
  AxiosResponse,
  InternalAxiosRequestConfig,
  Method,
  RawAxiosRequestHeaders
} from '@ohos/axios'
import { Log } from '@abner/log'

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
  // config.headers.Authorization = 'eyJhbGciOiJIUzI1NiJ9.eyJjdXJyZW50VXNlciI6IntcInVzZXJuYW1lXCI6XCIzNTQyMzQ4NEBxcS5jb21cIixcInBhc3N3b3JkXCI6XCJcIixcIm5pY2tOYW1lXCI6XCLmiqTnkIblkZgxXCIsXCJlbWFpbFwiOlwiMzU0MjM0ODRAcXEuY29tXCIsXCJyZWFsTmFtZVwiOlwi5oqk55CG5ZGYMVwiLFwibW9iaWxlXCI6XCIxODIxMTAyMTg5NlwiLFwic2V4XCI6XCIwXCIsXCJkZXB0Tm9cIjpcIjEwMDAwMTAwNTAwMDAwMFwiLFwicG9zdE5vXCI6XCIxMDAwMDEwMDUwMDMwMDBcIixcImRhdGFTdGF0ZVwiOlwiMFwiLFwiYXZhdGFyXCI6XCJodHRwczovL3lqeS1vc3MtdmlkZW9zLm9zcy1hY2NlbGVyYXRlLmFsaXl1bmNzLmNvbS9ncnp4aHouanBnXCIsXCJpZFwiOjE2NzE0MDMyNTY1MTkwNzgyNzUsXCJjcmVhdGVUaW1lXCI6MTcxNTU2ODM5MDAwMCxcInVwZGF0ZVRpbWVcIjoxNzE1NTY4MzkwMDAwLFwiY3JlYXRlQnlcIjoxNjcxNDAzMjU2NTE5MDc4MTM4fSIsImV4cCI6MTQ2NzU2NTk0Nzd9.8PrMKBNrVVCfcI4DgICxp6oBQGqy46m3oglFQCiKtzw'
  return config;
}, (error: AxiosError) => {
  return Promise.reject(error);
});


// 响应拦截器
instance.interceptors.response.use((response: AxiosResponse) => {
  return response.data?.data;
}, (error: AxiosError) => {
  Log.info(error)
  return Promise.reject(error);
});

export class Request {
  static get<D = null, P = null>(url: string, config: RequestConfig<P>) {
    config.url = url
    config.method = 'GET'
    return instance<null, D>(config)
  }

  static post<D = null, P = null>(url: string, config: RequestConfig<P>) {
    config.url = url
    config.method = 'POST'
    return instance<null, D>(config)
  }

  static delete<D = null, P = null>(url: string, config: RequestConfig<P>) {
    config.url = url
    config.method = 'DELETE'
    return instance<null, D>(config)
  }

  static put<D = null, P = null>(url: string, config: RequestConfig<P>) {
    config.url = url
    config.method = 'PUT'
    return instance<null, D>(config)
  }

  static other<D = null, P = null>(url: string, config: RequestConfig<P>) {
    config.url = url
    config.method = config.method || 'GET'
    return instance<null, D>(config)
  }
}