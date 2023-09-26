Class EMRservice.BL.BLSDOPRecord Extends %RegisteredObject [ ProcedureBlock ]
{

/// 	<add on 20190929 by houj>
/// 	<todo: 应该实现为ftp操作文件方式>
/// 	互联网医院：病历pdf生成后，拷贝PDF文件至指定病历路径，满足监管平台要求
/// 		s sc = ##Class(EMRservice.BL.BLSDOPRecord).RegPDF(episodeID)
/// 
/// @desc  	注册pdf病历信息，满足监管平台要求
/// @debug	w ##Class(EMRservice.BL.BLSDOPRecord).RegPDF("1111")
ClassMethod RegPDF(AEpisodeID As %String) As %String
{

	s $zt = "OnRegPDF"
	
	b "s"
	
	s itemIDList = "8^门诊病历^C001"
	s rootDir = "D:\"
	
	s admDate = $P($G(^PAADM(AEpisodeID)),"^",6)
	q:(admDate = "") "0^就诊日期为空值"
	
	s admNo =  $P($g(^PAADM(AEpisodeID)),"^",81)
	q:(admNo = "") "0^就诊号为空值"
	
	
	
	//获取要注册的病历归档系统的PDF路径信息
	s pdfList = ..GetFSPDF(AEpisodeID, itemIDList)
	q:(pdfList = "") "0^无病历PDF需要上传到监管平台"
	
	
	//复制PDF文件到监管平台指定路径
	s platList = ""
	s pdfCount = $ListLength(pdfList)
	for i = 1:1:pdfCount
	{
		s pdfInfo = $lg(pdfList,i)
		s itemName = $p(pdfInfo,"^",2)
		s itemType = $p(pdfInfo,"^",3)
		s itemPath = $p(pdfInfo,"^",4)
		s platPath = ..GetPlatPath(AEpisodeID,admDate,admNo,itemName,itemType)
		
		s sc = ..CopyPDF(itemPath, platPath, rootDir)
		s platList = platList_$lb(itemName_"^"_itemType_"^"_platPath)
	}
	
	//更新视图数据
	s fileList = "["
	for i = 1:1:pdfCount
	{
		s fileInfo = $lg(platList, i)
		s itemName = $p(fileInfo,"^",1)
		s itemType = $p(fileInfo,"^",2)
		s itemPath = $p(fileInfo,"^",3)
		s json = "[{""mr_file_src"":""医师书写"",""mr_type_code"":"""_itemType_""",""mr_type_name"":"""_itemName_""",""mr_file"":"""_itemPath_"""}]"
		if (i > 1) s fielList = fileList_","
		s fielList = fileList_json
	}
	s fileList = fileList_"]"
	
	if (fileList '= "")&&(fileList '= "[]")
	{
		s objPaadm = ##Class(User.PAAdm).%OpenId(AEpisodeID)
		if (objPaadm '= "")
		{
			s objPaadm.PAADMLabClinicalCondition = fileList
			s sc = objPaadm.%Save()
		}
	}
	
	q "1"


OnRegPDF
	s $ztrap = ""
	q "0^"_$zerror
}

ClassMethod CopyPDF(from, to, dir) As %String
{
	s ret = "0"
	
	if ($e(from,1,1) = "/") 
	{	s from = $e(from,2,$l(from)) }
	if ($e(to,1,1) = "/") 
	{	s to = $e(to,2,$l(to)) } 
	
	s from = dir_"/"_from
	s to   = dir_"/"_to
	
	s from = $replace(from, "/", "\")
	s to   = $replace(to, "/", "\")
	
	s fromDir  = ##class(%File).GetDirectory(from)
	s toDir    = ##class(%File).GetDirectory(to)
	
	if (##Class(%File).DirectoryExists(fromDir))
	{	
		s sc = ##Class(%File).CreateDirectoryChain(fromDir)
	}
	if (##Class(%File).DirectoryExists(toDir))
	{	
		d ##Class(%File).CreateDirectoryChain(toDir)
	}
	
	
	s sc = ##class(%File).CopyFile(from, to, "1")
	q sc
}

ClassMethod GetPlatPath(AAdmDate, AAdmNo, AItemName, AItemType) As %String
{
	s admDate = $zd(AAdmDate,3)
	s admDate = $replace(admDate,"-","")
	
	q "mr/WEBH012/"_admDate_"/"_AAdmNo_"/"_AItemType_".pdf"
}

ClassMethod GetFSPDF(AEpisodeID, AItemIDList) As %List
{
	s retList = ""
	
	s mrVerItemID = ##class(DHCEPRFS.BL.BLMRVerItem).GetVerItemByItemIDAndEpisodeID(AEpisodeID)
	
	s mrEpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(mrEpisodeID = "") retList
	
	s mrVersionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(mrEpisodeID,"0","")
	q:(mrVersionID = "") retList
	
	s count = $L(AItemIDList,"^")
	for i = 1:1:count
	{
		s itemInfo = $p(AItemIDList, "-", i)
		s itemID = $p(itemInfo, "^", 1)
		s itemName = $p(itemInfo, "^", 2)
		s itemType = $p(itemInfo, "^", 3)
		
		s mrVerItemID = ##Class(DHCEPRFS.BL.BLMRVerItem).GetMRVerItemID(mrVersionID,itemID)
		continue:(mrVerItemID = "")
		
		s ADetailNum = "0"	//默认0版本
		
		s detailID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", mrVerItemID, ADetailNum, ""))
		continue:(detailID = "")
		
		s mrVerItemDetailID = mrVerItemID_"||"_detailID
		s objMRVerItemDetail = ##Class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(mrVerItemDetailID)
		continue:(objMRVerItemDetail = "")
		
		s FileMasterPath = objMRVerItemDetail.FileMasterPath
		
		s retList = retList_$lb(itemID_"^"_itemName_"^"_itemType_"^"_FileMasterPath)
	}
	
	q retList
}

}
