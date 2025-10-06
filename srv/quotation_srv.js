const cds = require('@sap/cds');
const { DELETE } = require('@sap/cds/lib/ql/cds-ql');
const axios = require('axios');

module.exports = async (srv) => {
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
            const reqUrl = "http://100.96.27.87:8001/predict";
            const response = await axios.post(reqUrl, requestData);
            return {
                Response:response.data
            };

        } catch (error) {
            console.log(error)
        }
    })
};
