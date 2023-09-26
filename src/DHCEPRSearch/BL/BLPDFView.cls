Class DHCEPRSearch.BL.BLPDFView Extends %RegisteredObject [ ProcedureBlock ]
{

/// Debug: w ##class(DHCEPRFS.BL.BLPDFView).GetPDFPathByEpisodeID("","")
ClassMethod GetPDFPathByEpisodeID(AMREpisodeID As %String, MRVerItemsIDs As %String) As %String
{
	s ret = ""
	q:(AMREpisodeID = "") ret
	
	s dataServiceUrl = ##class(DHCEPRSearch.BL.BLSystemOption).GetValueByName("DataServiceUrl")

	s detailNum = ""
	s detailNum = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",MRVerItemsIDs,detailNum),-1)
	q:(detailNum = "") ret
	s subID = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",MRVerItemsIDs,detailNum,""))
	q:(subID = "") ret
	s mrVerItemDetailID = MRVerItemsIDs_"||"_subID
	
	s objMRVerItemDetail = ##Class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
	s FileMasterID = objMRVerItemDetail.FileMasterID
	d objMRVerItemDetail.%Close()
	s FileLocPath = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(FileMasterID)
	//s ftpConfig = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("FTPConfig")
	s encryptFileID = ##class(web.Util.Encryption).SimpleEncrypt(FileMasterID)
	s httpFilePath = dataServiceUrl_"DHCEPRFS.Util.PDFView.cls?FileID="_encryptFileID
	
	s ret = httpFilePath
	q ret
}

}
