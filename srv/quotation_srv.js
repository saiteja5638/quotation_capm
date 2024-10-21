const cds = require('@sap/cds');
const { DELETE } = require('@sap/cds/lib/ql/cds-ql');
const axios = require('axios');

module.exports = async (srv) => {

    // WebSocket broadcast function
    // const broadcastUpdate = (wss, data) => {
    //     wss.clients.forEach(client => {
    //         if (client.readyState === WebSocket.OPEN) {
    //             client.send(JSON.stringify(data));
    //         }
    //     });
    // };

    srv.before('CREATE', 'Z_QUOTATION', async (req) => {
        try {
          // Start a transactional request
          let dat = cds.run(DELETE.from("APP_QUOTATION_Z_QUOTATION"));
          
        } catch (error) {
          // Rollback in case of any errors
          console.log("Error handling /Z_QUOTATION:", error);
     
        }
      });

    srv.on('ApproveQuotation',async(req)=>{
        try {
             
            let response_data = JSON.parse(req.data.DATA)
            let dat = cds.run(DELETE.from("APP_QUOTATION_Z_QUOTATION"));
     
                for (let index = 0; index < response_data.length; index++) {
                    const element = response_data[index];
                    await cds.run(INSERT.into("APP_QUOTATION_Z_QUOTATION").entries(element));
                }
            
                return "Success"
       
            
        } catch (error) {
            console.log(error)
        }
    })  
    srv.on('createQuotation', async (req, res) => {
        try {

            
            let result = req.data.KUNNR.replace(/^00/, ''); // Remove the first two zeros
          
            const requestData = {
                KUNNR: result,
                VKORG: parseInt(req.data.VKORG),
                MATNR: req.data.MATNR,
                NETPR: parseInt(req.data.NETPR),
                KWMENG: parseInt(req.data.KWMENG)
            };
            const reqUrl = "https://060a0275trial-dev-myapp.cfapps.us10-001.hana.ondemand.com/predict";
            const response = await axios.post(reqUrl, requestData);
            console.log(response.data);

            return response.data;
        } catch (error) {
            console.log(error);
            req.reject(500, error.message);
        }
    });
    srv.before(['CREATE'], 'DATA_CARR', async (req, res) => {
        try {
            let Get_Data = req.data.DATA;
            let serv = req.data.SERV;
            let S4_GetData = JSON.parse(Get_Data);

            if (serv === 'Header_Data') {
                for (let index = 0; index < S4_GetData.length; index++) {
                    const element = S4_GetData[index];
                    await cds.run(INSERT.into("APP_QUOTATION_QUOT_HEADER_DATA").entries(element));
                }
            }

            if (serv === 'Item_Data') {
                for (let index = 0; index < S4_GetData.length; index++) {
                    const element = S4_GetData[index];
                    element['POSNR'] = element.POSNR + "";
                    await cds.run(INSERT.into("APP_QUOTATION_QUOT_ITEM_DATA").entries(element));
                }
            }

            // Broadcast the data insert via WebSocket
            // broadcastUpdate(global.wss, { action: 'insertData', data: { Get_Data, serv } });

        } catch (error) {
            console.log("Issue Raised at: " + error);
            req.reject(500, error.message);
        }
    });
};
