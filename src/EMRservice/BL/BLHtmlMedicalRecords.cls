/// 名称: EMRservice.BL.BLHtmlMedicalRecords
/// 描述: 病历HTML访问接口
/// 编写者：yejian
/// 编写日期: 2021-12-23
Class EMRservice.BL.BLHtmlMedicalRecords Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       根据就诊号获取HTML配置数据（重庆陆军特色医院）
/// Creator:    yejian
/// Createdate: 2021-12-23
/// Input:     	EpisodeID 就诊号
/// Output:     DataSet
/// debug:     d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLHtmlMedicalRecords","GetHtmlRecordsByID","67")	
Query GetHtmlRecordsByID(EpisodeID As %String) As %Query(ROWSPEC = "PATPatientID,PAADMVisitNumber,HTMLFileName,EMRName,CreateDateTime,UpdateDateTime,MedDoc,UpdateUser,HTMLFilePath")
{
}

ClassMethod GetHtmlRecordsByIDExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	//b "s"
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)	
	q:(EpisodeID = "") $$$OK
	s patientId=$P($G(^PAADM(EpisodeID)),"^",1)
	//html传输对象
	s objHtml = ##class(EMRservice.entity.EHtmlData).%New()
	s fileType=".html"
	
	s strInstanceID = ""
	for	
	{
		s strInstanceID=$O(^DHCEMRI.Export.SucceedI("IdxTyQueue"," HTML"," "_patientId," "_EpisodeID,strInstanceID)) 
		q:(strInstanceID="")
		s instanceID = $tr(strInstanceID," ")
		s objInstance = ##class(EMRinstance.InstanceData).%OpenId(instanceID)
		continue:(objInstance="")||(objInstance.Status'="Save")
		s episodeId = objInstance.EpisodeID
		s papmiId=$p($g(^PAADM(episodeId)),"^",1)
		s objHtml.PATPatientID=##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(papmiId)	
		s objHtml.PAADMVisitNumber=##class(EMRservice.HISInterface.PatientInfoAssist).InTimes(episodeId)
		s InsID = $REPLACE(instanceID,"||","/")
		s InsID = $REPLACE(InsID,"//","/")			
		s volNo=patientId\10000+1	
		s fileDirectory ="/emrhtml/vol"_volNo_"/"_patientId_"/"_EpisodeID_"/"_InsID_"/"
		s fileLocation=fileDirectory_1_fileType
		s objHtml.HTMLFileName=	fileLocation
		s objHtml.EMRName = objInstance.Title
		s objHtml.CreateDateTime = $ZDATE(objInstance.CreateDate,3)_" "_ $ZTIME(objInstance.CreateTime,1)
		s objHtml.UpdateDateTime = $ZDATE(objInstance.ModifyDate,3)_" "_ $ZTIME(objInstance.ModifyTime,1)
		s:(objInstance.CreateUser'="") objHtml.MedDoc = $p($g(^SSU("SSUSR",objInstance.CreateUser)),"^",2) 
		s:(objInstance.ModifyUser'="") objHtml.UpdateUser = $p($g(^SSU("SSUSR",objInstance.ModifyUser)),"^",2) 
		s objHtml.HTMLFilePath = fileLocation
		s data = $lb(objHtml.PATPatientID,objHtml.PAADMVisitNumber,objHtml.HTMLFileName,objHtml.EMRName,objHtml.CreateDateTime,objHtml.UpdateDateTime,objHtml.MedDoc,objHtml.UpdateUser,objHtml.HTMLFilePath)
		s ^CacheTemp(repid,ind) = data
		s ind=ind+1 
		
	} 
	
	Quit $$$OK
}

ClassMethod GetHtmlRecordsByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHtmlRecordsByIDExecute ]
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

ClassMethod GetHtmlRecordsByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHtmlRecordsByIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:       获取Html数据
/// Creator:    yejian
/// Createdate: 2021-12-11
/// Input:      aInstanceID 实例ID
///             argInData html流数据
/// Output:     EMRservice.entity.EHtmlDataGD
/// debug: s obj = ##class(EMRservice.BL.BLHtmlMedicalRecords).GetHtmlData("1||1",1,1)
/// 	   zw obj
ClassMethod GetHtmlData(aInstanceID As %String, argInData As %GlobalBinaryStream) As EMRservice.entity.EHtmlDataGD
{
	s objRes=##class(EMRservice.entity.EHtmlDataGD).%New()
	q:(aInstanceID="") objRes
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(aInstanceID)
	q:(objInstance="")||(objInstance.Status'="Save") objRes
	s strEpisodeID = objInstance.EpisodeID
	s strPatientID = objInstance.TheECRecord.PatientID
	s objRes.admType = $p($g(^PAADM(strEpisodeID)),"^",2)
	s objRes.patientid = strPatientID
	s objRes.inpatid = strEpisodeID
	s objRes.regid = strEpisodeID
	s objRes.sourcerecordid = aInstanceID
	s objRes.patientname = $P(^PAPER(objRes.patientid,"ALL"),"^",1)
	//s objRes.age =##class(web.DHCBillInterface).GetPapmiAge(strPatientID,strEpisodeID)
	s objRes.ageunit = ""
	s objRes.ageday = ""
	//科室
	s strDest = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(strEpisodeID)
	s:(strDest'="") objRes.deptcode = $p(strDest,"^",2)
	s:(strDest'="") objRes.deptname = $p(strDest,"^",3)
	//病区
	s strWard = ##class(EMRservice.HISInterface.PatientInfoAssist).DisWard(strEpisodeID)
	s:(strWard'="") objRes.wardcode = $p(strWard,"^",2)
	s:(strWard'="") objRes.wardname = $p(strWard,"^",3)
	//文书名
	//s objRes.recordtypecode = objInstance.TitleCode
	s strDocID = objInstance.TheECRecord.ChartItemID
	s:(strDocID'="") objRes.recordtypename = ##class(EMRservice.BL.BLHtmlMedicalRecords).GetEmrCategoryName(strDocID)

	s objRes.recordtitle = objInstance.Title
	//html流数据
	d objRes.originalhtmlcontent.CopyFrom(argInData)
	s objRes.stdflag = "0"
	s objRes.recordtime = $ZDATE(objInstance.HappenDate,3)_" "_ $ZTIME(objInstance.HappenTime,1)
	
	
	s InsID = $REPLACE(aInstanceID,"||","/")
	s InsID = $REPLACE(InsID,"//","/")			
	s volNo=strPatientID\10000+1	
	s fileDirectory ="/emrhtml/vol"_volNo_"/"_strPatientID_"/"_strEpisodeID_"/"_InsID_"/"
	s fileLocation=fileDirectory_"1.html"
	s objRes.weburl = fileLocation
	s objRes.createid = objInstance.CreateUser
	s:(objInstance.CreateUser'="") objRes.createname = $p($g(^SSU("SSUSR",objInstance.CreateUser)),"^",2) 
	s objRes.createtime =  $ZDATE(objInstance.CreateDate,3)_" "_ $ZTIME(objInstance.CreateTime,1)
	s objRes.isvalid = "true"
	s objRes.emrshowtype = "0"
	s objRes.lastopertime =  $ZDATE(objInstance.ModifyDate,3)_" "_ $ZTIME(objInstance.ModifyTime,1)
	//住院
	s objRes.inprecstateid=""
	s objRes.inprecstatecode=""
	s objRes.inprecstatename = ""	
	//门诊
	s objRes.outrecstateid=""
	s objRes.outrecstatecode= ""
	s objRes.outrecstatename = ""
	s strPapmiId=$p($g(^PAADM(objInstance.EpisodeID)),"^",1)
	s objRes.patbaseid=##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strPapmiId)
	q objRes
}

/// Desc:       获取病历展现第一层目录名称
/// Creator:    yejian
/// Createdate: 2021-12-11
/// Input:      aParentID 目录ID
/// Output:     categoryName 目录名
/// debug: w ##class(EMRservice.BL.BLHtmlMedicalRecords).GetEmrCategoryName("1")
ClassMethod GetEmrCategoryName(aParentID As %String) As %String
{
	s strRes = ""
	s objEmrT = ##class(EMRmeta.EMRTemplateCategory).%OpenId(aParentID)
	if (objEmrT'="")
	{
		if (objEmrT.ParentCategoryID'=0)
		{
			s strRes = ##class(EMRservice.BL.BLHtmlMedicalRecords).GetEmrCategoryName(objEmrT.ParentCategoryID)
		}
		else
		{
			s strRes = objEmrT.CategoryName	
		}
	}
	q strRes
}

}
