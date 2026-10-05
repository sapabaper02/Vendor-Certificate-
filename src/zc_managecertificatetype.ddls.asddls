@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'Manage Certificate Types'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZManageCertificateType', 
  semanticKey: [ 'CertificateType' ]
}
@AccessControl.authorizationCheck: #MANDATORY
@Search.searchable: true
@UI.headerInfo: {
  typeName: 'Certificate Type',
  typeNamePlural: 'Certificate Types',
  title: { value: 'CertificateType' },
  description: { value: 'CertTypeDes' }
}
define root view entity ZC_MANAGECERTIFICATETYPE
  provider contract transactional_query
  as projection on ZR_MANAGECERTIFICATETYPE
  association [1..1] to ZR_MANAGECERTIFICATETYPE as _BaseEntity on $projection.UUID = _BaseEntity.UUID
{
  key UUID,
  @UI.lineItem: [{ position: 10 }]  
  @UI.selectionField: [{ position: 10 }]
  @Search.defaultSearchElement: true
  key CertificateType,
  @UI.selectionField: [{ position: 20 }]
  @Search.defaultSearchElement: true
  CertTypeDes,
  Tolerance,
  Alert1,
  Alert2,
  Alert3,
  Note,
  @Semantics: {
    user.createdBy: true
  }
  LocalCreatedBy,
  @Semantics: {
    systemDateTime.createdAt: true
  }
  LocalCreatedAt,
  @Semantics: {
    user.localInstanceLastChangedBy: true
  }
  LocalLastChangedBy,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  LocalLastChangedAt,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  LastChangedAt,
  _BaseEntity
}
