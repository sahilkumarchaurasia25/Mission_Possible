// // 

// const { Client, Message } = require('azure-iot-device');
// const { Mqtt } = require('azure-iot-device-mqtt');

// // Azure IoT Hub connection string
// const connectionString = 'HostName=Colossus.azure-devices.net;DeviceId=ESP_EZ;SharedAccessKey=Ro4uCdnZs1F8oEnro5A5VMK9ZP3RtHoYgAIoTGaE8+U=';
// const client = Client.fromConnectionString(connectionString, Mqtt);

// // Open connection to IoT Hub
// client.open()
//     .then(() => {
//         console.log('Connected to Azure IoT Hub');
        
//         // Publish a message to IoT Hub (simulating MQTT publish to a topic)
//         const payload = {
//             temperature: 22.5,
//             humidity: 60
//         };

//         const message = new Message(JSON.stringify(payload));

//         // Optionally, add custom properties to simulate topic-like behavior
//         message.properties.add('sensorType', 'environment');

//         client.sendEvent(message, function (err) {
//             if (err) {
//                 console.error('Error sending message:', err.toString());
//             } else {
//                 console.log('Message sent successfully');
//             }
//         });
//     })
//     .catch(err => {
//         console.error('Failed to connect to Azure IoT Hub:', err);
//     });

const { Client, Message } = require('azure-iot-device');
const { Mqtt } = require('azure-iot-device-mqtt');

// Azure IoT Hub connection string
const connectionString = 'HostName=Colossus.azure-devices.net;DeviceId=ESP_EZ;SharedAccessKey=/8yTcOqPe50GV9iIrzX0QeUYITVGIrdEKAIoTD+m4e4=';
const client = Client.fromConnectionString(connectionString, Mqtt);

// Open connection to IoT Hub
client.open()
    .then(() => {
        console.log('Connected to Azure IoT Hub');
        
        // Payload: list of students
        const studentData = {
            studentId: '12345',
            name: 'John Doe',
            age: 21,
            classroom: 'AAA'
          };

        const message = new Message(JSON.stringify(studentData));

        // Add custom property to mimic topic (e.g., "classroom" as a topic)
        message.properties.add('classroom', 'A');

        // Send the message
        client.sendEvent(message, (err) => {
            if (err) {
                console.error('Error sending message:', err);
            } else {
                console.log('Student list message sent successfully');
            }
        });
    })
    .catch(err => {
        console.error('Failed to connect to Azure IoT Hub:', err);
    });
