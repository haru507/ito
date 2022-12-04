// ボタンの部品化
import React from 'react'
interface Props {
  text: string
  onClickFunction: () => void
}

// props →　親コンポーネントから子コンポーネントに値を渡すことができる。
// そうすることで子コンポーネントで再定義などをする手間が省ける
// このルールは覚えておいた方が良いかも（https://ja.reactjs.org/docs/hooks-rules.html#:~:text=%E3%81%97%E3%81%A6%E3%81%84%E3%81%BE%E3%81%99%E3%80%82-,%E3%83%95%E3%83%83%E3%82%AF%E3%82%92%E5%91%BC%E3%81%B3%E5%87%BA%E3%81%99%E3%81%AE%E3%81%AF%E3%83%88%E3%83%83%E3%83%97%E3%83%AC%E3%83%99%E3%83%AB%E3%81%AE%E3%81%BF,-%E3%83%95%E3%83%83%E3%82%AF%E3%82%92%E3%83%AB%E3%83%BC%E3%83%97）
const Button: React.FC<Props> = (props) => {
  return (
    <button onClick={props.onClickFunction}>
      {props.text}
    </button>
  )
}

export default Button