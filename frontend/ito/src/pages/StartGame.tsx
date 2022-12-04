import React from 'react';
import { Link } from 'react-router-dom';
import '../css/StartGame.css';

/**
 * スタート画面
 * @returns {React.ReactElement}
 */
const StartGame: React.FC = () => {
  return (
    <div>
      <h1>ito</h1>
      <button>
        {/* aタグみたいなもの。react-router-domを使っているため Linkタグを使うのが一般的 */}
        <Link to='/input-name'>start game</Link>
      </button>
    </div>
  );
}

export default StartGame;