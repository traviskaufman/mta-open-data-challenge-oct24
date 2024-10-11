import vegaEmbed from "vega-embed";
import spec from "./viz/map.vg.json";

async function main() {
  const res = await vegaEmbed("#vis", spec);
  const element = document.querySelector("#vis");
  const resizeObserver = new ResizeObserver(async ([entry]) => {
    const { width, height } = entry.contentRect;
    await res.view
      .width(width - 8)
      .height(height - 8)
      .runAsync();
  });

  resizeObserver.observe(element);
}

main().catch(console.error.bind(console));
