using app.quotation from '../db/quotation';


service Quotation {
    entity Z_QUOTATION      as projection on quotation.Z_QUOTATION;

    action ApproveQuotation(DATA:String) returns String;
    action predictQuotation(quotation:array of quotation.quotation_payload) returns quotation.Res; 

    function createQuotation(KUNNR : String,
                             VKORG : String,
                             MATNR : String,
                             NETPR : String, // Allowing for null values
                             KWMENG : String) returns String; // You can change the return type as required


}
