import { ILoginParams, IUserData } from '../model'
import { Request } from '../utils'

/**
 * 登录
 * @param data
 * @returns
 */
export function loginApi(data: ILoginParams) {
  return Request.post<string, ILoginParams>('/employee/login', { data })
}

/**
 * 获取登录用户信息
 * @returns
 */
export function getUserApi() {
  return Request.get<IUserData, null>('/employee/user', {})
}