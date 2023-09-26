Class DHCEPRFS.BL.BLPDFView Extends %RegisteredObject [ ProcedureBlock ]
{

/// Debug: w ##class(DHCEPRFS.BL.BLPDFView).GetPDFPathByEpisodeID("","","")
ClassMethod GetPDFPathByEpisodeID(AEpisodeID As %String, ASchemeID As %String, AMRItemID As %String) As %String
{
	s ret = ""
	q:(AEpisodeID = "") ret
	
	s mrVerItemID = ##class(DHCEPRFS.BL.BLMRVerItem).GetVerItemByItemIDAndEpisodeID(AEpisodeID,AMRItemID) 
	q:(mrVerItemID = "") ret
	s detailNum = ""
	s detailNum = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,detailNum),-1)
	q:(detailNum = "") ret
	s subID = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,detailNum,""))
	q:(subID = "") ret
	s mrVerItemDetailID = mrVerItemID_"||"_subID
	
	s objMRVerItemDetail = ##Class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
	s FileMasterID = objMRVerItemDetail.FileMasterID
	s FileLocPath = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(FileMasterID)
	s ftpConfig = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("FTPConfig")
	s httpConfig = "http://127.0.0.1/dthealth/web/csp/pdfjs"
	
	/*if (FileLocPath [ "|") //含有虚拟路径
	{
		if ($p(FileLocPath,"|",2)="/") //虚拟目录为根目录
		{
			s oneFilePath= "ftp://"_$p(ftpConfig,"^",2)_":"_$p(ftpConfig,"^",3)_$p(FileLocPath,"|",3)
		}
		else
		{
			s oneFilePath= "ftp://"_$p(ftpConfig,"^",2)_":"_$p(ftpConfig,"^",3)_$p(FileLocPath,"|",2)_$p(FileLocPath,"|",3)
		}
	}
	else
	{
		s oneFilePath= "ftp://"_$p(ftpConfig,"^",2)_":"_$p(ftpConfig,"^",3)_FileLocPath
	}*/
	if (FileLocPath [ "|") //含有虚拟路径
	{
		if ($p(FileLocPath,"|",2)="/") //虚拟目录为根目录
		{
			s oneFilePath= httpConfig_$p(FileLocPath,"|",3)
		}
		else
		{
			s oneFilePath= httpConfig_$p(FileLocPath,"|",2)_$p(FileLocPath,"|",3)
		}
	}
	else
	{
		s oneFilePath= httpConfig_FileLocPath
	}
	s ret = oneFilePath
	s ret = "http://127.0.0.1/dthealth/web/DHCEPRFS.Util.PDFView.cls?FileID=7E79"
	q ret
}

/// Desc: 获取PDF路径
/// Input: EpisodeID - 就诊RowID, DataServiceUrl - 实际数据访问Web服务地址
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLPDFView","GetPDFPathInfo","2944131","http://127.0.0.1/dthealth/web/")
Query GetPDFPathInfo(AEpisodeID As %String, ADataServiceUrl As %String = "") As %Query(ROWSPEC = "ItemCode:%String,ItemName:%String,ItemDesc:%String,FilePath:%String")
{
}

ClassMethod GetPDFPathInfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ADataServiceUrl As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	q:(AEpisodeID = "") $$$OK
	s mrEpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(mrEpisodeID = "") $$$OK
	s mrVersionID = ##class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(mrEpisodeID,"0")
	q:(mrVersionID = "") $$$OK
	
	s dataServiceUrl = ADataServiceUrl
	s:(dataServiceUrl = "") dataServiceUrl = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("WebURL")
	s defaultSchemeID = ##class(DHCEPRFS.BL.BLPrintScheme).GetSchemeIDByDefault("VIEW")
	q:(defaultSchemeID = "") $$$OK
	s objScheme = ##class(DHCEPRFS.META.PrintScheme).%OpenId(defaultSchemeID)
	s defaultViewItems = objScheme.SchemeItems
	d objScheme.%Close()
	q:(defaultViewItems = "") $$$OK
	
	for i=1:1:$l(defaultViewItems,"^")
	{
		s xMrItemID = $p($p(defaultViewItems,"^",i),"#",3)
		s mrVerItemID = ""
		s mrVerItemID = $o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_mrVersionID," "_xMrItemID,mrVerItemID))
		continue:(mrVerItemID = "")
		
		s detailNum = ""
		s detailNum = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,detailNum),-1)
		continue:(detailNum = "")
		s subID = ""
		s subID = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,detailNum,subID))
		continue:(subID = "")
		s mrVerItemDetailID = mrVerItemID_"||"_subID
		
		s objMRVerItemDetail = ##class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
		s fileMasterID = objMRVerItemDetail.FileMasterID
		d objMRVerItemDetail.%Close()
		s encryptFileID = ##class(web.Util.Encryption).SimpleEncrypt(fileMasterID)
		s httpFilePath = dataServiceUrl_"DHCEPRFS.Util.PDFView.cls?FileID="_encryptFileID
		
		s objMRItem = ##class(DHCEPRFS.META.MRItem).%OpenId(xMrItemID)
		s itemCode = objMRItem.Code
		s itemName = objMRItem.Name
		s itemDesc = objMRItem.Description
		s itemType = objMRItem.Type
		d objMRItem.%Close()
		
		s data = $lb(itemCode,itemName,itemDesc,httpFilePath)
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1
	}
	q $$$OK
}

ClassMethod GetPDFPathInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPDFPathInfoExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPDFPathInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPDFPathInfoExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 获取角色权限下PDF路径
/// Input: EpisodeID - 就诊RowID, RoleID - 角色RowID, OperationID - 操作RowID, DataServiceUrl - 实际数据访问Web服务地址
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLPDFView","GetApplyPDFPathInfo","2944131","1","1","http://127.0.0.1/dthealth/web/")
Query GetApplyPDFPathInfo(AEpisodeID As %String, ARoleID As %String, AOperationID As %String, ADataServiceUrl As %String = "") As %Query(ROWSPEC = "ItemCode:%String,ItemName:%String,ItemDesc:%String,FilePath:%String")
{
}

ClassMethod GetApplyPDFPathInfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ARoleID As %String, AOperationID As %String, ADataServiceUrl As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	q:(AEpisodeID = "") $$$OK
	s mrEpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(mrEpisodeID = "") $$$OK
	s mrVersionID = ##class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(mrEpisodeID,"0")
	q:(mrVersionID = "") $$$OK
	
	s itemIDs = ""
	s sequence = ""
	for {
		s sequence = $o(^DHCEPRRBAC.INST.ResourceRItemI("IdxRoleItem"," "_ARoleID," "_AOperationID,sequence))
		q:(sequence = "")
		s itemID = ""
		for {
			s itemID = $o(^DHCEPRRBAC.INST.ResourceRItemI("IdxRoleItem"," "_ARoleID," "_AOperationID,sequence,itemID))
			q:(itemID = "")
			
			s rowID = ##class(DHCEPRRBAC.Util.Utilization).TrimBlankSpace(itemID)
			s objRI = ##class(DHCEPRRBAC.INST.ResourceItem).%OpenId(rowID)
			s privacyID = objRI.PrivateDomainID
			s itemDID = objRI.ItemID
			s objID = ##class(DHCEPRRBAC.META.ItemDefinition).%OpenId(itemDID)
			s param = objID.ItemCode
			s type = objID.ItemType
			s objP = ##class(DHCEPRRBAC.META.PrivateDomainDefinition).%OpenId(privacyID)
			s privacyLevel = objP.RPDLevel
			
			if (itemIDs = "")
			{
				s itemIDs = privacyLevel_"@"_param_"@"_type
			}
			else
			{
				s itemIDs = itemIDs_"^"_privacyLevel_"@"_param_"@"_type
			}
		}
	}
	
	s dataServiceUrl = ADataServiceUrl
	s:(dataServiceUrl = "") dataServiceUrl = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("WebURL")
	s mrVerItemIDs = ##Class(DHCEPRFS.BL.BLPrintScheme).GetVerItemByVersionItemsString(mrEpisodeID,itemIDs)
	q:(mrVerItemIDs = "") $$$OK
	
	for i=1:1:$l(mrVerItemIDs,"^")
	{
		s mrVerItemID = $p(mrVerItemIDs,"^",i)
		continue:(mrVerItemID = "")
		
		s detailNum = ""
		s detailNum = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,detailNum),-1)
		continue:(detailNum = "")
		s subID = ""
		s subID = $o(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain",mrVerItemID,detailNum,subID))
		continue:(subID = "")
		s mrVerItemDetailID = mrVerItemID_"||"_subID
		
		s objMRVerItemDetail = ##class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
		s fileMasterID = objMRVerItemDetail.FileMasterID
		d objMRVerItemDetail.%Close()
		s encryptFileID = ##class(web.Util.Encryption).SimpleEncrypt(fileMasterID)
		s httpFilePath = dataServiceUrl_"DHCEPRFS.Util.PDFView.cls?FileID="_encryptFileID
		
		s objMRVerItem = ##class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
		s objMRItem = ##class(DHCEPRFS.META.MRItem).%OpenId(objMRVerItem.MRItemID)
		s itemCode = objMRItem.Code
		s itemName = objMRItem.Name
		s itemDesc = objMRItem.Description
		s itemType = objMRItem.Type
		d objMRItem.%Close()
		
		s data = $lb(itemCode,itemName,itemDesc,httpFilePath)
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1
	}
	q $$$OK
}

ClassMethod GetApplyPDFPathInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApplyPDFPathInfoExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetApplyPDFPathInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApplyPDFPathInfoExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// debug: d ##class(DHCEPRFS.BL.BLPDFView).GetPDFStream(1)
ClassMethod GetPDFStream(AFileMasterID As %String) As %GlobalCharacterStream
{
	s OutStream=##class(%GlobalCharacterStream).%New()
	s fileInfo = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(AFileMasterID)
	s ftpConfig = $p(fileInfo,"@@@",1)
	s fileLocPath = $p(fileInfo,"@@@",2)

	s FTPMethod = $p(ftpConfig,"^",1)
	s IP = $p(ftpConfig,"^",2)
	s Port = $p(ftpConfig,"^",3)
	s UserName = $p(ftpConfig,"^",4)
	s Password = $p(ftpConfig,"^",5)
	
	s FileName = $p(fileLocPath,"/",$l(fileLocPath,"/"),$l(fileLocPath,"/"))
	s Directory = $replace(fileLocPath,FileName,"")

	Set ftp=##class(%Net.FtpSession).%New()
	
	//设置FTPS
	if (($zcvt(FTPMethod,"U")) = "FTPS"){ 	
		Set ftp.SSLConfiguration = "FTPS"
	}
	 	
	If 'ftp.Connect(IP,UserName,Password,Port) {
		 d OutStream.Write("FTP连接不上")
		 q 0
	}
	if 'ftp.SetDirectory(Directory) {
		 d OutStream.Write("FTP路径不存在")
		 d ftp.Logout()
		 q 0
	}
	Set stream=##class(%GlobalCharacterStream).%New()
	If 'ftp.Binary() {
		d OutStream.Write("FTP内容不能binary mode")
		d ftp.Logout()
		q 0
	}
	
	s ret=ftp.Retrieve(FileName,stream)
	If 'ftp.Retrieve(FileName,stream) {
		d OutStream.Write("没有找个FTP上指定目录下的文件")
		d ftp.Logout()
		q 0
	}
	
	If 'ftp.Logout() {
		d OutStream.Write("断开FTP失败")
		q 0
	}
	
	s byteList = stream.Read(12288)   ;要为3的倍数，这样补0才不会出问题 12288=3*4*1024, 12k
	while(byteList'="")
	{ 
    	s baseStr = ##class(%SYSTEM.Encryption).Base64Encode(byteList)
        s baseStr=##class(web.DHCENS.STBLL.UTIL.Common).ReplaceStr(baseStr,$C(10),"")
        s baseStr=##class(web.DHCENS.STBLL.UTIL.Common).ReplaceStr(baseStr,$C(13),"")
        d OutStream.Write(baseStr)
        set byteList = ""         
        set byteList = stream.Read(12288)
	}
	//s OutStream=stream
	
	q OutStream
}

}
