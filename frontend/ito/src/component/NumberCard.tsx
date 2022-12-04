import React from 'react';
import '../css/Game.css';
import { UsersNumbersType } from '../types/UsersNumbersType';

// 表示するカードの部品化
// return()の中にHTMLタグや{}でjavascriptの変数をうめこ生むことができる。
// 他のファイルでimportすることで<NumberCard />が使えるようになる
const NumberCard: React.FC<UsersNumbersType> = (props) => {
  return (
    <div className="number-card">
      <p>
        {props.number}
      </p>
      <p>
        {props.user_name}
      </p>
    </div>
  )
}

export default NumberCard;