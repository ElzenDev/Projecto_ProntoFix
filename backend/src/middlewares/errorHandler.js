module.exports = (err, req, res, next) => {
  if (!err.status) console.error(err);
  res.status(err.status || 500).json({ erro: err.status ? err.message : 'Erro interno' });
};