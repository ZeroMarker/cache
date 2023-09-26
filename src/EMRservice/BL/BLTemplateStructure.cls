Class EMRservice.BL.BLTemplateStructure Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLTemplateStructure","SELECTALLCATE")
Query SELECTALLCATE() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,StructType:%String,Description:%String,Code:%String,Name:%String,ParentID:%String,IsFixedSection:%String,ResChildCount:%Integer,GlossaryInternalID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_TemplateStructure_SELECTALLCATE, SqlProc ]
{
	SELECT ID,StructType,Description,Code,Name,ParentID,IsFixedSection,ResChildCount,GlossaryInternalID
	FROM EMRmeta.TemplateStructure
	WHERE StructType='Category' OR StructType='Document'
}

Query SelectDocumentData() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,StructType:%String,Description:%String,Code:%String,Name:%String,ParentID:%String,IsFixedSection:%String,ResChildCount:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_TemplateS_SelectDocumentData, SqlProc ]
{
	SELECT ID,StructType,Description,Code,Name,ParentID,IsFixedSection,ResChildCount 
	FROM EMRmeta.TemplateStructure
	WHERE StructType!='Category'
}

Query SelectDocumentByCode(ACode As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,StructType:%String,Description:%String,Code:%String,Name:%String,ParentID:%String,IsFixedSection:%String,ResChildCount:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_TemplateS_SelectDocumentByCode, SqlProc ]
{
	SELECT ID,StructType,Description,Code,Name,ParentID,IsFixedSection,ResChildCount 
	FROM EMRmeta.TemplateStructure
	WHERE StructType='Document' and Code =:ACode
}

Query SELECTALLSECTION(AParentID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,StructType:%String,Description:%String,Code:%String,Name:%String,ParentID:%String,IsFixedSection:%String,ResChildCount:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_TemplateStructure_SELECTALLSECTION, SqlProc ]
{
	SELECT ID,StructType,Description,Code,Name,ParentID,IsFixedSection,ResChildCount 
	FROM EMRmeta.TemplateStructure
	WHERE StructType='Section' AND ParentID = :AParentID
}

/// 创建一个数据元范畴
ClassMethod CreateTemplateStructure(aTemStructureInfo As EMRservice.entity.ETemplateStructure) As %String [ WebMethod ]
{
	/// b "s"
	TSTART
	set objTemStructure=##class(EMRmeta.TemplateStructure).%New()
	quit:(objTemStructure="") ""
	
	set objTemStructure.StructType=aTemStructureInfo.StructType
	set objTemStructure.Description=aTemStructureInfo.Description
	set objTemStructure.Code=aTemStructureInfo.Code
	set objTemStructure.Name=aTemStructureInfo.Name
	set objTemStructure.ParentID=aTemStructureInfo.ParentID
	set objTemStructure.IsFixedSection=aTemStructureInfo.IsFixedSection
	set objTemStructure.ResChildCount=aTemStructureInfo.ResChildCount
	set objTemStructure.MetaTemplate=aTemStructureInfo.MetaTemplate
	s sc = objTemStructure.%Save()
	s ^CreateTemplateStructure(1) = sc
	if ($$$ISOK(sc))
	{
		if (objTemStructure.ParentID '="0")
		{
		s objPerStructute = ##Class(EMRmeta.TemplateStructure).%OpenId(objTemStructure.ParentID)
		s objPerStructute.ResChildCount = objPerStructute.ResChildCount+1
		if ('objPerStructute.%Save())
		{
			TROLLBACK
		 	quit "-1"
		}
		}
		TCOMMIT
		quit objTemStructure.%Id()
	}
	else
	{
		 TROLLBACK
		 quit "-1"
	}
}

/// 删除一个数据元范畴
ClassMethod DeleteTemplateStructure(aTemStructureId As %String) As %String [ WebMethod ]
{
	q:(aTemStructureId ="") "-1"
	s objTemStructure = ##Class(EMRmeta.TemplateStructure).%OpenId(aTemStructureId)
	s strParentid = objTemStructure.ParentID
	s sc = ##class(EMRmeta.TemplateStructure).%DeleteId(aTemStructureId)
	if ($$$ISOK(sc))
	{
		if (strParentid '="0")
		{
		s objPerTemStructure = ##Class(EMRmeta.TemplateStructure).%OpenId(strParentid)
		s objPerTemStructure.ResChildCount = objPerTemStructure.ResChildCount -1
		if ('objPerTemStructure.%Save())
		{
			q "-1"
		}
		}
		q (+sc)
	}else
	{
	q "-1"
	}
}

/// 更新一个数据元范畴
ClassMethod UpdateTemplateStructure(aTemStructureInfo As EMRservice.entity.ETemplateStructure) As %String [ WebMethod ]
{
	set objTemStructure=##class(EMRmeta.TemplateStructure).%OpenId(aTemStructureInfo.ID)
	quit:(objTemStructure="") "0"

	
	set objTemStructure.Code=aTemStructureInfo.Code
	set objTemStructure.Name=aTemStructureInfo.Name
	set objTemStructure.Description=aTemStructureInfo.Description
	set objTemStructure.IsFixedSection=aTemStructureInfo.IsFixedSection
	set objTemStructure.ParentID=objTemStructure.ParentID
	set objTemStructure.StructType=objTemStructure.StructType
	s ^updateTemStruct("123") = objTemStructure.Code_"^"_objTemStructure.Name_"^"_objTemStructure.Description_"^"_objTemStructure.IsFixedSection
	s sc = objTemStructure.%Save()
	if ($$$ISOK(sc))
	{

		q (objTemStructure.%Id())
	}
	else
	{

		 quit "-1"
	}
}

/// CreateTime: 2014-02-12
/// Creator:    candy
/// Desc:		得到模板xml文档
/// Input:		ATemplateVersionId: 模板版本ID
///             AOutRecords: 返回xml 
/// OutPut:     result: 返回1保存成功, -1保存失败
ClassMethod LoadmetaTemplate(ByRef AOutRecords As %GlobalBinaryStream, ATemplateStructureId As %String) As %String
{
	s result = "-1"		
    q:(ATemplateStructureId = "") result 
    s objTemplateStructure = ##Class(EMRmeta.TemplateStructure).%OpenId(ATemplateStructureId)
    q:(objTemplateStructure = "") result
    
    //s objMetaData = ##class(%GlobalBinaryStream).%New()
    //s objScriptData = ##Class(%GlobalBinaryStream).%New()
    //s objInstanceData = ##class(%GlobalBinaryStream).%New()
    d AOutRecords.CopyFrom(objTemplateStructure.MetaTemplate)  	
    
    //d AOutRecords.CopyFrom(##Class(EMRservice.BL.BLInstanceData).GetRecordXML(TemplateID,elementType,objMetaData,objScriptData,objInstanceData))
	s result = "1"
	q result
}

/// Desc:       保存模板
/// Creator:    candy
/// Createdate: 2014-01-25
/// Input:      argInData 模板文件流
///             TemplateVersionId   
/// Output:     result 1成功,-1失败 
ClassMethod SaveTemplateStructure(argInData As %GlobalBinaryStream, TemplateStructureId As %String) As %String
{
	s result = "-1"		
    q:((TemplateStructureId = "")||(argInData = "")) result 
   
   s objTemplateStructure = ##Class(EMRmeta.TemplateStructure).%OpenId(TemplateStructureId)
    q:(objTemplateStructure = "") result
    //增加模板保存状态更新
    d objTemplateStructure.MetaTemplate.Clear()
    d objTemplateStructure.MetaTemplate.CopyFrom(argInData)
    s sc = objTemplateStructure.%Save()
   
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// 更新一个数据元范畴
ClassMethod test()
{
	s aTemStructureInfo = ##Class(EMRservice.entity.ETemplateStructure).%New()
	s aTemStructureInfo.ID = "334"
	s aTemStructureInfo.Code = "334"
	s aTemStructureInfo.Name = "334"
	s aTemStructureInfo.Description = "334"
	s aTemStructureInfo.IsFixedSection = "334"
	s strR = ##Class(EMRservice.BL.BLTemplateStructure).UpdateTemplateStructure(aTemStructureInfo)
}

}
