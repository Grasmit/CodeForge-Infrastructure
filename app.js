// app.js
const express = require('express');
const bodyParser = require('body-parser');
const generatePassword = require('./utils/passwordGenerator');

const app = express();
const port = 3000;

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));

// Routes
app.get('/', (req, res) => {
  res.render('index', { password: null });
});

app.post('/generate', (req, res) => {
  const passwordLength = req.body.length || 12; // Default length is 12
  const newPassword = generatePassword(passwordLength);
  res.render('index', { password: newPassword });
});

// View engine setup (EJS)
app.set('views', './views');
app.set('view engine', 'ejs');

// Server listening
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
