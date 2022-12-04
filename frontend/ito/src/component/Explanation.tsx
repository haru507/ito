import React from 'react'
import { explanations } from '../data/explanations'

// 説明の部品化
// map: [https://ja.reactjs.org/docs/lists-and-keys.html]
const Explanation = () => {
  return (
    <div className="display-rule">

        <div className="whatIsIto">
          <h3>■ ITOの遊び方</h3>
            <p>自分の数字の大きさを「テーマに沿った言葉で」表現して、「小さい順に並べる」ゲームです。</p>
        </div>

        <div className="howToPlay">
            <h3>～ゲームの流れ～</h3>

            <div className="howToPlay-detail">
              {
                explanations.map(explanation => (
                    <div key={explanation.title}>
                        <div className="title">{explanation.title}</div>
                        <p className="detail">{explanation.detail}</p>
                    </div>
                ))
              }
            </div>
        </div>

        <div className='rule'>
           <h3> ■ ルール</h3>
            <p className="rule-detail">
              ・自分の数字を言わないこと<br/>
              ・表現は何度変更してもOK！<br/>
              ・他のプレイヤーと同じ言葉で表現してもOK！<br/>
              ・自分の数字より大きい数字が出た場合、自分のカードを場に出してください。<br/>
        　      ゲームはそのまま続行します。<br/>
              ・カードを出し終わった人も相談に参加してOK！
            </p>
        </div>
    </div>
  )
}

export default Explanation