import { getTreemap } from 'treemap-squarify';
import * as fs from "node:fs/promises";
 
import {california} from "./data/California.js"
import { colors, names, squareColor } from './data/PartyInfo.js';

let maps = []

california.forEach((e) => maps.push(e))

let mapWidth = 700;
let mapHeight = 700;

let treeMaps = [];
let years = []

const generateMaps = () => {
  maps && maps.length > 0 && maps.forEach(element => {
    const svgParams = {
      data: element.countyData && element.countyData.map(row => {
        return {label: row.label, value: row.totalVotes, color: squareColor(row.party, Math.floor(row.marginPct / 10))}
      })
        .sort((x, y) => x.value - y.value),
      width: mapWidth,
      height: mapHeight
    }
    treeMaps.push(StateTreemap(svgParams)/*<StateTreemap key={`${element.year}map`}svgParams={svgParams}/>*/)
    years.push(element.year)
  });
  treeMaps = treeMaps.reverse();
  years = years.reverse();
}

function textColor(rectColor) {
  let lowcount = 0;
  for (const x of [1, 3, 5]) {
    if (/^\d+$/.test(rectColor.charAt(x))) { // if is digit
      lowcount++
    }
  }
  return lowcount >= 2  ? "white" : "black"
} 

function StateTreemap(svgParams) {
  const treeMap = getTreemap(svgParams)
  let out = "";
  out += `<svg height="100%" width="100%" viewbox="0 0 700 700">\n`
   
  treeMap && treeMap.forEach((rectang, i) => 
    out += `<g key="${rectang.label ? rectang.label : i}" transform="scale(1, 1)"> 
      <rect
        x="${rectang.x}"
        y="${rectang.y}"
        width="${rectang.width}"
        height="${rectang.height}"
        style="fill: ${rectang.data.color}"
      />
      <text 
        style="fill: ${textColor(rectang.data.color)}; font-size: ${Math.min(rectang.width, rectang.height) / rectang.data.label.length}"
        dominant-baseline="central" text-anchor="middle" 
        x="${rectang.x + (rectang.width / 2)}"
        y="${rectang.y + (rectang.height / 2)}"
      >
        ${rectang.data.label}
      </text>
    </g>\n`
  )
  out += "</svg>"
  return out;
}

generateMaps();

let indexFile = ``
years.forEach((item) => {
  indexFile += `import {ReactComponent as Photo${item}} from "./${item}.svg"\n`
})

indexFile += 
`export const data = {
  firstYear: ${years[years.length - 1]},
  list: [\n`

years.forEach((item) => {
  indexFile += `    <Photo${item}/>,\n`
})

indexFile += `  ]\n}`

treeMaps.forEach((map, key) => {
  fs.writeFile(`./California/${years[key]}.svg`, map, function(err) {
    if (err) {
      return console.log(err);
    }
  }); 
})


fs.writeFile(`./California/index.js`, indexFile, function(err) {
  if (err) {
    return console.log(err);
  }
  console.log("The file was saved!");
}); 
