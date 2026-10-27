const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const routes = require('./routes');
const errorHandler = require('./middlewares/errorHandler');
const db = require('./config/db');

const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

app.get('/health', (req, res) => res.json({ status: 'ok' }));
app.get('/health/db', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT 1 AS ok, DATABASE() AS db');
    res.json({ status: 'ok', ...rows[0] });
  } catch (err) {
    res.status(500).json({ status: 'error', message: err.message });
  }
});
app.use('/api', routes);

app.use((req, res) => res.status(404).json({ erro: 'Rota não encontrada' }));
app.use(errorHandler);   // sempre o último

module.exports = app;