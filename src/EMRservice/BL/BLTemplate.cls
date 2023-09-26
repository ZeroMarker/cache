Class EMRservice.BL.BLTemplate Extends %RegisteredObject
{

ClassMethod GetIDBYCATEGORY(ACategoryID As %String, AEpisodeType As %String) As %String
{
 &sql(SELECT Count(ID)
 into :NumCount
 FROM EMRmeta.Template
 WHERE TemplateCategoryID = :ACategoryID)
 if ('NumCount=0)
 {
 &sql(SELECT ID
 into :Result
 FROM EMRmeta.Template
 WHERE TemplateCategoryID = :ACategoryID) 
 QUIT Result	  
 }
 elseif (NumCount=0)
 {
	Quit "" 	 
 }
}

ClassMethod GetReplaceIDBYCATEGORY(ACategoryID As %String, AName As %String) As %String
{
 &sql(SELECT Count(ID)
 into :NumCount
 FROM EMRmeta.Template
 WHERE TemplateCategoryID = :ACategoryID
 And Name =:AName
 )
 if ('NumCount=0)
 {
 &sql(SELECT ID
 into :Result
 FROM EMRmeta.Template
 WHERE TemplateCategoryID = :ACategoryID
 And Name =:AName ) 
 QUIT Result
	  
	  }
 elseif (NumCount=0)
 {
	Quit "" 	 }
}

ClassMethod GetTitleBYID(AID As %String) As %String
{
 
 &sql(SELECT Name
 into :Result 
 FROM EMRmeta.Template
 WHERE ID = :AID)
 QUIT Result
}

ClassMethod GetVersionBYID(AID As %String) As %Integer
{
 
 &sql(SELECT PublishVersion
 into :Result 
 FROM EMRmeta.Template
 WHERE ID = :AID)
 QUIT Result
}

ClassMethod SELECTBYGUID(AGUID As %String) As %String
{
 
 &sql(SELECT ID
 into :Result 
 FROM EMRmeta.Template
 WHERE GUID = :AGUID)
 QUIT Result
}

Query SELECTALLByCategoryID(ACategoryID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,GUID:%String,TemplateCategoryID:%String,Description:%String,PublishVersion:%Integer,LastVersion:%Integer,ChartItemType:%String,Code:%String,DocumentType:%String,DisplayName:%String,TemplateProperty:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_Template_SELECTALLByCategoryID, SqlProc ]
{
SELECT ID, Name, GUID,TemplateCategoryID, Description,PublishVersion,LastVersion,ChartItemType,Code,DocumentType,DisplayName,TemplateProperty
 FROM EMRmeta.Template
 WHERE TemplateCategoryID = :ACategoryID 
 ORDER BY ID
}

Query SELECTALLTemplate() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,GUID:%String,TemplateCategoryID:%String,Description:%String,PublishVersion:%Integer,LastVersion:%Integer,ChartItemType:%String,Code:%String,DocumentType:%String,DisplayName:%String,TemplateProperty:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_Template_SELECTALLTemplate, SqlProc ]
{
SELECT ID, Name, GUID,TemplateCategoryID, Description,PublishVersion,LastVersion,ChartItemType,Code,DocumentType,DisplayName,TemplateProperty
 FROM EMRmeta.Template
 ORDER BY ID
}

Query SelectForSltByCId(ACategoryID As %String, AEpisodeID As %String) As %Query(ROWSPEC = "ID:%String,Name:%String,GUID:%String,TemplateCategoryID:%String,Description:%String,PublishVersion:%String,LastVersion:%String,ChartItemType:%String,Code:%String,DocumentType:%String,DisplayName:%String")
{
}

ClassMethod SelectForSltByCIdExecute(ByRef qHandle As %Binary, ACategoryID As %String, AEpisodeID As %String) As %Status
{
	;b "s"	
	Set repid=$I(^CacheTemp)
	s ind=1
	s qHandle=""
 	s checkResult=""
 	s TemplateId="0"
 	s RowList="" 	
 	s TPrivActivity = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("TPRIVACTIVITY") 
	i TPrivActivity'="N"  d
 	.f  s TemplateId=$o(^DHCEPRM.TemplateI("IndexCategoryId"," "_ACategoryID,TemplateId))  q:TemplateId=""  d
 	..s checkResult = ##class(EMRservice.TPrivLogic.PrivLogic).CheckTempValid(AEpisodeID,"",TemplateId)
 	..q:checkResult'=1  d
 	..s objTemplate=##Class(EMRmeta.Template).%OpenId(TemplateId)
 	..s Name=objTemplate.Name
 	..s GUID = objTemplate.GUID 
 	..s TemplateCategoryID =objTemplate.TemplateCategoryID
 	..s Description = objTemplate.Description
 	..s PublishVersion =objTemplate.PublishVersion
 	..s LastVersion =objTemplate.LastVersion
 	..s ChartItemType =objTemplate.ChartItemType
 	..s Code =objTemplate.Code
 	..s DocumentType =objTemplate.DocumentType
 	..s DisplayName =objTemplate.DisplayName
 	..s TemplateProperty =objTemplate.TemplateProperty
 	..s Data = $lb(TemplateId,Name,GUID,TemplateCategoryID,Description,PublishVersion,LastVersion,ChartItemType,Code,DocumentType,DisplayName,TemplateProperty)
    ..S ^CacheTemp(repid,ind)=Data	
    ..S ind=ind+1
 	e  d
 	.f  s TemplateId=$o(^DHCEPRM.TemplateI("IndexCategoryId"," "_ACategoryID,TemplateId))  q:TemplateId=""  d
 	..s objTemplate=##Class(EMRmeta.Template).%OpenId(TemplateId)
 	..s Name=objTemplate.Name
 	..s GUID =objTemplate.GUID 
 	..s TemplateCategoryID =objTemplate.TemplateCategoryID
 	..s Description = objTemplate.Description
 	..s PublishVersion =objTemplate.PublishVersion
 	..s LastVersion =objTemplate.LastVersion
 	..s ChartItemType =objTemplate.ChartItemType
 	..s Code =objTemplate.Code
 	..s DocumentType =objTemplate.DocumentType
 	..s DisplayName =objTemplate.DisplayName
 	..s TemplateProperty =objTemplate.TemplateProperty
 	..s Data = $lb(TemplateId,Name,GUID,TemplateCategoryID,Description,PublishVersion,LastVersion,ChartItemType,Code,DocumentType,DisplayName,TemplateProperty)
    ..S ^CacheTemp(repid,ind)=Data	
    ..S ind=ind+1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod SelectForSltByCIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectForSltByCIdExecute ]
{
	s qHandle="" 
	Quit $$$OK
}

ClassMethod SelectForSltByCIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectForSltByCIdExecute ]
{
 Set AtEnd=$li(qHandle,1)
 Set repid=$li(qHandle,2)
 Set ind=$li(qHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query SELECTALLWithGroupByCategoryID(ACategoryID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,GUID:%String,TemplateCategoryID:%String,Description:%String,PublishVersion:%Integer,LastVersion:%Integer,ChartItemType:%String,Code:%String,DocumentType:%String,DisplayName:%String,TemplateProperty:%String,GroupId:%String,GroupName:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_Template_SELECTALLWithGroupByCategoryID, SqlProc ]
{
	SELECT t.ID, t.Name, t.GUID,t.TemplateCategoryID, t.Description,t.PublishVersion,t.LastVersion,t.ChartItemType,t.Code,t.DocumentType,t.DisplayName,t.TemplateProperty,g.TemplateGroup,g.TemplateGroup->GroupName
	 FROM EMRmeta.Template t
	 left join EMRmeta_TemplatePriv.TemplatesInGroup g on (t.ID = g.template) where t.TemplateCategoryID = :ACategoryID
	 ORDER BY t.ID
}

/// Creator：      guozongtao
/// CreatDate：    2014-1-23
/// Description:   根据EMRmeta.EMRTemplateCategory.ID获取EMRmeta.Template对象 
/// Table：        
/// Input：        argEMRTemplateCategoryID :EMRmeta.EMRTemplateCategory.ID
/// Output         
/// Return：       EMRservice.entity.ETemplate
/// Others：       其它说明
/// Debug:         w ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID("34")	
ClassMethod GetTemplateByEMRTmpCateID(argEMRTemplateCategoryID As %String) As EMRservice.entity.ETemplate
{
	s parentId=" "_argEMRTemplateCategoryID
	s entityTemplate=##Class(EMRservice.entity.ETemplate).%New()
	s flag = 0
	s curSeq = ""
	for {
		s curSeq = 	$o(^DHCEMRM.EMRTemplateI("IdxTemplateSeq",parentId,curSeq))
		q:(curSeq = "")
		s curTemplateId = ""
		for 
		{
			s curTemplateId = $o(^DHCEMRM.EMRTemplateI("IdxTemplateSeq",parentId,curSeq,curTemplateId))
			q:(curTemplateId = "")
			s objEMRTemplate=##Class(EMRmeta.EMRTemplate).%OpenId(curTemplateId)
			s curBindTemplateID = objEMRTemplate.BindTemplateID
			s objTemplate=##Class(EMRmeta.Template).%OpenId(curBindTemplateID)
			continue:(objTemplate = "")
			s entityTemplate.DocumentType=objTemplate.DocumentType
			s entityTemplate.ChartItemType=objTemplate.ChartItemType
			s entityTemplate.Description=objTemplate.Description
			s entityTemplate.GUID=objTemplate.GUID
			s entityTemplate.LastVersion=objTemplate.LastVersion
			s entityTemplate.Name=objTemplate.Name
			s entityTemplate.PublishVersion=objTemplate.PublishVersion
			s entityTemplate.TemplateCategoryID=objTemplate.TemplateCategoryID
			s entityTemplate.Code=objTemplate.Code
			s entityTemplate.DisplayName=objTemplate.DisplayName
			s entityTemplate.TemplateProperty=objTemplate.TemplateProperty
			s entityTemplate.ID=curBindTemplateID
			d objTemplate.%Close()
         	s flag = 1
         	q:(flag = 1)
		}
		q:(flag = 1)
	}
	q entityTemplate
}

/// CreateTime: 2014-02-12
/// Creator:    candy
/// Desc:		文档信息
/// Input:		ATempLateID: 模板ID
///             AElementType: 根标签类型(template,Document)
///             ATitle: 标题
///             ATitleCode: 标题代码 
///             AMetaData: 元数据
///             AScriptData: 公式规则
///             AInstanceData: 实例数据
/// OutPut:     stream：xml文档流数据
ClassMethod GetRecordXML(ATempLateID As %String, AElementType As %String, ATitle As %String, ATitleCode As %String, AMetaData As %GlobalBinaryStream, AScriptData As %GlobalBinaryStream, AInstanceData As %GlobalBinaryStream, AMediasData As %GlobalBinaryStream, AInitialData As %GlobalBinaryStream) As %GlobalBinaryStream
{
	s stream = ##Class(%GlobalBinaryStream).%New()
	q:((ATempLateID= "")||(AElementType = "")) stream
	s objTemplate = ##Class(EMRmeta.Template).%OpenId(ATempLateID)
	q:((objTemplate = "")) stream
	s templatePropertyCode = "testCode"
	s templatePropertyName = "testName"
 	s ctPropRowID = $o(^DHCEMRM.CTPropertyI("IdxCode"," "_$zcvt(objTemplate.TemplateProperty,"U"),""))
	s objCTProperty = ##Class(EMRmeta.CTProperty).%OpenId(ctPropRowID)
	if (objCTProperty '= "")
	{
		s templatePropertyCode = $zcvt(objCTProperty.PropertyCode,"O","UTF8")
		s templatePropertyName = $zcvt(objCTProperty.PropertyName,"O","UTF8")
	}
	s code = $ZSTRIP(objTemplate.Code,"*C")  //去特殊字符
	s code = $zcvt(code,"O","UTF8") //转为UTF8码制
	s displayName = $ZSTRIP(objTemplate.DisplayName,"*C") //去特殊字符
	s displayName = $zcvt(displayName,"O","UTF8") //转为UTF8码制
	
	//xml流
	d stream.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
	d stream.Write("<"_AElementType_">")
	d stream.Write("<Code Code="""_code_""" DisplayName="""_displayName_"""/>")
	d stream.Write("<TemplateGUID>"_objTemplate.GUID_"</TemplateGUID>")
	d stream.Write("<TemplateType>"_objTemplate.ChartItemType_"</TemplateType>")
	d stream.Write("<TemplateProperty Code="""_templatePropertyCode_""" DisplayName="""_templatePropertyName_"""/>")
	
	if (AElementType = "Document")
	{
		s tmpTitlecode = $p(ATitleCode,"^",1)
		s tmpTitlecode = $zcvt(tmpTitlecode,"O","UTF8")
		s ATitle = $ZSTRIP(ATitle,"*C") 
		s ATitle = $zcvt(ATitle,"O","UTF8")	
		s ATitle = $replace(ATitle,"&","&amp;")
		s title = ATitle
		s titleRowId = $o(^DHCEMRM.TitlesI("IdxCode"," "_$zcvt(tmpTitlecode,"U"),""))
		if (titleRowId '= "")
		{
			s objTitle = ##Class(EMRmeta.Titles).%OpenId(titleRowId)
			q:(objTitle = "") stream
			s title = $zcvt(objTitle.Description,"O","UTF8")
			s title = $replace(ATitle,"&","&amp;")
		}
		d stream.Write("<Title Code="""_tmpTitlecode_""" DisplayName="""_title_""" NewDisplayName="""_ATitle_""">")
		d stream.Write("<TitleItems>")
		for i=1:1:$l(ATitleCode,"^")
		{
			s tmpcode = $p(ATitleCode,"^",i)
			s titleRowId = $o(^DHCEMRM.TitlesI("IdxCode"," "_$zcvt(tmpcode,"U"),""))
			continue:(titleRowId = "")
			s objTitle = ##Class(EMRmeta.Titles).%OpenId(titleRowId)
			continue:(objTitle = "")
			s tmpDesc = objTitle.Description
			s tmpcode = $zcvt(tmpcode,"O","UTF8")
			s tmpDesc = $zcvt(tmpDesc,"O","UTF8")	
			d stream.Write("<TitleItem Code="""_tmpcode_""" DisplayName="""_tmpDesc_"""/>")
		}
		d stream.Write("</TitleItems>")
		d stream.Write("</Title>")
	}
	else
	{
		d stream.Write("<Title Code="""_ATitleCode_""" DisplayName="""_ATitle_"""/>")
	}
	
	d stream.Write("<Macros>")
	d stream.Write("<Macro/>")
	d stream.Write("</Macros>")
	  
	//表格文档需要加打印信息
	d:( $zcvt(objTemplate.DocumentType,"U") = "GRID") stream.Write("<PrintSetup/>")
	d stream.Write("<StructuredBody>")
	d stream.CopyFrom(AMetaData)
	d stream.CopyFrom(AScriptData)
	d stream.CopyFrom(AMediasData)
	d stream.CopyFrom(AInitialData)
	d stream.CopyFrom(AInstanceData)
	d stream.Write("</StructuredBody>")
	d stream.Write("</"_AElementType_">") 
	k objTemplate,AMetaData,AScriptData,AInstanceData,AMediasData,AInitialData
	q stream
}

}
