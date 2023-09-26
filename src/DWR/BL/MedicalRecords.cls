Class DWR.BL.MedicalRecords Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##Class(DWR.BL.MedicalRecords).GetBrowseLocation()
ClassMethod GetBrowseLocation(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>2200774</admId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s netWorkType=request.netWorkType
	   s netWorkType=$TR(netWorkType,$C(0))
	}
	q:($G(admId)="") "201^就诊号不能为空!"
	s myObj=##Class(DWR.MSG.EMRBrowseLocation).%New()
	i netWorkType'="Internet" s netWorkType="Intranet"
	s patientId=$P($G(^PAADM(admId)),"^",1)
	s devstr1="$"
	s devstr2="#"
	s imageFileType=".gif"
	s cateCharptersCount=0
	s parentId=" 0"
	s curCategoryId="0"
	s showIndex=0
	f  s curCategoryId=$O(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID",parentId,curCategoryId)) q:curCategoryId=""  d
	.s hasImage=..IsHasImage(admId, curCategoryId, "")
	.q:hasImage="0"
	.s curCategoryChapterId="0"
	.f  s curCategoryChapterId=$O(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID"," "_curCategoryId,curCategoryChapterId)) q:curCategoryChapterId=""  d
	..s showIndex=showIndex+1
	..//q:showIndex>5
	..s hasImage=..IsHasImage(admId, curCategoryId, curCategoryChapterId)
	..q:hasImage="0"
	..s endDate=$ZD(+$H,3)
	..s endTime=$ZT($P($H,",",2),2)
	..// 取模板列表
	..s docIdList=##class(EPRmeta.EPRTemplateCategory).GetSubPrtTemplateCategory(curCategoryId,curCategoryChapterId)		//若为第二层目录,传入两个参数
	..q:docIdList=""
	..s logIdList=##class(EPRservice.BOEPRLogs).GetLogIDByDate(admId, "1840-12-31", "0:00", endDate, endTime, docIdList)
	..q:logIdList=""
	..s cateCharptersCount=cateCharptersCount+1
	..//返回值格式：totImgaeCount$docID1^logsID1^printType1^imageCount1^hasTitlePage1#docID2^logsID2^printType2^imageCount2^hasTitlePage2
	..s imageList=##class(EPRservice.BOEPImage).GetEPImageCount(admId,logIdList)	
	..s imageCount=+imageList
	..s categoryChapter = ##class(EPRmeta.EPRTemplateCategory).%OpenId(curCategoryChapterId)
	..s cateCharpterObj=##Class(DWR.MSG.EMRCateCharpter).%New()
	..s cateCharpterObj.categoryId=curCategoryId
	..s cateCharpterObj.cateCharpterId=curCategoryChapterId
	..s cateCharpterObj.cateCharpterName=categoryChapter.CategoryName
	..s cateCharpterObj.pages=imageCount
	..s imageList2=$P(imageList,devstr1,2)
	..s myLogCount=$l(imageList2,devstr2)
	..f mylog=1:1:myLogCount d
	...s myTmpStr=$piece(imageList2,devstr2,mylog)
	...s docId=$piece(myTmpStr,"^",1)
	...s logsId=$piece(myTmpStr,"^",2)
	...s printType=$piece(myTmpStr,"^",3)
	...s logImageCount=$piece(myTmpStr,"^",4)			
	...f myPage=1:1:logImageCount d
	....s pageObj=##Class(DWR.MSG.EMRPageFile).%New()
	....s volNo=patientId\10000+1
	....s fileLocation="/dhcepr/vol"_volNo_"/"_patientId_"/"_admId_"/"_logsId_"/"_myPage_imageFileType
	....s pageObj.fileLocation=fileLocation
	....d cateCharpterObj.pageFileList.Insert(pageObj)
	....d pageObj.%Close()
	..d myObj.cateCharpterList.Insert(cateCharpterObj)
	..d cateCharpterObj.%Close()
	..d categoryChapter.%Close()
	i netWorkType'="Internet" s serverType="SERVERINTRA"
	e  s serverType="SERVERINTER"
	s browseType=$G(^DHCDWRSET("EMR","BROWSETYPE"))
	i (browseType="FTP")||(browseType="HTTP") d
	.s serverIP=$get(^DHCDWRSET("EMR",browseType,serverType))
	.s vdir=$get(^DHCDWRSET("EMR",browseType,"VDIR"))
	.s port=$get(^DHCDWRSET("EMR",browseType,"PORT"))
	.s user=$get(^DHCDWRSET("EMR","FTP","USER"))			
	.s password=$get(^DHCDWRSET("EMR","FTP","PASSWORD"))  	
	.s fileServerLocation=browseType_"://"_user_":"_password_"@"_serverIP	
	.//s fileServerLocation=browseType_"://"_serverIP
	.i port'="" s fileServerLocation=fileServerLocation_":"_port
	.i vdir'="" s fileServerLocation=fileServerLocation_"/"_vdir
	.s myObj.fileServerLocation=fileServerLocation
	i (browseType="ONEURL") d
	.s fileServerLocation=$get(^DHCDWRSET("EMR",browseType,serverType))
	.s myObj.fileServerLocation=fileServerLocation
	s myObj.browseType=browseType
	s myObj.cateCharpters=cateCharptersCount
	d myObj.%Close()
	s Xml=""
	s ret=myObj.XMLExportToString(.Xml,"BrowseLocation")
	i ret=1 s retStr=retStr_Xml
	q retStr
}

/// CreateTime:2010-1-22
/// Creator:zhuj
/// Description:根据目录取判断是否有图片
/// Input：	aEpisodeID：病人就诊rowid
/// 		parentId：病历结构树第一层的id
/// 		curCategoryId: 病历结构树第二层id,若只选中第1层,传入""即可
/// Output: 1:有图片，0：无图片
/// Return:
/// Others:
ClassMethod IsHasImage(episodeID As %String, parentId As %String, curCategoryId As %String) As %String
{
	set now = $Horolog
	set endDate = $ZD(now, 3)
	set endTime = $ZT(now, 2)		
	set docIdList = ##class(EPRmeta.EPRTemplateCategory).GetSubPrtTemplateCategory(parentId, curCategoryId)		//若为第二层目录,传入两个参数
	q:(docIdList = "") "0"
	
	set logIdList = ##class(EPRservice.BOEPRLogs).GetLogIDByDate(episodeID, "1840-12-31", "0:00", endDate, endTime,  docIdList)	
	q:(logIdList = "") "0"

	//返回值格式：totImgaeCount$docID1^logsID1^printType1^imageCount1^hasTitlePage1#docID2^logsID2^printType2^imageCount2^hasTitlePage2
	set imageList = ##class(EPRservice.BOEPImage).GetEPImageCount(episodeID,logIdList)	
	s imageCount = $p(imageList, "$", 1)
	q:(imageCount = 0) "0"

	q "1"
}

}
