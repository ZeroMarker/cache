/// 名称：		EMRservice.BL.BLTemplateFrequency
/// 描述：		模板使用频率BL层
/// 编写者：	yejian
/// 编写时间：	2021-9-13
Class EMRservice.BL.BLTemplateFrequency Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    yejian
///  CreateDate: 2021-9-13
///  Desc:       添加科室模板使用频率表数据
///  Input:     AUserID:创建用户ID AInstanceID：实例ID
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLTemplateFrequency).AddData("230","33","1||1")
ClassMethod AddData(AUserID As %String, AInstanceID As %String) As %String
{
	s result = "0"
	q:(AUserID = "")||(AInstanceID = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s ADocID = objInstance.TheECRecord.RealChartItemID
	s rowID = $o(^DHCEMRI.TemplateFrequencyI("IdxUserDocID"," "_AUserID," "_ADocID,""))	
    if (rowID = "")
    {
	    //插入新数据
	    s obj = ##Class(EMRinstance.TemplateFrequency).%New()
		s obj.DocID = ADocID
		s obj.UserID = AUserID
		s obj.Frequency = 1
		
    }
    else
    {
	    s obj = ##Class(EMRinstance.TemplateFrequency).%OpenId(rowID)
	    q:(obj = "") result
	    s obj.Frequency = obj.Frequency + 1
    }
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		s result = "1"
	}
    d obj.%Close()	
	k obj,objInstance
	q result
}

///  Creator:    lifengbo
///  CreateDate: 2022-07-04
///  Desc:       模板使用频率表数据
///  Input:      AUserID:创建用户ID AInstanceID：实例ID
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLTemplateFrequency).GetData("230","33","1||1")
ClassMethod GetData(AUserID As %String, ADocID As %String) As %String
{
	s result = "0"
	q:(AUserID = "") result

	s rowID = $o(^DHCEMRI.TemplateFrequencyI("IdxUserDocID"," "_AUserID," "_ADocID,""))	
    q:(rowID = "") result

	s obj = ##Class(EMRinstance.TemplateFrequency).%OpenId(rowID)
	q:(obj = "") result
	
	s result = obj.Frequency
	
	d obj.%Close()
	s obj=""
	
	q result
}

}
