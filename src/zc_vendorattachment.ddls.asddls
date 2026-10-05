@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View - Attachment'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_VENDORATTACHMENT
  //  provider contract transactional_query
  as projection on ZI_VendorAttachment
{
  key AttachmentId,
      CertUuid,
      @Semantics.largeObject:
      { mimeType: 'Mimetype',
      fileName: 'Filename',
      contentDispositionPreference: #ATTACHMENT }
      Attachment,
      @UI.hidden: true
      @Semantics.largeObject.fileName: 'FileName'
      Filename,
      @Semantics.mimeType: true
      @UI.hidden: true
      Mimetype,

      @Semantics.user.createdBy: true
      CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      CreatedAt,
      /* Associations */
      _VendorCert : redirected to parent ZC_VendorCert
}
