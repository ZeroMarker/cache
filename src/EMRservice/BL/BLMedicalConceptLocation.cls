Class EMRservice.BL.BLMedicalConceptLocation Extends (%RegisteredObject, %XML.Adaptor)
{

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,ConceptCode:%String,DisplayName:%String,Description:%String,SectionCode:%String,SectionName:%String,TemplateCode:%String,TemplateName:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_MedConceptL_SELECTALL, SqlProc ]
{
	SELECT l.ID,l.Code,l.ConceptCode,l.DisplayName,l.Description,l.SectionCode,l.SectionName,l.TemplateCode,l.TemplateName 
	FROM EMRmeta.MedicalConceptLocation l
}

Query SELECTALLMED() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,CategoryID:%String,Code:%String,DisplayName:%String,Description:%String,AllowInput:%String,FixedStructs:%String,FontName:%String,FontSize:%String,FontWeight:%String,FontStyle:%String,TextColor:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_MedConceptL_SELECTALLMED, SqlProc ]
{
	SELECT ID,CategoryID,Code,DisplayName,Description,AllowInput,FixedStructs,FontName,FontSize,FontWeight,FontStyle,TextColor
	FROM EMRmeta.MedicalConceptValues
}

Query SelectByConceptCode(aConceptCode As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,ConceptCode:%String,DisplayName:%String,Description:%String,SectionCode:%String,SectionName:%String,TemplateCode:%String,TemplateName:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_MedConceptL_SELECTBYCODE, SqlProc ]
{
	SELECT l.ID,l.Code,l.ConceptCode,l.DisplayName,l.Description,l.SectionCode,l.SectionName,l.TemplateCode,l.TemplateName 
	FROM EMRmeta.MedicalConceptLocation l
	WHERE ConceptCode =:aConceptCode
}

/// 创建一个医学概念关联
ClassMethod CreateMedConceptLoc(aMedConcepLoc As EMRservice.entity.EMedicalConceptLocation) As %String
{
	set objMedConcepLoc=##class(EMRmeta.MedicalConceptLocation).%New()
	quit:(objMedConcepLoc="") ""
	
	set objMedConcepLoc.Code=aMedConcepLoc.Code
	set objMedConcepLoc.ConceptCode=aMedConcepLoc.ConceptCode
	set objMedConcepLoc.DisplayName=aMedConcepLoc.DisplayName
	set objMedConcepLoc.Description=aMedConcepLoc.Description
	set objMedConcepLoc.SectionCode=aMedConcepLoc.SectionCode
	set objMedConcepLoc.SectionName=aMedConcepLoc.SectionName
	set objMedConcepLoc.TemplateCode=aMedConcepLoc.TemplateCode
	set objMedConcepLoc.TemplateName=aMedConcepLoc.TemplateName
	s sc = objMedConcepLoc.%Save()
	if ($$$ISOK(sc))
	{
		quit objMedConcepLoc.%Id()
	}
	else
	{
		 quit "-1"
	}
}

/// 删除一个医学概念关联
ClassMethod DeleteMedConceptLocByID(aTitleId As %String) As %String
{
	q:(aTitleId ="") "-1"
	s objTemStructure = ##Class(EMRmeta.MedicalConceptLocation).%OpenId(aTitleId)
	q:(objTemStructure="") "-1"
	s sc = ##class(EMRmeta.MedicalConceptLocation).%DeleteId(aTitleId)
	if ($$$ISOK(sc))
	{
		q (+sc)
	}
	else
	{
		q "-1"
	}
}

/// 更新一个医学概念关联
ClassMethod UpdateMedConceptLoc(aID As %String, aCode As %String) As %String
{
	set objMedConcepLoc=##class(EMRmeta.MedicalConceptLocation).%OpenId(aID)
	quit:(objMedConcepLoc="") "0"

	
	set objMedConcepLoc.Code=aCode
	s sc = objMedConcepLoc.%Save()
	if ($$$ISOK(sc))
	{

		q (objMedConcepLoc.%Id())
	}
	else
	{

		 quit "-1"
	}
}

/// 得到最大code编号
/// d ##Class(EMRservice.BL.BLMedicalConceptLocation).selectMaxByCode("MCC0063")
ClassMethod selectMaxByCode(aCode As %String) As %String
{
	&sql(select id into :IdexCode from EMRmeta.MedicalConceptLocation where code =:aCode)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// 得到最大code编号
ClassMethod GetMaxID() As %String
{
	//s IdexCode=0
	&sql(select max(Code) into :IdexCode   from EMRmeta.MedicalConceptLocation)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

}
