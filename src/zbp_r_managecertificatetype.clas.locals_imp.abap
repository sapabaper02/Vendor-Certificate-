CLASS LHC_ZR_MANAGECERTIFICATETYPE DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ManageCertificateType
        RESULT result,
      val_certyp FOR VALIDATE ON SAVE
            IMPORTING keys FOR ManageCertificateType~val_certyp.
            METHODS:
      validate_alert_fields FOR VALIDATE ON SAVE
            IMPORTING entities FOR ManageCertificateType~validate_alert_fields.
*      precheck_create FOR PRECHECK
*            IMPORTING entities FOR CREATE ManageCertificateType.

ENDCLASS.

CLASS LHC_ZR_MANAGECERTIFICATETYPE IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.


  METHOD val_certyp.


    DATA lv_certtype TYPE zmngcrtfcatetype-certificate_type.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).

      SELECT SINGLE certificate_type
        FROM zmngcrtfcatetype
        WHERE certificate_type = @<fs_key>-CertificateType
        INTO @lv_certtype.

      IF sy-subrc = 0.

        APPEND VALUE #(
          %tky = <fs_key>-%tky
        ) TO failed-managecertificatetype. "zr_managecertificatetype.

        APPEND VALUE #(
          %tky = <fs_key>-%tky
*          %msg = new_message(
*                    id       = 'ZMSG'
*                    number   = '001'
*                    severity = if_abap_behv_message=>severity-error
*        )
    %msg = new_message_with_text(
             severity = if_abap_behv_message=>severity-error
             text     = 'Certification type is already exit'
           )

        ) TO reported-managecertificatetype. "zr_managecertificatetype.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validate_alert_fields.

    READ ENTITIES OF zr_managecertificatetype IN LOCAL MODE
        ENTITY ManageCertificateType
          FIELDS ( Alert1 Alert2 Alert3 )
          WITH CORRESPONDING #( entities )
        RESULT DATA(lt_certificates).



    LOOP AT lt_certificates ASSIGNING FIELD-SYMBOL(<fs_certificate>).

      " Check if any alert field is zero
      IF <fs_certificate>-Alert1 = 0.
*         OR <fs_certificate>-Alert2 = 0
*         OR <fs_certificate>-Alert3 = 0.

        " 3. Mark the specific record as failed
        APPEND VALUE #(
          %tky = <fs_certificate>-%tky
        ) TO failed-managecertificatetype.

        " 4. Report the error message and link it to the UI fields
        APPEND VALUE #(
          %tky        = <fs_certificate>-%tky
          %state_area = 'VALIDATE_ALERTS'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = 'Alert1, should not be zero'
                        )
          " This highlights the specific fields in red on the Fiori UI
          %element-alert1 = if_abap_behv=>mk-on
*          %element-alert2 = if_abap_behv=>mk-on
*          %element-alert3 = if_abap_behv=>mk-on
        ) TO reported-managecertificatetype.

      ENDIF.

      IF <fs_certificate>-Alert2 = 0.

        " 3. Mark the specific record as failed
        APPEND VALUE #(
          %tky = <fs_certificate>-%tky
        ) TO failed-managecertificatetype.

        " 4. Report the error message and link it to the UI fields
        APPEND VALUE #(
          %tky        = <fs_certificate>-%tky
          %state_area = 'VALIDATE_ALERTS'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = 'Alert2, should not be zero'
                        )
          " This highlights the specific fields in red on the Fiori UI

          %element-alert2 = if_abap_behv=>mk-on
        ) TO reported-managecertificatetype.

      ENDIF.

      IF <fs_certificate>-Alert3 = 0.

        " 3. Mark the specific record as failed
        APPEND VALUE #(
          %tky = <fs_certificate>-%tky
        ) TO failed-managecertificatetype.

        " 4. Report the error message and link it to the UI fields
        APPEND VALUE #(
          %tky        = <fs_certificate>-%tky
          %state_area = 'VALIDATE_ALERTS'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = 'Alert3 should not be zero'
                        )
          " This highlights the specific fields in red on the Fiori UI

          %element-alert3 = if_abap_behv=>mk-on
         ) TO reported-managecertificatetype.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.
*  METHOD precheck_create.
*  ENDMETHOD.

ENDCLASS.
