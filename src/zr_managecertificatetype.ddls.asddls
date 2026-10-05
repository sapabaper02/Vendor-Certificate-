@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZManageCertificateType'
@EndUserText.label: '###GENERATED Core Data Service Entity'
@ObjectModel.semanticKey: [ 'CertificateType' ]
@Search.searchable: true
define root view entity ZR_MANAGECERTIFICATETYPE
  as select from zmngcrtfcatetype as ManageCertificateType
{
  key uuid as UUID,
  @Search.defaultSearchElement: true
  key certificate_type as CertificateType,
  @Search.defaultSearchElement: true
  cert_type_des as CertTypeDes,
  tolerance as Tolerance,
  alert1 as Alert1,
  alert2 as Alert2,
  alert3 as Alert3,
  note as Note,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
}
