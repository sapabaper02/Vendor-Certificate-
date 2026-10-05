@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View - Attachment'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_VendorAttachment
  as select from zvend_attachment
  
  association to parent ZI_VendorCert as _VendorCert 
  on $projection.CertUuid = _VendorCert.CertUuid
{


  key attachment_id as AttachmentId,
      cert_uuid     as CertUuid,
      
      @Semantics.largeObject : { 
      mimeType: 'mimetype',
      fileName: 'filename',
      contentDispositionPreference: #INLINE }
      
      attachment    as Attachment,
      
      filename      as Filename,
      
      @Semantics.mimeType: true
      mimetype      as Mimetype,
      
      @Semantics.user.createdBy: true
      created_by    as CreatedBy,
      
      @Semantics.systemDateTime.createdAt: true
      created_at    as CreatedAt,
      
      _VendorCert
}
