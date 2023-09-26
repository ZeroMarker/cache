/// 名称：		EMRservice.BL.BLUserTemplateFrequency
/// 描述：		科室模板使用频率BL层
/// 编写者：	董璐璐
/// 编写时间：	2019-5-17
Class EMRservice.BL.BLUserTemplateFrequency Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    Donglulu
///  CreateDate: 2019-05-22
///  Desc:       添加科室模板使用频率表数据
///  Input:      ATemplateCode:科室模板ID AUserID:创建用户ID AInstanceID：实例ID
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLUserTemplateFrequency).AddData("230","33","1||1")
ClassMethod AddData(AUserTemplateID As %String, AUserID As %String, AInstanceID As %String) As %String
{
	s result = "0"
	q:(AUserTemplateID = "")||(AUserID = "")||(AInstanceID = "") result
	s rowID = $o(^DHCEMRI.UserTemplateFreqI("IdxUserIDUserTemplateID"," "_AUserID," "_AUserTemplateID,""))	
    if (rowID = "")
    {
	    //插入新数据
	    s obj = ##Class(EMRinstance.UserTemplateFrequency).%New()
	    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	    q:(objInstance = "") result
		s obj.TemplateID = objInstance.RealTemplateID
		s obj.UserID = AUserID
		s obj.UserTemplateID = AUserTemplateID
		s obj.Frequency = 1
    }
    else
    {
	    s obj = ##Class(EMRinstance.UserTemplateFrequency).%OpenId(rowID)
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
