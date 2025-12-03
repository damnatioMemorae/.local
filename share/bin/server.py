import urllib.parse
from http.server import BaseHTTPRequestHandler, HTTPServer


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        html = """
                <html>
                <body>
                <form method="POST">
                <textarea name="text" rows="10" cols="40"></textarea><br>
                <button type="submit">Send</button>
                </form>
                </body>
                </html>
            """
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(html.encode())  # pyright: ignore[reportUnusedCallResult]

        def do_POST(self):  # pyright: ignore[reportUnusedFunction]
            length = int(self.headers["Content-Length"])
            data = self.rfile.read(length).decode()
            fields = urllib.parse.parse_qs(data)
            text = fields.get("text", [""])[0]
            print("Received:", text)

            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write(b"OK\n")

            HTTPServer(("", 8000), Handler).serve_forever()
