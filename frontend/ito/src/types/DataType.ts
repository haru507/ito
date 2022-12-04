// typescriptでenumっぽいことをしている。
export const DataType = {
    TypeTheme: 0,
    TypeNumber: 1,
    TypeUser: 2,
    TypeResetGame: 3
} as const;
   
// 以下は type DataType = 0 | 1 | 2 | 3 と同じ
type DataType = typeof DataType[keyof typeof DataType];