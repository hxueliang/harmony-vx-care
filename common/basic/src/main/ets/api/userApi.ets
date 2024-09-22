/**
 * 获取登录用户信息
 * @returns
 */
import { ILoginParams, IUserData } from '../model'
import { Request } from '../utils'

export function loginApi(data: ILoginParams): Promise<string> {
  return Request.post<string, ILoginParams>('/employee/login', { data })
}

export function getUserApi(): Promise<IUserData> {
  return Request.get<IUserData, null>('/employee/user', {})
}