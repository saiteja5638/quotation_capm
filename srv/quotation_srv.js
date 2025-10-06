const cds = require('@sap/cds');
const { DELETE } = require('@sap/cds/lib/ql/cds-ql');
const axios = require('axios');
var WebSocket = require('ws');

module.exports = async (srv) => {

    srv.on('ApproveQuotation',async(req)=>{
        try {
             
            let response_data = JSON.parse(req.data.DATA)
             await cds.run(DELETE.from("APP_QUOTATION_Z_QUOTATION"));
     
                for (let index = 0; index < response_data.length; index++) {
                    const element = response_data[index];
                    await cds.run(INSERT.into("APP_QUOTATION_Z_QUOTATION").entries(element));

                    if (index + 1 == response_data.length) {
                        broadcastUpdate(global.wss, { action: 'ApproveQuotation', data: "working fine" });
                    }
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
            const reqUrl = "http://100.96.8.237:8001/predict";
            const response = await axios.post(reqUrl, requestData);
            return response.data;
        } catch (error) {
            console.log(error);
            req.reject(500, error.message);
        }
    });

    srv.on('predictQuotation',async(req,res)=>{
        try {
            let {KUNNR,VKORG,MATNR,NETPR,KWMENG} =  req.data.quotation[0];


            let result = KUNNR.replace(/^00/, ''); // Remove the first two zeros

            const requestData = {
                KUNNR: result,
                VKORG: parseInt(VKORG),
                MATNR: MATNR,
                NETPR: parseInt(NETPR),
                KWMENG: parseInt(KWMENG)
            };
            const reqUrl = "https://41045a93trial-dev-myapp.cfapps.us10-001.hana.ondemand.com/predict";
            const response = await axios.post(reqUrl, requestData);
            return {
                Response:response.data
            };

        } catch (error) {
            console.log(error)
        }
    })
};
