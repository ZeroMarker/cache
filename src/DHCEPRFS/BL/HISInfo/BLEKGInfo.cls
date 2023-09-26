Class DHCEPRFS.BL.HISInfo.BLEKGInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	通过就诊号获取心电图所在FTP地址，以^分隔多个地址
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLEKGInfo).DHCEKGPdfPathOut("11")
ClassMethod DHCEKGPdfPathOut(AEpisodeID) As %String
{
	s ret = ##class(web.DHCEkgWebServiceNew).DHCEKGPdfPathOut(AEpisodeID)
  	q ret
}

/// Desc:	通过就诊号判断是否有心电图
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLEKGInfo).HasEKGToPrint("11")
ClassMethod HasEKGToPrint(AEpisodeID) As %String
{
	s ret = ""
	s ret = ##class(web.DHCEkgWebServiceNew).DHCEKGPdfPathOut(AEpisodeID)
	if (ret = "")
	{
		q "0"	
	}
  	else
  	{
		q "1"  	
	}
}

/// Desc:	是否有心电图(根据类型判断)
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLEKGInfo).HasEKGToPrintByType(13729172,"EBH001")
ClassMethod HasEKGToPrintByType(AEpisodeID As %String, ATypeCode As %String) As %String
{
	s ret = ""
	s ret = ..DHCEKGPdfPathOutByType(AEpisodeID,ATypeCode)
	if (ret = "")
	{
		q "0"	
	}
  	else
  	{
		q "1"  	
	}
}

/// 前庭功能检查七项 - EBH001
/// Desc:	获取心电图pdf路径(根据类型判断)
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLEKGInfo).DHCEKGPdfPathOutByType(13729172,"EBH001")
ClassMethod DHCEKGPdfPathOutByType(EpisodeID As %String, ATypeCode As %String) As %String
{
	set pdfFilePath=""
	
	s CurrentNS = $ZNSPACE

	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	
	set configureId = ""
	for  set configureId=$o(^dbo.tblConfigureD(configureId)) quit:configureId=""  do
	.set configureInfo=^dbo.tblConfigureD(configureId)
	.quit:configureInfo=""
	.set CurrentVolumeId=$list(configureInfo,5)
	.quit:CurrentVolumeId'="CurrentVolumeId"
	.set CurrentVolumeId=$list(configureInfo,6)
	.set dictVolumnId="" for  set dictVolumnId=$o(^dbo.tblDictVolumnD(dictVolumnId)) quit:dictVolumnId=""  do
	..set dictVolumnInfo=^dbo.tblDictVolumnD(dictVolumnId)
	..quit:dictVolumnInfo=""
	..set volumnftpId=$list(dictVolumnInfo,2)
	..quit:CurrentVolumeId'=volumnftpId
	..set volumnftpPath=$list(dictVolumnInfo,5)
	
	quit:volumnftpPath="" "ftp address is null"
	
	set result = ##class(%Library.ResultSet).%New()
	set sqlStr = "select c.ekgReservedName from dbo.tblDictExamItem a,dbo.tblRequest b,dbo.tblFilePath c,dbo.tblExamination d  where b.ekgExamItemCode=a.ekgCode and d.ekgRequestID=b.ID and c.ekgExaminationID=d.ID  and c.ekgReservedName is not null and b.ekgAppointNo='"_EpisodeID_"' and a.ekgCode='"_ATypeCode_"'  group by b.ekgExamCode order by b.ekgRequestTime"
	do result.Prepare(sqlStr) 
	do result.Execute()
	While(result.Next())
	{
		;-----------获取默认登录科室的code----------------------------------------
		//获取user默认登录科室的rowid
		;set filePath = volumnftpPath_result.Data("ekgReservedName")
		set pdfName=result.Data("ekgReservedName")
		set pdfName=$replace(pdfName,".jpg",".pdf")
		set filePath = volumnftpPath_pdfName
		if pdfFilePath'="" set pdfFilePath=pdfFilePath_"^"
		set pdfFilePath=pdfFilePath_filePath
	}
	
	zn CurrentNS
	
	quit pdfFilePath
}

}
