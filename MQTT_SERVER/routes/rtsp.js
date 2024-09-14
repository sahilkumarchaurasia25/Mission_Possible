const express = require('express');
const ffmpeg = require('fluent-ffmpeg');
const router = express.Router();

// Route to handle streaming
router.get('/stream', (req, res) => {
    const inputStream = 'rtsp://1701954d6d07.entrypoint.cloud.wowza.com:1935/app-m75436g0/27122ffc_stream2'; // RTSP source URL from esp

    // Set headers before starting the stream
    res.setHeader('Content-Type', 'video/mp4'); // Set appropriate content type

    // Stream the input to the response using fluent-ffmpeg
    const ffmpegStream = ffmpeg(inputStream)
        .on('start', (commandLine) => {
            console.log('FFmpeg process started:', commandLine);
        })
        .on('error', (err) => {
            console.error('Error in FFmpeg process:', err.message);
            if (!res.headersSent) {
                res.status(500).send('Stream could not be started.');
            }
        })
        .on('end', () => {
            console.log('Stream ended.');
        });

    // Pipe the stream to the response
    ffmpegStream.pipe(res, { end: true });
});

module.exports = router;
