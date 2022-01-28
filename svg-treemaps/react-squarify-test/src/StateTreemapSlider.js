import React, {useState, useEffect} from "react"
import StateTreemap from "./StateTreemap";
import { colors, names } from './data/PartyInfo';


export default function StateTreemapSlider(props) {
  const [maps, setMaps] = useState([])
  const [index, setIndex] = useState(1)
  
  const generateMaps = () => {
    let newMaps = [];
    props.stateData && props.stateData.forEach(element => {
      const svgParams = {
        data: element.countyData && element.countyData.map(row => {
          return {label: row.label, value: row.totalVotes, color: colors[row.parties[0][0]][Math.floor(row.marginPct / 10)]}
        })
          .sort((x, y) => x.value - y.value),
        width: props.mapWidth,
        height: props.mapHeight
      }
      newMaps.push({year: element.year, tmap: <StateTreemap key={`${element.year}map`}svgParams={svgParams}/>})
    });
    setMaps(newMaps)
    setIndex(0)
  }
  
  return (
    <div>
      <p>{index < maps.length && maps[index].year}</p>
      {index < maps.length && maps[index].tmap}<br/>
      <input type="range" style={{width: 500}} defaultValue={0} min={0} max={maps.length - 1} step={1} onChange={(e) => setIndex(e.target.value)}/>
      <button onClick={generateMaps}>Generate maps</button>
    </div>
    
  )
}