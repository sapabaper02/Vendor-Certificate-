@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Certificate Type Value Help'
@Metadata.ignorePropagatedAnnotations: true

// This annotation enforces a clean search/dialog window or drop list behavior on the UI
@Search.searchable: true

define view entity ZI_CertTypeVH
  as select from zmngcrtfcatetype
{
      @UI.hidden: true
  key uuid                  as TypeUuid,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element: [ 'CertificateDescription' ] 
      @EndUserText.label: 'Certificate Type'
      @UI.lineItem: [ { position: 10 } ]
  key certificate_type      as CertificateType,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @EndUserText.label: 'Description'
      @UI.lineItem: [ { position: 20 } ]
      cert_type_des         as CertificateDescription,
      
      @UI.lineItem: [ { position: 30 } ]
      @EndUserText.label: 'Tolerance Days'
      tolerance             as ToleranceDays
}
