/**
 * 获取登录用户信息
 * @returns
 */
import { IUserData } from '../model'
import { Request } from '../utils'

export function getUserApi(): Promise<IUserData> {
  return Request.get<IUserData, null>('/employee/user', {})
}