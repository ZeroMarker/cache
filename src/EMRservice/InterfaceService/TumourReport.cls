/// Desc:肿瘤数据上报
/// Creator:Candy
/// CreateDate:2019-1-31
Class EMRservice.InterfaceService.TumourReport Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/interfaceservice";

/// Name of the WebService.
Parameter SERVICENAME = "TumourReport";

/// Desc:		入院记录上报数据
/// Creator:	Candy
/// CreateDate:	2019-1-31
/// Input:		argEpisodeID
/// Output:		BUS_ID,BUS_TYPE,DATA_DATE,ORGA_NAME,CARD_ID,PAT_NO,PAT_ID,CHI_COMP,PRE_HIST,PAS_HIST,PER_HIST,MENCHI_HIST,FAM_HIST,MENSTRUAL_HIST,BP,BREATH,ADM_TEMP,HEA_RATE,ADM_HEIG,ADM_WEIG,BOD_AREA,STA_SCOR,SCO_CRIT
/// Debug: 		d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.TumourReport","GetAdmissionRecord",135)
Query GetAdmissionRecord(argEpisodeID As %String) As %Query(ROWSPEC = "BUS_ID:%String,BUS_TYPE:%String,DATA_DATE:%String,ORGA_NAME:%String,CARD_ID:%String,PAT_NO:%String,PAT_ID:%String,CHI_COMP:%String,PRE_HIST:%String,PAS_HIST:%String,PER_HIST:%String,MENCHI_HIST:%String,FAM_HIST:%String,MENSTRUAL_HIST:%String,BP:%String,BREATH:%String,ADM_TEMP:%String,HEA_RATE:%String,ADM_HEIG:%String,ADM_WEIG:%String,BOD_AREA:%String,STA_SCOR:%String,SCO_CRIT:%String")
{
}

ClassMethod GetAdmissionRecordExecute(ByRef qHandle As %Binary, argEpisodeID As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	q:(argEpisodeID = "") $$$OK
	s episodeType = $p(^PAADM(argEpisodeID),"^",2)
	s episodeType = $case(episodeType,"O":1,"E":2,"I":3,"H":4,:9)
	s hospital = ##class(EMRservice.HISInterface.PatientInfoAssist).HospitalName(argEpisodeID)
	s medicalNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(argEpisodeID,hospital)
	s patientId = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(argEpisodeID)	
	s array = ##Class(EMRservice.BL.BLGlossary).GetDataByGlossaryCategory(argEpisodeID,"HDSD00.13.01")
	q:(array.Count()<= 0) $$$OK
	s index = ""
	for
	{
		s tmpList = array.GetNext(.index)
		q:(index = "") 
		s instanceId = ""
		for
		{
			s item = tmpList.GetNext(.instanceId)
			q:(instanceId '= "")
			q:(instanceId = "")
		}
		q:(instanceId '= "")
	}
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(instanceId)
	q:(objInstance = "") $$$OK
	s createDateTime = $zd(objInstance.CreateDate,3)_" "_$zt(objInstance.CreateTime)
	s happenDateTime = $zd(objInstance.HappenDate,3)_" "_$zt(objInstance.HappenTime)
	s CHICOMP = ..GetValueFormArray(array,"HDSD00.13.114")
	s PREHIST = ..GetValueFormArray(array,"HDSD00.13.095")
	s PASHIST = ..GetValueFormArray(array,"HDSD00.13.042")
	s PERHIST = ..GetValueFormArray(array,"HDSD00.13.036")
	s MENCHIHIST = ..GetValueFormArray(array,"HDSD00.13.041")
	s FAMHIST = ..GetValueFormArray(array,"HDSD00.13.043")
	s MENSTRUALHIST = ..GetValueFormArray(array,"HDSD00.13.106")
	s BP = ..GetValueFormArray(array,"HDSD00.13.086")_" "_..GetValueFormArray(array,"HDSD00.13.085")
	s BREATH = ..GetValueFormArray(array,"HDSD00.13.077")
	s ADMTEMP = ..GetValueFormArray(array,"HDSD00.13.088")
	s HEARATE = ..GetValueFormArray(array,"HDSD00.13.080")
	s ADMHEIG = ..GetValueFormArray(array,"HDSD00.13.083")
	s ADMWEIG = ..GetValueFormArray(array,"HDSD00.13.089")
	s BODAREA = "" //..GetValueFormArray(array,"")
	s STASCOR = "" //..GetValueFormArray(array,"")
	s SCOCRIT = "" //..GetValueFormArray(array,"")
	s data = $lb(instanceId,episodeType,createDateTime,hospital,argEpisodeID,medicalNo,patientId,CHICOMP,PREHIST,PASHIST,PERHIST,MENCHIHIST,FAMHIST,MENSTRUALHIST,BP,BREATH,ADMTEMP,HEARATE,ADMHEIG,ADMWEIG,BODAREA,STASCOR,SCOCRIT)
	s ^CacheTemp(repid,ind) = data
	s ind=ind+1 		
	Quit $$$OK
}

ClassMethod GetAdmissionRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmissionRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAdmissionRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmissionRecordExecute ]
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

ClassMethod GetValueFormArray(argArray As %ArrayOfDataTypes, argGlossaryID As %String) As %String
{
	s value = ""
	q:(argArray.Count() <=0) value
	s itemList = argArray.GetAt(argGlossaryID)
	q:(itemList.Count()<=0) value  
	s value = itemList.GetNext("")
	q value
}

/// Desc:		上报病程记录
/// Creator:	Candy
/// CreateDate:	2019-1-31
/// Input: 		argEpisodeID 就诊号，argDocID 病程目录
/// Output:		BUS_ID,BUS_TYPE,DATA_DATE,ORGA_NAME,CARD_ID,PAT_NO,PAT_ID,DUR_DISE,DUR_DISE_TIME
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.TumourReport","GetProgressNote",135,66)
Query GetProgressNote(argEpisodeID As %String, argDocID As %String) As %Query(ROWSPEC = "BUS_ID:%String,BUS_TYPE:%String,DATA_DATE:%String,ORGA_NAME:%String,CARD_ID:%String,PAT_NO:%String,PAT_ID:%String,DUR_DISE:%String,DUR_DISE_TIME:%String")
{
}

ClassMethod GetProgressNoteExecute(ByRef qHandle As %Binary, argEpisodeID As %String, argDocID As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	q:(argEpisodeID = "")||(argDocID = "") $$$OK
	s episodeType = $p(^PAADM(argEpisodeID),"^",2)
	s episodeType = $case(episodeType,"O":1,"E":2,"I":3,"H":4,:9)
	s hospital = ##class(EMRservice.HISInterface.PatientInfoAssist).HospitalName(argEpisodeID)
	s medicalNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(argEpisodeID,hospital)
	s patientId = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(argEpisodeID)
	s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",argEpisodeID,argDocID,""))
	q:(ecrecordId = "") $$$OK
	s subId = ""
	for
	{
		s subId = $o(^DHCEMRI.InstanceDataI("IdxECRecord",ecrecordId,subId))
		q:(subId = "")
		s instanceId = ecrecordId_"||"_subId
		s objInstance = ##class(EMRinstance.InstanceData).%OpenId(instanceId)
		continue:(objInstance = "")
		continue:(objInstance.Status '= "Save")
		s tmpInstanceStream = ##class(%GlobalBinaryStream).%New()
		d tmpInstanceStream.CopyFrom(objInstance.InstanceData)
		//压缩优化代码屏蔽原有取值函数
		//s stream = ..GetDocumentContent(tmpInstanceStream)
		s stream = ##class(EMRservice.InterfaceService.EMRRecordInfo).GetDocumentContent(instanceId)
		continue:(stream = "")
		s content = stream.Read()
		s createDateTime = $zd(objInstance.CreateDate,3)_" "_$zt(objInstance.CreateTime)
		s happenDateTime = $zd(objInstance.HappenDate,3)_" "_$zt(objInstance.HappenTime)
		s data = $lb(instanceId,episodeType,createDateTime,hospital,argEpisodeID,medicalNo,patientId,content,happenDateTime)
		s ^CacheTemp(repid,ind) = data
		s ind=ind+1 	
	}	
	Quit $$$OK
}

ClassMethod GetProgressNoteClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetProgressNoteExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetProgressNoteFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetProgressNoteExecute ]
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

/// Desc: 取病历内容
/// Creator:Candy
/// CreateDate:2019-1-21
/// Input: argInstanceID 病历ID
/// Debug: w ##Class(EMRservice.BL.BLEpisodeRecrodService).GetDocumentContent("105||5")
ClassMethod GetDocumentContent(argStream As %GlobalBinaryStream) As %GlobalBinaryStream
{
	//压缩改造屏蔽函数
	s streamContent = ##class(%GlobalBinaryStream).%New()
	q:(argStream.Size <= 0) streamContent
	/*
	s streamScatterData = ##Class(EMRservice.Parser.StreamData).ParserStream(argStream,"<ScatterData","</ScatterData>","14")
	s sc =##class(%XML.XPATH.Document).CreateFromStream(streamScatterData,.scatterData)
	q:($$$ERROR(sc)) streamContent
	s sc = scatterData.EvaluateExpression("/ScatterData/Component","count(Section)",.sections)
	q:($$$ERROR(sc)||(sections.GetAt(1)="")) streamContent
	s count = sections.GetAt(1).Value
	s footer = ""
	for i=1:1:count
	{
		set sc=scatterData.EvaluateExpression("/ScatterData/Component/Section["_i_"]/Code","@DisplayName",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))		
		s sectionName = result.GetAt(1).Value	
		s:(sectionName'["：") sectionName= sectionName_"："
		d streamContent.Write(sectionName)
		s sc = scatterData.EvaluateExpression("/ScatterData/Component/Section["_i_"]/Text","text()",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s value = result.GetAt(1).Value
		s:(i = 2) footer = value
		continue:(i=2)
		d streamContent.Write(value)
		d streamContent.Write($c(13))	
	}
	d streamContent.Write(footer)
	*/
	q streamContent
}

/// Desc:		出院记录上报数据
/// Creator:	Candy
/// CreateDate:	2019-1-31
/// Input:		argEpisodeID
/// Output:		BUS_ID,BUS_TYPE,DATA_DATE,ORGA_NAME,CARD_ID,PAT_NO,PAT_ID,ADM_SITU,DIA_TREA,DIS_RECO,DIS_DIAG,DIS_PRES
/// Debug: 		d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.TumourReport","GetDischargeSummary",135)
Query GetDischargeSummary(argEpisodeID As %String) As %Query(ROWSPEC = "BUS_ID:%String,BUS_TYPE:%String,DATA_DATE:%String,ORGA_NAME:%String,CARD_ID:%String,PAT_NO:%String,PAT_ID:%String,ADM_SITU:%String,DIA_TREA:%String,DIS_RECO:%String,DIS_DIAG:%String,DIS_PRES:%String")
{
}

ClassMethod GetDischargeSummaryExecute(ByRef qHandle As %Binary, argEpisodeID As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	q:(argEpisodeID = "") $$$OK
	s episodeType = $p(^PAADM(argEpisodeID),"^",2)
	s episodeType = $case(episodeType,"O":1,"E":2,"I":3,"H":4,:9)
	s hospital = ##class(EMRservice.HISInterface.PatientInfoAssist).HospitalName(argEpisodeID)
	s medicalNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(argEpisodeID,hospital)
	s patientId = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(argEpisodeID)	
	s array = ##Class(EMRservice.BL.BLGlossary).GetDataByGlossaryCategory(argEpisodeID,"HDSD00.14.13")
	q:(array.Count()<= 0) $$$OK
	s index = ""
	for
	{
		s tmpList = array.GetNext(.index)
		q:(index = "") 
		s instanceId = ""
		for
		{
			s item = tmpList.GetNext(.instanceId)
			q:(instanceId '= "")
			q:(instanceId = "")
		}
		q:(instanceId '= "")
	}
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(instanceId)
	q:(objInstance = "") $$$OK
	s createDateTime = $zd(objInstance.CreateDate,3)_" "_$zt(objInstance.CreateTime)
	s happenDateTime = $zd(objInstance.HappenDate,3)_" "_$zt(objInstance.HappenTime)
	s ADMSITU = ..GetValueFormArray(array,"HDSD00.14.080")
	s DIATREA = ..GetValueFormArray(array,"HDSD00.14.120")
	s DISRECO = ..GetValueFormArray(array,"HDSD00.14.013")
	s DISDIAG = ..GetValueFormArray(array,"HDSD00.14.018")_" "_..GetValueFormArray(array,"HDSD00.14.020")_" "_..GetValueFormArray(array,"HDSD00.14.022")
	s DISPRES = ..GetValueFormArray(array,"HDSD00.14.016")
	s data = $lb(instanceId,episodeType,createDateTime,hospital,argEpisodeID,medicalNo,patientId,ADMSITU,DIATREA,DISRECO,DISDIAG,DISPRES)
	s ^CacheTemp(repid,ind) = data
	s ind=ind+1 		
	Quit $$$OK
}

ClassMethod GetDischargeSummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDischargeSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDischargeSummaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDischargeSummaryExecute ]
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

}
