import { Request } from '@hm/basic'

import { IHomeMessageCount } from '../model'

export function getMessageCountApi() {
  return Request.get<IHomeMessageCount, null>('/employee/message/statisticsUnreadByType')
}