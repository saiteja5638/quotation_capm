using app.quotation from '../db/quotation';


service Quotation {

    entity QUOT_HEADER_DATA as projection on quotation.QUOT_HEADER_DATA;
    entity QUOT_ITEM_DATA   as projection on quotation.QUOT_ITEM_DATA;
    entity DATA_CARR        as projection on quotation.DATA_CARR;
    entity Z_QUOTATION      as projection on quotation.Z_QUOTATION;

    action ApproveQuotation(DATA:String) returns String;


    function createQuotation(KUNNR : String,
                             VKORG : String,
                             MATNR : String,
                             NETPR : String, // Allowing for null values
                             KWMENG : String) returns String; // You can change the return type as required


}
