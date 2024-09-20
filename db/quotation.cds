context app.quotation {

    entity QUOT_HEADER_DATA {
        key ZQUOTATION : String(10);
        key VBELN      : String(10);
            KUNNR      : String(10);
            NAME1      : String(35);
            REGIO      : String(3);
            ORT01      : String(35);
            STATUS     : String(1);
            AUFSD      : String(2);
            VKORG      : String(4);
            VKBUR      : String(4);
            ERDAT      : String;
            ERNAM      : String(12);
    }

    entity QUOT_ITEM_DATA {
        key ZQUOTATION : String(10);
        key VBELN      : String(10);
        key POSNR      : String(6);
            MATNR      : String(40);
            MAKTX      : String(40);
            KWMENG     : Decimal(10, 3);
            KBMENG     : Decimal(10, 3);
            NETWR      : Decimal(10, 2);
            ZSTATUS    : String(1);

    }

    entity DATA_CARR {
        key ID   : String;
            SERV : String;
            DATA : LargeString;
    }

    entity Z_QUOTATION {
        key ZQUOTATION : String(10);
        key POSNR      : String(6);
            KUNNR      : String(10);
            WERKS      : String(4);
            VKORG      : String(4);
            MATNR      : String(40);
            NETWR      : Decimal(10, 2);
            KWMENG     : Decimal(10, 3);
    }        

}
