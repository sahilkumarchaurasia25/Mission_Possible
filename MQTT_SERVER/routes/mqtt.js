// routes/mqtt.js
const express = require('express');
const aedes = require('aedes')();
const net = require('net');
const router = express.Router();

const mqttPort = 1885;
const mqttServer = net.createServer(aedes.handle);

// Mock list of students and RFID tags for verification
const rfidDatabase = [
    { student_name: "John Doe", rfid_code: "RFID12345" },
    { student_name: "Jane Smith", rfid_code: "RFID54321" },
    { student_name: "Michael Brown", rfid_code: "RFID98765" },
    { student_name: "Emily Johnson", rfid_code: "RFID56789" },
    { student_name: "David Wilson", rfid_code: "RFID34567" }
];

function publishAuthStatus(authStatus, subtopics) {
    subtopics.forEach(topic => {
        const payload = Buffer.from(authStatus.toString()); // Convert 0/1 to Buffer
        aedes.publish({topic, payload});
        // aedes.publish({ topic, payload }, (err) => {
        //     if (err) {
        //         console.error(`Error publishing to ${topic}: ${err.message}`);
        //     } else {
        //         console.log(`Auth status ${authStatus} published to ${topic}`);
        //     }
        // });
    });
}


// Function to publish message to a topic
function publishAuthCompleted(studentName, status, subtopics) {
    const authMessage = JSON.stringify({ student_name: studentName, status });
    // const authcode = 0;
    subtopics.forEach(topic => {
        aedes.publish({ topic, payload: Buffer.from(authMessage) }, (err) => {
            if (err) {
                console.error(`Error publishing to ${topic}: ${err.message}`);
            } else {
                console.log(`Auth completed message published to ${topic} for ${studentName}`);
            }
        });
    });
}

mqttServer.listen(mqttPort, '0.0.0.0', (err) => {
    if (err) {
        console.error(`Failed to bind to port ${mqttPort}:`, err);
    } else {
        console.log(`Aedes MQTT Broker started and listening on port ${mqttPort}`);
    }
});

router.post('/publish', (req, res) => {
    const { topic, message } = req.body;
    if (topic && message) {
        aedes.publish({ topic, payload: Buffer.from(message) }, (err) => {
            if (err) {
                return res.status(500).send(`Error publishing message: ${err.message}`);
            }
            res.send(`Message published to ${topic}`);
        });
    } else {
        res.status(400).send('Topic and message are required.');
    }
});

aedes.on('client', client => {
    console.log(`Client Connected: ${client ? client.id : 'Unknown client'}`);
});

aedes.on('clientDisconnect', client => {
    console.log(`Client Disconnected: ${client ? client.id : 'Unknown client'}`);
});

aedes.on('publish', (packet, client) => {
    const topic = packet.topic;
    const message = packet.payload.toString();
    
    console.log(`Message Published to Topic: ${topic}, Message: ${message}`);

    // Checking is the message is an auth request
    // Process RFID verification based on topic
    if (topic === 'rfid/auth') {
        // Assuming the message is the RFID code being sent for verification
        const rfidCode = message;

        // Search the RFID code in the database
        const student = rfidDatabase.find(entry => entry.rfid_code === rfidCode);

        // Define the subtopics where the auth status should be published
        const subtopics = ['test/parents', 'test/driver'];
        const topic = 'rfid/auth';
        
        if (student) {
            console.log(`RFID Verified for ${student.student_name}`);
            // Publish 1 (success) to subtopics
            publishAuthCompleted(student.student_name,"Boarded",subtopics);
            publishAuthStatus(1, subtopics);
        } else {
            console.log(`RFID verification failed for code: ${rfidCode}`);
            // Publish 0 (failure) to subtopics
            publishAuthStatus(0,topic);
        }
    }
});

aedes.on('subscribe', (subscriptions, client) => {
    console.log(`Client ${client.id} subscribed to topics: ${subscriptions.map(s => s.topic).join(', ')}`);
});

module.exports = router;
