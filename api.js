const express = require('express');
const { exec } = require('child_process');
const bodyParser = require('body-parser');

const app = express();
const PORT = 3000;

// Middleware
app.use(bodyParser.json());

// Route to create new PocketBase instance
app.post('/create-instance', (req, res) => {
    const { username } = req.body;

    // Dynamic port assignment (incrementing for simplicity)
    const assignedPort = 8090 + Math.floor(Math.random() * 1000);

    // Execute the deployment script
    const command = `./deploy_pocketbase.sh ${username} ${assignedPort}`;

    exec(command, (error, stdout, stderr) => {
        if (error) {
            console.error(`Error creating instance: ${error.message}`);
            return res.status(500).send({ error: error.message });
        }

        if (stderr) {
            console.error(`Error: ${stderr}`);
            return res.status(500).send({ error: stderr });
        }

        console.log(`Instance created:\n${stdout}`);
        res.send({
            message: 'PocketBase instance created',
            username: username,
            port: assignedPort,
            output: stdout
        });
    });
});

// Start the server
app.listen(PORT, () => {
    console.log(`API Server running on port ${PORT}`);
});

