const cds = require('@sap/cds');
const { DELETE } = require('@sap/cds/lib/ql/cds-ql');
const axios = require('axios');
var WebSocket = require('ws');

module.exports = async (srv) => {
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
