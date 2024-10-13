import vegaEmbed from "vega-embed";
import mapSpec from "./viz/map.vg.json";
import insightsSpec from "./viz/insights.vg.json";

async function main() {
  const vizzes = await Promise.all([
    vegaEmbed("#map", mapSpec),
    vegaEmbed("#insights", insightsSpec),
  ]);
  const elements = [
    document.querySelector("#vis"),
    document.querySelector("#insights"),
  ];
  const resizeObserver = new ResizeObserver(([entry]) => {
    const { width, height } = entry.contentRect;
    for (const viz of vizzes) {
      viz.view
        .width(width - 8)
        .height(height - 8)
        .run();
    }
  });

  elements.forEach((element) => resizeObserver.observe(element));
}

main().catch(console.error.bind(console));
