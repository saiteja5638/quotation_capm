using app.quotation from '../db/quotation';


service Quotation {
    entity Z_QUOTATION as projection on quotation.Z_QUOTATION;
    action predictQuotation(quotation: array of quotation.quotation_payload) returns quotation.Res;

}
