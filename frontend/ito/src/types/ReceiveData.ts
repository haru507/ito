import { UsersNumbersType } from "./UsersNumbersType";

export interface ReceiveData {
    type: number
    id?: number
    user_name?: string
    number?: number
    other_users_numbers?: UsersNumbersType[]
    theme?: string
}