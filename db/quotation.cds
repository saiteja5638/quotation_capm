context app.quotation {

    entity Z_QUOTATION {
        key ZQUOTATION : String(10);
        key POSNR      : String(6);
            KUNNR      : String(10);
            WERKS      : String(4);
            VKORG      : String(4);
            MATNR      : String(40);
            NETWR      : Decimal(10, 2);
            KWMENG     : Decimal(10, 3);
            ZVKORG     : Decimal(5, 2);
            ZWERKS     : Decimal(5, 2);
            ZKUNNR     : Decimal(5, 2);
            ZMATNR     : Decimal(5, 2);
            MAKTX      : String(40);
            ZNETWRP    : Decimal(5, 2);
            NETPR      : Decimal(11, 2);
            ZMATAVG    : Decimal(10, 3);
            ZMATAVGK   : Decimal(10, 3);
    }

    type quotation_payload {
        KUNNR  : String(10);
        VKORG  : String(4);
        MATNR  : String(40);
        NETPR  : Decimal(11, 2);
        KWMENG : Decimal(10, 3);
    }

    type Res{
        Response:String;
    }
    
    

}
