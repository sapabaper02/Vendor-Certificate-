@EndUserText.label: 'Vendor Certificates - Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
//@UI.createDirectly: false
define root view entity ZC_VendorCert
  provider contract transactional_query
  as projection on ZI_VendorCert
{
  key CertUuid,
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'I_BusinessPartner', element: 'BusinessPartner' }
      }]
      Vendor,

      @Consumption.valueHelpDefinition: [{
         entity: {
           name: 'ZI_CertTypeVH', element: 'CertificateType'
         }
//             additionalBinding: [
//      { 
//        localElement: 'ToleranceDays',       
//        element: 'ToleranceDays'            
//      } 
//    ]
       }]
      CertType,

      CertNo,
      CertName,

      @Consumption.valueHelpDefinition: [{
        entity: { name: 'I_CompanyCode', element: 'CompanyCode' }
      }]
      CompanyCode,

      @Consumption.valueHelpDefinition: [{
        entity: { name: 'I_Country', element: 'Country' }
      }]
      RegCountry,

      PurchOrg,
      ValidFrom,
      ValidTo,
      Exempt,
      ExemptReason,
      IntOwnerEmail,
      SupplierEmail,
      Alert1,
      Alert2,
      Alert3,
      ToleranceDays,
      //      CertStatus,
      Status,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      @Semantics.systemDateTime.createdAt: true
      CreatedAt,
      @Semantics.user.createdBy: true
      CreatedBy,
      @Semantics.user.lastChangedBy: true
      LastChangedBy,
//      _Attachment.Attachment as attachment,
      
      _Attachment : redirected to composition child ZC_VENDORATTACHMENT,
      _EmailLogs

      //      _EmailLogs : redirected to composition child ZC_VendorCertEmail

}
