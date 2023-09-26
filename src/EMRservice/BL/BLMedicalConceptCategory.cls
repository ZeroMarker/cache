Class EMRservice.BL.BLMedicalConceptCategory Extends (%RegisteredObject, %XML.Adaptor)
{

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,InternalID:%String,Description:%String,Name:%String,ParentID:%String,ResChildCount:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_MedConceptC_SELECTALL, SqlProc ]
{
	SELECT ID,InternalID,Description,Name,ParentID,ResChildCount
	FROM EMRmeta.MedicalConceptCategory
}

Query SelectByParentID(aParentID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,InternalID:%String,Description:%String,Name:%String,ParentID:%String,ResChildCount:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_MedConceptC_SELECTBYID, SqlProc ]
{
	SELECT ID,InternalID,Description,Name,ParentID,ResChildCount
	FROM EMRmeta.MedicalConceptCategory
	WHERE ParentID =:aParentID
}

/// 创建一个医学概念范畴
ClassMethod CreateCategory(aMedConceptCategory As EMRservice.entity.EMedicalConceptCategory) As %String [ WebMethod ]
{
	set objMedConceptCategory=##class(EMRmeta.MedicalConceptCategory).%New()
	quit:(objMedConceptCategory="") ""
	
	set objMedConceptCategory.InternalID=aMedConceptCategory.InternalID
	set objMedConceptCategory.Description=aMedConceptCategory.Description
	set objMedConceptCategory.Name=aMedConceptCategory.Name
	set objMedConceptCategory.ParentID=aMedConceptCategory.ParentID
	set objMedConceptCategory.ResChildCount=aMedConceptCategory.ResChildCount
	s sc = objMedConceptCategory.%Save()
	if ($$$ISOK(sc))
	{
		quit objMedConceptCategory.%Id()
	}
	else
	{
		 quit "-1"
	}
}

/// 删除一个医学概念范畴
ClassMethod DeleteCategoryByID(aTitleId As %String) As %String [ WebMethod ]
{
	q:(aTitleId ="") "-1"
	s objTemStructure = ##Class(EMRmeta.MedicalConceptCategory).%OpenId(aTitleId)
	q:(objTemStructure="") "-1"
	s sc = ##class(EMRmeta.MedicalConceptCategory).%DeleteId(aTitleId)
	if ($$$ISOK(sc))
	{
		q (+sc)
	}
	else
	{
		q "-1"
	}
}

/// 更新一个医学概念范畴
ClassMethod UpdateCategory(aMedConceptCategory As EMRservice.entity.EMedicalConceptCategory) As %String [ WebMethod ]
{
	set objMedConceptCategory=##class(EMRmeta.MedicalConceptCategory).%OpenId(aMedConceptCategory.ID)
	quit:(objMedConceptCategory="") "0"

	
	set objMedConceptCategory.InternalID=aMedConceptCategory.InternalID
	set objMedConceptCategory.Description=aMedConceptCategory.Description
	set objMedConceptCategory.Name=aMedConceptCategory.Name
	set objMedConceptCategory.ParentID=aMedConceptCategory.ParentID
	set objMedConceptCategory.ResChildCount=aMedConceptCategory.ResChildCount
	s sc = objMedConceptCategory.%Save()
	if ($$$ISOK(sc))
	{

		q (objMedConceptCategory.%Id())
	}
	else
	{

		 quit "-1"
	}
}

}
