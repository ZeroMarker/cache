/// 名称: 病历业务域BL层
/// 描述: 病历业务域BL层
/// 编写者：叶剑
/// 编写日期: 2020-5-13
Class EMRservice.BL.BLEMRStructure Extends (%RegisteredObject, %XML.Adaptor)
{

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEMRStructure","SELECTALLCATE")
Query SELECTALLCATE() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,StructType:%String,Description:%String,Code:%String,Name:%String,ParentID:%String,GlossaryInternalID:%String", SELECTMODE = "RUNTIME") [ SqlProc ]
{
	SELECT ID,StructType,Description,Code,Name,ParentID,GlossaryInternalID
	FROM EMRmeta.EMRStructure
	WHERE StructType='Category' OR StructType='Document'
}

Query SelectDocumentData() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,StructType:%String,Description:%String,Code:%String,Name:%String,ParentID:%String,GlossaryInternalID:%String", SELECTMODE = "RUNTIME") [ SqlProc ]
{
	SELECT ID,StructType,Description,Code,Name,ParentID,GlossaryInternalID
	FROM EMRmeta.EMRStructure
	WHERE StructType!='Category'
}

Query SelectDocumentByCode(ACode As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,StructType:%String,Description:%String,Code:%String,Name:%String,ParentID:%String,GlossaryInternalID:%String", SELECTMODE = "RUNTIME") [ SqlProc ]
{
	SELECT ID,StructType,Description,Code,Name,ParentID,GlossaryInternalID
	FROM EMRmeta.EMRStructure
	WHERE StructType='Document' and Code =:ACode
}

/// 创建一个数据元范畴
ClassMethod CreateEMRStructure(aTemStructureInfo As EMRservice.entity.EEMRStructure) As %String [ WebMethod ]
{

	set objEMRStructure=##class(EMRmeta.EMRStructure).%New()
	quit:(objEMRStructure="") ""
	
	set objEMRStructure.StructType=aTemStructureInfo.StructType
	set objEMRStructure.Description=aTemStructureInfo.Description
	set objEMRStructure.Code=aTemStructureInfo.Code
	set objEMRStructure.Name=aTemStructureInfo.Name
	set objEMRStructure.ParentID=aTemStructureInfo.ParentID
	set objEMRStructure.GlossaryInternalID = aTemStructureInfo.GlossaryInternalID
	s sc = objEMRStructure.%Save()

	quit sc
}

/// 删除一个数据元范畴
ClassMethod DeleteEMRStructure(aTemStructureId As %String) As %String [ WebMethod ]
{
	q:(aTemStructureId ="") "-1"
	s objEMRStructure = ##Class(EMRmeta.EMRStructure).%OpenId(aTemStructureId)
	s strParentid = objEMRStructure.ParentID
	s sc = ##class(EMRmeta.EMRStructure).%DeleteId(aTemStructureId)
	q (+sc)
}

/// 更新一个数据元范畴
ClassMethod UpdateEMRStructure(aTemStructureInfo As EMRservice.entity.EEMRStructure) As %String [ WebMethod ]
{
	set objEMRStructure=##class(EMRmeta.EMRStructure).%OpenId(aTemStructureInfo.ID)
	quit:(objEMRStructure="") "0"

	
	set objEMRStructure.Code=aTemStructureInfo.Code
	set objEMRStructure.Name=aTemStructureInfo.Name
	set objEMRStructure.Description=aTemStructureInfo.Description
	set objEMRStructure.GlossaryInternalID = aTemStructureInfo.GlossaryInternalID
	set objEMRStructure.ParentID=objEMRStructure.ParentID
	set objEMRStructure.StructType=objEMRStructure.StructType
	s sc = objEMRStructure.%Save()
	if ($$$ISOK(sc))
	{

		q (objEMRStructure.%Id())
	}
	else
	{

		 quit "-1"
	}
}

/// Desc:       判断编码是否已经被关联
/// Creator:    yejian
/// Createdate: 2020-6-2 
/// Input:      aCode 修改业务域编码
///             aID 修改RowID
/// Output:     result rowID^categoryName
/// w ##Class(EMRservice.BL.BLEMRStructure).GetCodeIsExist("EMR09","65")
ClassMethod GetCodeIsExist(aCode As %String, aID As %String) As %String [ WebMethod ]
{
 	s strRowID =""
    q:(aCode="") strRowID
    s aCode = $zcvt(aCode,"U")
    s strCode = ""
	q:(aCode [ "EMR99") strRowID
    for 
	{	
		s strCode=$O(^DHCEMRM.EMRTemplateCategoryI("IdxInternalID", strCode))
		q:(strCode = "")
		s itemCode = $tr(strCode," ","")_"^"
		//判断存在增加后缀^
		if (itemCode[(aCode_"^"))
		{
			s ItemRowID=$O(^DHCEMRM.EMRTemplateCategoryI("IdxInternalID", strCode, ""))
			q:(ItemRowID="")
			continue:(ItemRowID=aID)
			s objEmrTemCategory=##class(EMRmeta.EMRTemplateCategory).%OpenId(ItemRowID)
			continue:(objEmrTemCategory.CategoryType="TempCate")
			s strRowID = ItemRowID_"^"_objEmrTemCategory.CategoryName
			q
		}
	}
	q strRowID
}

}
