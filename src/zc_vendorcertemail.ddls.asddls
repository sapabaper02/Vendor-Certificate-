@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Certificate Email Logs - Pro View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_VendorCertEmail
  as projection on ZI_VendorCertEmail
{
  key EmailUuid,
      CertUuid,
      Vendor,
      CertType,
      CertNo,
      LastSent

//      _VendorCert : redirected to parent ZC_VendorCert
}
