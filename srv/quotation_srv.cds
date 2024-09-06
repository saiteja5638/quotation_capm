using app.quotation from '../db/quotation';


service Quotation {

    entity QUOT_HEADER_DATA       as projection on quotation.QUOT_HEADER_DATA;
    entity QUOT_ITEM_DATA         as projection on quotation.QUOT_ITEM_DATA;
    entity DATA_CARR              as projection on quotation.DATA_CARR;
    entity Authors                as projection on quotation.Authors;
    entity Books                  as projection on quotation.Books;
    entity Publishers             as projection on quotation.Publishers;
    entity WorkflowTaskCollection as projection on quotation.WorkflowTaskCollection;
    entity HeaderDetails          as projection on quotation.HeaderDetails;
    entity ItemDetails            as projection on quotation.ItemDetails;
    entity Notes                  as projection on quotation.Notes;
    entity Attachments            as projection on quotation.Attachments;
    entity Limits                 as projection on quotation.Limits;

}
