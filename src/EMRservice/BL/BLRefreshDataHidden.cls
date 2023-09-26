/// 名称:EMRservice.BL.BLRefreshDataHidden
/// 描述:不需要显示的同步数据的BL层
/// 编写者：liuyunfei
/// 编写日期: 2020-12-24
Class EMRservice.BL.BLRefreshDataHidden Extends %RegisteredObject
{

/// creator:     liuyunfei
/// CreatDate:   2020-12-24
/// Desc: 		 记录instanceId和code值
/// Table:		 EMRinstance.plugin.RefreshDataHidden
/// input:		 InstanceId，Code（病历上每个单元对应的编码）
/// debug：		 w ##Class(EMRservice.BL.BLRefreshDataHidden).InsertData("121212","ABC")
ClassMethod InsertData(InstanceID As %String, Code As %String) As %String
{
	s result = ""
	q:(InstanceID="")||(Code="") result
	s rowId = $o(^DHCEMRI.plugin.RefreshDataHI("IdxInstanceID"," "_InstanceID,""))
	if (rowId = "")
	{
		s obj = ##class(EMRinstance.plugin.RefreshDataHidden).%New()
		s obj.InstanceID = InstanceID
		s obj.Code = Code
	}
	else
	{
		s obj = ##class(EMRinstance.plugin.RefreshDataHidden).%OpenId(rowId)
		s obj.Code = obj.Code_"^"_Code
	}
	s sc = obj.%Save()
	if (sc)
	{
		s result = "1"
	}
	q result
}

/// creator:     liuyunfei
/// CreatDate:   2020-12-24
/// Desc: 		 根据instanceId获取Code值
/// Table:		 EMRinstance.plugin.RefreshDataHidden
/// input:		 InstanceId
/// debug：		 w ##Class(EMRservice.BL.BLRefreshDataHidden).GetAllCodeByInstanceID(121212)
ClassMethod GetAllCodeByInstanceID(InstanceID As %String) As %String
{
	s result = ""
	q:(InstanceID="") result
	s rowId = $o(^DHCEMRI.plugin.RefreshDataHI("IdxInstanceID"," "_InstanceID,""))
	q:(rowId = "") result
	s obj = ##class(EMRinstance.plugin.RefreshDataHidden).%OpenId(rowId)
	s result = obj.Code
	q result
}

}
