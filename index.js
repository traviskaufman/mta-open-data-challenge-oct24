import vegaEmbed from "vega-embed";
import spec from "./viz/map.vg.json";

async function main() {
  await vegaEmbed("#vis", spec);
}

main().catch(console.error.bind(console));
