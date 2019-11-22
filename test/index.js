/**
 * https://www.w3schools.com/nodejs/nodejs_filesystem.asp
 * https://nodejs.org/api/http.html
 */

const http = require("http"),
  fs = require("fs"),
  ud = require(__dirname + "/.."),
  testfile = __dirname + "/../test/test.md",
  host = "localhost",
  port = 3000;

fs.readFile(testfile, "utf8", function(err, data) {
  var html;

  if (err) {
    console.log(testfile + " not found.");
    return;
  }

  try {
    html = ud.parse(data);
  } catch (e) {
    console.log(e);
    return;
  }

  console.log(html);

  http
    .createServer(function(req, res) {
      res.writeHead(200, { "Content-Type": "text/html" });
      res.write(html);
      res.end();
    })
    .listen({ host, port });
});

console.log("server listening on http://" + host + ":" + port);
