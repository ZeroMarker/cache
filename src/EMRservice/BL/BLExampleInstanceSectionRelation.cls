/// Desc:       个人模板继承关系业务类
/// Creator:    yan
/// CreateDate: 2020-5-7
Class EMRservice.BL.BLExampleInstanceSectionRelation Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    
///  CreateDate: 2020-05-25
///  Desc:       获取对应个人模板章节对应关系
///  Input:      APersonalTemplateID:个人模板ID
///  return:     result 成功：S001:REFERENCE^S002:REPLACE^....^S020:REFERENCE   失败：空
///  Debug:      w ##Class(EMRservice.BL.BLExampleInstanceSectionRelation).GetSectionRelationS(66)
ClassMethod GetSectionRelationS(APersonalTemplateID As %String) As %String
{
	s result = ""
	q:(APersonalTemplateID = "") result
	s rowID = ""
	for
	{
		s rowID = $o(^DHCEMRM.ExampleInsSecRelationI("IdxExampleID"," "_APersonalTemplateID,rowID))
		q:(rowID = "")
		s relationobj = ##class(EMRmeta.ExampleInsSecRelation).%OpenId(rowID)
		continue:(relationobj = "")
		s:(result'="") result = result_"^"
		s result = result_relationobj.SectionCode_":"_relationobj.Status_":"_relationobj.SectionName
	}
	q result
}

}
