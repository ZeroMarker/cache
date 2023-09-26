Class EMRservice.BL.BLBindQuery Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Query SelectAllQuery() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,ClassName:%String,QueryName:%String,Description:%String,SingleResult:%String,Mark:%String,BindType:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_BindQuery_SELECTALLQuery, SqlProc ]
{
 SELECT ID,Name, ClassName, QueryName, Description,SingleResult,Mark,BindType
 FROM EMRmeta.BindQuery
 ORDER BY ID
}

Query SelectFieldByQID(AQID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String, QueryID:%String,FieldName:%String,FieldType:%String,Description:%String,DicID:%String,ValueType:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_BindField_SELECTFieldByQID, SqlProc ]
{
 SELECT ID,Name, QueryID, FieldName,FieldType, Description, DicID,ValueType
 FROM EMRmeta.BindField
 Where QueryID =:AQID 
 ORDER BY ID
}

ClassMethod AddQuery(ABindQuery As EMRservice.entity.EBindQuery) As %String [ WebMethod ]
{
	 s objBindQuery = ##class(EMRmeta.BindQuery).%New()
	 q:(objBindQuery ="") "ERROR" 
	 s objBindQuery.Name = ABindQuery.Name
	 s objBindQuery.ClassName = ABindQuery.ClassName
	 s objBindQuery.Description = ABindQuery.Description
	 s objBindQuery.QueryName = ABindQuery.QueryName
	 s objBindQuery.SingleResult = ABindQuery.SingleResult
	 s objBindQuery.Mark = ABindQuery.Mark
	 s objBindQuery.BindType = ABindQuery.BindType
	 if '(objBindQuery.%Save())
	 {
	 	q 0
	 } 
	 q objBindQuery.%Id()
}

ClassMethod DelQueryByID(AID As %String) As %Boolean [ WebMethod ]
{
	 s objBindQuery = ##class(EMRmeta.BindQuery).%OpenId(AID)
	 q:(objBindQuery ="") 0 

	 d ##class(EMRservice.BL.BLBindField).DelFieldByQueryId(AID) 
	 d ##class(EMRservice.BL.BLBindParameter).DelParameterByQueryId(AID) 

	 if '(objBindQuery.%DeleteId(AID))
	 {
	 	q 0
	 } 
	 q 1
}

ClassMethod GetQueryByID(AID As %String) As EMRservice.entity.EBindQuery [ WebMethod ]
{
 s objBindQuery = ##class(EMRmeta.BindQuery).%OpenId(AID)
 q:(objBindQuery="") ""
 s Result = ##class(EMRservice.entity.EBindQuery).%New()
 s Result.ID = objBindQuery.%Id()
 s Result.ClassName = objBindQuery.ClassName
 s Result.QueryName = objBindQuery.QueryName
 s Result.SingleResult = objBindQuery.SingleResult
 s Result.Description = objBindQuery.Description
 s Result.BindType = objBindQuery.BindType
 q Result
}

ClassMethod UpdateQuery(ABindQuery As EMRservice.entity.EBindQuery) As %String [ WebMethod ]
{
	 s objBindQuery = ##class(EMRmeta.BindQuery).%OpenId(ABindQuery.ID)
	 q:(objBindQuery ="") "0"
	 s objBindQuery.Name = ABindQuery.Name
	 s objBindQuery.ClassName = ABindQuery.ClassName
	 s objBindQuery.Description = ABindQuery.Description
	 s objBindQuery.QueryName = ABindQuery.QueryName
	 s objBindQuery.SingleResult = ABindQuery.SingleResult
	 s objBindQuery.Mark = ABindQuery.Mark

	 if '(objBindQuery.%Save())
	 {
		 q "0"
	 } 
	 q "1"
}

ClassMethod SelectIDByClassName(AClassName As %String, AQueryName As %String) As %String
{
 &sql(SELECT Count(ID)
 Into :CountID
 FROM EMRmeta.BindQuery
 where QueryName= :AQueryName
 and ClassName =:AClassName)
 if (CountID=0)
 {s Result="" }
 elseif (CountID >=0)
 {
 &sql(SELECT ID
 Into :Result
 FROM EMRmeta.BindQuery
 where QueryName= :AQueryName
 and ClassName =:AClassName)

 }
 QUIT Result
}

/// Desc:       绑定病历目录
/// Modify:     DONGLULU
/// DateTime:   2015-10-21
/// OutPut:     所绑定病历目录的json数据 
/// w ##Class(EMRservice.BL.BLBindQuery).GetRecordCategoryJson()
ClassMethod GetRecordCategoryJson() As %GlobalCharacterStream
{
	s TempParentId = ""
	s result = ##Class(%GlobalCharacterStream).%New() 
	s TempChildId = ""
	s GrandChildId = ""
	s children = ##Class(%GlobalCharacterStream).%New()
	s grandchild = ##Class(%GlobalCharacterStream).%New()
	s TemplateId = ""
	s TemplateName = ""
	s TemplateFirst = ##Class(%GlobalCharacterStream).%New()
	s TemplateFirstId = ""
	s TemplateFirstName = ""
	s json = ##Class(%GlobalCharacterStream).%New()
	s TemplateJson = ##Class(%GlobalCharacterStream).%New()
	d result.Write("[")
	for{
		s TempParentId=$o(^DHCEMRM.TemplateCategoryI("IdxParentId"," 0",TempParentId))
		q:(TempParentId = "") 
		s TempParentName=$lg((^DHCEMRM.TemplateCategoryD(TempParentId)),5)
		s TempParentName = $ZSTRIP(TempParentName,"*C")
		s TempParentName = ##Class(EMRservice.Tools.Tool).ReplaceCacheSpecialWord(TempParentName)
		if (result.Size '= "1")
		{
			d result.Write(",")
		}
		d result.Write("{")
		d result.Write("""id"":"""_TempParentId_""""_",")
		d result.Write("""text"":"""_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.TemplateCategory","Name",TempParentName)_""""_",")
		d result.Write("""iconCls"":"""_"user-folder-open"_"""")
		d result.Write(",""attributes"":{")
		d result.Write("""type"":"""_"Category"_"""")
		d result.Write("}")
		d children.Clear()
		for{
			s TempChildId=$o(^DHCEMRM.TemplateCategoryI("IdxParentId"," "_TempParentId,TempChildId))
			q:(TempChildId = "")
			s TempChildName=$lg((^DHCEMRM.TemplateCategoryD(TempChildId)),5)
			s TempChildName = $ZSTRIP(TempChildName,"*C")
			s TempChildName = ##Class(EMRservice.Tools.Tool).ReplaceCacheSpecialWord(TempChildName)
			if (children.Size '= 0)
			{
				d children.Write(",")
			}
			d children.Write("{")
			d children.Write("""id"":"""_TempChildId_""""_",")
			d children.Write("""text"":"""_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.TemplateCategory","Name",TempChildName)_""""_",")
			d children.Write("""iconCls"":"""_"user-folder-open"_"""")
			d children.Write(",""attributes"":{")
			d children.Write("""type"":"""_"Category"_"""")
			d children.Write("}")		
			d grandchild.Clear()
			for{
				s GrandChildId=$o(^DHCEMRM.TemplateCategoryI("IdxParentId"," "_TempChildId,GrandChildId))
				q:(GrandChildId = "")
				s GrandChildName=$lg((^DHCEMRM.TemplateCategoryD(GrandChildId)),5)
				s GrandChildName = $ZSTRIP(GrandChildName,"*C")
				s GrandChildName = ##Class(EMRservice.Tools.Tool).ReplaceCacheSpecialWord(GrandChildName)
				if (grandchild.Size '= 0)
				{
					d grandchild.Write(",")
				}
				d grandchild.Write("{")
				d grandchild.Write("""id"":"""_GrandChildId_""""_",")
				d grandchild.Write("""text"":"""_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.TemplateCategory","Name",GrandChildName)_""""_",")
				d grandchild.Write("""iconCls"":"""_"user-folder-open"_"""")
				d grandchild.Write(",""attributes"":{")
				d grandchild.Write("""type"":"""_"Category"_"""")
				d grandchild.Write("}")
				d TemplateJson.Clear()
				for{
					s TemplateId = $o(^DHCEMRM.TemplateI("IndexCategoryId"," "_GrandChildId,TemplateId))
					q:(TemplateId = "")
					s TemplateName = $lg((^DHCEMRM.TemplateD(TemplateId)),15)
					s TemplateName = $ZSTRIP(TemplateName,"*C")
					s TemplateName = ##Class(EMRservice.Tools.Tool).ReplaceCacheSpecialWord(TemplateName)
					if (TemplateJson.Size '= 0)
					{
						d TemplateJson.Write(",")
					}
					d TemplateJson.Write("{")
					d TemplateJson.Write("""id"":"""_TemplateId_""""_",")
					d TemplateJson.Write("""text"":"""_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Template","Name",TemplateName)_""""_",")
					d TemplateJson.Write("""iconCls"":"""_"new-category"_"""")
					d TemplateJson.Write(",""attributes"":{")
					d TemplateJson.Write("""type"":"""_"Template"_"""")
					d TemplateJson.Write("}")
					d TemplateJson.Write("}")
				}
				
				if ($o(^DHCEMRM.TemplateI("IndexCategoryId"," "_GrandChildId,""))'="")
				{
					d grandchild.Write(",""children"":[")
					d grandchild.CopyFrom(TemplateJson)
					d grandchild.Write("]")
				}
				d grandchild.Write("}")
				}
			d TemplateFirst.Clear()
			for{
				s TemplateFirstId = $o(^DHCEMRM.TemplateI("IndexCategoryId"," "_TempChildId,TemplateFirstId))
				q:(TemplateFirstId = "")
				s TemplateFirstName = $lg((^DHCEMRM.TemplateD(TemplateFirstId)),15)
				s TemplateFirstName = $ZSTRIP(TemplateFirstName,"*C")
				s TemplateFirstName = ##Class(EMRservice.Tools.Tool).ReplaceCacheSpecialWord(TemplateFirstName)
				if (TemplateFirst.Size '= 0)
				{
					d TemplateFirst.Write(",")
				}
				d TemplateFirst.Write("{")
				d TemplateFirst.Write("""id"":"""_TemplateFirstId_""""_",")
				d TemplateFirst.Write("""text"":"""_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Template","Name",TemplateFirstName)_""""_",")
				d TemplateFirst.Write("""iconCls"":"""_"new-category"_"""")
				d TemplateFirst.Write(",""attributes"":{")
				d TemplateFirst.Write("""type"":"""_"Template"_"""")
				d TemplateFirst.Write("}")
				d TemplateFirst.Write("}")
				}
			if ($o(^DHCEMRM.TemplateI("IndexCategoryId"," "_TempChildId,""))'="")
			{
				d children.Write(",""children"":[")
				d children.CopyFrom(TemplateFirst)
				d children.Write("]")
			}
			if ($o(^DHCEMRM.TemplateCategoryI("IdxParentId"," "_TempChildId,""))'="")
			{
				d children.Write(",""children"":[")
				d children.CopyFrom(grandchild)
				d children.Write("]")
			}
			d children.Write("}")
			}
		s TemplateFirstStageId = ""
		s TemplateFirstStageName = ""
		for{
			s TemplateFirstStageId = $o(^DHCEMRM.TemplateI("IndexCategoryId"," "_TempParentId,TemplateFirstStageId))
			q:(TemplateFirstStageId = "")
			s TemplateFirstStageName = $lg((^DHCEMRM.TemplateD(TemplateFirstStageId)),15)
			s TemplateFirstStageName = $ZSTRIP(TemplateFirstStageName,"*C")
			s TemplateFirstStageName = ##Class(EMRservice.Tools.Tool).ReplaceCacheSpecialWord(TemplateFirstStageName)
			if (children.Size '= 0)
			{
				d children.Write(",")
			}
			d children.Write("{")
			d children.Write("""id"":"""_TemplateFirstStageId_""""_",")
			d children.Write("""text"":"""_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Template","Name",TemplateFirstStageName)_""""_",")
			d children.Write("""iconCls"":"""_"new-category"_"""")
			d children.Write(",""attributes"":{")
			d children.Write("""type"":"""_"Template"_"""")
			d children.Write("}")
			d children.Write("}")
			}	
			
		if (($o(^DHCEMRM.TemplateCategoryI("IdxParentId"," "_TempParentId,""))'="")||($o(^DHCEMRM.TemplateI("IndexCategoryId"," "_TempParentId,""))'=""))
		{
			d result.Write(",""children"":[")
			d result.CopyFrom(children)
			d result.Write("]")
		}
		d result.Write("}")
		}
	d result.Write("]")
	d json.Write("["_"{")
	d json.Write("""text"":"""_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.TemplateCategory","Name","病历模板")_""""_",")
	d json.Write("""iconCls"":"""_"user-folder-open"_"""")
	d json.Write(",""children"":")
	d json.CopyFrom(result)
	d json.Write("}"_"]")
	q json
}

/// Desc:       取所选模板的metadata数据
/// Modify:     DONGLULU
/// DateTime:   2015-10-27
/// InPut:      TemplateID  所选病历的TemplateID  
/// OutPut:     result  所选病历的metadata数据流  
ClassMethod GetMetaData(ATemplateID As %String) As %GlobalBinaryStream
{
	s result = ##Class(%GlobalBinaryStream).%New()
	q:(ATemplateID = "") result
	s objTempalte = ##Class(EMRmeta.Template).%OpenId(ATemplateID)
	q:(objTempalte = "") result
	//取病历的最新发布版本ID
	s VersionNumber = objTempalte.PublishVersion
	s templateVersionId = $o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_ATemplateID,VersionNumber,""))
	q:(templateVersionId = "") result
	s objTemplateVersion = ##Class(EMRmeta.TemplateVersion).%OpenId(templateVersionId)
	q:(objTemplateVersion = "") result
	//取最新发布病历版本的MetaData
	s metaStream = objTemplateVersion.MetaData
	while (metaStream.AtEnd = 0)
	{
		d result.Write($ZCONVERT(metaStream.Read(32000),"I","UTF8"))
	}
	q result
}

}
