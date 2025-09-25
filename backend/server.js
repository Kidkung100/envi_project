const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(cors());

const mongoUri = process.env.MONGO_URI || "mongodb://127.0.0.1:27017/participantsDB";
mongoose.connect(mongoUri, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log("✅ MongoDB connected"))
  .catch(err => console.error(err));

const ParticipantSchema = new mongoose.Schema({
  employeeId: String,
  name: String,
  score: Number,
});
const GameScoreSchema = new mongoose.Schema({
  employeeId: String,
  name: String,
  game1_score: Number,
  game2_score: Number,
});

const Participant = mongoose.model("Participant", ParticipantSchema);
const GameScore = mongoose.model("GameScore", GameScoreSchema);

app.get("/api/participants", async (req, res) => {
  const data = await Participant.find();
  res.json(data);
});
app.post("/api/participants", async (req, res) => {
  const newData = new Participant(req.body);
  await newData.save();
  res.status(201).json(newData);
});

app.get("/api/game_scores", async (req, res) => {
  const data = await GameScore.find();
  res.json(data);
});
app.post("/api/game_scores", async (req, res) => {
  const newScore = new GameScore(req.body);
  await newScore.save();
  res.status(201).json(newScore);
});

app.listen(3131, () => console.log("🚀 Backend running on port 3131"));
