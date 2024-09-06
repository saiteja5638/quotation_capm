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

    // Define Authors entity
    entity Authors {
        key ID      : UUID;
            name    : String(100);
            country : String(50);
            books   : Association to many Books
                          on books.authorID = $self.ID;
    }

    // Define Publishers entity
    entity Publishers {
        key ID      : UUID;
            name    : String(100);
            address : String(150);
            books   : Association to many Books
                          on books.publisherID = $self.ID;
    }

    // Define Books entity
    entity Books {
        key ID              : UUID;
            title           : String(150);
            genre           : String(50);
            publicationYear : Integer;
            // Associations to Authors and Publishers
            authorID        : UUID;
            publisherID     : UUID;
            author          : Association to Authors
                                  on author.ID = authorID;
            publisher       : Association to Publishers
                                  on publisher.ID = publisherID;
    }


    // WorkflowTaskCollection entity with composite key
    entity WorkflowTaskCollection {
        key SAPOrigin     : String(50); // Part of composite key
        key WorkitemID    : UUID; // Part of composite key
            description   : String(255); // Additional fields for workflow task

            // Association to HeaderDetails
            headerDetails : Association to HeaderDetails
                                on  headerDetails.workflowTaskSAPOrigin = $self.SAPOrigin
                                and headerDetails.workflowTaskID        = $self.WorkitemID;
    }

    // HeaderDetails entity
    entity HeaderDetails {
        key ID                    : UUID; // Primary Key for HeaderDetails
            workflowTaskSAPOrigin : String(50); // Foreign key (SAPOrigin from WorkflowTaskCollection)
            workflowTaskID        : UUID; // Foreign key (WorkitemID from WorkflowTaskCollection)
            documentNumber        : String(50); // Document Number
            createdDate           : Date; // Date of workflow creation

            // Associations to related entities
            itemDetails           : Association to many ItemDetails
                                        on itemDetails.headerID = $self.ID;
            notes                 : Association to many Notes
                                        on notes.headerID = $self.ID;
            attachments           : Association to many Attachments
                                        on attachments.headerID = $self.ID;
    }

    // ItemDetails entity
    entity ItemDetails {
        key ID              : UUID; // Primary Key for ItemDetails
            headerID        : UUID; // Foreign key referencing HeaderDetails
            itemDescription : String(255); // Description of the item
            quantity        : Integer; // Quantity of items

            // Association to Limits
            limits          : Association to Limits
                                  on limits.itemID = $self.ID;
    }

    // Limits entity (nested under ItemDetails)
    entity Limits {
        key ID       : UUID; // Primary Key for Limits
            itemID   : UUID; // Foreign key referencing ItemDetails
            maxLimit : Decimal(15, 2); // Maximum limit for the item
            minLimit : Decimal(15, 2); // Minimum limit for the item
    }

    // Notes entity
    entity Notes {
        key ID          : UUID; // Primary Key for Notes
            headerID    : UUID; // Foreign Key referencing HeaderDetails
            noteText    : String(1000); // Note text
            author      : String(100); // Author of the note
            createdDate : DateTime; // Date when note was created
    }

    // Attachments entity
    entity Attachments {
        key ID       : UUID; // Primary Key for Attachments
            headerID : UUID; // Foreign Key referencing HeaderDetails
            fileName : String(255); // Name of the file attachment
            fileType : String(50); // Type of the file (e.g., PDF, DOC)
            fileUrl  : String(500); // URL to access the file
    }

}
