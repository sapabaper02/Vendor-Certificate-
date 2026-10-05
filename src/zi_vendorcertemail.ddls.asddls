@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Certificate Email Logs - Interface View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZI_VendorCertEmail
  as select from zvc_email_log
//  association to parent ZI_VendorCert as _VendorCert on $projection.CertUuid = _VendorCert.CertUuid
{
  key email_uuid as EmailUuid,
      cert_uuid  as CertUuid,
      vendor     as Vendor,
      cert_type  as CertType,
      cert_no    as CertNo,
      last_sent  as LastSent
//      _VendorCert
}
