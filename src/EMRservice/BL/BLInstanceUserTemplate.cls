/// 名称：		EMRservice.BL.BLInstanceUserTemplate
/// 描述：		存储病历使用的科室模板ID BL层
/// 编写者：	董璐璐
/// 编写时间：	2019-5-17
Class EMRservice.BL.BLInstanceUserTemplate Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    Donglulu
///  CreateDate: 2019-05-22
///  Desc:       存储病历使用的科室模板ID表数据
///  Input:      ATemplateCode:科室模板ID AUserID:创建用户ID AInstanceID：实例ID
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLInstanceUserTemplate).AddData("230","33","1")
ClassMethod AddData(ATemplateCode As %String, AUserID As %String, AInstanceID As %String) As %String
{
	s result = "0"
	q:(ATemplateCode = "")||(AUserID = "")||(AInstanceID = "") result
	s rowID = $o(^DHCEMRI.InstanceUserTemplateI("IdxInstanceID"," "_AInstanceID,""))
    if (rowID '= "") {
	    s obj = ##Class(EMRinstance.InstanceUserTemplate).%OpenId(rowID)
	}else {
		//插入新数据
    	s obj = ##Class(EMRinstance.InstanceUserTemplate).%New()
	}
	s obj.InstanceID = AInstanceID
	s obj.UserID = AUserID
	s obj.UserTemplateID = ATemplateCode
	s obj.Status = "0"
	
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		s result = "1"
	}
    d obj.%Close()	
	k obj
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2019-05-22
///  Desc:       病历保存时更改表status的状态
///  Input:      AUserID:创建用户ID AInstanceID：实例ID
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLInstanceUserTemplate).ChangeStatus("33","1")
ClassMethod ChangeStatus(AUserID As %String, AInstanceID As %String) As %String
{
	s result = "0"
	q:(AUserID = "")||(AInstanceID = "") result
	s rowID = $o(^DHCEMRI.InstanceUserTemplateI("IdxInstanceID"," "_AInstanceID,""))
	q:(rowID = "") result
    s obj = ##Class(EMRinstance.InstanceUserTemplate).%OpenId(rowID)
    q:((obj = "")||(obj.Status = "1")) result

    TStart
    s obj.Status = "1"
    s templateCode = obj.UserTemplateID
	s frequencyFlag = ##Class(EMRservice.BL.BLUserTemplateFrequency).AddData(templateCode,AUserID,AInstanceID)
	s sc = obj.%Save()
	if (($$$ISOK(sc))&&(frequencyFlag = "1"))
	{
		TCommit
		s result = "1"
	}
	else
	{
		TRollback
	}
    d obj.%Close()	
	k obj
	q result
}

}
