const cds = require("@sap/cds");
const cov2ap = require("@sap/cds-odata-v2-adapter-proxy");
const WebSocket = require('ws');

cds.on("bootstrap", (app) => app.use(cov2ap()));

// cds.on("bootstrap", (app) => {
//     app.use(cov2ap());

//     cds.on('listening', ({ server }) => {
//         const wss = new WebSocket.Server({ noServer: true });
//         server.on('upgrade', (request, socket, head) => {
//             wss.handleUpgrade(request, socket, head, (ws) => {
//                 wss.emit('connection', ws, request);
//             });
//         });
//         global.wss = wss;

//         // Handle WebSocket connections
//         wss.on('connection', (ws) => {
//             console.log('New WebSocket connection established');

//             ws.on('close', () => {
//                 console.log('WebSocket connection closed');
//             });
//         });

//         console.log('WebSocket server is ready');
//     });
// });
module.exports = cds.server;
