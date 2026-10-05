CLASS lcl_buffer DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA mt_cert_create TYPE TABLE OF zvendor_cert.
    CLASS-DATA mt_cert_update TYPE TABLE OF zvendor_cert.
    CLASS-DATA mt_cert_delete TYPE TABLE OF zvendor_cert.

    TYPES : tt_attach TYPE SORTED TABLE OF zvend_attachment WITH UNIQUE KEY attachment_id cert_uuid filename.
    CLASS-DATA: mt_attach_create      TYPE tt_attach,
                mt_attach_update      TYPE tt_attach,
                mt_attach_delete      TYPE tt_attach,
                mt_attach_read        TYPE tt_attach,
                mt_attach_from_header TYPE tt_attach,
                gv_certiid            TYPE sysuuid_x16.


ENDCLASS.

CLASS lhc_attachment DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      keys REQUEST requested_features FOR Attachment RESULT result.

*    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
*      REQUEST requested_authorizations FOR Attachment RESULT result.

*    METHODS create FOR MODIFY
*       entities FOR CREATE Attachment.

    METHODS update FOR MODIFY
       entities FOR UPDATE Attachment.

    METHODS delete FOR MODIFY
       keys FOR DELETE Attachment.

    METHODS read FOR READ
       keys FOR READ Attachment RESULT result.

    METHODS rba_Vendorcert FOR READ
       keys_rba FOR READ Attachment\_Vendorcert FULL result_requested RESULT result LINK association_links.
    METHODS create FOR MODIFY
       entities FOR CREATE Attachment.
*    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
*      REQUEST requested_authorizations FOR Attachment RESULT result.

*    METHODS Upload FOR MODIFY
*       keys FOR ACTION Attachment~Upload RESULT result.

*    METHODS Upload FOR MODIFY
*      keys FOR ACTION Attachment~Upload.

ENDCLASS.

CLASS lhc_attachment IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

*  METHOD get_global_authorizations.
*  ENDMETHOD.

*  METHOD create.
**
**    DATA : ls_temp       LIKE LINE OF lcl_buffer=>mt_attach_create,
**           ls_attach_map LIKE LINE OF lcl_buffer=>mt_attach_create.
**
**
**    READ ENTITIES OF ZI_VendorCert IN LOCAL MODE
**                                ENTITY Attachment ALL FIELDS WITH CORRESPONDING #( entities )
**                                RESULT DATA(certificates).
**
**    LOOP AT entities INTO DATA(ls_attach).
**      IF lcl_buffer=>gv_certiid IS NOT INITIAL.
**        DATA(lv_uuid) = lcl_buffer=>gv_certiid.
**      ELSE.
**        lv_uuid = ls_attach-CertUuid.
**      ENDIF.
**
**      MOVE-CORRESPONDING ls_attach TO  ls_temp.
**      MOVE-CORRESPONDING ls_attach TO ls_attach_map.
**

**
**      APPEND ls_temp TO lcl_buffer=>mt_attach_create.
***      APPEND ls_attach_map TO mapped-attachment.
*
**    ENDLOOP.
*
*
*
*  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.


    DATA : lv_certiid TYPE uuid.

    LOOP AT keys INTO DATA(ls_keys).

      DATA(lv_uid) = ls_keys-%control-CertUuid.


*      SELECT * FROM zvend_attachment WHERE cert_uuid = @lv_uid
*                                                INTO TABLE @DATA(lt_attach_read).

*      LOOP AT lt_wtkt_item_read INTO DATA(ls_wtkt_item_read).
*        INSERT VALUE #( wtktno = ls_wtkt_item_read-wtktno
*                        wtktitm = ls_wtkt_item_read-wtktitm
*                        werks = ls_wtkt_item_read-werks
*                        prueflos = ls_wtkt_item_read-prueflos
*                        charg = ls_wtkt_item_read-charg
*                        ebeln = ls_wtkt_item_read-ebeln
*                        ebelp = ls_wtkt_item_read-ebelp
*                        mblnr = ls_wtkt_item_read-mblnr
*                        mjahr = ls_wtkt_item_read-mjahr
*                        invoice = ls_wtkt_item_read-invoice
*                        splitinvoice1 = ls_wtkt_item_read-invoice_split1
*                        splitinvoice2 = ls_wtkt_item_read-invoice_split2
*                        splitinvoice3 = ls_wtkt_item_read-invoice_split3
*                        weight = ls_wtkt_item_read-weight
*                        unit = ls_wtkt_item_read-unit
*                        ernam = ls_wtkt_item_read-ernam
*                        erdat = ls_wtkt_item_read-erdat
*                        ereit = ls_wtkt_item_read-ereit
*                        aenam = ls_wtkt_item_read-aenam
*                        aedat = ls_wtkt_item_read-aedat
*                        aeeit = ls_wtkt_item_read-aeeit
*                        supplier = ls_wtkt_item_read-supplier
*                        agreement = ls_wtkt_item_read-agreement
*                        matnr = ls_wtkt_item_read-matnr
*                        collection_point = ls_wtkt_item_read-collection_point
*                        lgort = ls_wtkt_item_read-lgort
*                        poprice = ls_wtkt_item_read-po_price
*                        status = ls_wtkt_item_read-status
*                        comments = ls_wtkt_item_read-comments
*                        rocancel = ls_wtkt_item_read-rocancel
*                        ) INTO TABLE result.

*      ENDLOOP.
    ENDLOOP.


  ENDMETHOD.

  METHOD rba_Vendorcert.
  ENDMETHOD.

*  METHOD Upload.
*  ENDMETHOD.

*  METHOD get_global_authorizations.
*  ENDMETHOD.

*  METHOD Upload.
*  ENDMETHOD.

  METHOD create.

    DATA : ls_item_temp LIKE LINE OF lcl_buffer=>mt_attach_create,
*           lv_prueflos   TYPE zpr_dt_qplos,
*           lv_charg      TYPE charg_d,
           ls_item_map  LIKE LINE OF mapped-attachment.
*           lv_item       TYPE zpr_dt_wtktitm,
*           lt_item_count TYPE STANDARD TABLE OF zpr_tb_wt_it.

*    CLEAR : lv_item.

    READ ENTITIES OF ZI_VendorCert IN LOCAL MODE
                                ENTITY Attachment ALL FIELDS WITH CORRESPONDING #( entities ) RESULT DATA(attach).

    LOOP AT entities INTO DATA(ls_attach).
      IF lcl_buffer=>gv_certiid IS NOT INITIAL.
        DATA(lv_certiid) = lcl_buffer=>gv_certiid.
      ELSE.
        lv_certiid = ls_attach-CertUuid.
      ENDIF.

      MOVE-CORRESPONDING ls_attach TO  ls_item_temp.
      MOVE-CORRESPONDING ls_attach TO ls_item_map.
      ls_item_temp-cert_uuid = lv_certiid.
      ls_item_temp-attachment_id = ls_attach-AttachmentId.
      ls_item_temp-client = sy-mandt.
      ls_item_temp-created_at = ls_attach-CreatedAt.
      ls_item_temp-created_by = ls_attach-CreatedBy.
      ls_item_temp-mimetype = ls_attach-Mimetype.
      ls_item_temp-filename = ls_attach-Filename.
      ls_item_temp-attachment = ls_attach-Attachment.

      APPEND ls_item_temp TO lcl_buffer=>mt_attach_create.
      APPEND ls_item_map TO mapped-attachment.
    ENDLOOP.



  ENDMETHOD.

ENDCLASS.


CLASS lhc_VendorCert DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR VendorCert RESULT result.

    METHODS create FOR MODIFY
       entities FOR CREATE VendorCert.

    METHODS update FOR MODIFY
       entities FOR UPDATE VendorCert.

    METHODS delete FOR MODIFY
       keys FOR DELETE VendorCert.

    METHODS read FOR READ
       keys FOR READ VendorCert RESULT result.

    METHODS lock FOR LOCK
       keys FOR LOCK VendorCert.

    METHODS rba_Attachment FOR READ
       keys_rba FOR READ VendorCert\_Attachment FULL result_requested RESULT result LINK association_links.

    METHODS cba_Attachment FOR MODIFY
       entities_cba FOR CREATE VendorCert\_Attachment.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR VendorCert RESULT result.

    METHODS validateCertNo FOR VALIDATE ON SAVE
       keys FOR VendorCert~validateCertNo.

    METHODS validatecerttype FOR VALIDATE ON SAVE
       keys FOR vendorcert~validatecerttype.

    METHODS validatevendor FOR VALIDATE ON SAVE
       keys FOR vendorcert~validatevendor.

ENDCLASS.

CLASS lhc_VendorCert IMPLEMENTATION.

  METHOD get_global_authorizations.

* result-%create = if_abap_behv=>auth-allowed.
* result-%update = if_abap_behv=>auth-allowed.
* result-%delete = if_abap_behv=>auth-allowed.
* result-%action-sendEmail = if_abap_behv=>auth-allowed.

    " --- Check CREATE authorization ---
    IF requested_authorizations-%create = if_abap_behv=>mk-on.
      AUTHORITY-CHECK OBJECT 'ZVEN_CERT'
        ID 'ACTVT' FIELD '01'.
*      IF sy-subrc = 0.
      IF 1 = 1.
        result-%create = if_abap_behv=>auth-allowed.
      ELSE.
        result-%create = if_abap_behv=>auth-unauthorized.
      ENDIF.
    ENDIF.

*    " --- Check UPDATE authorization ---
*    IF requested_authorizations-%update = if_abap_behv=>mk-on.
*      AUTHORITY-CHECK OBJECT 'ZVEN_CERT'
*        ID 'ACTVT' FIELD '02'.
*      IF sy-subrc = 0.
*        result-%update = if_abap_behv=>auth-allowed.
*      ELSE.
*        result-%update = if_abap_behv=>auth-unauthorized.
*      ENDIF.
*    ENDIF.
*
*    " --- Check DELETE authorization ---
*    IF requested_authorizations-%delete = if_abap_behv=>mk-on.
*      AUTHORITY-CHECK OBJECT 'ZVEN_CERT'
*        ID 'ACTVT' FIELD '06'.
*      IF sy-subrc = 0.
*        result-%delete = if_abap_behv=>auth-allowed.
*      ELSE.
*        result-%delete = if_abap_behv=>auth-unauthorized.
*      ENDIF.
*    ENDIF.

  ENDMETHOD.

  METHOD create.

    DATA lt_cert_db TYPE TABLE OF zvendor_cert.
    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).

      IF <entity>-ValidFrom IS NOT INITIAL
      AND <entity>-ValidTo IS NOT INITIAL
      AND <entity>-ValidFrom > <entity>-ValidTo.

        APPEND VALUE #(
        %cid = <entity>-%cid
        %msg = new_message_with_text(
        severity = if_abap_behv_message=>severity-error
        text = 'Valid From must be before Valid To' )
        ) TO reported-vendorcert.

        CONTINUE.

      ENDIF.
      DATA(ls_cert) = CORRESPONDING zvendor_cert( <entity> MAPPING FROM ENTITY ).

      " Generate UUID (unmanaged: developer is responsible)
      ls_cert-cert_uuid = cl_system_uuid=>create_uuid_x16_static( ).
      ls_cert-client = sy-mandt.

      " Derive Status from ValidTo date
      IF ls_cert-valid_to < lv_today."sy-datum.
        ls_cert-status = 'Expired'.
      ELSE.
        ls_cert-status = 'Valid'.
      ENDIF.

*      " Set administrative fields manually
*      GET TIME STAMP FIELD DATA(lv_timestamp).
*      ls_cert-created_by = sy-uname.
*      ls_cert-created_at = lv_timestamp.
*      ls_cert-last_changed_by = sy-uname.
*      ls_cert-last_changed_at = lv_timestamp.
*      ls_cert-local_last_changed_at = lv_timestamp.

      APPEND ls_cert TO lt_cert_db.

      " Map back the generated key to %cid
      APPEND VALUE #(
      %cid = <entity>-%cid
      %key-CertUuid = ls_cert-cert_uuid
      ) TO mapped-vendorcert.
    ENDLOOP.

    " Explicit INSERT - replaces managed framework persistence
    INSERT zvendor_cert FROM TABLE @lt_cert_db.
    IF sy-subrc <> 0.
      LOOP AT entities ASSIGNING <entity>.
        APPEND VALUE #(
        %cid = <entity>-%cid
        %msg = new_message_with_text(
        severity = if_abap_behv_message=>severity-error
        text = 'Error creating Vendor Certificate' )
        ) TO reported-vendorcert.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

**----------------------------------------------------------------------*
** UPDATE - explicit UPDATE on zvendor_cert
**----------------------------------------------------------------------*
  METHOD update.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).

      " 1. CRITICAL CHANGE: Read from the Draft Table or active entity buffer instead of direct DB SELECT
      " For Unmanaged Draft, you should update the draft runtime state.
      " If you must fetch the active record baseline:
      SELECT SINGLE * FROM zvendor_cert
        WHERE cert_uuid = @<entity>-CertUuid
        INTO @DATA(ls_cert).

      IF sy-subrc <> 0.
        APPEND VALUE #(
           %tky = <entity>-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Vendor Certificate not found' )
        ) TO reported-vendorcert.
        CONTINUE.
      ENDIF.

      " [Keep your exact %control mapping logic here...]
      IF <entity>-%control-Vendor = if_abap_behv=>mk-on.
        ls_cert-vendor = <entity>-Vendor.
      ENDIF.

      IF <entity>-%control-CompanyCode = if_abap_behv=>mk-on.
        ls_cert-company_code = <entity>-CompanyCode.
      ENDIF.
      IF <entity>-%control-PurchOrg = if_abap_behv=>mk-on.
        ls_cert-purch_org = <entity>-PurchOrg.
      ENDIF.
      IF <entity>-%control-CertName = if_abap_behv=>mk-on.
        ls_cert-cert_name = <entity>-CertName.
      ENDIF.
      IF <entity>-%control-ValidFrom = if_abap_behv=>mk-on.
        ls_cert-valid_from = <entity>-ValidFrom.
      ENDIF.

      IF <entity>-%control-ValidTo = if_abap_behv=>mk-on.
        ls_cert-valid_to = <entity>-ValidTo.
      ENDIF.
      " Handle expiration checks
      IF  <entity>-%control-RegCountry = if_abap_behv=>mk-on.
        ls_cert-reg_country = <entity>-RegCountry.
      ENDIF.
      IF <entity>-%control-Exempt = if_abap_behv=>mk-on.
        ls_cert-exempt = <entity>-Exempt.
      ENDIF.
      IF <entity>-%control-ExemptReason = if_abap_behv=>mk-on.
        ls_cert-exempt_reason = <entity>-ExemptReason.
      ENDIF.
      IF <entity>-%control-IntOwnerEmail = if_abap_behv=>mk-on.
        ls_cert-int_owner_email = <entity>-IntOwnerEmail.
      ENDIF.
      IF <entity>-%control-SupplierEmail = if_abap_behv=>mk-on.
        ls_cert-supplier_email = <entity>-SupplierEmail.
      ENDIF.
      IF <entity>-%control-Alert1 = if_abap_behv=>mk-on.
        ls_cert-alert1 = <entity>-Alert1.
      ENDIF.
      IF <entity>-%control-Alert2 = if_abap_behv=>mk-on.
        ls_cert-alert2 = <entity>-Alert2.
      ENDIF.
      IF <entity>-%control-Alert3 = if_abap_behv=>mk-on.
        ls_cert-alert3 = <entity>-Alert3.
      ENDIF.
      IF <entity>-%control-ToleranceDays = if_abap_behv=>mk-on.
        ls_cert-tolerance_days = <entity>-ToleranceDays.
      ENDIF.

      " Update administrative field trackers
      ls_cert-last_changed_by = sy-uname.

      " 3. Push the modified record directly into the transactional memory buffer
      " This bypasses infinite EML recursion entirely!
      APPEND ls_cert TO lcl_buffer=>mt_cert_update.
    ENDLOOP.

  ENDMETHOD.

**----------------------------------------------------------------------*
** DELETE - explicit DELETE from zvendor_cert + cascade children
**----------------------------------------------------------------------*
  METHOD delete.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).

      " Explicit DELETE - replaces managed framework persistence
      DELETE FROM zvendor_cert WHERE cert_uuid = @<key>-CertUuid.
      IF sy-subrc <> 0.
        APPEND VALUE #(
        %key = <key>-%key
        %msg = new_message_with_text(
        severity = if_abap_behv_message=>severity-error
        text = 'Error deleting Vendor Certificate' )
        ) TO reported-vendorcert.
      ELSE.
        " Cascade delete child records (unmanaged: developer responsibility)
        DELETE FROM zvc_email_log WHERE cert_uuid = @<key>-CertUuid.
* DELETE FROM zvendor_cert_attach WHERE cert_uuid = @<key>-CertUuid.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

**----------------------------------------------------------------------*
** READ - explicit SELECT from zvendor_cert
**----------------------------------------------------------------------*
  METHOD read.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
      SELECT SINGLE * FROM zvendor_cert
      WHERE cert_uuid = @<key>-CertUuid
      INTO @DATA(ls_cert).

      IF sy-subrc = 0.
*        APPEND CORRESPONDING #( ls_cert MAPPING TO ENTITY ) TO result.
        APPEND VALUE #(
          %tky          = <key>-%tky
          CertUuid      = ls_cert-cert_uuid
          Vendor        = ls_cert-vendor
          CompanyCode   = ls_cert-company_code
          PurchOrg      = ls_cert-purch_org
          CertType      = ls_cert-cert_type
          CertNo        = ls_cert-cert_no
          CertName      = ls_cert-cert_name
          ValidFrom     = ls_cert-valid_from
          ValidTo       = ls_cert-valid_to
          RegCountry    = ls_cert-reg_country
          Exempt        = ls_cert-exempt
          ExemptReason  = ls_cert-exempt_reason
          IntOwnerEmail = ls_cert-int_owner_email
          SupplierEmail = ls_cert-supplier_email
          Alert1        = ls_cert-alert1
          Alert2        = ls_cert-alert2
          Alert3        = ls_cert-alert3
          ToleranceDays = ls_cert-tolerance_days
          status        = ls_cert-status
        ) TO result.
      ELSE.
        APPEND VALUE #(
        %key = <key>-%key
        %msg = new_message_with_text(
        severity = if_abap_behv_message=>severity-error
        text = 'Vendor Certificate not found' )
        ) TO reported-vendorcert.
      ENDIF.
    ENDLOOP.


*    ENDLOOP.
  ENDMETHOD.

**----------------------------------------------------------------------*
** LOCK - optimistic locking via ETag (LocalLastChangedAt)
**----------------------------------------------------------------------*
  METHOD lock.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
      SELECT SINGLE local_last_changed_at
      FROM zvendor_cert
      WHERE cert_uuid = @<key>-CertUuid
      INTO @DATA(lv_ts).
      IF sy-subrc <> 0.
        APPEND VALUE #(
* %key = <key>-%key
        CertUuid = keys[ 1 ]-CertUuid
        %msg = new_message_with_text(
        severity = if_abap_behv_message=>severity-error
        text = 'Record not found for locking' )
        ) TO reported-vendorcert.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_Attachment.
    READ ENTITIES OF ZI_VendorCert IN LOCAL MODE
      ENTITY Attachment
        FIELDS ( Attachment Filename CreatedAt CreatedBy ) WITH CORRESPONDING #( keys_rba )
      RESULT DATA(lt_input_attach).



    LOOP AT keys_rba ASSIGNING FIELD-SYMBOL(<key>).
      SELECT SINGLE * FROM zvend_attachment
      WHERE cert_uuid = @<key>-CertUuid
      INTO @DATA(ls_attach).

      IF sy-subrc = 0.
*        APPEND CORRESPONDING #( ls_cert MAPPING TO ENTITY ) TO result.
        APPEND VALUE #(
          %tky          = <key>-%tky
          CertUuid      = ls_attach-cert_uuid
          attachment        = ls_attach-attachment
          attachmentid   = ls_attach-attachment_id
*          client     = ls_attach-client
          createdat      = ls_attach-created_at
          createdby        = ls_attach-created_by
          fileName      = ls_attach-filename
          mimetype     = ls_attach-mimetype
        ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

*  METHOD cba_Attachment.
*  ENDMETHOD.

  METHOD validateCertNo.

*    "1. READ the Certificate Numbers entered by the user on the screen
*    READ ENTITIES OF ZI_VendorCert IN LOCAL MODE
*      ENTITY VendorCert
*        FIELDS ( CertNo ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_input_certs).
*
*    " 2. LOOP through each record the user is trying to create/save
*    LOOP AT lt_input_certs ASSIGNING FIELD-SYMBOL(<ls_input>).
*
*      " Skip evaluation if the input field was left completely empty
*      IF <ls_input>-CertNo IS INITIAL.
*        CONTINUE.
*      ENDIF.
*
*      " 3. CHECK the database table to see if this certificate number already exists
*      SELECT SINGLE @abap_true FROM zvendor_cert
*        WHERE cert_no = @<ls_input>-CertNo
*          AND cert_uuid <> @<ls_input>-CertUuid " Exclude the current record if it's an update edit
*        INTO @DATA(lv_exists).
*
*      IF sy-subrc = 0.
*
*        " 4. MARK FAILURE: Stop the transactional pipeline from saving the record
*        APPEND VALUE #(
*          %tky = <ls_input>-%tky
*        ) TO failed-vendorcert.
*
*        " 5. CUSTOM ERROR MESSAGE: Bind the message to the CertNo field on screen
*        APPEND VALUE #(
*          %tky          = <ls_input>-%tky
*          %element-CertNo = if_abap_behv=>mk-on " Flags the exact input field box in red
*          %msg          = new_message_with_text(
*                            severity = if_abap_behv_message=>severity-error
*                            text     = 'Certification number already exists!' )
*        ) TO reported-vendorcert.
*
*        " 6. Purge the memory buffers so the SAVER class can't write to DB
*        DELETE lcl_buffer=>mt_cert_create WHERE cert_uuid = <ls_input>-CertUuid.
*        DELETE lcl_buffer=>mt_cert_update WHERE cert_uuid = <ls_input>-CertUuid.
*
*      ENDIF.
*    ENDLOOP.

    " 1. READ the Certificate Numbers entered by the user on the screen
    READ ENTITIES OF ZI_VendorCert IN LOCAL MODE
      ENTITY VendorCert
        FIELDS ( CertNo ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_input_certs).

    " 2. LOOP through each record the user is trying to create/save
    LOOP AT lt_input_certs ASSIGNING FIELD-SYMBOL(<ls_input>).

      " -----------------------------------------------------------------
      " ADDED: Validation for Empty / Mandatory Field
      " -----------------------------------------------------------------
      IF <ls_input>-CertNo IS INITIAL.

        " Mark validation failure for this row context
        APPEND VALUE #(
          %tky = <ls_input>-%tky
        ) TO failed-vendorcert.

        " Bind the custom mandatory error message straight to the field
        APPEND VALUE #(
          %tky            = <ls_input>-%tky
          %element-CertNo = if_abap_behv=>mk-on " Flags the blank field in red
          %msg            = new_message_with_text(
                              severity = if_abap_behv_message=>severity-error
                              text     = 'Please enter the certificate number.' )
        ) TO reported-vendorcert.

        " Skip the database duplicate check entirely for this blank row
        CONTINUE.
      ENDIF.

      " 3. CHECK the database table to see if this certificate number already exists
      SELECT SINGLE @abap_true FROM zvendor_cert
        WHERE cert_no = @<ls_input>-CertNo
          AND cert_uuid <> @<ls_input>-CertUuid " Exclude the current record if it's an update edit
        INTO @DATA(lv_exists).

      IF sy-subrc = 0.

        " 4. MARK FAILURE: Stop the transactional pipeline from saving the record
        APPEND VALUE #(
          %tky = <ls_input>-%tky
        ) TO failed-vendorcert.

        " 5. CUSTOM ERROR MESSAGE: Bind the message to the CertNo field on screen
        APPEND VALUE #(
          %tky            = <ls_input>-%tky
          %element-CertNo = if_abap_behv=>mk-on " Flags the exact input field box in red
          %msg            = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                            text     = 'Certification number already exists!' )
        ) TO reported-vendorcert.

        " 6. Purge the memory buffers so the SAVER class can't write to DB
        DELETE lcl_buffer=>mt_cert_create WHERE cert_uuid = <ls_input>-CertUuid.
        DELETE lcl_buffer=>mt_cert_update WHERE cert_uuid = <ls_input>-CertUuid.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

    " 1. READ the status of the keys passed by the runtime framework
    READ ENTITIES OF ZI_VendorCert IN LOCAL MODE
      ENTITY VendorCert
        FIELDS ( CertUuid ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_certs).

    " 2. Build the dynamic field control properties array
    result = VALUE #( FOR ls_cert IN lt_certs (
        %tky = ls_cert-%tky

        " If it's a draft session (Create mode), leave open. Else (Edit mode), make read-only.
        %field-CertType = COND #( WHEN ls_cert-%is_draft = if_abap_behv=>mk-on
                                 THEN if_abap_behv=>fc-f-unrestricted
                                 ELSE if_abap_behv=>fc-f-read_only )

        %field-Vendor   = COND #( WHEN ls_cert-%is_draft = if_abap_behv=>mk-on
                                 THEN if_abap_behv=>fc-f-unrestricted
                                 ELSE if_abap_behv=>fc-f-read_only )

        %field-CertNo   = COND #( WHEN ls_cert-%is_draft = if_abap_behv=>mk-on
                                 THEN if_abap_behv=>fc-f-unrestricted
                                 ELSE if_abap_behv=>fc-f-read_only )
    ) ).

  ENDMETHOD.

  METHOD validateVendor.
    " 1. Read the input value from the UI layout context
    READ ENTITIES OF ZI_VendorCert IN LOCAL MODE
      ENTITY VendorCert
        FIELDS ( Vendor ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_certs).

    LOOP AT lt_certs ASSIGNING FIELD-SYMBOL(<ls_cert>).
      " 2. Trigger error if field is completely blank
      IF <ls_cert>-Vendor IS INITIAL.
        APPEND VALUE #( %tky = <ls_cert>-%tky ) TO failed-vendorcert.

        APPEND VALUE #(
          %tky          = <ls_cert>-%tky
          %element-Vendor = if_abap_behv=>mk-on
          %msg          = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                            text     = 'Please enter the vendor ID.' )
        ) TO reported-vendorcert.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateCertType.
    READ ENTITIES OF ZI_VendorCert IN LOCAL MODE
      ENTITY VendorCert
        FIELDS ( CertType ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_certs).

    LOOP AT lt_certs ASSIGNING FIELD-SYMBOL(<ls_cert>).
      IF <ls_cert>-CertType IS INITIAL.
        APPEND VALUE #( %tky = <ls_cert>-%tky ) TO failed-vendorcert.

        APPEND VALUE #(
          %tky          = <ls_cert>-%tky
          %element-CertType = if_abap_behv=>mk-on
          %msg          = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                            text     = 'Please select a certificate type.' )
        ) TO reported-vendorcert.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

*  METHOD validateCertNo.
*    READ ENTITIES OF ZI_VendorCert IN LOCAL MODE
*      ENTITY VendorCert
*        FIELDS ( CertNo ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_certs).
*
*    LOOP AT lt_certs ASSIGNING FIELD-SYMBOL(<ls_cert>).
*      IF <ls_cert>-CertNo IS INITIAL.
*        APPEND VALUE #( %tky = <ls_cert>-%tky ) TO failed-vendorcert.
*
*        APPEND VALUE #(
*          %tky          = <ls_cert>-%tky
*          %element-CertNo = if_abap_behv=>mk-on
*          %msg          = new_message_with_text(
*                            severity = if_abap_behv_message=>severity-error
*                            text     = 'Please enter the certificate number.' )
*        ) TO reported-vendorcert.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.


  METHOD cba_attachment.


    DATA : ls_item_temp LIKE LINE OF lcl_buffer=>mt_attach_create,
           ls_item_map  LIKE LINE OF mapped-attachment.

    READ ENTITIES OF ZI_VendorCert IN LOCAL MODE
    ENTITY VendorCert ALL FIELDS WITH CORRESPONDING #( entities_cba ) RESULT DATA(certificates).

    READ TABLE certificates INTO DATA(ls_cert) INDEX 1.

    LOOP AT entities_cba INTO DATA(ls_attach).
      IF lcl_buffer=>gv_certiid IS NOT INITIAL.
        DATA(lv_certiid) = lcl_buffer=>gv_certiid.
      ELSE.
        lv_certiid = ls_attach-CertUuid.
      ENDIF.

      SORT ls_attach-%target BY AttachmentId CertUuid.

      LOOP AT ls_attach-%target INTO DATA(ls_attach_target).
        MOVE-CORRESPONDING ls_attach_target TO ls_item_temp.
*lv_item = lv_item + 10.
        ls_item_temp-cert_uuid = lv_certiid.

        ls_item_temp-attachment_id = ls_attach_target-AttachmentId.
        ls_item_temp-attachment = ls_attach_target-Attachment.
        ls_item_temp-cert_uuid = ls_attach_target-CertUuid.
        ls_item_temp-created_at = ls_attach_target-CreatedAt.
        ls_item_temp-created_by = ls_attach_target-CreatedBy.
        ls_item_temp-filename = ls_attach_target-Filename.
        ls_item_temp-mimetype = ls_attach_target-mimetype.


        APPEND ls_item_temp TO lcl_buffer=>mt_attach_create.
        MOVE-CORRESPONDING ls_item_temp TO ls_item_map.
        APPEND ls_item_map TO mapped-attachment.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

****Commented on 03/09/26
*  METHOD validateCertType.
*  ENDMETHOD.

*  METHOD validateVendor.
*  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_VENDORCERT DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_VENDORCERT IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
*    " Cross-field validation: ValidFrom must be before ValidTo
*    SELECT cert_uuid, valid_from, valid_to
*    FROM zvendor_cert
*    FOR ALL ENTRIES IN @keys
*    WHERE cert_uuid = @keys-CertUuid
*    INTO TABLE @DATA(lt_certs).
*
*    LOOP AT lt_certs ASSIGNING FIELD-SYMBOL(<cert>).
*      IF <cert>-valid_from > <cert>-valid_to.
*        APPEND VALUE #(
*        %key-CertUuid = <cert>-cert_uuid
*        %msg = new_message_with_text(
*        severity = if_abap_behv_message=>severity-error
*        text = 'Valid From must be before Valid To' )
*        ) TO reported-vendorcert.
*        failed-vendorcert = VALUE #(
*        BASE failed-vendorcert
*        ( %key-CertUuid = <cert>-cert_uuid ) ).
*      ENDIF.
*    ENDLOOP.

*    " 1. Validate records waiting to be CREATED
*    LOOP AT lcl_buffer=>mt_cert_create ASSIGNING FIELD-SYMBOL(<ls_create>).
*      IF <ls_create>-valid_from > <ls_create>-valid_to.
*
*        APPEND VALUE #(
*          cert_uuid = <ls_create>-cert_uuid
*          %msg      = new_message_with_text(
*                       severity = if_abap_behv_message=>severity-error
*                       text     = 'Valid From must be before Valid To' )
*        ) TO reported-vendorcert.
*
*        APPEND VALUE #(
*          cert_uuid = <ls_create>-cert_uuid
*        ) TO failed-vendorcert.
*
*      ENDIF.
*    ENDLOOP.
*
*    " 2. Validate records waiting to be UPDATED
*    LOOP AT lcl_buffer=>mt_cert_update ASSIGNING FIELD-SYMBOL(<ls_update>).
*      IF <ls_update>-valid_from > <ls_update>-valid_to.
*
*        APPEND VALUE #(
*          cert_uuid = <ls_update>-cert_uuid
*          %msg      = new_message_with_text(
*                       severity = if_abap_behv_message=>severity-error
*                       text     = 'Valid From must be before Valid To' )
*        ) TO reported-vendorcert.
*
*        APPEND VALUE #(
*          cert_uuid = <ls_update>-cert_uuid
*        ) TO failed-vendorcert.
*
*      ENDIF.
*    ENDLOOP.
  ENDMETHOD.

  METHOD save.
    DATA :
         lt_attach       TYPE STANDARD TABLE OF zvend_attachment.
    DATA lv_validation_failed TYPE abap_boolean VALUE abap_false.
    " 1. PERMANENTLY PERSIST NEW CREATIONS
    IF lcl_buffer=>mt_cert_create IS NOT INITIAL.
      INSERT zvendor_cert FROM TABLE @lcl_buffer=>mt_cert_create.
      " Clear buffer immediately to free system memory
      CLEAR lcl_buffer=>mt_cert_create.
    ENDIF.

* SELECT * FROM zvendor_cert_d
*      WHERE hasactiveentity = @abap_false
*      INTO TABLE @DATA(lt_final_creations).
*
*    IF sy-subrc = 0.
*            " Reset flag for the current execution block
*      lv_validation_failed = abap_false.
*      " CRITICAL VALIDATION CHECK FOR UNMANAGED RAP:
*      " Loop through the staged draft rows and check if any mandatory field is initial.
*      " If a user bypasses the UI and a blank value leaks here, abort the database write!
*      LOOP AT lt_final_creations ASSIGNING FIELD-SYMBOL(<ls_draft_check>).
*        IF <ls_draft_check>-vendor           IS INITIAL OR
*           <ls_draft_check>-certtype        IS INITIAL OR
*           <ls_draft_check>-certno          IS INITIAL.
*
*           " Found a blank mandatory field! Clear the collection and skip database insertion.
*           lv_validation_failed = abap_true.
*           EXIT. " Exit the loop immediately since we found an invalid record
*        ENDIF.
*      ENDLOOP.
*
*      " 2. Only proceed with database insertion if the validation check passed
*      IF lt_final_creations IS NOT INITIAL.
*        DATA: lt_active_insert TYPE TABLE OF zvendor_cert,
*              ls_active_line   TYPE zvendor_cert.
*
*        LOOP AT lt_final_creations ASSIGNING FIELD-SYMBOL(<ls_draft>).
*          CLEAR ls_active_line.
*          ls_active_line-cert_uuid      = <ls_draft>-certuuid.
*          ls_active_line-vendor         = <ls_draft>-vendor.
*          ls_active_line-company_code   = <ls_draft>-companycode.
*          ls_active_line-purch_org      = <ls_draft>-purchorg.
*          ls_active_line-cert_type      = <ls_draft>-certtype.
*          ls_active_line-cert_no        = <ls_draft>-certno.
*          ls_active_line-cert_name      = <ls_draft>-certname.
*          ls_active_line-valid_from     = <ls_draft>-validfrom.
*          ls_active_line-valid_to       = <ls_draft>-validto.
*          ls_active_line-reg_country    = <ls_draft>-regcountry.
*          ls_active_line-exempt         = <ls_draft>-exempt.
*          ls_active_line-exempt_reason  = <ls_draft>-exemptreason.
*          ls_active_line-supplier_email = <ls_draft>-supplieremail.
*          ls_active_line-int_owner_email = <ls_draft>-intowneremail.
*          ls_active_line-status         = <ls_draft>-status.
*          " Fill admin fields...
*          ls_active_line-created_by     = <ls_draft>-createdby.
*          ls_active_line-created_at     = <ls_draft>-createdat.
*
*          APPEND ls_active_line TO lt_active_insert.
*        ENDLOOP.
*
*        INSERT zvendor_cert FROM TABLE @lt_active_insert.
*
*        IF sy-subrc = 0.
*          " Send success message toast back to the UI
*          LOOP AT lt_active_insert ASSIGNING FIELD-SYMBOL(<ls_created>).
*            APPEND VALUE #(
*              certuuid = <ls_created>-cert_uuid
*              %msg      = new_message_with_text(
*                           severity = if_abap_behv_message=>severity-success
*                           text     = 'Record successfully created' )
*            ) TO reported-vendorcert.
*          ENDLOOP.
*        ENDIF.
*      ENDIF.
*    ENDIF.
**********************************************************************
*      IF sy-subrc = 0.
*        " 2. LOOP through the successfully created records to send custom messages
*        LOOP AT lcl_buffer=>mt_cert_create ASSIGNING FIELD-SYMBOL(<ls_created>).
*
*          APPEND VALUE #(
*            " Bind the message directly to the newly created record key
*            certuuid = <ls_created>-cert_uuid
*
*            " FIX: Using the universally available severity interface path
*            %msg      = new_message_with_text(
*                         severity = if_abap_behv_message=>severity-success
*                         text     = 'Record successfully created' )
*
*          ) TO reported-vendorcert. " mt_cert_create.
*
*      ENDLOOP.
*    ENDIF.

************************************************************************

    IF lcl_buffer=>mt_attach_create IS NOT INITIAL.
      LOOP AT lcl_buffer=>mt_attach_create INTO DATA(ls_attach).
        APPEND ls_attach TO lt_attach.
      ENDLOOP.
      IF lt_attach IS NOT INITIAL.
        INSERT zvend_attachment FROM TABLE @lt_attach .
      ENDIF.



*      INSERT zvend_attachment FROM TABLE @lcl_buffer=>mt_attach_create.
    ENDIF.


    " 2. PERMANENTLY PERSIST CHANGES (EDITS)
    IF lcl_buffer=>mt_cert_update IS NOT INITIAL.
      UPDATE zvendor_cert FROM TABLE @lcl_buffer=>mt_cert_update.
      CLEAR lcl_buffer=>mt_cert_update.
    ENDIF.

    " 3. PERMANENTLY PERSIST DELETIONS
    IF lcl_buffer=>mt_cert_delete IS NOT INITIAL.

*        LOOP AT lcl_buffer=>mt_cert_delete ASSIGNING FIELD-SYMBOL(<ls_del>).
*          DELETE zvendor_cert WHERE cert_uuid IN @lcl_buffer=>mt_cert_delete.
*        ENDLOOP.
      DELETE zvendor_cert FROM TABLE @lcl_buffer=>mt_cert_delete.
      CLEAR lcl_buffer=>mt_cert_delete.
    ENDIF.
  ENDMETHOD.


  METHOD cleanup.
    " Clear out global memory buffers if the transaction gets canceled
    CLEAR: lcl_buffer=>mt_cert_create,
           lcl_buffer=>mt_cert_update,
           lcl_buffer=>mt_cert_delete.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.




*----------------------------------------------------------------------*
* LOCAL HANDLER CLASS DEFINITION
* Inherits from CL_ABAP_BEHAVIOR_HANDLER
* Handles: RAP Interaction Phase (Read + Modify operations)
* Located in: Local Types tab (CCIMP include)
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* LOCAL HANDLER CLASS - replaces managed framework persistence
*----------------------------------------------------------------------*
*
*CLASS lhc_vendorcert DEFINITION INHERITING FROM cl_abap_behavior_handler.
*  PRIVATE SECTION.
*    METHODS:
*      "--- Root Entity: VendorCert ---
*      create FOR MODIFY
*        IMPORTING entities FOR CREATE VendorCert,
*
*      update FOR MODIFY
*        IMPORTING entities FOR UPDATE VendorCert,
*
*      delete FOR MODIFY
*        IMPORTING keys FOR DELETE VendorCert,
*
*      read FOR READ
*        IMPORTING keys   FOR READ VendorCert
*        RESULT    result,
*
*      lock FOR LOCK
*        IMPORTING keys FOR LOCK VendorCert,
*
** get_authorizations FOR INSTANCE AUTHORIZATION
** IMPORTING keys REQUEST requested_authorizations FOR VendorCert
** RESULT result.
*
*      get_authorizations FOR GLOBAL AUTHORIZATION
*        IMPORTING REQUEST requested_authorizations FOR VendorCert
*        RESULT result.
*
** sendemail FOR MODIFY
** IMPORTING keys FOR ACTION VendorCert~sendEmail
** RESULT result.
**
** "--- Child Entity: EmailLog ---
** create_emaillog FOR MODIFY
** IMPORTING entities FOR CREATE EmailLog,
**
** update_emaillog FOR MODIFY
** IMPORTING entities FOR UPDATE EmailLog,
**
** delete_emaillog FOR MODIFY
** IMPORTING keys FOR DELETE EmailLog,
**
** read_emaillog FOR READ
** IMPORTING keys FOR READ EmailLog
** RESULT result.
*
*
*ENDCLASS.
*
*CLASS lhc_vendorcert IMPLEMENTATION.
*
**----------------------------------------------------------------------*
** CREATE - explicit INSERT into zvendor_cert
**----------------------------------------------------------------------*
*  METHOD create.
*    DATA lt_cert_db TYPE TABLE OF zvendor_cert.
*
*    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
*
*      IF <entity>-ValidFrom IS NOT INITIAL
*      AND <entity>-ValidTo IS NOT INITIAL
*      AND <entity>-ValidFrom > <entity>-ValidTo.
*
*        APPEND VALUE #(
*        %cid = <entity>-%cid
*        %msg = new_message_with_text(
*        severity = if_abap_behv_message=>severity-error
*        text = 'Valid From must be before Valid To' )
*        ) TO reported-vendorcert.
*
*        CONTINUE.
*
*      ENDIF.
*      DATA(ls_cert) = CORRESPONDING zvendor_cert( <entity> MAPPING FROM ENTITY ).
*
*      " Generate UUID (unmanaged: developer is responsible)
*      ls_cert-cert_uuid = cl_system_uuid=>create_uuid_x16_static( ).
*      ls_cert-client = sy-mandt.
*
*      " Derive Status from ValidTo date
*      IF ls_cert-valid_to < sy-datum.
*        ls_cert-status = 'Expired'.
*      ELSE.
*        ls_cert-status = 'Valid'.
*      ENDIF.
*
*      " Set administrative fields manually
** ls_cert-created_by = sy-uname.
** ls_cert-created_at = utclong_current( ).
** ls_cert-last_changed_by = sy-uname.
** ls_cert-last_changed_at = utclong_current( ).
** ls_cert-local_last_changed_at = utclong_current( ).
*
*      APPEND ls_cert TO lt_cert_db.
*
*      " Map back the generated key to %cid
*      APPEND VALUE #(
*      %cid = <entity>-%cid
*      %key-CertUuid = ls_cert-cert_uuid
*      ) TO mapped-vendorcert.
*    ENDLOOP.
*
*    " Explicit INSERT - replaces managed framework persistence
*    INSERT zvendor_cert FROM TABLE @lt_cert_db.
*    IF sy-subrc <> 0.
*      LOOP AT entities ASSIGNING <entity>.
*        APPEND VALUE #(
*        %cid = <entity>-%cid
*        %msg = new_message_with_text(
*        severity = if_abap_behv_message=>severity-error
*        text = 'Error creating Vendor Certificate' )
*        ) TO reported-vendorcert.
*      ENDLOOP.
*    ENDIF.
*  ENDMETHOD.
*
**----------------------------------------------------------------------*
** UPDATE - explicit UPDATE on zvendor_cert
**----------------------------------------------------------------------*
*  METHOD update.
*    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
*
*      " Read existing record first
*      SELECT SINGLE * FROM zvendor_cert
*      WHERE cert_uuid = @<entity>-CertUuid
*      INTO @DATA(ls_cert).
*
*      IF sy-subrc <> 0.
*        APPEND VALUE #(
*        %key = <entity>-%key
*        %msg = new_message_with_text(
*        severity = if_abap_behv_message=>severity-error
*        text = 'Vendor Certificate not found' )
*        ) TO reported-vendorcert.
*        CONTINUE.
*      ENDIF.
*
*      " Apply only changed fields using %control
*      IF <entity>-%control-Vendor = if_abap_behv=>mk-on.
*        ls_cert-vendor = <entity>-Vendor.
*      ENDIF.
*      IF <entity>-%control-CompanyCode = if_abap_behv=>mk-on.
*        ls_cert-company_code = <entity>-CompanyCode.
*      ENDIF.
*      IF <entity>-%control-PurchOrg = if_abap_behv=>mk-on.
*        ls_cert-purch_org = <entity>-PurchOrg.
*      ENDIF.
*      IF <entity>-%control-CertName = if_abap_behv=>mk-on.
*        ls_cert-cert_name = <entity>-CertName.
*      ENDIF.
*      IF <entity>-%control-ValidFrom = if_abap_behv=>mk-on.
*        ls_cert-valid_from = <entity>-ValidFrom.
*      ENDIF.
*      IF <entity>-%control-ValidTo = if_abap_behv=>mk-on.
*        ls_cert-valid_to = <entity>-ValidTo.
*        " Recalculate status on ValidTo change
*        IF ls_cert-valid_to < sy-datum.
*          ls_cert-status = 'Expired'.
*        ELSE.
*          ls_cert-status = 'Valid'.
*        ENDIF.
*      ENDIF.
*      IF <entity>-%control-RegCountry = if_abap_behv=>mk-on.
*        ls_cert-reg_country = <entity>-RegCountry.
*      ENDIF.
*      IF <entity>-%control-Exempt = if_abap_behv=>mk-on.
*        ls_cert-exempt = <entity>-Exempt.
*      ENDIF.
*      IF <entity>-%control-ExemptReason = if_abap_behv=>mk-on.
*        ls_cert-exempt_reason = <entity>-ExemptReason.
*      ENDIF.
** IF <entity>-%control-InternalOwnerEmail = if_abap_behv=>mk-on.
** ls_cert-internal_owner_email = <entity>-InternalOwnerEmail.
** ENDIF.
*      IF <entity>-%control-SupplierEmail = if_abap_behv=>mk-on.
*        ls_cert-supplier_email = <entity>-SupplierEmail.
*      ENDIF.
*      IF <entity>-%control-Alert1 = if_abap_behv=>mk-on.
*        ls_cert-alert1 = <entity>-Alert1.
*      ENDIF.
*      IF <entity>-%control-Alert2 = if_abap_behv=>mk-on.
*        ls_cert-alert2 = <entity>-Alert2.
*      ENDIF.
*      IF <entity>-%control-Alert3 = if_abap_behv=>mk-on.
*        ls_cert-alert3 = <entity>-Alert3.
*      ENDIF.
*      IF <entity>-%control-ToleranceDays = if_abap_behv=>mk-on.
*        ls_cert-tolerance_days = <entity>-ToleranceDays.
*      ENDIF.
*
*      " Update admin fields
*      ls_cert-last_changed_by = sy-uname.
** ls_cert-last_changed_at = utclong_current( ).
** ls_cert-local_last_changed_at = utclong_current( ).
*
*      " Explicit UPDATE - replaces managed framework persistence
*      UPDATE zvendor_cert FROM @ls_cert.
*      IF sy-subrc <> 0.
*        APPEND VALUE #(
*        %key = <entity>-%key
*        %msg = new_message_with_text(
*        severity = if_abap_behv_message=>severity-error
*        text = 'Error updating Vendor Certificate' )
*        ) TO reported-vendorcert.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*
**----------------------------------------------------------------------*
** DELETE - explicit DELETE from zvendor_cert + cascade children
**----------------------------------------------------------------------*
*  METHOD delete.
*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
*
*      " Explicit DELETE - replaces managed framework persistence
*      DELETE FROM zvendor_cert WHERE cert_uuid = @<key>-CertUuid.
*      IF sy-subrc <> 0.
*        APPEND VALUE #(
*        %key = <key>-%key
*        %msg = new_message_with_text(
*        severity = if_abap_behv_message=>severity-error
*        text = 'Error deleting Vendor Certificate' )
*        ) TO reported-vendorcert.
*      ELSE.
*        " Cascade delete child records (unmanaged: developer responsibility)
*        DELETE FROM zvc_email_log WHERE cert_uuid = @<key>-CertUuid.
** DELETE FROM zvendor_cert_attach WHERE cert_uuid = @<key>-CertUuid.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*
**----------------------------------------------------------------------*
** READ - explicit SELECT from zvendor_cert
**----------------------------------------------------------------------*
*  METHOD read.
*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
*      SELECT SINGLE * FROM zvendor_cert
*      WHERE cert_uuid = @<key>-CertUuid
*      INTO @DATA(ls_cert).
*
*      IF sy-subrc = 0.
*        APPEND CORRESPONDING #( ls_cert MAPPING TO ENTITY ) TO result.
*      ELSE.
*        APPEND VALUE #(
*        %key = <key>-%key
*        %msg = new_message_with_text(
*        severity = if_abap_behv_message=>severity-error
*        text = 'Vendor Certificate not found' )
*        ) TO reported-vendorcert.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*
**----------------------------------------------------------------------*
** LOCK - optimistic locking via ETag (LocalLastChangedAt)
**----------------------------------------------------------------------*
*  METHOD lock.
*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
*      SELECT SINGLE local_last_changed_at
*      FROM zvendor_cert
*      WHERE cert_uuid = @<key>-CertUuid
*      INTO @DATA(lv_ts).
*      IF sy-subrc <> 0.
*        APPEND VALUE #(
** %key = <key>-%key
*        CertUuid = keys[ 1 ]-CertUuid
*        %msg = new_message_with_text(
*        severity = if_abap_behv_message=>severity-error
*        text = 'Record not found for locking' )
*        ) TO reported-vendorcert.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*
*
**ENDCLASS.
*
***----------------------------------------------------------------------*
*** AUTHORIZATIONS - grant all (extend with PFCG checks as needed)
***----------------------------------------------------------------------*
*  METHOD get_authorizations.
*** LOOP AT key ASSIGNING FIELD-SYMBOL(<key>).
*** APPEND VALUE #(
*** %key = <key>-%key
*** %create = if_abap_behv=>auth-allowed
*** %update = if_abap_behv=>auth-allowed
*** %delete = if_abap_behv=>auth-allowed
*** %action-sendEmail = if_abap_behv=>auth-allowed
*** ) TO result.
*** ENDLOOP.
*
*    result-%create = if_abap_behv=>auth-allowed.
*    result-%update = if_abap_behv=>auth-allowed.
*    result-%delete = if_abap_behv=>auth-allowed.
** result-%action-sendEmail = if_abap_behv=>auth-allowed.
*
*
*
** result-%create = if_abap_behv=>auth-allowed.
** result-%update = if_abap_behv=>auth-allowed.
** result-%delete = if_abap_behv=>auth-allowed.
** result-%action-sendEmail = if_abap_behv=>auth-allowed.
*
*  ENDMETHOD.
*
****----------------------------------------------------------------------*
**** SEND EMAIL ACTION - send email + log to zvc_email_log
****----------------------------------------------------------------------*
*** METHOD sendemail.
*** LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
*** SELECT SINGLE * FROM zvendor_cert
*** WHERE cert_uuid = @<key>-CertUuid
*** INTO @DATA(ls_cert).
***
*** IF sy-subrc = 0.
*** TRY.
*** DATA(lo_send_request) = cl_bcs=>create_instance( ).
***
*** DATA(lv_subject) = |Certificate { ls_cert-cert_name } Expiry Notification|.
*** DATA(lv_body) = |Dear Supplier, your certificate { ls_cert-cert_name }| &
*** | expires on { ls_cert-valid_to }. Please renew it.|.
***
*** DATA(lo_document) = cl_document_bcs=>create_document(
*** i_type = 'RAW'
*** i_text = VALUE #( ( line = lv_body ) )
*** i_subject = lv_subject ).
***
*** lo_send_request->set_document( lo_document ).
***
*** DATA(lo_recipient) = cl_cam_address_bcs=>create_internet_address(
*** i_address_string = ls_cert-supplier_email ).
*** lo_send_request->add_recipient( lo_recipient ).
*** lo_send_request->send( ).
*** COMMIT WORK.
***
*** " Log the sent email into zvc_email_log
*** DATA(ls_email_log) = VALUE zvc_email_log(
*** client = sy-mandt
*** email_uuid = cl_system_uuid=>create_uuid_x16_static( )
*** cert_uuid = ls_cert-cert_uuid
*** vendor = ls_cert-vendor
*** cert_type = ls_cert-cert_type
*** cert_no = ls_cert-cert_no
*** last_sent = utclong_current( )
*** email_status = 'Sent'
*** recipient_email = ls_cert-supplier_email ).
***
*** INSERT zvc_email_log FROM @ls_email_log.
***
*** CATCH cx_bcs INTO DATA(lx_bcs).
*** APPEND VALUE #(
*** %key = <key>-%key
*** %msg = new_message_with_text(
*** severity = if_abap_behv_message=>severity-error
*** text = lx_bcs->get_text( ) )
*** ) TO reported-vendorcert.
*** ENDTRY.
***
*** APPEND CORRESPONDING #( ls_cert MAPPING TO ENTITY ) TO result.
*** ENDIF.
*** ENDLOOP.
*** ENDMETHOD.
**
***----------------------------------------------------------------------*
*** EMAIL LOG CHILD - CREATE
***----------------------------------------------------------------------*
** METHOD create_emaillog.
** DATA lt_email_db TYPE TABLE OF zvc_email_log.
**
** LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
** DATA(ls_email) = CORRESPONDING zvc_email_log( <entity> MAPPING FROM ENTITY ).
** ls_email-email_uuid = cl_system_uuid=>create_uuid_x16_static( ).
** ls_email-client = sy-mandt.
** APPEND ls_email TO lt_email_db.
**
** APPEND VALUE #(
** %cid = <entity>-%cid
** %key-EmailUuid = ls_email-email_uuid
** ) TO mapped-emaillog.
** ENDLOOP.
**
** INSERT zvc_email_log FROM TABLE @lt_email_db.
** IF sy-subrc <> 0.
** LOOP AT entities ASSIGNING <entity>.
** APPEND VALUE #(
** %cid = <entity>-%cid
** %msg = new_message_with_text(
** severity = if_abap_behv_message=>severity-error
** text = 'Error creating Email Log' )
** ) TO reported-emaillog.
** ENDLOOP.
** ENDIF.
** ENDMETHOD.
**
***----------------------------------------------------------------------*
*** EMAIL LOG CHILD - UPDATE
***----------------------------------------------------------------------*
** METHOD update_emaillog.
** LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
** SELECT SINGLE * FROM zvc_email_log
** WHERE email_uuid = @<entity>-EmailUuid
** INTO @DATA(ls_email).
**
** IF sy-subrc = 0.
** IF <entity>-%control-EmailStatus = if_abap_behv=>mk-on.
** ls_email-email_status = <entity>-EmailStatus.
** ENDIF.
** IF <entity>-%control-RecipientEmail = if_abap_behv=>mk-on.
** ls_email-recipient_email = <entity>-RecipientEmail.
** ENDIF.
** UPDATE zvc_email_log FROM @ls_email.
** ENDIF.
** ENDLOOP.
** ENDMETHOD.
**
***----------------------------------------------------------------------*
*** EMAIL LOG CHILD - DELETE
***----------------------------------------------------------------------*
** METHOD delete_emaillog.
** LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
** DELETE FROM zvc_email_log WHERE email_uuid = @<key>-EmailUuid.
** IF sy-subrc <> 0.
** APPEND VALUE #(
** %key = <key>-%key
** %msg = new_message_with_text(
** severity = if_abap_behv_message=>severity-error
** text = 'Error deleting Email Log' )
** ) TO reported-emaillog.
** ENDIF.
** ENDLOOP.
** ENDMETHOD.
**
***----------------------------------------------------------------------*
*** EMAIL LOG CHILD - READ
***----------------------------------------------------------------------*
** METHOD read_emaillog.
** LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
** SELECT SINGLE * FROM zvc_email_log
** WHERE email_uuid = @<key>-EmailUuid
** INTO @DATA(ls_email).
** IF sy-subrc = 0.
** APPEND CORRESPONDING #( ls_email MAPPING TO ENTITY ) TO result.
** ENDIF.
** ENDLOOP.
** ENDMETHOD.
**
**------
**------
***----------------------------------------------------------------------*
*** SAVER CLASS - with additional save (cross-entity validations)
***----------------------------------------------------------------------*
**CLASS lsc_vendorcert DEFINITION INHERITING FROM cl_abap_behavior_saver.
** PROTECTED SECTION.
** METHODS finalize REDEFINITION.
** METHODS check_before_save REDEFINITION.
** METHODS save REDEFINITION.
** METHODS cleanup REDEFINITION.
**ENDCLASS.
*
*CLASS lsc_vendorcert IMPLEMENTATION.
*
*  METHOD finalize.
*    " Final pre-save validations
*  ENDMETHOD.
*
*  METHOD check_before_save.
*    " Cross-field validation: ValidFrom must be before ValidTo
*    SELECT cert_uuid, valid_from, valid_to
*    FROM zvendor_cert
*    FOR ALL ENTRIES IN @keys
*    WHERE cert_uuid = @keys-CertUuid
*    INTO TABLE @DATA(lt_certs).
*
*    LOOP AT lt_certs ASSIGNING FIELD-SYMBOL(<cert>).
*      IF <cert>-valid_from > <cert>-valid_to.
*        APPEND VALUE #(
*        %key-CertUuid = <cert>-cert_uuid
*        %msg = new_message_with_text(
*        severity = if_abap_behv_message=>severity-error
*        text = 'Valid From must be before Valid To' )
*        ) TO reported-vendorcert.
*        failed-vendorcert = VALUE #(
*        BASE failed-vendorcert
*        ( %key-CertUuid = <cert>-cert_uuid ) ).
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*
*  METHOD save.
*
*  ENDMETHOD.
*
*  METHOD cleanup.
*
*  ENDMETHOD.
*
*ENDCLASS.

