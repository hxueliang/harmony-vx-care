export interface IUser {
  token: string
}

/**
 * 登录请求参数
 */
export interface ILoginParams {
  /**
   * 华为应用id
   */
  clientId: null | string;

  /**
   * 华为应用秘钥
   */
  clientSecret: null | string;

  /**
   * 华为账号授权码
   */
  code: string;
}

/**
 * 我的：登录用户
 */
export interface IUserData {
  /**
   * 头像
   */
  avatar: null | string;

  /**
   * 用户id
   */
  id: string;

  /**
   * 用户昵称
   */
  nickName: string;

  /**
   * 用户账号，即邮箱
   */
  username: string;
}