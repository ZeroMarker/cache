/// Creator:	guozongtao 
/// CreatDate:  2019-5-24
/// Desc:		GlobalEMR V3.0版本提供给临床科研数据管理的病历数据接口
Class EMRservice.InterfaceService.MedicalRecordsForCSM Extends %RegisteredObject
{

/// Desc:		获取病历的纯文本数据 (原上报病程记录)
/// Creator:	guozongtao (Candy)
/// CreateDate:	2019-05-24
/// Input: 		argEpisodeID 就诊号，argDocID (病历展现结构第三层节点的ID)
/// Output:		BUS_ID,BUS_TYPE,DATA_DATE,ORGA_NAME,CARD_ID,PAT_NO,PAT_ID,DUR_DISE,DUR_DISE_TIME
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.MedicalRecordsForCSM","GetProgressNote",315,66)
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
		//b "s"
		s subId = $o(^DHCEMRI.InstanceDataI("IdxECRecord",ecrecordId,subId))
		q:(subId = "")
		s instanceId = ecrecordId_"||"_subId
		s objInstance = ##class(EMRinstance.InstanceData).%OpenId(instanceId)
		continue:(objInstance = "")
		continue:(objInstance.Status '= "Save")
		s InstanceData = ##class(%GlobalBinaryStream).%New()
		d InstanceData.CopyFrom(objInstance.InstanceData)
		//修改取值方法，压缩后通过模板+打散取值
		//s stream = ..GetDocumentContent(InstanceData)
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
/// Debug: w ##Class(EMRservice.InterfaceService.MedicalRecordsForCSM).GetDocumentContent(argInstanceData)
ClassMethod GetDocumentContent(argStream As %GlobalBinaryStream) As %GlobalBinaryStream
{
	//因压缩改造，屏蔽代码
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
		set tSC=scatterData.EvaluateExpression("/ScatterData/Component/Section["_i_"]/Code","@DisplayName",.displayname)
		s displayname = displayname.GetAt(1).Value	
		s:(displayname'["：") displayname= displayname_"："

		s sc = scatterData.EvaluateExpression("/ScatterData/Component/Section["_i_"]/Text","text()",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s value = result.GetAt(1).Value
		
		s:(i = 2) footer = value
		continue:(i=2)
		d streamContent.Write(displayname)
		d streamContent.Write(value)
		d streamContent.Write($c(13))	
	}
	d streamContent.Write(footer)
	*/
	q streamContent
}

/// Desc:		根据患者就诊号，获取已书写的病历的DocID的集合。
/// Creator:	guozongtao
/// CreateDate:	2019-05-24
/// Input: 		argEpisodeID 就诊号，argDocID (病历展现结构第三层节点的ID)
/// Output:		%ArrayOfDataTypes (DOCID,DOCDesc)
/// Debug:		d ##Class(EMRservice.InterfaceService.MedicalRecordsForCSM).GetMedicalRecordsArrayByAdm("315")
ClassMethod GetMedicalRecordsArrayByAdm(argEpisodeID As %String) As %ArrayOfDataTypes
{
	s RetrunArray = ##class(%ArrayOfDataTypes).%New()
	
	s mDocID = ""
	for 
	{
		s mDocID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",argEpisodeID,mDocID))
		q:(mDocID = "") 
		
		s ecrecordId = ""
		for
		{
			s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",argEpisodeID,mDocID,ecrecordId))
			q:(ecrecordId = "") 
		
			s EcrecordOref = ##class(EMRinstance.ECRecord).%OpenId(ecrecordId)
			if (EcrecordOref.InstanceCount>1)
			{
				s EMRTemplateCategoryOref = ##Class(EMRmeta.EMRTemplateCategory).%OpenId($tr(mDocID," ",""))
				d RetrunArray.SetAt(EMRTemplateCategoryOref.CategoryName,$tr(mDocID," ",""))				
			}
			d EcrecordOref.%Close()
			s EcrecordOref = ""
		}
	}
	
	/*
	测试代码
	s key = ""
	for
	 {	 
		Set value = RetrunArray.GetNext(.key)
		quit:key=""
		Write "CategoryID: ",key ," CategoryName:",value,!
	} 
	*/	

	q RetrunArray
}

/// Desc:		获取病历展现结构-病历模板目录树
/// Creator:	Lina
/// CreateDate:	2016-12-15
/// OutPut:		CategoryId   目录CategoryId
/// 			CategoryName 目录名称
///             CategoryType 目录节点类型
/// Debug: 		d ##Class(EMRservice.InterfaceService.MedicalRecordsForCSM).GetAllCategory()
ClassMethod GetAllCategory() As %GlobalBinaryStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s cjson = ##Class(%GlobalCharacterStream).%New()
	s count = 0
	s parentCategoryID = ""
	for
	{
		s parentCategoryID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_parentCategoryID))
		q:(parentCategoryID = "")
		s parentCategoryID = $tr(parentCategoryID," ","")
		s seq = ""
		for 
		{
			s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_parentCategoryID,seq))
			q:(seq = "")
			s rowId = ""
			for
			{
				s rowId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_parentCategoryID,seq,rowId))
				q:(rowId = "")
				s objCatergory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(rowId)
				continue:(objCatergory = "")
				continue:(objCatergory.CategoryType '= "Category")
				s cjson = ..GetChildTemplateByParentCategoryID(rowId)
				continue:(cjson.Size = 0)
				d:(count '= 0) json.Write(",")
				d json.Write("{")
				d json.Write("""CategoryId"":"""_rowId_"""")
				d json.Write("""ParentCategoryID"":"""_objCatergory.ParentCategoryID_"""")
				d json.Write(",""CategoryName"":"""_objCatergory.CategoryName_"""")
				d json.Write(",""CategoryType"":"""_objCatergory.CategoryType_"""")
				d json.Write(",""child"":[")
				d json.CopyFrom(cjson)
				d json.Write("]")
				d json.Write("}")
				s count = count + 1
			}
		}
	}
	d json.OutputToDevice()
	q json
}

/// Desc:		按父节点ID取挂靠的目录
/// Creator:	Lina
/// CreateDate:	2016-12-15
/// InPut:      AParentCategoryID   父节点ID
/// OutPut:		CategoryId   目录CategoryId
/// 			CategoryName 目录名称
///             CategoryType 目录节点类型
/// Debug: 		w ##Class(EMRservice.BL.BLEMRTemplateCategory).GetChildTemplateByParentCategoryID(3)
ClassMethod GetChildTemplateByParentCategoryID(AParentCategoryID As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s cjson = ##Class(%GlobalCharacterStream).%New()
	q:(AParentCategoryID = "") json
	s count = 0
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentCategoryID,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentCategoryID,seq,rowId))
			q:(rowId = "")
			s objCatergory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(rowId)
			if (objCatergory.CategoryType '= "TempCate")
			{
				s cjson = ..GetChildTemplateByParentCategoryID(rowId)
				continue:(cjson.Size = 0)
			}
			d:(count '= 0) json.Write(",")
			d json.Write("{")
			d json.Write("""CategoryId"":"""_rowId_"""")
			d json.Write("""ParentCategoryID"":"""_objCatergory.ParentCategoryID_"""")
			d json.Write(",""CategoryName"":"""_objCatergory.CategoryName_"""")
			d json.Write(",""CategoryType"":"""_objCatergory.CategoryType_"""")
			d:(cjson.Size '= 0) json.Write(",""children"":[")
			d:(cjson.Size '= 0) json.CopyFrom(cjson)
			d:(cjson.Size '= 0) json.Write("]")
			d json.Write("}")
			s count = count + 1
		}
	}
	q json
}

}
