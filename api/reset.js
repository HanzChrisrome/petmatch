export default function handler(req, res) {
  const query = req.url.split("?")[1] || "";
  const deepLink = `petmatch://reset-password`;

  res.setHeader("Content-Type", "text/html");
  res.status(200).send(`
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="UTF-8" />
        <title>Redirecting…</title>
      </head>
      <body>
        <script>
          window.location.href = "${deepLink}";
        </script>
        <p>Redirecting to app…</p>
      </body>
    </html>
  `);
}
