const request = require('supertest');
const app = require('../src/app');

describe('API Security Tests', () => {
  let authToken;

  test('Health check returns 200', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
    expect(res.body.status).toBe('healthy');
  });

  test('Register creates a new user', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send({ username: 'testuser', email: 'test@example.com', password: 'SecureP@ss123' });
    expect(res.status).toBe(201);
    expect(res.body.token).toBeDefined();
    authToken = res.body.token;
  });

  test('Login returns token for valid credentials', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ username: 'testuser', password: 'SecureP@ss123' });
    expect(res.status).toBe(200);
    expect(res.body.token).toBeDefined();
  });

  test('Login rejects invalid credentials', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ username: 'testuser', password: 'wrong' });
    expect(res.status).toBe(401);
  });

  test('Protected endpoint requires auth', async () => {
    const res = await request(app).get('/api/data');
    expect(res.status).toBe(401);
  });

  test('Protected endpoint works with valid token', async () => {
    const res = await request(app)
      .get('/api/data')
      .set('Authorization', `Bearer ${authToken}`);
    expect(res.status).toBe(200);
    expect(res.body.data).toBeDefined();
  });

  test('Register rejects missing fields', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send({ username: 'incomplete' });
    expect(res.status).toBe(400);
  });
});
