import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './pages/App';
import StartGame from './pages/StartGame'
import InputName from './pages/InputName'
import Game from './pages/Game'
import Admin from './pages/Admin'
import { BrowserRouter, Route, Switch } from 'react-router-dom';

// react-router-dom [https://zenn.dev/longbridge/articles/65355d3fdb7939]
ReactDOM.render(
  <BrowserRouter>
    <Switch>
      <Route exact path="/" component={App} />
      <Route exact path="/start" component={StartGame} />
      <Route exact path="/input-name" component={InputName} />
      <Route exact path="/game" component={Game} />
      <Route exact path="/admin" component={Admin} />
    </Switch>
  </BrowserRouter>,
  document.getElementById('root')
);
