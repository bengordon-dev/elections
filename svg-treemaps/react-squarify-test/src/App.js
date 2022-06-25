import './App.css';
import USMap from './USMap.js';
import StateTreemap from './StateTreemap';
import React, {useState, useEffect} from "react"
import { northCarolina } from './data/newNorthCarolina';
import { texas } from './data/Texas';
import { colors, names } from './data/PartyInfo';
import StateTreemapSlider from './StateTreemapSlider';


const input = {
  data: [
    { value: 23, color: '#1B277C', label: '23' },
    { value: 20, color: '#2C5A9C', label: '20' },
    { value: 19, color: '#3984B6', label: '19' },
    { value: 14, color: '#3F97C2', label: '14' },
    { value: 9, color: '#78C6D0', label: '9' },
    { value: 8, color: '#AADACC', label: '8' },
    { value: 7, color: '#DCECC9', label: '7' },
   ],
  width: 700,
  height: 600,
};




function App() {
  useEffect = (() => {
    console.log("yeah")
  }, [])
  
  return (
    <div className="App">
      <StateTreemapSlider stateData={texas} mapWidth={700} mapHeight={700}/>
    </div>
  );
}

export default App;
