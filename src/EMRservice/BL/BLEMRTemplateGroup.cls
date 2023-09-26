Class EMRservice.BL.BLEMRTemplateGroup Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:		获取模板组下拉框数据
/// Mender:     Candyxu
/// ModifyDate: 2017-8-17
/// Input:      argLocID 科室ID
/// Output:     模板组列表
/// Debug:      w ##Class(EMRservice.BL.BLEMRTemplateGroup).GetEMRTemplateGroup(6)
ClassMethod GetEMRTemplateGroup(argLocID As %String) As %GlobalBinaryStream
{
	s json = ""
	q:(argLocID = "") json
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s groupCode = ""
	for
	{
		s groupCode = $o(^DHCEMRM.EMRTemplateGroupLocI("IdxCTLocIDCode"," "_argLocID,groupCode))
		q:(groupCode = "")
		s rowId = $o(^DHCEMRM.EMRTemplateGroupI("IdxTemplateGroupCode",groupCode,""))
		continue:(rowId = "")
		s objTemplateGroup = ##class(EMRmeta.EMRTemplateGroup).%OpenId(rowId)
		continue:(objTemplateGroup = "")
		s name = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateGroup","TemplateGroupName",objTemplateGroup.TemplateGroupName,langid)
		s:(json '= "") json = json_","
		s json = json_"{"
		s json = json_"""TemplateGroupCode"":"""_objTemplateGroup.TemplateGroupCode_""""
		s json = json_",""TemplateGroupName"":"""_name_""""
		s json = json_"}"
	}
	k objTemplateGroup
	q json
}

/// Desc:		获取指定模板组下的模板
/// Debug:      w ##Class(EMRservice.BL.BLEMRTemplateGroup).GetTempCateJsonByGroupCode("5","1")
ClassMethod GetTempCateJsonByGroupCode(AEpisodeID As %String, AGroupCode As %String) As %GlobalBinaryStream
{
	q:(AGroupCode = "")
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s json = ##Class(%GlobalCharacterStream).%New()
	s userTemplateCode = ""
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateItemI("IdxItemSeq"," "_AGroupCode,seq))
		q:(seq = "")
		s rowid = $o(^DHCEMRM.EMRTemplateItemI("IdxItemSeq"," "_AGroupCode,seq,""))
		q:(rowid = "")
		s objItem = ##class(EMRmeta.EMRTemplateItem).%OpenId(rowid)
		q:(objItem = "")
		s userTemplateCode = $case(objItem.UserTemplateCode,"":"",$c(0):"",:objItem.UserTemplateCode)
		s titleCode = $case(objItem.TitleCode,"":"",$c(0):"",:objItem.TitleCode)
		s templateID = objItem.EMRTemplateID
		q:(templateID = "")
		s obj = ##class(EMRmeta.EMRTemplate).%OpenId(templateID)
		q:(obj = "")
		
		
		s objdoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(obj.CategoryID)
		continue:(objdoc = "")
		s objchapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objdoc.ParentCategoryID)
		continue:(objchapter = "")
		s objcategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objchapter.ParentCategoryID)
		continue:(objcategory = "")
		s JaneSpell = objchapter.JaneSpell
	    s FullFight = objchapter.FullFight
	    s objTemplate=##Class(EMRmeta.Template).%OpenId(obj.BindTemplateID)
	    continue:(objTemplate = "")
		
		s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID, obj.BindTemplateID,obj.CategoryID)
		continue:((result '= 0) && (objTemplate.ChartItemType = "Single"))
		
		d GetJson
		s cjson = $ZSTRIP(cjson,"*C")
		d:(json.Size>0) json.Write(",")
		d json.Write(cjson)
	}
	k obj,objdoc,objchapter,objcategory,objTemplate
	q json
GetJson
	s name = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRTemplateCategory","CategoryName",objchapter.CategoryName,langid)
	s cjson = "{"
	s cjson = cjson_ """id"":"""_obj.CategoryID_""""
	s cjson = cjson_ ",""text"":"""_name_""""
	s cjson = cjson_ ",""type"":""TempCate""" 
	s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
	s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
	s cjson = cjson_ ",""isLeadframe"":"""_objdoc.IsLeadframe_""""
	s cjson = cjson_ ",""isMutex"":"""_objchapter.IsMutex_""""
	s cjson = cjson_ ",""templateId"":"""_obj.BindTemplateID_""""
	//科室模板编码不为空时，添加科室模板编码信息
	if (userTemplateCode'="")
	{
		s cjson = cjson_ ",""userTemplateCode"":"""_userTemplateCode_""""
	}
	//标题不为空时，添加标题编码
	if (titleCode'="")
	{
		s cjson = cjson_ ",""titleCode"":"""_titleCode_""""
	}
	s cjson = cjson_ ",""categoryId"":"""_objchapter.ParentCategoryID_""""
	s cjson = cjson_ ",""JaneSpell"":"""_objchapter.JaneSpell_"""" 
	s cjson = cjson_ ",""FullFight"":"""_objchapter.FullFight_""""
	s cjson = cjson_ ",""groupCode"":"""_AGroupCode_""""
	s cjson = cjson_",""characteristic"":"""_objdoc.IsLeadframe_""""
	s cjson = cjson_ "}"
	q
}

/// Desc:		获取指定模板组下的实例
/// Debug:      w ##Class(EMRservice.BL.BLEMRTemplateGroup).GetInstanceJsonByGroupCode("112","C001","Save")
ClassMethod GetInstanceJsonByGroupCode(AEpisodeID As %String, AGroupCode As %String, AStatus As %String) As %GlobalBinaryStream
{
	q:((AEpisodeID = "")||(AGroupCode = ""))
	s json = ##Class(%GlobalCharacterStream).%New()
	s InstanceId = ""
	for
	{
		s InstanceId = $o(^DHCEMRI.TemplateGroupDocI("IdxMain"," "_AEpisodeID," "_AGroupCode,InstanceId))
		q:(InstanceId = "")
		s tempInstanceId = $tr(InstanceId," ","")
		s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tempInstanceId)
		continue:(objInstance.Status '= AStatus)
		s ecrecordId = $p(tempInstanceId,"||",1)
		s subId = $p(tempInstanceId,"||",2)
		s tempJson = ##Class(EMRservice.BL.BLClientCategory).GetInstanceJsonByID(ecrecordId,subId)
		continue:(tempJson = "")
		s tempJson = $ZSTRIP(tempJson,"*C")
		d:(json.Size>0) json.Write(",")
		d json.Write(tempJson)
	}
	q json
}

/// Desc:       保存关联文档
/// Debug:      w ##Class(EMRservice.BL.BLEMRTemplateGroup).SaveItemDocument("1","29||1","5","27","手术同意书","EMR070001")
ClassMethod SaveItemDocument(ATemplateGroupCode As %String, AInstanceID As %String, AEpisodeID As %String) As %String
{
	s result = "0"
	q:(AInstanceID = "")||(ATemplateGroupCode = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s rowId = ""
	s rowId = $o(^DHCEMRI.TemplateGroupDocI("IdxMain"," "_AEpisodeID," "_ATemplateGroupCode," "_AInstanceID,rowId))
	if (rowId '= "")
	{
		s obj = ##Class(EMRinstance.TemplateGroupDocument).%OpenId(rowId)
	}
	else
	{
	    s obj = ##Class(EMRinstance.TemplateGroupDocument).%New()
	    s obj.EpisodeID = AEpisodeID
	    s obj.GroupCode = ATemplateGroupCode
	}
    s obj.InstanceID  = AInstanceID    
    s $zt = "ErrorHandler"
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		s result = "1"
	}
	k obj,objInstance
	q result
	 
ErrorHandler
    q result
}

/// Desc:		初始化EMRTemplateGroup表
/// CreateDate:	2017-05-06
/// Debug: 		w ##Class(EMRservice.BL.BLEMRTemplateGroup).initEMRTemplateGroup("1","知情告知模板组")
ClassMethod initEMRTemplateGroup(ATemplateGroupCode As %String, ATemplateGroupName As %String) As %String
{
	s result = "0"
	q:((ATemplateGroupCode = "")&&(ATemplateGroupName = "")) result
	s obj = ##class(EMRmeta.EMRTemplateGroup).%New()
	s obj.TemplateGroupCode = ATemplateGroupCode
	s obj.TemplateGroupName = ATemplateGroupName
	
	s $zt = "ErrorHandler"
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{

		s result = obj.%Id()
	}
	k obj
	q result
	 
ErrorHandler
    q result
}

/// Desc:		初始化EMRTemplateItem表
/// CreateDate:	2017-05-06
/// Debug: 		w ##Class(EMRservice.BL.BLEMRTemplateGroup).initEMRTemplateItem("1","30^31")
ClassMethod initEMRTemplateItem(ATemplateGroupCode As %String, AIDs As %String) As %String
{
    s $zt = "ErrorHandler"
	s result = "0"
    s errflag = "0"
	q:(ATemplateGroupCode = "") result
    Tstart
	for i=1:1:$l(AIDs,"^")
	{
		s ID = $p(AIDs,"^",i)
		continue:(ID = "")
		s obj = ##class(EMRmeta.EMRTemplateItem).%New()
		s obj.TemplateGroupCode = ATemplateGroupCode
		s obj.EMRTemplateID = ID
		s templateobj = ##class(EMRmeta.EMRTemplate).%OpenId(ID)
		s obj.EMRTemplateName = templateobj.TemplateName
		s sc = obj.%Save()
		if ($$$ISOK(sc))
		{
			s:(i '= 1) result = result_","
			s result = $case(result,"0":"",:result)_obj.%Id()
		}
        else
		{
			s errflag = "1"
			q
		}
	}
	
    if (errflag = "1")
	{
		Trollback
	}
	else
	{
		TCOMMIT
	}
    
	k obj,templateobj
	q result
	 
ErrorHandler
    Trollback
    q result
}

/// Desc:		获取指定模板组下的实例(知情告知分组显示，单个创建，不是批量创建，实例显示在该分组中)
/// Debug:      w ##Class(EMRservice.BL.BLEMRTemplateGroup).GetInstanceJsonByGroupCodeSingle("112","C001","Save")
ClassMethod GetInstanceJsonByGroupCodeSingle(AEpisodeID As %String, AGroupCode As %String, AStatus As %String) As %GlobalBinaryStream
{
	q:((AEpisodeID = "")||(AGroupCode = ""))
	s json = ##Class(%GlobalCharacterStream).%New()
	s tempJson = ##Class(%GlobalCharacterStream).%New()
	s templateID = ""
	for
	{
		s templateID = $o(^DHCEMRM.EMRTemplateItemI("IdxItemCode"," "_AGroupCode," "_templateID))
		s templateID = $tr(templateID," ","")
		q:(templateID = "")
		s obj = ##class(EMRmeta.EMRTemplate).%OpenId(templateID)
		q:(obj = "")
		s docId = obj.CategoryID
		s tempJson = ##Class(EMRservice.BL.BLClientCategory).DoInstanceJsonByDocID(docId,AEpisodeID,AStatus,"List","")
		continue:(tempJson.Size = 0)
		d:(json.Size>0) json.Write(",")
		d json.CopyFrom(tempJson)
	}
	q json
}

}
