/// 名称：EPRservice.BOEPImage
/// 描述：病历预览图片相关业务类
/// 创建者: HouJ
/// 创建时间：2009-07-24
Class EPRservice.BOEPImage Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EPImageInfo";

/// CreateTime: 2009-07-24
/// Creator: HouJ
/// Desc: 初始化EPImage，若不存在，创建新的；若已存在，初始化，即清除原来的图片
/// Input：	aEpisodeID：病人就诊rowid
/// 		aEPRLogsID: EPRLogs的rowid
/// 		aSaveType：图片保存方式
/// 		aPageCount：总页数
/// Output: 1:成功，0：失败
/// Debug:	w ##class(EPRservice.BOEPImage).InitEPImage(aEEPImage)
ClassMethod InitEPImage(aEEPImage As EPRservice.entity.EEPImage) As EPRservice.entity.EEPImage [ WebMethod ]
{
	//b "s"
	s retValue = ""
	q:(aEEPImage="") retValue
	
	// 获取EPImage相关信息
	s epImageID = ##class(EPRinstance.EPImage).GetEPImageID(aEEPImage.EpisodeID,aEEPImage.EPRLogsID)
	if epImageID = ""
	{	
		//创建新的EPImage
		s objEPImage = ##class(EPRinstance.EPImage).%New()
		q:(objEPImage="") retValue
	}
	else
	{	
		//已存在
		s objEPImage = ##class(EPRinstance.EPImage).%OpenId(epImageID)
		q:(objEPImage="") retValue
		
		if (objEPImage.SaveType="DB")
		{	
			//删除数据库中存储的所有EPImagePage
		}
	}
	
	s objEPImage.EpisodeID = aEEPImage.EpisodeID
	s objEPImage.EPRLogsID = aEEPImage.EPRLogsID
	s objEPImage.SaveType = aEEPImage.SaveType
	s objEPImage.PrintType = aEEPImage.PrintType
	s objEPImage.PageCount = aEEPImage.PageCount
	s objEPImage.HasTitlePage = aEEPImage.HasTitlePage
	
	s now = $h
	s objEPImage.ModifyDate = $p(now,",",1)
	s objEPImage.ModifyTime = $p(now,",",2)
	
	if $$$ISOK(objEPImage.%Save())
	{
		s aEEPImage.ID = objEPImage.%Id()
		s retValue = aEEPImage
	}
	
	quit retValue
}

/// CreateTime: 2009-07-24
/// Creator: HouJ
/// Desc: 	删除EPImage记录
/// Input：	aEpisodeID：病人就诊rowid
/// 		aEPRLogsID: EPRLogs的rowid
/// Output: 1:成功，0：失败，-1:记录不存在
/// Debug:	w ##class(EPRservice.BOEPImage).DeleteEPImage(aEpisodeID,aEPRLogsID)
ClassMethod DeleteEPImage(aEpisodeID As %String, aEPRLogsID As %String) As %String
{
	q:(aEpisodeID="")||(aEPRLogsID="") "-1"
	
	s epImageID = ##Class(EPRinstance.EPImage).GetEPImageID(aEpisodeID, aEPRLogsID)
	q:(epImageID="") "-1"
	
	s sc = ##Class(EPRinstance.EPImage).%DeleteId(epImageID)
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// CreateTime: 2009-08-10
/// Creator: houj
/// Desc: 获取每份病历的图片数及总的图片数
/// Input:	aEpisodeID：就诊rowid
/// 		aEPRLogsIDs: docID1^logsID1#docID2^logsID2
/// Return:	totImgaeCount$docID1^logsID1^printType1^imageCount1^hasTitlePage1#docID2^logsID2^printType2^imageCount2^hasTitlePage2	
/// Debug:	w ##class(EPRservice.BOEPImage).GetEPImageCount("65","60^205")
ClassMethod GetEPImageCount(aEpisodeID As %String, aEPRLogsIDs As %String) As %String
{
	q:((aEpisodeID="")||(aEPRLogsIDs="")) ""
	s imageCountList = ""
	s totCount = 0
	
	s idCount = $L(aEPRLogsIDs,"#")
	s rowid = ""
	for i=1:1:idCount 
	{
		s tmpStr = $p($g(aEPRLogsIDs),"#",i)
		s docId = $p(tmpStr,"^",1)
		s logsId = $p(tmpStr,"^",2)
		
		s pageCount = 0
		s printType = "", hasTitlePage = ""
		&sql(select PageCount, PrintType, HasTitlePage 
			into :pageCount, :printType, :hasTitlePage 
			from EPRinstance.EPImage 
			where EpisodeID = :aEpisodeID and EPRLogsID = :logsId)
		
		if pageCount = "" {s pageCount=0}
		s printType = $E(printType,1,1)
		
		if imageCountList=""
		{	s imageCountList = docId_"^"_logsId_"^"_printType_"^"_pageCount_"^"_hasTitlePage}
		else
		{	s imageCountList = imageCountList_"#"_docId_"^"_logsId_"^"_printType_"^"_pageCount_"^"_hasTitlePage}
		s totCount = totCount + pageCount
	}
	
	q totCount_"$"_imageCountList
}

/// 需求：	哈医大项目提出更新模板的病历要求删除生成病历浏览图片的需求，针对这一需求存在一些问题，我与侯工讨论后，整理如下：
/// 		一.新增一个病历初始状态：当打印模板下的全部界面模板都为"UnSave"时，则这个打印模板为初始状态；
///    		如: 误写了死亡记录后，把死亡记录下的全部界面模板都更新模板后，则死亡记录为初始状态；
/// 		二.增加一个系统参数：用于配置图片生成节点：
///    		1.(配置一)打印模板下有一个界面模板保存，则生成病历浏览图片；
///    		2.(配置二)打印模板下全部必填界面模板都保存时(病历为"完成"状态)，才生成病历浏览图片；
/// 		三.病历浏览图片的生成和删除：
///    		配置一：
///    		1.保存界面模板生成病历浏览图片；
///    		2.更新界面模板后，如病历为初始状态则删除病历浏览图片，如病历不为初始状态重新生成病历浏览图片；
///    		配置二：
///    		1.保存界面模板后，如果病历状态为"完成"，则生成病历浏览图片，否则不生成图片；
///    		2.更新界面模板后，如果病历为"完成"状态，则重新生成病历浏览图片，如病历为"未完成"状态，则删除病历浏览图片；
/// 
/// Desc:	病历预览图片是否应该生成, 如上需求所述，非为两种情况，默认为第一种：
///    		配置1：打印模板下有一个界面模板保存，则生成病历浏览图片
///    		配置2：打印模板下全部必填界面模板都保存时(病历为"完成"状态)，才生成病历浏览图片；
/// Input:	AEpisodeID  : 就诊rowid,  AEPRLogsID : 日志ID
/// Return:	1 应该生成图片，0 应该删除图片，-1 异常
/// Debug:	w ##Class(EPRservice.BOEPImage).GetEPRImageCheckStatus("201764","2")
ClassMethod GetEPRImageCheckStatus(AEpisodeID As %String, AEPRLogsID As %String) As %String
{
	q:(AEpisodeID = "")||(AEPRLogsID="") "-1"	
	
	s savePrintImageStatus = ##class(EPRmeta.SysOption).GetOptionValueByName("SavePrintImageStatus")
	s:(savePrintImageStatus="")||(savePrintImageStatus="NULL") savePrintImageStatus = "unfinished"
	
	s objEPRLogs = ##Class(EPRinstance.EPRLogs).%OpenId(AEPRLogsID)
	q:(objEPRLogs = "") "-1"
	
	s eprLogStatus =  objEPRLogs.EPRStatus
	
	if (savePrintImageStatus = "unfinished")
	{
		q:(eprLogStatus="created") "0"
	}
	elseif (savePrintImageStatus = "finished")
	{
		q:(eprLogStatus="created") "0"
		q:(eprLogStatus="unfinished") "0"
	}
	
	q "1"
}

/// Desc:	检查病历图片状态，如果是删除病历的操作，则清空病历图片记录
/// Debug:	w ##Class(EPRservice.BOEPImage).RegEPImageByStatus("201871","7")
ClassMethod RegEPImageByStatus(AEpisodeID As %String, AEPRLogsID As %String, AEPRStatus As %String) As %String
{
	s savePrintImageStatus = ##class(EPRmeta.SysOption).GetOptionValueByName("SavePrintImageStatus")
	s:(savePrintImageStatus="")||(savePrintImageStatus="NULL") savePrintImageStatus = "unfinished"
	
	if (savePrintImageStatus = "unfinished")
	{
		if (AEPRStatus="created")
		{
			do ..DeleteEPImage(AEpisodeID,AEPRLogsID)
			q "0"
		} 
	}
	elseif (savePrintImageStatus = "finished")
	{
		if (AEPRStatus="created")||(AEPRStatus="unfinished")
		{
			do ..DeleteEPImage(AEpisodeID,AEPRLogsID)
			q "0"
		}
	}
	
	q "1"
}

ClassMethod HasOldEPImage(AEpisodeID As %String, AEPRLogIDList As %String) As %String
{
	s hasOldImage = 0
	
	s idCount = $L(AEPRLogIDList,"#")
	for i=1:1:idCount 
	{
		s tmpStr = $p($g(AEPRLogIDList),"#",i)
		s docId = $p(tmpStr,"^",1)
		s logsId = $p(tmpStr,"^",2)
		
		s epImageID = ##class(EPRinstance.EPImage).GetEPImageID(AEpisodeID,logsId)
		s obj = ##Class(EPRinstance.EPImage).%OpenId(epImageID)
		continue:(obj = "")
		continue:(obj.ModifyDate="")||(obj.ModifyTime="")
		
		s obj2 = ##Class(EPRinstance.EPRLogs).%OpenId(logsId)
		continue:(obj2 = "")
		s logCount = obj2.Log.Count()
		continue:(logCount = 0)
		s instLog = obj2.Log.GetAt(logCount)
		continue:(instLog="")
		
		if (obj.ModifyDate < instLog.OperateDate)
		{
			s hasOldImage = 1
			quit
		}
		elseif (obj.ModifyDate = instLog.OperateDate)
		{
			if (obj.ModifyTime < instLog.OperateTime)
			{
				s hasOldImage = 1
				quit
			}
		}
	}
	
	q hasOldImage
}

/// ----------- 以下为停用代码，停用预览图片数据库存储功能，只支持FTP存储 ------------
/// 
/// Desc: 保存一份EPImagePage，若其不存在，添加之；若已经存在，修改之
ClassMethod SaveEPImagePage(aEPImagePage As EPRservice.entity.EEPImagePage) As %String [ WebMethod ]
{
	s rowid = ""
	&sql(select ID into :rowid from EPRinstance.EPImagePage 
		where EPImageID = :aEPImagePage.ID and PageIndex = :aEPImagePage.PageIndex)
	
	if rowid=""
	{	q ..AddEPImagePage(aEPImagePage)}
	else
	{	
		s aEPImagePage.ID = rowid
		q ..SetEPImagePage(aEPImagePage)
	}
}

ClassMethod AddEPImagePage(aEPImagePage As EPRservice.entity.EEPImagePage) As %String
{
	s page = ##class(EPRinstance.EPImagePage).%New()
	q:(page="") "-1"
	
	s page.EPImageID = aEPImagePage.EPImageID
	s page.PageIndex = aEPImagePage.PageIndex
	d page.ImageData.CopyFrom(aEPImagePage.ImageData)
	s sc = page.%Save()
	q:($$$ISOK(sc)) page.%Id()
	q "-1"
}

ClassMethod SetEPImagePage(aEPImagePage As EPRservice.entity.EEPImagePage) As %String
{
	s page = ##class(EPRinstance.EPImagePage).%OpenId(aEPImagePage.ID)
	q:(page="") "-1"
	
	s page.EPImageID = aEPImagePage.EPImageID
	s page.PageIndex = aEPImagePage.PageIndex
	d page.ImageData.CopyFrom(aEPImagePage.ImageData)
	s sc = page.%Save()
	q:($$$ISOK(sc)) page.%Id()
	q "-1"
}

/// CreateDate：2009-08-04
/// CreateUser: HouJ
/// Desc: 获取某次就诊、某个打印模板的病历预览对象
/// 		 唯一病历：就诊RowId + EPRLogs的rowid 决定一个病历预览对象
/// 		 可重复病历：就诊rowid + EPRLogs的rowid 决定一个病历预览对象
/// Input：aEpisodeID：就诊RowId
/// 		  aEPRLogsID：EPRLogs的rowid
/// Output：无
/// Return：EPRservice.entity.EEPImage
ClassMethod GetEPImage(aEpisodeID As %String, aEPRLogsID As %String, aHappenDate As %String) As EPRservice.entity.EEPImage [ WebMethod ]
{
	s epImageID = ##class(EPRinstance.EPImage).GetEPImageID(aEpisodeID,aEPRDocID)
	q:(epImageID="") ""
	
	s obj = ##class(EPRinstance.EPImage).%OpenId(epImageID)
	q:(obj="") ""
	
	s entity = ##class(EPRservice.entity.EEPImage).%New()
	s entity.ID = obj.%Id()
	s entity.EpisodeID = obj.EpisodeID
	s entity.EPRLogsID = obj.EPRLogsID
	s entity.PrintType = obj.PrintType
	s entity.SaveType = obj.SaveType
	s entity.PageCount = obj.PageCount
	
	q entity
}

/// CreateDate：2009-08-04
/// CreateUser: HouJ
/// Desc: 获取某次就诊、某个打印模板的病历预览对象下的某页病历
/// Input：aEPImageID：EPRinstance.EPImage的RowId
/// 		  aPageIndex：病历页索引
/// Output：无
/// Return：EPRservice.entity.EEPImagePage
ClassMethod GetEEPImagePage(aEPImageID As %String, aPageIndex As %Integer) As EPRservice.entity.EEPImagePage [ WebMethod ]
{
	q:((aEPImageID="")||(aPageIndex="")) ""
	
	s blankEPImageID = " "_aEPImageID
	s pageIndex = +aPageIndex
	s rowid = $O(^DHCEPRI.EPImagePageI("IdxForLink",blankEPImageID,pageIndex,""))
	q:(rowid="") ""
	
	s obj = ##class(EPRinstance.EPImagePage).%OpenId(rowid)
	q:(obj="") ""
	
	s entity =  ##class(EPRservice.entity.EEPImagePage).%New()
	s entity.ID = obj.%Id()
	s entity.EPImageID = obj.EPImageID
	s entity.PageIndex = obj.PageIndex
	d entity.ImageData.CopyFrom(obj.ImageData)
	
	q entity
}

/// Desc:	获取保存在数据库中的Image
/// Input:	aAdmID: 就诊rowid
/// 		aStartPage：Image起始页
/// 		aPageScope：要取的Image页数
/// Debug:	w ##class(EPRservice.BOEPImage).GetImagesByFile("56")
ClassMethod GetImagesByFile(aAdmID As %String, aStartPage As %String = "", aPageScope As %String = "", aPrintTemplateID As %String = "") As %String
{
	//b "s"
	s retVal=""
	
	s totPage = 0
	s fileNames = ""
	
	s param = ##class(EPRmeta.SysOption).GetOptionValueByName("SavePrintImage")
	s type = $p(param,"^",1)
	s path = $p(param,"^",2)
	
	
	//取本次就诊所有打印过的病历图片
	if aPrintTemplateID=""	
	{
		q:(path="") ""
		s lastChar=$e(path,$L(path))
		if lastChar'="\"
		{	s path = path_"\"}
		
		&sql(DECLARE MyCursor CURSOR FOR
 		SELECT ID INTO :CurID
 		FROM EPRinstance.EPImage WHERE EpisodeID = :aAdmID)
	
		&sql(OPEN MyCursor)
		for {
			&SQL(FETCH MyCursor) 
 			Q:SQLCODE
			
			s obj = ##class(EPRinstance.EPImage).%OpenId(CurID)
			i obj=""  continue
			i (obj.SaveType'="Local") continue    //取保存在本地的病历打印图片
			i (obj.PageCount<1) continue
			
			s count = 0 
			for {
				s count = count + 1
				q:(obj.PageCount<count)
				
				s totPage = totPage + 1
				s eid = obj.EpisodeID
				s ptid = obj.PrintTemplateID
				s fileNames = fileNames_path_eid_"-"_ptid_"\"_count_".gif^"
			}
		}
		
		&sql(CLOSE MyCursor)
		
		q:(totPage=0) ""
		s retVal = totPage_"|"_"1"_"|"_totPage_"|"_$E(fileNames,1,$L(fileNames)-1)
		s retVal = $tr(retVal,"\","/")
	}
	
	q retVal
}

ClassMethod GetFTPPath() As %String
{
	q ##class(EPRmeta.SysOption).GetOptionValueByName2("SavePrintFile", "")
}

/// w ##Class(EPRservice.BOEPImage).GetImagePath("201868","HDSD00.02")
ClassMethod GetImagePath(EpisodeID As %String, TermID As %String) As %String
{
	s result=""
	s patientID=##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
    s tmp=(patientID\10000)+1
    s path="DHCEPR/VOL"_tmp_"/"_patientID_"/"_EpisodeID
   
    s printDocID=""
    s printDocID=$O(^EPRmeta.PrintGlossaryI("Idx", " "_TermID, printDocID))
    q:""=printDocID ""
    s obj=##Class(EPRmeta.PrintGlossary).%OpenId(printDocID)
    s printDocID=obj.PrintDocID
   
    s EPRNum=1
    while(1)
    {
	    s EPRLogsID=""      
	    s EPRLogsID=$O(^DHCEPRI.EPRLogsI("IdxMain", " "_EpisodeID, " "_printDocID, EPRNum, EPRLogsID))
	    if ""=EPRLogsID { q }
	    
	    s rowId=$O(^DHCEPRI.EPImageI("IdxForLink", " "_EpisodeID, " "_EPRLogsID, ""))
	    s obj=##class(EPRinstance.EPImage).%OpenId(rowId)
	    if ""=obj 
	    {
		    if (""=result) { s result="NULL"}
		    else { s result = result_"^NULL"  }
		}
	    else 
	    {
		    if (""=result) { s result=path_"/"_EPRLogsID_"/" } 
	        else { s result = result _"^"_path_"/"_EPRLogsID_"/" }
	        
	    }
	    s EPRNum = EPRNum + 1
    }
    q result
}

/// ------------ 以下为测试代码 ------------
/// 
/// w ##class(EPRservice.BOEPImage).TestAddLocalImage()
/// 
ClassMethod TestAddLocalImage()
{
	s i=0
	for {
		s i = i + 1
		q:(i>1)
		
		s obj = ##class(EPRinstance.EPImage).%New()
		s obj.EpisodeID = "56"
	 	s obj.PrintTemplateID = "86"
		s obj.InstanceDataID = "100||1"		
		d obj.%Save()
		
		//Set stream=##class(%FileCharacterStream).%New()
		s page = ##class(EPRinstance.EPImagePage).%New()
		set stream=##class(%FileBinaryStream).%New()
		Set stream.Filename="d:\1.gif"
		While 'stream.AtEnd {
			d page.ImageData.Write(stream.Read(1024))
		}
		s page.EPImageID = obj.%Id()
		s page.PageIndex = obj.PageCount + 1
		d page.%Save()
		
		d stream.%Close()
		
		
	}
}

/// w ##class(EPRservice.BOEPImage).TestGetImage()
ClassMethod TestGetImage()
{

	s stream = ##class(%FileBinaryStream).%New()
	s obj =  ##class(EPRinstance.EPImagePage).%OpenId(4)
	Set stream.Filename="d:\get1.gif"
	d stream.CopyFrom(obj.ImageData)
	d stream.SaveStream()
	d stream.%Close()
	
	b "s"
	
	s obj =  ##class(EPRinstance.EPImagePage).%OpenId(5)
	Set stream.Filename="d:\get2.gif"
	d stream.CopyFrom(obj.ImageData)
	d stream.SaveStream()
	d stream.%Close()
	q
}

/// w ##class(EPRservice.BOEPImage).TestSaveEEPImagePage()
ClassMethod TestSaveEEPImagePage()
{
	s page = ##class(EPRservice.entity.EEPImagePage).%New()
	s page.EPImageID = "1"
	s page.PageIndex = 1
	d page.ImageData.Write("xxxxxxxxx")
	d ..SaveEPImagePage(page)
}

/// w ##class(EPRservice.BOEPImage).TestInitEPImage("89")
ClassMethod TestInitEPImage(id)
{
	/*
	s obj = ##class(EPRinstance.EPImage).%OpenId(id)
	s entity = ##class(EPRservice.entity.EEPImage).%New()
	
	s entity.EpisodeID = obj.EpisodeID
	s entity.EPRLogsID = obj.EPRLogsID
	s entity.SaveType = obj.SaveType
	s entity.PrintType = obj.PrintType
	s entity.PageCount = obj.PageCount
	s entity.HasTitlePage = obj.HasTitlePage
	*/
	
	s entity = ##class(EPRservice.entity.EEPImage).%New()
	
	s entity.EpisodeID = "49"
	s entity.EPRLogsID = "3"
	s entity.SaveType = "FTP"
	s entity.PrintType = "Single"
	s entity.PageCount = "1"
	s entity.HasTitlePage = "0"
	q ..InitEPImage(entity)
}

}
