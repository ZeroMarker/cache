/// 名称: EMRservice.BL.ImageMedicalRecords
/// 描述: 病历图片访问接口
/// 编写者：FangLuoCheng
/// 编写日期: 2015-04-28
Class EMRservice.BL.ImageMedicalRecords Extends %RegisteredObject [ ProcedureBlock ]
{

///  输入PatientIDEpisodeID，	
///  输出图片FTP数据信息
/// Return:		无
/// Others：    d ##Class(%ResultSet).RunQuery("EMRservice.BL.ImageMedicalRecords","GetImageMedicalRecords","1483682")	
Query GetImageMedicalRecords(EpisodeID As %String) As %Query(ROWSPEC = "patientID:%String,episodeID:%String,categoryId:%String,cateCharpterId:%String,cateCharpterName:%String,pages:%String,fileLocation:%String,HappenDateTime")
{
}

ClassMethod GetImageMedicalRecordsExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	//b "s"
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)	
	q:(EpisodeID = "") $$$OK
	s admId=EpisodeID
	s devstr1="$"
	s devstr2="#"
	s patientId=$P($G(^PAADM(EpisodeID)),"^",1)
	s parentId=" 0", curCategoryId="0",imageFileType=".gif"
	s OutcurCategoryId="",OutcurCategoryChapterId="",OutcategoryChapterName="",Outpages="",fileLocation=""
	
	i ..CheckEdition(EpisodeID)="0" d
	.f  s curCategoryId=$O(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID",parentId,curCategoryId)) q:curCategoryId=""  d
	..s hasImage=..IsHasImage(EpisodeID, curCategoryId, "")
	..q:hasImage="0"
	..s curCategoryChapterId="0"
	..f  s curCategoryChapterId=$O(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID"," "_curCategoryId,curCategoryChapterId)) q:curCategoryChapterId=""  d
	...s hasImage=..IsHasImage(EpisodeID, curCategoryId, curCategoryChapterId)
	...q:hasImage="0"
	...s endDate=$ZD(+$H,3)
	...s endTime=$ZT($P($H,",",2),2)
	...// 取模板列表
	...s docIdList=##class(EPRmeta.EPRTemplateCategory).GetSubPrtTemplateCategory(curCategoryId,curCategoryChapterId)		//若为第二层目录,传入两个参数
	...q:docIdList=""
	...s logIdList=##class(EPRservice.BOEPRLogs).GetLogIDByDate(EpisodeID, "1840-12-31", "0:00", endDate, endTime, docIdList)
	...q:logIdList=""
	...s cateCharptersCount=cateCharptersCount+1
	...//返回值格式：totImgaeCount$docID1^logsID1^printType1^imageCount1^hasTitlePage1#docID2^logsID2^printType2^imageCount2^hasTitlePage2
	...s imageList=##class(EPRservice.BOEPImage).GetEPImageCount(EpisodeID,logIdList)	
	...s imageCount=+imageList
	...s categoryChapter = ##class(EPRmeta.EPRTemplateCategory).%OpenId(curCategoryChapterId)
	//...s cateCharpterObj=##Class(DWR.MSG.EMRCateCharpter).%New()
	...s OutcurCategoryId=curCategoryId
	...s OutcurCategoryChapterId=curCategoryChapterId
	...s OutcategoryChapterName=categoryChapter.CategoryName
	...s Outpages=imageCount
	...s imageList2=$P(imageList,devstr1,2)
	...s myLogCount=$l(imageList2,devstr2)
	...f mylog=1:1:myLogCount d
	....s myTmpStr=$piece(imageList2,devstr2,mylog)
	....s docId=$piece(myTmpStr,"^",1)
	....s logsId=$piece(myTmpStr,"^",2)
	....s printType=$piece(myTmpStr,"^",3)
	....s logImageCount=$piece(myTmpStr,"^",4)			
	....f myPage=1:1:logImageCount d	
	.....s volNo=patientId\10000+1
	.....s fileLocation="/dhcepr/vol"_volNo_"/"_patientId_"/"_admId_"/"_logsId_"/"_myPage_imageFileType
	.....s OutfileLocation=fileLocation
	.....s HappenDateTime = ""
	.....s data = $lb(patientId,EpisodeID,OutcurCategoryId,OutcurCategoryChapterId,OutcategoryChapterName,Outpages,OutfileLocation,HappenDateTime)
	.....s ^CacheTemp(repid,ind) = data
	.....s ind=ind+1 
	e  d
	.s imageFileType=".jpg"
	.f  s curCategoryId=$O(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID",parentId,curCategoryId)) q:curCategoryId=""  d
    ..q:curCategoryId=""
	..s curCategoryChapterId=""	
	..f  s curCategoryChapterId=$O(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_curCategoryId,curCategoryChapterId)) q:curCategoryChapterId=""  d
	...q:curCategoryChapterId="0"	
	...s docIdList = ##class(EMRservice.BL.BLEMRTemplateCategory).GetSubPrtTemplateCategory(curCategoryId, curCategoryChapterId)		//若为第二层目录,传入两个参数
	...q:docIdList=""		
	...s imageList=##class(EMRservice.BL.BLExportQueue).GetImageCount(EpisodeID,docIdList)		
	...s imageCount = $p(imageList, "$", 1)	
	...q:(imageCount = 0)
	...s categoryChapter = ##class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryChapterId)
	...q:(categoryChapter = "")
	...s OutcurCategoryId=curCategoryId
	...s OutcurCategoryChapterId=curCategoryChapterId
	...s OutcategoryChapterName=categoryChapter.CategoryName
	...s Outpages=imageCount
	...s imageList2=$P(imageList,devstr1,2)
	...s myLogCount=$l(imageList2,devstr2)
	...f mylog=1:1:myLogCount d
	....s myTmpStr=$piece(imageList2,devstr2,mylog)
	....s docId=$piece(myTmpStr,"^",1)
	....s InstanceID=$piece(myTmpStr,"^",2)
	....// 20190715
	....s instanceidstr =$case(InstanceID["||",1:InstanceID,0:InstanceID_"||"_mylog)  
	....s objInstance = ##class(EMRinstance.InstanceData).%OpenId(instanceidstr)
	....//q:(objInstance="")
	....s HappenDateTime = $ZD(objInstance.HappenDate,3)_" "_$ZT(objInstance.HappenTime)
	....// 20190715
	....//s:(InstanceID["||") InstanceID = $P(InstanceID,"||",1)
	....s InstanceID = $REPLACE(InstanceID,"||","/")
	....s InstanceID = $REPLACE(InstanceID,"//","/")
	....s printType=$piece(myTmpStr,"^",3)
	....s logImageCount=$piece(myTmpStr,"^",4)			
	....f myPage=1:1:logImageCount d
	.....s volNo=patientId\10000+1	
	.....s fileLocation="/dhcepr/vol"_volNo_"/"_patientId_"/"_admId_"/"_InstanceID_"/"_myPage_imageFileType
	.....s OutfileLocation=fileLocation
	.....s data = $lb(patientId,EpisodeID,OutcurCategoryId,OutcurCategoryChapterId,OutcategoryChapterName,Outpages,OutfileLocation,HappenDateTime)
	.....s ^CacheTemp(repid,ind) = data
	.....s ind=ind+1 
		 
	
	Quit $$$OK
}

ClassMethod GetImageMedicalRecordsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetImageMedicalRecordsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetImageMedicalRecordsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetImageMedicalRecordsExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
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

/// w ##class(EMRservice.BL.ImageMedicalRecords).CheckEdition("58")
ClassMethod CheckEdition(episodeID As %String) As %String
{
	//检查是否书写新版实例数据，如果书写则是3版患者，否则则是2版患者
	s tmpID=""
	&sql(SELECT ID into :tmpID FROM EMRinstance.InstanceData
 		WHERE EpisodeID = :episodeID)
 	q:(tmpID="") "0"
 	q:(tmpID'="") "1"
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
ClassMethod IsHasImageEMR(episodeID As %String, parentId As %String, curCategoryId As %String) As %String
{
	set now = $Horolog
	set endDate = $ZD(now, 3)
	set endTime = $ZT(now, 2)		
	set docIdList = ##class(EMRservice.BL.BLEMRTemplateCategory).GetSubPrtTemplateCategory(parentId, curCategoryId)		//若为第二层目录,传入两个参数
	q:(docIdList = "") "0"
	
	
	//返回值格式：totImgaeCount$docID1^aInstanceID2^printType1^imageCount1#docID2^aInstanceID2^printType2^imageCount2
	set imageList = ##class(EMRservice.BL.BLExportQueue).GetImageCount(episodeID,logIdList)	
	s imageCount = $p(imageList, "$", 1)
	q:(imageCount = 0) "0"

	q "1"
}

/// Input:	AEpisodeID 	患者就诊RowID
/// 
/// Return:	<MedRecordList>
/// 				<Record>
/// 						<Id>30</Id>
/// 					<Desc>入院记录</Desc>
/// 					<Flag>1</Flag>
/// 					<PathList>
/// 						<Path>/dhcepr/vol1/1109/2320/169/1.gif</Path>
/// 						<Path>/dhcepr/vol1/1109/2320/169/2.gif</Path>
/// 						<Path>/dhcepr/vol1/1109/2320/169/3.gif</Path>
/// 						<Path>/dhcepr/vol1/1109/2320/169/4.gif</Path>
/// 					</PathList>
/// 				</Record>
/// 				<Record>
/// 					<Id>35</Id>
/// 						<Desc>病程记录</Desc>
/// 					<Flag>1</Flag>
/// 					<PathList>
/// 						<Path>/dhcepr/vol1/1109/2320/210/1.gif</Path>
/// 						<Path>/dhcepr/vol1/1109/2320/215/1.gif</Path>
/// 						<Path>/dhcepr/vol1/1109/2320/289/1.gif</Path>
/// 						<Path>/dhcepr/vol1/1109/2320/290/1.gif</Path>
/// 						<Path>/dhcepr/vol1/1109/2320/311/1.gif</Path>
/// 					</PathList>
/// 				</Record>
/// 			<MedRecordList>
/// Debug:	w ##Class(EMRservice.BL.ImageMedicalRecords).GetImage("13")
ClassMethod GetImage(AEpisodeID As %String) As %String
{
	s ret = "<MedRecordList>"
	
	s curCategoryChapterID = "", xml = ""
	
	s rs = ##class(%ResultSet).%New("EMRservice.BL.ImageMedicalRecords:GetImageMedicalRecords")
	s sc = rs.Execute(AEpisodeID)
 	while (rs.Next()) {
	 	//"patientID:%String,episodeID:%String,categoryId:%String,cateCharpterId:%String,cateCharpterName:%String,pages:%String,fileLocation:%String"
 		s id = rs.GetDataByName("cateCharpterId")
 		s desc = rs.GetDataByName("cateCharpterName")
 		s flag = ""
 		s fullFile = rs.GetDataByName("fileLocation")
 		
 		continue:(id = "") //必要数据
 		
 		if (curCategoryChapterID = "") 
 		{
	 		s xml = "<Record>"
			s xml = xml_"<Id>"_id_"</Id>"
			s xml = xml_"<Desc>"_desc_"</Desc>"
			s xml = xml_"<Flag>"_flag_"</Flag>"
			s xml = xml_"<PathList>"
			s xml = xml_"<Path>"_fullFile_"</Path>"
			
			s curCategoryChapterID = id
 		} 
 		elseif (curCategoryChapterID = id)
 		{
	 		s xml = xml_"<Path>"_fullFile_"</Path>"
 		}
 		else
 		{
	 		s xml = xml_"</PathList>"
			s xml = xml_"</Record>"
			
			s ret = ret_xml
			
			s xml = "<Record>"
			s xml = xml_"<Id>"_id_"</Id>"
			s xml = xml_"<Desc>"_desc_"</Desc>"
			s xml = xml_"<Flag>"_flag_"</Flag>"
			s xml = xml_"<PathList>"
			s xml = xml_"<Path>"_fullFile_"</Path>"
 		}
 	}
 	d rs.Close()
	
	if (xml '= "")
	{
		s xml = xml_"</PathList>"
		s xml = xml_"</Record>"
			
		s ret = ret_xml
	}
	
	s ret = ret_"</MedRecordList>"
	
	q ret
}

}
