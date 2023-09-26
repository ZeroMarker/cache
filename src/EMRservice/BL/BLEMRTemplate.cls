Class EMRservice.BL.BLEMRTemplate Extends %RegisteredObject
{

ClassMethod GetTemplateIDByDocID(TemplateDocID As %String) As %String
{
  	s objtemplate = ##class(EMRmeta.EMRTemplate).%OpenId(TemplateDocID)
	q:(objtemplate="") ""
	s bindTemplateID = objtemplate.BindTemplateID
	d objtemplate.%Close()
	s objtemplate = ""	
	q bindTemplateID
}

/// Creator:   Candy
/// CreateDate:2022-8-9
/// Input:     ADocID 目录展现结构第三层ID
/// Output:   emrTemplateIds 目录展现结构第四层挂的模板ID
/// debug:     w ##Class(EMRservice.BL.BLEMRTemplate).GetEMRTemplateIDsByDocID(66)
ClassMethod GetEMRTemplateIDsByDocID(ADocID As %String) As %String
{
	s emrTemplateIds = ""
	q:(ADocID = "") emrTemplateIds
	s tmpId=""
	for
	{
		s tmpId = $O(^DHCEMRM.EMRTemplateI("IdxCategoryTemplate"," "_ADocID,tmpId))
		q:(tmpId = "")
		s rowId = $O(^DHCEMRM.EMRTemplateI("IdxCategoryTemplate"," "_ADocID,tmpId,""))
		continue:(rowId = "")
		s:(emrTemplateIds '="") emrTemplateIds = emrTemplateIds_"^"
		s emrTemplateIds = emrTemplateIds_rowId
	}
	q emrTemplateIds
}

}
