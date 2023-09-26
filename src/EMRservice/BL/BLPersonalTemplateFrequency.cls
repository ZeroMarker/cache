/// 名称：		EMRservice.BL.BLUserTemplateFrequency
/// 描述：		用户模板使用频率BL层
/// 编写者：	董璐璐
/// 编写时间：	2019-5-29
Class EMRservice.BL.BLPersonalTemplateFrequency Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    Donglulu
///  CreateDate: 2019-05-22
///  Desc:       添加科室模板使用频率表数据
///  Input:      APersonalTemplateID:用户模板ID AUserID:创建用户ID AInstanceID：实例ID
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLPersonalTemplateFrequency).AddData("230","33","1||1")
ClassMethod AddData(APersonalTemplateID As %String, AUserID As %String, AInstanceID As %String) As %String
{
	s result = "0"
	q:(APersonalTemplateID = "")||(AUserID = "")||(AInstanceID = "") result
	s rowID = $o(^DHCEMRI.PersonalTemplateFreqI("IdxUserIDPersonalTemplateID"," "_AUserID," "_APersonalTemplateID,""))	
    if (rowID = "")
    {
	    //插入新数据
	    s obj = ##Class(EMRinstance.PersonalTemplateFrequency).%New()
	    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	    q:(objInstance = "") result
		s obj.TemplateID = objInstance.RealTemplateID
		s obj.UserID = AUserID
		s obj.PersonalTemplateID = APersonalTemplateID
		s obj.Frequency = 1
    }
    else
    {
	    s obj = ##Class(EMRinstance.PersonalTemplateFrequency).%OpenId(rowID)
	    q:(obj = "") result
	    s obj.Frequency = obj.Frequency + 1
    }
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		s result = "1"
	}
    d obj.%Close()	
	k obj
	q result
}

}
