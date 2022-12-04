// 入力欄の部品化
import React from 'react'

interface Props {
    className: string
    placeholder: string
    type: string;
    inputUserName: (e: React.ChangeEvent<HTMLInputElement>) => void
}

// input要素の部品化
// 色々な書き方が存在する
// export default function 関数名() {}
// .ts: 関数のみやクラスといったファイル、.tsx: jsx(javascript XML)を含むファイル と分けるようになっている
const InputText: React.FC<Props> = (props) => {
  return (
    <input
        className={props.className}
        placeholder={props.placeholder}
        type={props.type}
        onChange={props.inputUserName}
    />
  )
}

export default InputText