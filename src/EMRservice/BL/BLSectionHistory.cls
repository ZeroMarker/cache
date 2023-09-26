/// Desc:       患者历史就诊章节数据逻辑
/// Creator:    Donglulu
/// CreateDate: 2020-11-17
Class EMRservice.BL.BLSectionHistory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       获取患者就诊列表信息
/// Creator:    Donglulu
/// CreateDate: 2020-11-17
/// Input:      APatientID 患者ID
///             ALocID 医生当前登录科室
/// Output:     患者就诊列表信息
/// Debug:      w ##Class(EMRservice.BL.BLSectionHistory).GetEpisodeList("20","6","26","S002","2020-10-25","2020-11-23","Loc")
ClassMethod GetEpisodeList(APatientID As %String, ALocID As %String, ATemplateID As %String, ASectionCode As %String, AStartDate As %String = "", AEndDate As %String = "", ALocSelect As %String = "Loc", ALastEpisode As %String = "", ACurrentEpisode As %String = "") As %GlobalCharacterStream
{
	s json = ""
	s result = ##Class(%GlobalCharacterStream).%New()
	s count = 0
	q:(APatientID = "")||(ALocID = "")||(ATemplateID = "")||(ASectionCode = "") result
	
	//按照输入的日期进行筛选输出 
	s dateFlag = 0
	if (AStartDate '= "")&&(AEndDate '= "")
	{
		s AStartDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",AStartDate)
		s AEndDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",AEndDate)
		s startDate = AStartDate
		s endDate = AEndDate
		s dateFlag = 1
	}
	
	//s type = ##Class(EMRservice.SystemParameter).GetSectionHistoryType()
	
	s findEpisode = "0"
	s currentFlag = "0"
	
	s secInfo=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("secHistoryInfo","5^N")
	
	//默认加载条数
	s secCount=$p(secInfo,"^",1)
	s secFilter=$p(secInfo,"^",2)
	
	s ds = ##Class(%Library.ResultSet).%New("EMRservice.HISInterface.EpisodeInfo:GetEpisodeListByPID")
	d ds.Execute(APatientID,"","")
	While (ds.Next())
	{
		//过滤当前选择就诊的就诊时间之后的时间
		if ((ACurrentEpisode '= "")&&(secFilter = "Y"))
		{
			if (ds.Data("EpisodeID") = ACurrentEpisode)
			{
				s currentFlag = "1"
				continue
			}
			continue:(currentFlag = "0")
		}
		
		//加载更多过滤
		if (ALastEpisode '= "")
		{
			if (ds.Data("EpisodeID") = ALastEpisode)
			{
				s findEpisode = "1"
				continue
			}
			continue:(findEpisode = "0")
		}

		//根据配置获取默认加载条数
		continue:(count >= secCount)
		
		//筛选本科或全院
		//continue:((type = "Loc")&&(ds.Data("EpisodeDeptID") '= ALocID))  
		continue:((ALocSelect = "Loc")&&(ds.Data("EpisodeDeptID") '= ALocID))
		//按照输入的日期进行筛选输出 
		if (dateFlag = 1)
		{
			
			s EpisodeDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",ds.Data("EpisodeDate"))
			continue:((EpisodeDate < startDate)||(EpisodeDate > endDate))
		}
		
		s sectionData = ##Class(EMRservice.BL.BLSectionHistory).GetSectionData(ds.Data("EpisodeID"),ATemplateID,ASectionCode)
		//相同术语集其他模板数据
		s otherDate = ##Class(EMRservice.BL.BLSectionHistory).GetSectionDataByGlossary(ds.Data("EpisodeID"),ATemplateID,ASectionCode)
		s:(otherDate '= "") sectionData = sectionData_"@@@"_otherDate
		s sectionData = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(sectionData)
		
		s json = "{"
		s json = json_"""EpisodeID"":"""_ds.Data("EpisodeID")_""","
		s json = json_"""MedicareNo"":"""_ds.Data("MedicareNo")_""","
		s json = json_"""SectionData"":"""_sectionData_""","
		s episodeDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("EpisodeDate"))
		s episodeTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("EpisodeTime"))
		s json = json_"""EpisodeDate"":"""_episodeDate_""","
		s json = json_"""EpisodeTime"":"""_episodeTime_""","
		//对于诊断中的单引号，这里输出已经使用了双引号，不会引起问题，直接输出单引号即可
		s json = json_"""Diagnosis"":"""_$tr(ds.Data("Diagnosis"),"\'","'")_""","
		s json = json_"""EpisodeType"":"""_ds.Data("EpisodeType")_""","			
		s json = json_"""EpisodeDeptDesc"":"""_ds.Data("EpisodeDeptDesc")_"""," 
		s json = json_"""EpisodeDeptID"":"""_ds.Data("EpisodeDeptID")_""","
		s json = json_"""MainDocName"":"""_ds.Data("MainDocName")_"""" 		
		s json = json_"}"

		s json = $ZSTRIP(json,"*C")
		
		if (count = "0")
		{
			d result.Write("[")
		}
		else
		{
			d result.Write(",")
		}
		d result.Write(json)
			
		s count = count + 1
	}
	
	d:(count '= "0") result.Write("]")
	q result
}

/// Desc:       获取该次就诊的章节数据（根据模板打散数据取）
/// Creator:    Donglulu
/// CreateDate: 2020-11-17
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ASectionCode 章节代码
/// Output:     result 章节历史数据（多条以@@@分隔）
/// Debug:      w ##Class(EMRservice.BL.BLSectionHistory).GetSectionData("631","27","S002")
ClassMethod GetSectionData(AEpisodeID As %String, ATemplateID As %String, ASectionCode As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(ATemplateID = "")||(ASectionCode = "") result
	
	s instanceID = ""
	for
	{
		s instanceID = $o(^DHCEMRI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_ASectionCode,instanceID))
		q:(instanceID = "")
		s objInstance = ##Class(EMRinstance.InstanceData).%OpenId($e(instanceID,2,*))
		q:(objInstance = "")
		s instanceStatus = $zcvt(objInstance.Status,"U")
		continue:(instanceStatus = "UNSAVE")||(instanceStatus = "DELETE")
		
		s rowID = $o(^DHCEMRI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_ASectionCode,instanceID,""))
		q:(rowID = "")
		s obj = ##Class(EMRinstance.ISectionDesc).%OpenId(rowID)
    	q:(obj = "") 
		s:((result '= "")&&(obj.Text.Size '= "0")) result = result_"@@@"
		s result = result_obj.Text.Read()
	}
	s result = $ZSTRIP(result,"*C")
	q result
}

/// Desc:       获取该次就诊的相同术语集其他模板章节数据
/// Creator:    Donglulu
/// CreateDate: 2020-11-17
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ASectionCode 章节代码
/// Output:     result 该次就诊的相同术语集其他模板章节历史数据（多条以@@@分隔）
/// Debug:      w ##Class(EMRservice.BL.BLSectionHistory).GetSectionDataByGlossary("631","27","S002")
ClassMethod GetSectionDataByGlossary(AEpisodeID As %String, ATemplateID As %String, ASectionCode As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(ATemplateID = "")||(ASectionCode = "") result
	
	s glossaryID = ##Class(EMRservice.BL.BLSectionHistory).GetGlossaryID(ATemplateID,ASectionCode)
	q:(glossaryID = "") result
	s itemRowID = ""
	for
	{
		s itemRowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",glossaryID,itemRowID))
		q:(itemRowID = "")
		s itemObj = ##Class(EPRmeta.GlossaryItem).%OpenId(itemRowID)
    	q:(itemObj = "") 
    	s templateID = itemObj.TemplateID
    	continue:(templateID = "")||(templateID = ATemplateID)
    	s itemCode = itemObj.ItemCode
    	s secondPart = $p(itemCode,"SCODE:",2)
    	s tmpSectionCode = $p(secondPart,"|",1)
    	continue:(tmpSectionCode = "")
    	s instanceID = ""
		for
		{
			s instanceID = $o(^DHCEMRI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_templateID," "_tmpSectionCode,instanceID))
			q:(instanceID = "")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId($e(instanceID,2,*))
			q:(objInstance = "")
			s instanceStatus = $zcvt(objInstance.Status,"U")
			continue:(instanceStatus = "UNSAVE")||(instanceStatus = "DELETE")
			
			s rowID = $o(^DHCEMRI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_templateID," "_tmpSectionCode,instanceID,""))
			q:(rowID = "")
			s obj = ##Class(EMRinstance.ISectionDesc).%OpenId(rowID)
	    	q:(obj = "") 
			s:((result '= "")&&(obj.Text.Size '= "0")) result = result_"@@@"
			s result = result_obj.Text.Read()
		}
	}
	
	s result = $ZSTRIP(result,"*C")
	q result
}

/// Desc:       获取术语集ID
/// Creator:    Donglulu
/// CreateDate: 2020-11-23
/// Input:      ATemplateID 模板ID
///             ASectionCode 章节代码
/// Output:     EPRmeta.Glossary表的ID
/// Debug:      w ##Class(EMRservice.BL.BLSectionHistory).GetGlossaryID("1","S002")
ClassMethod GetGlossaryID(ATemplateID As %String, ASectionCode As %String) As %String
{
	s result = ""
	q:(ATemplateID = "")||(ASectionCode = "") result
	
	s secContent = "SCODE:"_ASectionCode
	s itemCode = ""
	for
	{
		s itemCode = $o(^DHCEPRM.GlossaryItemI("IdxLink",ATemplateID,itemCode))
		q:(itemCode = "")
		continue:(itemCode '[ secContent)
		s secondPart = $p(itemCode,secContent,2)
		continue:((secondPart '= "")&&($e(secondPart,1) '= "|"))
		s valueType = $o(^DHCEPRM.GlossaryItemI("IdxLink",ATemplateID,itemCode,""))
		s result = $o(^DHCEPRM.GlossaryItemI("IdxLink",ATemplateID,itemCode,valueType,""))
		q:(result '= "")
	}	
	q result
}

}
