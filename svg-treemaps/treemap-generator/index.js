import { getTreemap } from 'treemap-squarify';
import * as fs from "node:fs/promises";
 
import {northCarolina} from "./data/NorthCarolina.js"
import { colors, names, squareColor } from './data/PartyInfo.js';

//console.log(northCarolina);
let maps = []

northCarolina.forEach((e) => maps.push(e))


//const path = process.argv[2];


/*fs.readFile(path, 'utf8', (err, data) => {
    if (err) throw err;
    let correctJSON = data.replace(/(['"])?([a-z0-9A-Z_]+)(['"])?:/g, '"$2": ');

    const databases = JSON.parse(correctJSON);
    databases.forEach((e) => maps.append(e));
});*/

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
  out += `<svg height="${svgParams.height}" width="${svgParams.width}">\n`
   
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

treeMaps.forEach((map, key) => {
  fs.writeFile(`./NorthCarolina/${years[key]}.svg`, map, function(err) {
    if(err) {
        console.log(map);
        return console.log(err);
    }
    console.log("The file was saved!");
  }); 

  }
)
