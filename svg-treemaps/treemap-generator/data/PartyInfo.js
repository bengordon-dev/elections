export function squareColor(party, marginIndex) {
  if (marginIndex > 9 || marginIndex < 0) {
    return "#999999";
  }
  if (party in colors) {
    return colors[party][marginIndex]
  }
  return colors["PRO"][marginIndex]
}

export const colors = {
  "DEM": ['#C5E1FF', '#ABD3FF', '#86B6F2', '#4389E3', '#1666CB', '#0645B4', '#002B84', '#000051', '#010144', '#000033'],
  "GOP": ["#FFD4D4", "#FFB2B2", "#FF7F7F", "#FF4C4C", "#FF0000", "#B20000", "#7F0000", "#660000", "#4C0000", "#330000"],
  "PRO": ["#D4FFD4", "#B2FFB2", "#7FFF7F", "#4CFF4C", "#00FF00", "#00B200", "#007F00", "#006600", "#004C00", "#003300"],
  /*"PHB": ["#D4FFD4", "#B2FFB2", "#7FFF7F", "#4CFF4C", "#00FF00", "#00B200", "#007F00", "#006600", "#004C00", "#003300"],
  "LIB": ["#D4FFD4", "#B2FFB2", "#7FFF7F", "#4CFF4C", "#00FF00", "#00B200", "#007F00", "#006600", "#004C00", "#003300"],
  "OTH": ["#D4FFD4", "#B2FFB2", "#7FFF7F", "#4CFF4C", "#00FF00", "#00B200", "#007F00", "#006600", "#004C00", "#003300"],
  "IND": ["#D4FFD4", "#B2FFB2", "#7FFF7F", "#4CFF4C", "#00FF00", "#00B200", "#007F00", "#006600", "#004C00", "#003300"],
  "WRT": ["#D4FFD4", "#B2FFB2", "#7FFF7F", "#4CFF4C", "#00FF00", "#00B200", "#007F00", "#006600", "#004C00", "#003300"],
  "AIP": ["#D4FFD4", "#B2FFB2", "#7FFF7F", "#4CFF4C", "#00FF00", "#00B200", "#007F00", "#006600", "#004C00", "#003300"],
  "DIX": ["#D4FFD4", "#B2FFB2", "#7FFF7F", "#4CFF4C", "#00FF00", "#00B200", "#007F00", "#006600", "#004C00", "#003300"],
  "REF": ["#D4FFD4", "#B2FFB2", "#7FFF7F", "#4CFF4C", "#00FF00", "#00B200", "#007F00", "#006600", "#004C00", "#003300"],
  "GRN": ["#D4FFD4", "#B2FFB2", "#7FFF7F", "#4CFF4C", "#00FF00", "#00B200", "#007F00", "#006600", "#004C00", "#003300"],*/
}
export const names = {
  "DEM": "Democratic",
  "GOP": "Republican",
  "LIB": "Libertarian",
  "PRO": "Progressive",
  "PHB": "Prohibition",
  "OTH": "Other",
  "IND": "Independent",
  "WRT": "Write-in",
  "AIP": "American Independent Party",
  "DIX": "Dixiecrat",
  "REF": "Reform",
  "GRN": "Green"
}