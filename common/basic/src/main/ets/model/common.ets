export interface IItem<T = number> {
  key?: string
  label?: string
  index?: number
  icon?: ResourceStr
  value?: T
}