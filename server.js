const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = process.env.PORT || 8080;
const ROOT = process.cwd();
const STATE_FILE = path.join(ROOT, 'scores.json');

const MIME_TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
};

function sendJson(res, statusCode, data) {
  res.writeHead(statusCode, { 'Content-Type': 'application/json; charset=utf-8' });
  res.end(JSON.stringify(data));
}

function sanitizePath(urlPath) {
  const decoded = decodeURIComponent(urlPath.split('?')[0]);
  const safePath = decoded === '/' ? '/index.html' : decoded;
  const normalized = path.normalize(safePath).replace(/^\\+/, '').replace(/^\/+/, '');
  const fullPath = path.join(ROOT, normalized);
  if (!fullPath.startsWith(ROOT)) return null;
  return fullPath;
}

function readBody(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', chunk => {
      body += chunk;
      if (body.length > 2 * 1024 * 1024) {
        req.destroy();
        reject(new Error('Payload too large'));
      }
    });
    req.on('end', () => resolve(body));
    req.on('error', reject);
  });
}

const server = http.createServer(async (req, res) => {
  if (req.url === '/api/state' && req.method === 'GET') {
    try {
      const raw = fs.readFileSync(STATE_FILE, 'utf8');
      const data = JSON.parse(raw);
      return sendJson(res, 200, data);
    } catch (err) {
      return sendJson(res, 500, { error: 'Failed to read scores.json' });
    }
  }

  if (req.url === '/api/state' && req.method === 'POST') {
    try {
      const body = await readBody(req);
      const data = JSON.parse(body);
      if (!data || !Array.isArray(data.items)) {
        return sendJson(res, 400, { error: 'Invalid payload: items is required' });
      }
      fs.writeFileSync(STATE_FILE, JSON.stringify(data, null, 2) + '\n', 'utf8');
      return sendJson(res, 200, { ok: true });
    } catch (err) {
      return sendJson(res, 500, { error: 'Failed to write scores.json' });
    }
  }

  if (req.method !== 'GET' && req.method !== 'HEAD') {
    res.writeHead(405);
    res.end('Method Not Allowed');
    return;
  }

  const fullPath = sanitizePath(req.url || '/');
  if (!fullPath) {
    res.writeHead(403);
    res.end('Forbidden');
    return;
  }

  let filePath = fullPath;
  if (fs.existsSync(filePath) && fs.statSync(filePath).isDirectory()) {
    filePath = path.join(filePath, 'index.html');
  }

  if (!fs.existsSync(filePath)) {
    res.writeHead(404);
    res.end('Not Found');
    return;
  }

  const ext = path.extname(filePath).toLowerCase();
  const contentType = MIME_TYPES[ext] || 'application/octet-stream';
  res.writeHead(200, { 'Content-Type': contentType });
  fs.createReadStream(filePath).pipe(res);
});

server.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
