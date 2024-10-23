self.addEventListener("fetch", (event) => {
  if (event.request.url.startsWith("https://maps.wikimedia.org")) {
    event.respondWith(
      (async () => {
        const modifiedRequest = new Request(event.request, {
          headers: new Headers({
            ...Object.fromEntries(event.request.headers.entries()),
            "User-Agent": "traviskaufman/1.0 MTA Open Data Challenge",
          }),
        });

        // Proceed with the modified request
        return fetch(modifiedRequest);
      })()
    );
  } else {
    event.respondWith(fetch(event.request));
  }
});
