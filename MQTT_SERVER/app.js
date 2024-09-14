// app.js
const express = require('express');
const bodyParser = require('body-parser');
const mqttRoutes = require('./routes/mqtt');
const rtspRoutes = require('./routes/rtsp');
// const azureIoTHubRoutes = require('./routes/azurIot');
// const {uploadToFirestore, uploadToRealtimeDB} = require('/routes/fs');

const app = express();
app.use(bodyParser.json());


app.use('/mqtt', mqttRoutes);
app.use('/rtsp', rtspRoutes);
// app.use('/iot', azureIoTHubRoutes);


// Endpoint to upload data to Firebase 



const port = 3000;
const port = 
app.listen(port, '0.0.0.0', () => {
    console.log(`Main server listening on all interfaces at http://0.0.0.0:${port}`);
});
