// Simple Backend Proxy for ReviveAI
// Deploy this on Render, Railway, or similar for free.
// This keeps your Replicate API key secure (never sent to the mobile app).

const express = require('express');
const cors = require('cors');
const fetch = require('node-fetch');

const app = express();
app.use(cors());
app.use(express.json({ limit: '10mb' }));

const REPLICATE_API_TOKEN = process.env.REPLICATE_API_TOKEN;

if (!REPLICATE_API_TOKEN) {
  console.error('ERROR: REPLICATE_API_TOKEN environment variable is missing!');
  process.exit(1);
}

app.post('/enhance', async (req, res) => {
  try {
    const { mode, model, input } = req.body;

    console.log(`Received enhancement request for mode: ${mode}`);

    // Call Replicate
    const createResponse = await fetch('https://api.replicate.com/v1/predictions', {
      method: 'POST',
      headers: {
        'Authorization': `Token ${REPLICATE_API_TOKEN}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        version: model,
        input: input,
      }),
    });

    const prediction = await createResponse.json();

    if (createResponse.status !== 201) {
      return res.status(400).json({ error: prediction.detail || 'Failed to start prediction' });
    }

    const predictionId = prediction.id;

    // Poll until done (max ~3 minutes)
    let result;
    for (let i = 0; i < 60; i++) {
      await new Promise(resolve => setTimeout(resolve, 3000));

      const pollRes = await fetch(`https://api.replicate.com/v1/predictions/${predictionId}`, {
        headers: { 'Authorization': `Token ${REPLICATE_API_TOKEN}` },
      });
      const pollData = await pollRes.json();

      if (pollData.status === 'succeeded') {
        result = pollData;
        break;
      }
      if (pollData.status === 'failed') {
        return res.status(500).json({ error: pollData.error || 'Prediction failed' });
      }
    }

    if (!result) {
      return res.status(504).json({ error: 'Enhancement timed out' });
    }

    const outputUrl = Array.isArray(result.output) ? result.output[0] : result.output;

    res.json({ output_url: outputUrl });
  } catch (error) {
    console.error('Proxy error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`ReviveAI Proxy running on port ${PORT}`);
});
