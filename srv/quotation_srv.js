var cds = require('@sap/cds');


module.exports = async srv =>{
   srv.before(['CREATE'],'DATA_CARR', async(req,res)=>{
    try {
       
        let Get_Data = req.data.DATA;
        let serv = req.data.SERV;
        let S4_GetData = JSON.parse(Get_Data);

        if (serv == 'Header_Data') {
            for (let index = 0; index < S4_GetData.length; index++) {
                const element = S4_GetData[index];
                var post_obj =   cds.run(INSERT.into("APP_QUOTATION_QUOT_HEADER_DATA").entries(element))
            }
        }
        if (serv == 'Item_Data') {
            for (let index = 0; index < S4_GetData.length; index++) {
                const element = S4_GetData[index];
                element['POSNR'] = element.POSNR + "";
                var post_obj =   cds.run(INSERT.into("APP_QUOTATION_QUOT_ITEM_DATA").entries(element))
            }
        }
     

    } catch (error) {
        console.log("Issued Raised at :"+error)
    }
   })
}