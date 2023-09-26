/// Class Name:		EMRservice.Observer.BOUpdateData
/// Description:	对电子病历订阅信息表的操作
/// Creator:		Lina
/// Create Date:	2015-09-17
Class EMRservice.Observer.BOUpdateData Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// Desc:   获取订阅信息列表
/// Creator: Lina
/// Input:  AEpisodeId
///         APatientId
///         AUserId
///         ATemplateId
///         Aaction
/// Output: Stream
/// Debug:  w ##Class(EMRservice.Observer.BOUpdateData).ObserverUpData("441","158","105","17","SAVE","")
ClassMethod ObserverUpData(AEpisodeId As %String, APatientId As %String, AUserId As %String, ATemplateId As %String, Aaction As %String, AInstanceDataID As %String = "") As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeId = "")||(APatientId = "")||(AUserId = "")||(ATemplateId = "")||(Aaction = "") json
	s tempjson = ""
	//Type的形式：^type1^type2^type3^...
	//Modified By Liuzhongwan
	s Type = "^"
	s event = Aaction_"|"_ATemplateId
	s result = ##class(EMRservice.Observer.Subject).GetSubjectInfo(event)
	
	s key = ""
	for i=1:1:result.Count()
	{
		s entity = result.GetNext(.key)
    	s code = entity.Code
    	s desc= entity.Description
	    s glossary= entity.Glossary
	    s type = entity.Type
	    s rowid = entity.ID
	    
	    s current = ""
	    s value = ..GetSubjectValue(AEpisodeId,entity)
	    s current = $p(value,"^",1)
	    s currentcode = $p(value,"^",2)
	    
	    s observer = ..GetObserverValue(APatientId,entity)
	    
	    s actionInfo = ..GetObserverAction(APatientId,AEpisodeId,value,observer,entity)
	    continue:(actionInfo = "")
	    
		d DisplayData
		//按照type_"json"的模式动态定义不同type的json变量名，用@exeCode引用该变量名
		//Modified By Liuzhongwan
		s exeCode = type_"json"
		if (Type[("^"_type_"^"))
		{
			//如果新订阅的type在Type中，说明对应的json串存在，在对应的json串后接该条订阅信息
			//Modified By Liuzhongwan
			s @exeCode = @exeCode_","_tempjson
		}else{
			//如果type不在Type中，新建一个json，并把type加入Type中
			//Modified By Liuzhongwan
			s @exeCode = tempjson
			s Type = Type_type_"^"
		}
		s tempjson = ""
	}
	//把各分类的json串合并
	s count=2
	for
	{
		s type = $p(Type,"^",count)
		q:(type="")
		s:(count>2) tempjson = tempjson_","
		s exeCode = type_"json"
		s tempjson = tempjson_"{""Type"":"""_type_""",""children"":["_@exeCode_"]}"
		s count=count+1
	}
	d json.Write($ZSTRIP(tempjson,"*C",,$c(1)_$c(2)))
	q json
DisplayData
	s tempjson = tempjson_"{""RowId"":"""_rowid_""","
	s tempjson = tempjson_"""Code"":"""_code_""","
	s tempjson = tempjson_"""Desc"":"""_desc_""","
	s tempjson = tempjson_"""CurrentCode"":"""_currentcode_""","
	s tempjson = tempjson_"""Current"":"""_current_""","	
	s tempjson = tempjson_"""Original"":"""_observer_""","
	s tempjson = tempjson_"""Glossary"":"""_glossary_""","
	s tempjson = tempjson_"""Type"":"""_type_""","
	s tempjson = tempjson_"""ActionInfo"":"""_actionInfo_"""}"
	q
}

/// Desc:	获取被订阅项目值
ClassMethod GetSubjectValue(AEpisodeID As %String, AESubject As EMRservice.entity.ESubject, AInstanceDataID As %String = "") As %String
{
	s value = ""
	q:(AESubject="") value
	if (AESubject.Type = "PaPatMas")
	{
		s categoryID = ""
		for {
			s categoryID = $o(^DHCEPRM.GlossaryI("IdxInternalID"," "_AESubject.Glossary,categoryID))
			q:(categoryID = "")
			s tempCategoryID = $tr(categoryID," ","")
			s categoryObj = ##class(EPRmeta.GlossaryCategory).%OpenId(tempCategoryID)
			s internalID = categoryObj.InternalID
			s glossarySet = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(AEpisodeID,internalID)
			s value = glossarySet.GetAt(AESubject.Glossary)
			q:(value '= "")
		}
	}
	elseif (AESubject.Type = "WMRInfection")
	{
		s value = ##Class(EMRservice.Observer.SubjectEPRInfo).GetInfoByType(AEpisodeID, AESubject.Type, AESubject.Event, AInstanceDataID)
	}
	elseif (AESubject.Type = "NosocomialInfection")
	{
		s value = ##Class(EMRservice.Record.FP).HasNosocomialInfection(AEpisodeID)
	}
	elseif (AESubject.Type = "RareDiseases")
	{
		s value = ##Class(EMRservice.Record.FP).HasRareDiseases(AEpisodeID)
	}
	
	q value
}

/// Desc:	获取观察者项目值
ClassMethod GetObserverValue(APatientID As %String, AESubject As EMRservice.entity.ESubject, AInstanceDataID As %String = "") As %String
{
	q:(AESubject="") ""
	if (AESubject.Type = "PaPatMas")
	{
		s value = ##Class(EMRservice.Observer).BLGetData(AESubject.Code,APatientID)
	}
	elseif (AESubject.Type = "WMRInfection")
	{
		s value = ""
	}
	elseif (AESubject.Type = "NosocomialInfection")
	{
		s value = ""
	}
	elseif (AESubject.Type = "RareDiseases")
	{
		s value = ""
	}
	else
	{
		s value = ""
	}
	q value
}

/// Desc:	观察者根据被订阅项目值、自身项目值及自身业务逻辑判断是否需要附加操作
ClassMethod GetObserverAction(APatientId As %String, AEpisodeID As %String, ASubjectValue As %String, AObserverValue As %String, AESubject As EPRservice.entity.ESubject) As %String
{
	
	if (AESubject.Type = "PaPatMas")
	{
		q:($p(ASubjectValue,"^",1) '= AObserverValue) "1"
	}
	elseif (AESubject.Type = "WMRInfection")
	{
		//传染病上报
		s actionInfo = ##Class(EMRservice.HISInterface.WMRInfo).GetInfectionInfo(APatientId,AEpisodeID,ASubjectValue)
		q actionInfo
	}
	elseif (AESubject.Type = "NosocomialInfection")
	{
		//院内感染
		q:($p(ASubjectValue,"^",1) '= "1") ""		//诊断中没有感染信息，无需上报
		s actionInfo = ##Class(EMRservice.HISInterface.WMRInfo).GetNosocomialInfection(AEpisodeID,$p(ASubjectValue,"^",2))
		q actionInfo
	}
	elseif (AESubject.Type = "RareDiseases")
	{
		//罕见病
		q:($p(ASubjectValue,"^",1) '= "1") ""		//诊断中没有感染信息，无需上报
		s actionInfo = ##Class(EMRservice.HISInterface.WMRInfo).GetRareDiseases(AEpisodeID,$p(ASubjectValue,"^",2))
		q actionInfo
	}
	
	q ""
}

}
