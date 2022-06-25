import React, {useState, useEffect} from "react"
const { getTreemap } = require('treemap-squarify');

function textColor(rectColor) {
  let lowcount = 0;
  for (const x of [1, 3, 5]) {
    if (/^\d+$/.test(rectColor.charAt(x))) { // if is digit
      lowcount++
    }
  }
  return lowcount >= 2  ? "white" : "black"
} 

export default function StateTreemap(props) {
  const [treeMap, setTreeMap] = useState(getTreemap(props.svgParams))
  return (
    <svg height={props.svgParams.height} width={props.svgParams.width}>
      {treeMap && treeMap.map((rectang, i) => 
        <g key={rectang.label ? rectang.label : i} transform="scale(1, 1)"> 
          <rect
            x={rectang.x}
            y={rectang.y}
            width={rectang.width}
            height={rectang.height}
            style={{fill: rectang.data.color}}
          />
          <text 
            style={{fill: textColor(rectang.data.color), fontSize: Math.min(rectang.width, rectang.height) / rectang.data.label.length}}
            dominantBaseline="central" textAnchor="middle" 
            x = {rectang.x + (rectang.width / 2)}
            y = {rectang.y + (rectang.height / 2)}
          >
            {rectang.data.label}
          </text>
        </g>
      )}
    </svg>
    
  )
}