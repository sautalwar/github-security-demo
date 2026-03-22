const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const winston = require('winston');
const swaggerUi = require('swagger-ui-express');
const YAML = require('yamljs');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Logger
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [new winston.transports.Console()]
});

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '10mb' }));

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100
});
app.use('/api/', limiter);

// Swagger docs
try {
  const swaggerDoc = YAML.load(path.join(__dirname, '../docs/api-spec.yaml'));
  app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDoc));
} catch (e) {
  logger.warn('Swagger spec not found, skipping API docs');
}

// --- DEMO: Intentionally vulnerable patterns for security scanning ---

// In-memory user store (demo purposes)
const users = [];
const JWT_SECRET = process.env.JWT_SECRET || 'demo-secret-change-me';

// Auth routes
app.post('/api/auth/register', async (req, res) => {
  try {
    const { username, email, password } = req.body;
    if (!username || !email || !password) {
      return res.status(400).json({ error: 'All fields required' });
    }
    const hashedPassword = await bcrypt.hash(password, 12);
    const user = { id: users.length + 1, username, email, password: hashedPassword };
    users.push(user);
    const token = jwt.sign({ id: user.id, username }, JWT_SECRET, { expiresIn: '1h' });
    res.status(201).json({ token, user: { id: user.id, username, email } });
  } catch (err) {
    logger.error('Registration error', { error: err.message });
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/api/auth/login', async (req, res) => {
  try {
    const { username, password } = req.body;
    const user = users.find(u => u.username === username);
    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }
    const token = jwt.sign({ id: user.id, username }, JWT_SECRET, { expiresIn: '1h' });
    res.json({ token });
  } catch (err) {
    logger.error('Login error', { error: err.message });
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Auth middleware
function authenticate(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Token required' });
  }
  try {
    const decoded = jwt.verify(authHeader.split(' ')[1], JWT_SECRET);
    req.user = decoded;
    next();
  } catch {
    res.status(401).json({ error: 'Invalid token' });
  }
}

// Protected data routes
app.get('/api/data', authenticate, (req, res) => {
  res.json({
    message: 'Secure data endpoint',
    user: req.user,
    data: [
      { id: 1, name: 'Project Alpha', status: 'active', classification: 'internal' },
      { id: 2, name: 'Project Beta', status: 'active', classification: 'confidential' },
      { id: 3, name: 'Project Gamma', status: 'archived', classification: 'public' }
    ]
  });
});

// Intentional SQL-injection-like pattern (for DAST/SAST demo)
app.get('/api/search', authenticate, (req, res) => {
  const { query } = req.query;
  // DEMO VULNERABILITY: Direct string interpolation (would be SQL injection with real DB)
  const simulatedQuery = `SELECT * FROM projects WHERE name LIKE '%${query}%'`;
  logger.info('Executing query', { query: simulatedQuery });
  res.json({ results: [], query: simulatedQuery });
});

// File upload endpoint (for security scanning demo)
app.post('/api/upload', authenticate, (req, res) => {
  // DEMO: Missing file type validation
  res.json({ message: 'File upload endpoint - demo only' });
});

// Admin endpoint (for access control scanning)
app.get('/api/admin/users', authenticate, (req, res) => {
  // DEMO VULNERABILITY: No role-based access control check
  const sanitizedUsers = users.map(u => ({ id: u.id, username: u.username, email: u.email }));
  res.json({ users: sanitizedUsers });
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString(), version: '1.0.0' });
});

// Error handler
app.use((err, req, res, _next) => {
  logger.error('Unhandled error', { error: err.message, stack: err.stack });
  res.status(500).json({ error: 'Internal server error' });
});

if (require.main === module) {
  app.listen(PORT, () => {
    logger.info(`Server running on port ${PORT}`);
    logger.info(`API docs available at http://localhost:${PORT}/api-docs`);
  });
}

module.exports = app;
