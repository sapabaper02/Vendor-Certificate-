@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Certificates - Interface View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZI_VendorCert
  as select from zvendor_cert as _VendorCert
  composition [0..*] of ZI_VendorAttachment as _Attachment
  association [0..*] to ZI_VendorCertEmail  as _EmailLogs on $projection.CertUuid = _EmailLogs.CertUuid



{
  key cert_uuid             as CertUuid,
      vendor                as Vendor,
      cert_type             as CertType,
      cert_no               as CertNo,
      cert_name             as CertName,
      company_code          as CompanyCode,
      reg_country           as RegCountry,
      purch_org             as PurchOrg,
      valid_from            as ValidFrom,
      valid_to              as ValidTo,
      exempt                as Exempt,
      exempt_reason         as ExemptReason,
      int_owner_email       as IntOwnerEmail,
      supplier_email        as SupplierEmail,
      alert1                as Alert1,
      alert2                as Alert2,
      alert3                as Alert3,
      tolerance_days        as ToleranceDays,
      status                as Status,
      -- Computed Status Field
      //      case
      //        when valid_to < $session.system_date then 'EXPIRED'
      //        when valid_to >= $session.system_date
      //         and valid_to <= $session.system_date + tolerance_days
      //                                             then 'EXPIRING_SOON'
      //        else 'VALID'
      //      end                 as CertStatus,
      case
        when valid_to < $session.system_date
          then 'EXPIRED'

        when valid_to >= $session.system_date
         and valid_to <= dats_add_days(
              $session.system_date,
              tolerance_days,
              'INITIAL'
            )
          then 'EXPIRING_SOON'

        else 'VALID'
      end                   as CertStatus,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      _Attachment,
      _EmailLogs

}
