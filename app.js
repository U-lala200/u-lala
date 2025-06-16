const express = require('express');
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

// Connect to MongoDB
mongoose.connect('mongodb://localhost/socialmedia', { useNewUrlParser: true, useUnifiedTopology: true });

// User model
const UserSchema = new mongoose.Schema({
  username: { type: String, unique: true },
  password: String,
});
const User = mongoose.model('User', UserSchema);

// Post model
const PostSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  content: String,
  createdAt: { type: Date, default: Date.now },
});
const Post = mongoose.model('Post', PostSchema);

// Register endpoint
app.post('/register', async (req, res) => {
  const { username, password } = req.body;
  const hashed = await bcrypt.hash(password, 10);
  try {
    const user = new User({ username, password: hashed });
    await user.save();
    res.json({ message: 'User registered successfully.' });
  } catch (e) {
    res.status(400).json({ error: 'User already exists.' });
  }
});

// Login endpoint
app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  const user = await User.findOne({ username });
  if (!user) return res.status(400).json({ error: 'User not found.' });
  const valid = await bcrypt.compare(password, user.password);
  if (!valid) return res.status(400).json({ error: 'Invalid password.' });

  const token = jwt.sign({ userId: user._id }, 'SECRET_KEY');
  res.json({ token });
});

// Middleware for authentication
const auth = (req, res, next) => {
  const header = req.headers['authorization'];
  if (!header) return res.status(401).json({ error: 'No token provided.' });
  const token = header.split(' ')[1];
  jwt.verify(token, 'SECRET_KEY', (err, decoded) => {
    if (err) return res.status(403).json({ error: 'Invalid token.' });
    req.userId = decoded.userId;
    next();
  });
};

// Create a post
app.post('/posts', auth, async (req, res) => {
  const post = new Post({ user: req.userId, content: req.body.content });
  await post.save();
  res.json({ message: 'Post created.' });
});

// Get news feed (all posts)
app.get('/feed', auth, async (req, res) => {
  const posts = await Post.find().populate('user', 'username').sort({ createdAt: -1 });
  res.json(posts);
});

// Start server
app.listen(3000, () => console.log('Server started on http://localhost:3000'));