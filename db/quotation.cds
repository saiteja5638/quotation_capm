context app.quotation {

    entity QUOT_HEADER_DATA {
        key ZQUOTATION : String(10);
        key VBELN      : String(10);
            KUNNR      : String(10);
            NAME1      : String(35);
            REGIO      : String(3);
            ORTO1      : String(35);
            STATUS     : String(1);
            AUFSD      : String(2);
            VKBUR      : String(4);
            ERDAT      : Date;
            ERNAM      : String(12);
    }

    entity QUOT_ITEM_DATA {
        key ZQUOTATION : String(10);
        key VBELN      : String(10);
        key POSNR      : String(6);
            MATNR      : String(40);
            MAKTX      : String(40);
            KWMENG     : String(15);
            KBMENG     : String(15);
            NETWR      : String(15);
            STATUS     : String(1);

    }

    entity DATA_CARR {
        key ID   : String;
            DATA : LargeString;
    }

}
