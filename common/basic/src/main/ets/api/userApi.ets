/**
 * 获取登录用户信息
 * @returns
 */
import { ILoginParams, IUserData } from '../model'
import { Request } from '../utils'

export function loginApi(data: ILoginParams) {
  return Request.post<string, ILoginParams>('/employee/login', { data })
}

export function getUserApi() {
  return Request.get<IUserData, null>('/employee/user', {})
} 