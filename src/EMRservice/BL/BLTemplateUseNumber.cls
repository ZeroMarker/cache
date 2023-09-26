/// 名称：		EMRservice.BL.BLTemplateUseNumber
/// 描述：		文档创建是增加记录模板的使用次数 BL层
/// 编写者：	yejian
/// 编写时间：	2021-4-12
Class EMRservice.BL.BLTemplateUseNumber Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    yejian
///  CreateDate: 2021-4-12
///  Desc:       文档创建是增加记录模板的使用次数
///  Input:      ATemplateID:模板ID ATemplateVersion:版本ID
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLTemplateUseNumber).SetUseNumber("314||1")
ClassMethod SetUseNumber(AInstanceID As %String) As %String
{
	s result = "0"
	q:(AInstanceID = "") result
	s objIn = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	s strTemplateID = objIn.RealTemplateID
	s strTemplateVersion =objIn.TemplateVersion
	d objIn.%Close()
	s rowID = $o(^DHCEMRM.TemplateUseNumberI("IndexTVersion"," "_strTemplateID,strTemplateVersion,""))
    if (rowID '= "") {
	    s obj = ##Class(EMRmeta.TemplateUseNumber).%OpenId(rowID)
	}else {
		//插入新数据
    	s obj = ##Class(EMRmeta.TemplateUseNumber).%New()
	}
	s obj.TemplateID = strTemplateID
	s obj.TemplateVersion = strTemplateVersion
	s obj.UseNumber = obj.UseNumber+1	
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		s result = "1"
	}
    d obj.%Close()	
	q result
}

}
