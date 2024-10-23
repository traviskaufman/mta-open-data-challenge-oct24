import { join } from "node:path";
import { buildSync } from "esbuild";

/** @type {import('vite').UserConfig} */
export default {
  plugins: [
    {
      apply: "build",
      enforce: "post",
      transformIndexHtml() {
        buildSync({
          minify: true,
          bundle: true,
          entryPoints: [join(process.cwd(), "service-worker.js")],
          outfile: join(process.cwd(), "dist", "service-worker.js"),
        });
      },
    },
  ],
};
